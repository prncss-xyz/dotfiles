local M = {}

function M:setup()
	ps.sub("cd", function()
		local uri = "file://" .. ya.percent_encode(tostring(cx.active.current.cwd))
		local command = "printf '\\033]7;%s\\033\\\\' " .. ya.quote(uri) .. " > /dev/tty"

		ya.emit("shell", { command:gsub("%%", "%%%%"), orphan = true })
	end)
end

return M
