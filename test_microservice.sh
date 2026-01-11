#!/bin/bash
set -e

source ./venv/bin/activate

python3 app.py > server.log 2>&1 &
PID=$!

sleep 3

pytest tests/

kill $PID

