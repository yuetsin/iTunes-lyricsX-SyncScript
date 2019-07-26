tell application "LyricsX"
	activate
end tell

try
	ignoring application responses
		tell application "System Events" to tell process "LyricsX"
			tell menu bar item 1 of menu bar 2
				click
			end tell
		end tell
	end ignoring
	
	do shell script "killall System\\ Events"
	delay 0.1
	tell application "System Events" to tell process "LyricsX"
		tell menu bar 2
			tell menu bar item 1
				tell menu 1
					tell menu item 7
						click
						tell menu 1
							tell menu item 4
								click
							end tell
						end tell
					end tell
				end tell
			end tell
		end tell
	end tell
end try