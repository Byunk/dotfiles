
function iterm() {
	cp ~/Library/Preferences/com.googlecode.iterm2.plist $DOT_DIR/iterm/
}

function todo() {
	cp ~/.todo/done.txt $DOT_DIR/todo/
	cp ~/.todo/todo.txt $DOT_DIR/todo/
	cp ~/.todo/report.txt $DOT_DIR/todo/
}

function main() {
	case $1 in
		"--iterm")
			iterm
		;;
		"--todo")
			todo
	esac

	exit 0
}

main $@
