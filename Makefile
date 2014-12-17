
all: osx-spotify

json.scpt: json.applescript
	osacompile -o json.scpt json.applescript

osx-spotify: json.scpt
	osacompile -s -o osx-spotify.app osx-spotify.applescript

clean:
	rm -rf json.scpt
	rm -rf osx-spotify.app