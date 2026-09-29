#!/bin/bash

# commix_bounty.sh - Interactive helper for using Commix in authorized bug bounty testing.
# Only use on systems you have explicit permission to test.

COMMIX_BIN="commix"

# Check if commix is installed
if ! command -v "$COMMIX_BIN" &> /dev/null; then
    echo "[!] Commix not found. Install it first (pip install commix)."
    exit 1
fi

# Default variables
URL=""
DATA=""
REQUEST_FILE=""
COOKIE=""
PROXY=""
TOR=false
DELAY=""
LEVEL=""
TAMPER=""
TECHNIQUE=""
OS_SHELL=false
FILE_READ=""
FILE_WRITE=""
FILE_DEST=""
REPORT_JSON=""
EXTRA_ARGS=()

show_menu() {
    clear
    echo "============================================="
    echo "        Commix Bug Bounty Helper"
    echo "============================================="
    echo "Current settings:"
    echo "  URL:          ${URL:-not set}"
    echo "  POST data:    ${DATA:-not set}"
    echo "  Request file: ${REQUEST_FILE:-not set}"
    echo "  Cookie/Auth:  ${COOKIE:-not set}"
    echo "  Proxy:        ${PROXY:-not set}"
    echo "  Tor:          $TOR"
    echo "  Delay:        ${DELAY:-not set}"
    echo "  Level:        ${LEVEL:-not set}"
    echo "  Tamper:       ${TAMPER:-not set}"
    echo "  Technique:    ${TECHNIQUE:-not set}"
    echo "  OS Shell:     $OS_SHELL"
    echo "  File read:    ${FILE_READ:-not set}"
    echo "  File write:   ${FILE_WRITE:-not set} -> ${FILE_DEST:-not set}"
    echo "  JSON report:  ${REPORT_JSON:-not set}"
    echo "---------------------------------------------"
    echo "1)  Set URL (GET, use * for injection point)"
    echo "2)  Set POST data (use * for injection point)"
    echo "3)  Set request file (from Burp Suite)"
    echo "4)  Set cookie / auth string"
    echo "5)  Set proxy (e.g. http://127.0.0.1:8080)"
    echo "6)  Toggle Tor"
    echo "7)  Set delay between requests (seconds)"
    echo "8)  Set testing level (1-3)"
    echo "9)  Set tamper scripts (comma-separated)"
    echo "10) Set technique (e.g. time, file, class)"
    echo "11) Toggle OS shell"
    echo "12) Set file to read from target"
    echo "13) Set file to write to target"
    echo "14) Set JSON report output file"
    echo "15) RUN COMMIX"
    echo "0)  Exit"
    echo "============================================="
}

run_commix() {
    local cmd=("$COMMIX_BIN")

    [ -n "$URL" ]          && cmd+=(--url="$URL")
    [ -n "$DATA" ]         && cmd+=(--data="$DATA")
    [ -n "$REQUEST_FILE" ] && cmd+=(-r "$REQUEST_FILE")
    [ -n "$COOKIE" ]       && cmd+=(--cookie="$COOKIE")
    [ -n "$PROXY" ]        && cmd+=(--proxy="$PROXY")
    [ "$TOR" = true ]      && cmd+=(--tor)
    [ -n "$DELAY" ]        && cmd+=(--delay="$DELAY")
    [ -n "$LEVEL" ]        && cmd+=(--level="$LEVEL")
    [ -n "$TAMPER" ]       && cmd+=(--tamper="$TAMPER")
    [ -n "$TECHNIQUE" ]    && cmd+=(--technique="$TECHNIQUE")
    [ "$OS_SHELL" = true ] && cmd+=(--os-shell)
    [ -n "$FILE_READ" ]    && cmd+=(--file-read="$FILE_READ")
    if [ -n "$FILE_WRITE" ] && [ -n "$FILE_DEST" ]; then
        cmd+=(--file-write="$FILE_WRITE" --file-dest="$FILE_DEST")
    fi
    [ -n "$REPORT_JSON" ]  && cmd+=(--report-json="$REPORT_JSON")

    # Add any extra arguments
    cmd+=("${EXTRA_ARGS[@]}")

    echo ""
    echo "[*] Running: ${cmd[*]}"
    echo ""
    "${cmd[@]}"
    echo ""
    echo "[*] Finished. Press Enter to return to menu."
    read -r
}

# Main loop
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1)  read -p "Enter URL (use * for injection point): " URL ;;
        2)  read -p "Enter POST data (use * for injection point): " DATA ;;
        3)  read -p "Enter path to request file: " REQUEST_FILE ;;
        4)  read -p "Enter cookie or auth string: " COOKIE ;;
        5)  read -p "Enter proxy (e.g. http://127.0.0.1:8080): " PROXY ;;
        6)  if [ "$TOR" = true ]; then TOR=false; else TOR=true; fi ;;
        7)  read -p "Enter delay in seconds: " DELAY ;;
        8)  read -p "Enter level (1-3): " LEVEL ;;
        9)  read -p "Enter tamper scripts (comma-separated): " TAMPER ;;
        10) read -p "Enter technique (e.g. time, file, class): " TECHNIQUE ;;
        11) if [ "$OS_SHELL" = true ]; then OS_SHELL=false; else OS_SHELL=true; fi ;;
        12) read -p "Enter remote file path to read: " FILE_READ ;;
        13) read -p "Enter local file to write: " FILE_WRITE
            read -p "Enter remote destination path: " FILE_DEST ;;
        14) read -p "Enter JSON report output file: " REPORT_JSON ;;
        15) run_commix ;;
        0)  echo "Exiting. Stay ethical!"; exit 0 ;;
        *)  echo "Invalid option."; sleep 1 ;;
    esac
done
