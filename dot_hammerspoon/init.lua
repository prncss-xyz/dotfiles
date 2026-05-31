hs.hotkey.bind({ "cmd", "shift" }, "y", function()
	hs.application.open("Google Chrome")
end)
hs.hotkey.bind({ "cmd", "shift" }, "t", function()
	hs.application.open("Ghostty")
end)
hs.hotkey.bind({ "cmd", "shift" }, "d", function()
	hs.osascript.applescript([[
		tell application "System Events"
      tell appearance preferences
        set dark mode to not dark mode
      end tell
		end tell
	]])
end)
