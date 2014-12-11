
property channel : "#your-channel"
property webhook : "your-webhook"
property icon_emoji : ":musical_note:"

tell application "Spotify"
	
	-- if player state is playing then
	
	set current_track to current track's name
	set current_artist to current track's artist
	set current_album to current track's album
	set current_track_url to current track's spotify url
	
	set payload_text to current_artist & " - <" & current_track_url & "|" & current_track & ">"
	
	set payload to "{ \"channel\": \"" & channel & "\", \"icon_emoji\": \"" & icon_emoji & "\", \"text\": \"" & payload_text & "\" }"
	set curl_command to "curl -X POST --data-urlencode 'payload=" & payload & "' " & webhook
	
	-- display alert curl_command
	do shell script curl_command
	
	-- end if
	
end tell
