Nice—adding a **help/usage system** makes your script much more professional and easy to reuse 👍

Here’s an **upgraded version of your Commix automation script** with:

* `-h / --help` support
* Command-line arguments
* Interactive fallback (if no args given)

---

# 🧰 ✅ Commix Automation Script (with Help Options)

```bash
#!/bin/bash

# =========================================
# 🔥 Commix Automation Script (Advanced)
# =========================================

# ====== HELP FUNCTION ======
show_help() {
echo "========================================="
echo " Commix Command Injection Scanner"
echo "========================================="
echo ""
echo "Usage:"
echo "  ./commix_auto.sh [options]"
echo ""
echo "Options:"
echo "  -u, --url          Target URL"
echo "  -p, --param        Parameter to test"
echo "  -d, --data         POST data"
echo "  -c, --cookie       Cookie value"
echo "  --proxy            Use Burp proxy (127.0.0.1:8080)"
echo "  --headers          Test User-Agent header"
echo "  --fingerprint      Enable OS fingerprinting"
echo "  -m, --multi        File with multiple targets"
echo "  -l, --level        Scan level (1-5, default=3)"
echo "  -v, --verbose      Verbosity (1-3, default=2)"
echo "  --crawl            Crawl depth (default=2)"
echo "  -o, --output       Output directory"
echo "  -h, --help         Show this help menu"
echo ""
echo "Examples:"
echo "  ./commix_auto.sh -u http://site.com/page.php?id=1"
echo "  ./commix_auto.sh -u http://site.com -p id --level 5"
echo "  ./commix_auto.sh -m targets.txt"
echo ""
exit 0
}

# ====== DEFAULT VALUES ======
LEVEL=3
VERBOSE=2
CRAWL=2
OUTPUT_DIR="./commix_results"
TAMPER="space2ifs"

# ====== ARGUMENT PARSER ======
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--url)
            URL="$2"
            shift 2
            ;;
        -p|--param)
            PARAM="$2"
            shift 2
            ;;
        -d|--data)
            DATA="$2"
            shift 2
            ;;
        -c|--cookie)
            COOKIE="$2"
            shift 2
            ;;
        --proxy)
            PROXY="yes"
            shift
            ;;
        --headers)
            HEADERS="yes"
            shift
            ;;
        --fingerprint)
            FINGERPRINT="yes"
            shift
            ;;
        -m|--multi)
            MULTI_FILE="$2"
            shift 2
            ;;
        -l|--level)
            LEVEL="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE="$2"
            shift 2
            ;;
        --crawl)
            CRAWL="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# ====== INTERACTIVE MODE (if no URL & no file) ======
if [[ -z "$URL" && -z "$MULTI_FILE" ]]; then
    echo "No arguments provided. Switching to interactive mode..."
    read -p "Enter target URL: " URL
fi

# ====== BUILD COMMAND ======
if [[ ! -z "$MULTI_FILE" ]]; then
    CMD="python3 commix.py -m $MULTI_FILE --level=$LEVEL -v $VERBOSE --batch --output-dir=$OUTPUT_DIR"
else
    CMD="python3 commix.py -u \"$URL\" --level=$LEVEL -v $VERBOSE --crawl=$CRAWL --tamper=$TAMPER --batch --output-dir=$OUTPUT_DIR"
fi

# ====== OPTIONAL FLAGS ======
[ ! -z "$PARAM" ] && CMD="$CMD -p $PARAM"
[ ! -z "$DATA" ] && CMD="$CMD --data=\"$DATA\""
[ ! -z "$COOKIE" ] && CMD="$CMD --cookie=\"$COOKIE\""
[ "$PROXY" == "yes" ] && CMD="$CMD --proxy=\"http://127.0.0.1:8080\""
[ "$HEADERS" == "yes" ] && CMD="$CMD --headers=\"User-Agent: commix-test\""
[ "$FINGERPRINT" == "yes" ] && CMD="$CMD --fingerprint"

# ====== EXECUTE ======
echo ""
echo "========================================="
echo " Running Commix Scan..."
echo "========================================="
echo "$CMD"
echo ""

eval $CMD

echo ""
echo "✅ Scan completed!"
echo "📁 Results saved in: $OUTPUT_DIR"
```

---

# 🚀 How to Use (Examples)

### Basic scan:

```bash
./commix_auto.sh -u "http://target.com/page.php?id=1"
```

### Advanced scan:

```bash
./commix_auto.sh -u "http://target.com" -p id --level 5 --headers --fingerprint
```

### Multiple targets:

```bash
./commix_auto.sh -m targets.txt
```

### Help menu:

```bash
./commix_auto.sh -h
```

---

# 🧠 What You Improved

✔ Professional CLI tool style
✔ Easy reuse (no prompts needed)
✔ Flexible automation
✔ Beginner + advanced friendly

---

