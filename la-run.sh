#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
	echo "Usage: la-run <command> [args...]" >&2
	exit 1
fi

RUN_ID=$(uuidgen)
CMD="$*"
TITLE="$(basename "$PWD")"

urlencode() {
	python3 - "$1" <<'PY'
import urllib.parse, sys
print(urllib.parse.quote(sys.argv[1]))
PY
}

ENC_TITLE=$(urlencode "$TITLE")
ENC_CMD=$(urlencode "$CMD")

# Start run
open "terminal-activity://start?run_id=${RUN_ID}&title=${ENC_TITLE}&cmd=${ENC_CMD}" >/dev/null 2>&1

# Run the command
set +e
"$@"
EXIT=$?
set -e

STATUS="failure"
if [ $EXIT -eq 0 ]; then
	STATUS="success"
fi

# End run
open "terminal-activity://end?run_id=${RUN_ID}&status=${STATUS}&exit=${EXIT}" >/dev/null 2>&1

exit $EXIT
