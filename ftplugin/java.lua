-- Debugging and testing
local test_path = vim.env.VSCODE_JAVA_TEST_PATH
local debug_path = vim.env.VSCODE_JAVA_DEBUG_PATH

local bundles = {
	vim.fn.glob(debug_path .. "/server/*.jar", true),
}

local java_test_bundles = vim.split(vim.fn.glob(test_path .. "/server/*.jar", true), "\n")
local excluded = {
	"com.microsoft.java.test.runner-jar-with-dependencies.jar",
	"jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
	local fname = vim.fn.fnamemodify(java_test_jar, ":t")
	if not vim.tbl_contains(excluded, fname) then
		table.insert(bundles, java_test_jar)
	end
end

vim.lsp.config("jdtls", {
	settings = {
		java = {
			init_options = {
				bundles = bundles,
			},
		},
	},
})

vim.lsp.enable("jdtls")

local gradle_port = 5005
local gradle_hostName = "127.0.0.1"

local function is_port_open(host, port)
	local client = vim.uv.new_tcp()
	if client == nil then
		return false
	end

	local done = false
	local is_open = false

	client:connect(host, port, function(err)
		is_open = (err == nil)
		done = true

		client:close()
	end)

	local start = vim.uv.now()

	while not done and vim.uv.now() - start < 100 do
		vim.uv.run("once")
	end

	if not done then
		client:close()
	end

	return is_open
end

local function is_gradle_project()
	local files = vim.fs.find({ "build.gradle", "gradlew" }, { upward = true, limit = 1, path = vim.fn.getcwd() })
	return #files > 0
end

local dap = require("dap")

dap.configurations.java = {
	setmetatable({
		type = "java",
		request = "attach",
		name = "Gradle run",
		hostName = gradle_hostName,
		port = gradle_port,
	}, {
		__call = function(config)
			local new_config = vim.deepcopy(config)

			new_config.port = function()
				return coroutine.create(function(dap_run_co)
					if not is_gradle_project() then
						coroutine.resume(dap_run_co, dap.ABORT)
						return
					end

					if vim.fn.executable("gradle") ~= 1 then
						vim.notify("Gradle not available", vim.log.levels.ERROR)
						coroutine.resume(dap_run_co, dap.ABORT)
						return
					end

					if is_port_open(gradle_hostName, gradle_port) then
						vim.notify("Gradle debug is busy on port " .. gradle_port, vim.log.levels.ERROR)
						coroutine.resume(dap_run_co, dap.ABORT)
						return
					end

					local cmd = { "gradle", "run", "--no-daemon", "--debug-jvm" }
					local job_id = vim.fn.jobstart(cmd, { cwd = vim.fn.getcwd() })

					if job_id == 0 or job_id == -1 then
						vim.notify("Failed to start Gradle", vim.log.levels.ERROR)
						coroutine.resume(dap_run_co, dap.ABORT)
						return
					end

					local notif_id = vim.notify(
						string.format("Connecting to %s:%d [0 / 30 s]", gradle_hostName, gradle_port),
						vim.log.levels.INFO,
						{ title = "Gradle Debug" }
					)

					local timer = vim.uv.new_timer()
					if timer == nil then
						vim.notify("Failed to connect to Gradle", vim.log.levels.ERROR)
						vim.fn.jobstop(job_id)
						coroutine.resume(dap_run_co, dap.ABORT)
						return
					end

					local count = 0
					local max_count = 60

					timer:start(
						500,
						500,
						vim.schedule_wrap(function()
							count = count + 1
							local elapsed = count * 0.5

							vim.notify(
								string.format(
									"Connecting to %s:%d [%.1f / 30 s]",
									gradle_hostName,
									gradle_port,
									elapsed
								),
								vim.log.levels.INFO,
								{ replace = notif_id }
							)

							if is_port_open(gradle_hostName, gradle_port) then
								timer:stop()
								vim.notify(
									"Debug socket ready! Attaching...",
									vim.log.levels.INFO,
									{ replace = notif_id, timeout = 2000 }
								)
								coroutine.resume(dap_run_co, gradle_port)
								return
							end

							if count > max_count then
								timer:stop()
								vim.fn.jobstop(job_id)
								vim.notify(
									"Timeout waiting for debug socket",
									vim.log.levels.ERROR,
									{ replace = notif_id }
								)
								coroutine.resume(dap_run_co, dap.ABORT)
							end
						end)
					)
				end)
			end

			return new_config
		end,
	}),
}
