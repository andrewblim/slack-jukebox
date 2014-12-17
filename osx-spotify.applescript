
property slack_webhook : "[your hook here]"
property icon_emoji : ":musical_note:"

property chunk_size : 1
property recent_tracks : {}

property current_track_url : ""

-- replace_chars is directly from hawleykc's song-to-slack

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on clean_chars(this_text)
	-- set this_text to my replace_chars(this_text, "\\", "\\u005c")
	set this_text to my replace_chars(this_text, "'", "\\u0027")
	-- set this_text to my replace_chars(this_text, "\"", "\\u0022")
	return this_text
end clean_chars


on idle
	
	tell application "Finder"
		set json_path to file "json.scpt" of folder of (path to me)
	end tell
	set json to load script (json_path as alias)
	
	if application "Spotify" is running then
		
		tell application "Spotify"
			
			if player state is playing then
				
				if current_track_url is not equal to current track's spotify url then
					
					set current_track_url to current track's spotify url
					set recent_tracks to recent_tracks & {{current track's name, current track's artist, current track's album, current track's spotify url}}
					
					if (count of recent_tracks) is greater than or equal to chunk_size then
						
						set slack_payload_fields to {}
						set slack_payload_fallback to ""
						
						repeat with this_track in recent_tracks
							
							set this_track_name to item 1 of my clean_chars(this_track)
							set this_track_artist to item 2 of my clean_chars(this_track)
							set this_track_url to item 4 of my clean_chars(this_track)
							
							set slack_track_text to this_track_artist & " - <" & this_track_url & "|" & this_track_name & ">"
							set slack_payload_fields to slack_payload_fields & json's createDictWith({{"value", slack_track_text}, {"short", "false"}})
							set slack_payload_fallback to slack_payload_fallback & slack_track_text & " // "
							
						end repeat
						
						set slack_payload to json's encode(json's createDictWith({{"icon_emoji", icon_emoji}, {"fallback", slack_payload_fallback}, {"fields", slack_payload_fields}}))
						set slack_curl_command to "curl -X POST --data-urlencode 'payload=" & slack_payload & "' " & slack_webhook
						
						display alert slack_curl_command
						-- do shell script slack_curl_command
						set recent_tracks to {}
						set recent_artists to {}
						set recent_albums to {}
						set recent_track_urls to {}
						
					end if
					
				end if
				
			end if
			
		end tell
		
	end if
	
	return 5
	
end idle
