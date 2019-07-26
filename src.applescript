-- Utilities that generates date
(*
	The zero_pad function taken from:
	http://www.nineboxes.net/2009/10/an-applescript-function-to-zero-pad-integers/
*)
on zero_pad(value, string_length)
	set string_zeroes to ""
	set digits_to_pad to string_length - (length of (value as string))
	if digits_to_pad > 0 then
		repeat digits_to_pad times
			set string_zeroes to string_zeroes & "0" as string
		end repeat
	end if
	set padded_value to string_zeroes & value as string
	return padded_value
end zero_pad

on run
	-- Initialize necessary apps
	--tell application "System Events"
	--	tell application "iTunes"
	--		activate
	--	end tell
	--	tell application "LyricsX"
	--		activate
	--	end tell
	--end tell
	
	-- Prompt picking music
	set musicItems to (choose file with prompt "Pick songs you want to import to iTunes with Lyrics embedded: " of type {"public.audio"} with multiple selections allowed)
	
	-- Get current time as playlist name
	
	set now to (current date)
	
	set result to (year of now as integer) as string
	set result to result & "-"
	set result to result & zero_pad(month of now as integer, 2)
	set result to result & "-"
	set result to result & zero_pad(day of now as integer, 2)
	set result to result & " "
	set result to result & zero_pad(hours of now as integer, 2)
	set result to result & ":"
	set result to result & zero_pad(minutes of now as integer, 2)
	set result to result & ":"
	set result to result & zero_pad(seconds of now as integer, 2)
	
	set playlistName to "Playlist created @ " & result
	
	-- Create new playlist
	tell application "iTunes"
		make new user playlist with properties {name:playlistName, shuffle:false, song repeat:one}
	end tell
	
	repeat with musicItem in musicItems
		tell application "iTunes"
			add musicItem to playlist playlistName
		end tell
	end repeat
	
	tell application "iTunes"
		set songCount to count tracks of playlist playlistName
	end tell
	
	set counter to 1
	
	tell application "LyricsX"
		activate
	end tell
	
	repeat until (counter = songCount + 1)
		tell application "iTunes"
			play track counter of playlist playlistName
		end tell
		tell application "iTunes"
			pause
		end tell
		tell application "System Events"
			tell process "LyricsX"
				entire contents
			end tell
		end tell
		
		-- Give LyricsX some time to sync these lyrics
		delay 1
		
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
		
		set counter to (counter + 1)
	end repeat
	
	set status to "Done"
end run