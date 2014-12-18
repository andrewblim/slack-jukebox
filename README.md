
# slack-jukebox

Tells a slack channel what you're listening to.

Instructions

1. Make a file `slack-webhook.txt` in this directory and put your webhook into it, just a single line containing the URL (the target of curl). 
2. `make clean && make`
3. `open osx-spotify.app` or double-click it in the Finder. 

Directly uses mgax's [applescript-json](https://github.com/mgax/applescript-json) to make JSON in AppleScript less painful.

Originally based off of hawleykc's [current-song-to-slack](https://github.com/hawleykc/current-song-to-slack), devised as a way to teach myself a little AppleScript, and accordingly it's been hacked up a bit. 
