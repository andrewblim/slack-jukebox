
property slack_webhook : ""
property icon_emoji : ":musical_note:"

property chunk_size : 10
property recent_tracks : {}

property current_track_url : ""

-- replace_chars is directly from hawleykc's song-to-slack
-- https://github.com/hawleykc/current-song-to-slack
-- no license attached to it, but it's not my own

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

tell application "Finder"
	set slack_webhook to read file ((path to me as text) & "::slack-webhook.txt")
	set slack_webhook to my replace_chars(slack_webhook, "\n", "")
end tell

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

							set this_track_name to item 1 of this_track
							set this_track_artist to item 2 of this_track
							set this_track_url to item 4 of this_track

							set this_track_name to my replace_chars(this_track_name, "<", "&lt;")
							set this_track_name to my replace_chars(this_track_name, ">", "&gt;")
							set this_track_artist to my replace_chars(this_track_artist, "<", "&lt;")
							set this_track_artist to my replace_chars(this_track_artist, ">", "&gt;")

							set slack_track_text to this_track_artist & " - <" & this_track_url & "|" & this_track_name & ">"
							set slack_payload_fields to slack_payload_fields & json's createDictWith({{"value", slack_track_text}, {"short", "false"}})
							set slack_payload_fallback to slack_payload_fallback & slack_track_text & " // "
							
						end repeat
						
						set slack_payload to json's encode(json's createDictWith({{"icon_emoji", icon_emoji}, {"fallback", slack_payload_fallback}, {"fields", slack_payload_fields}}))

						-- write it to a tempfile, don't have to deal with funny escaping

						set tempfile to (do shell script "mktemp -t temp")
						set fp to open for access tempfile with write permission
						write slack_payload to fp
						close access fp

						set slack_curl_command to "curl -X POST --data-urlencode payload@" & tempfile & " " & slack_webhook
						display alert slack_curl_command
						do shell script slack_curl_command

						do shell script "rm -f " & tempfile
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
