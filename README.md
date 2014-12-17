
# slack-jukebox

Tells a slack channel what you're listening to.

Instructions

1. `make clean && make`
2. Make a file `slack-webhook.txt` in this directory and put your webhook into it, just a single line containing the URL (target of curl). 
3. Run `osx-spotify.app`. 

Heavily based off of hawleykc's [current-song-to-slack](https://github.com/hawleykc/current-song-to-slack), originally devised as a way to teach myself a little AppleScript (it didn't come with a license). Uses mgax's [applescript-json](https://github.com/mgax/applescript-json) to make JSON in AppleScript less painful.
