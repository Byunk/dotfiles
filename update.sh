
function iterm() {
	cp ~/Library/Preferences/com.googlecode.iterm2.plist $DOT_DIR/iterm/
}

function main() {
	case $1 in
		"--iterm")
			iterm
		;;
	esac

	exit 0
}

main $@
