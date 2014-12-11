
property slack_webhook : "[your hook here]"
property icon_emoji : ":musical_note:"

property current_track_url : ""

on idle

	tell application "Finder"
		set json_path to file "json.scpt" of folder of (path to me)
	end tell
	set json to load script (json_path as alias)

	if application "Spotify" is running then

		tell application "Spotify"

			if player state is playing then

				if current_track_url is not equal to current track's spotify url then

					set current_track to current track's name
					set current_artist to current track's artist
					set current_album to current track's album
					set current_track_url to current track's spotify url

					set slack_payload_text to current_artist & " - <" & current_track_url & "|" & current_track & ">"
					set slack_payload to json's encode(json's createDictWith({{"icon_emoji", icon_emoji}, {"text", slack_payload_text}}))
					set slack_curl_command to "curl -X POST --data-urlencode 'payload=" & slack_payload & "' " & slack_webhook

					-- display alert slack_curl_command
					do shell script slack_curl_command

				end if

			end if

		end tell

	end if

	return 5

end idle
