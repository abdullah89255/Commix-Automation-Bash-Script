#!/bin/bash

# ===============================
# 🔥 Commix Automation Script
# ===============================

echo "========================================="
echo "   Commix Command Injection Scanner"
echo "========================================="

# ====== INPUT ======
read -p "Enter target URL: " URL
read -p "Enter parameter to test (optional): " PARAM
read -p "Enter POST data (optional): " DATA
read -p "Enter cookie (optional): " COOKIE
read -p "Use proxy? (y/n): " USE_PROXY

# ====== DEFAULT SETTINGS ======
LEVEL=3
VERBOSE=2
CRAWL=2
TAMPER="space2ifs"
OUTPUT_DIR="./commix_results"
BATCH="--batch"

# ====== BUILD COMMAND ======
CMD="python3 commix.py -u \"$URL\" --level=$LEVEL -v $VERBOSE --crawl=$CRAWL --tamper=$TAMPER $BATCH --output-dir=$OUTPUT_DIR"

# ====== OPTIONAL PARAM ======
if [ ! -z "$PARAM" ]; then
    CMD="$CMD -p $PARAM"
fi

# ====== POST DATA ======
if [ ! -z "$DATA" ]; then
    CMD="$CMD --data=\"$DATA\""
fi

# ====== COOKIE ======
if [ ! -z "$COOKIE" ]; then
    CMD="$CMD --cookie=\"$COOKIE\""
fi

# ====== PROXY ======
if [ "$USE_PROXY" == "y" ]; then
    CMD="$CMD --proxy=\"http://127.0.0.1:8080\""
fi

# ====== HEADER TEST ======
read -p "Test headers (User-Agent)? (y/n): " HEADER_TEST
if [ "$HEADER_TEST" == "y" ]; then
    CMD="$CMD --headers=\"User-Agent: commix-test\""
fi

# ====== FINGERPRINT ======
read -p "Enable OS fingerprinting? (y/n): " FINGERPRINT
if [ "$FINGERPRINT" == "y" ]; then
    CMD="$CMD --fingerprint"
fi

# ====== MULTI TARGET ======
read -p "Use multiple targets file? (y/n): " MULTI
if [ "$MULTI" == "y" ]; then
    read -p "Enter file path: " FILE
    CMD="python3 commix.py -m $FILE --level=$LEVEL -v $VERBOSE --batch --output-dir=$OUTPUT_DIR"
fi

# ====== SHOW COMMAND ======
echo ""
echo "Running Command:"
echo "$CMD"
echo ""

# ====== EXECUTE ======
eval $CMD

# ====== DONE ======
echo ""
echo "Scan completed!"
echo "Results saved in: $OUTPUT_DIR"
