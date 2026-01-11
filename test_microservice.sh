#!/bin/bash
set -euo pipefail

# 1) pornește mediul virtual (dacă ai)
if [ -f "./venv/bin/activate" ]; then
  echo "Activăm venv..."
  source ./venv/bin/activate
fi

echo "Pornim microserviciul..."
python3 app.py > server.log 2>&1 &
PID=$!
echo "PID server: $PID"

# 2) așteaptă activ până răspunde (max 15s)
MAX_WAIT=15
SLEEP_INTERVAL=1
TIME_PASSED=0
until curl -s -o /dev/null -I -w "%{http_code}" http://127.0.0.1:5000 | grep -q "200"; do
  sleep $SLEEP_INTERVAL
  TIME_PASSED=$((TIME_PASSED + SLEEP_INTERVAL))
  if [ $TIME_PASSED -ge $MAX_WAIT ]; then
    echo "❌ Serverul nu a pornit în $MAX_WAIT secunde. Log server:"
    tail -n 50 server.log
    kill $PID || true
    exit 1
  fi
done

echo "✅ Serverul răspunde (uptime ${TIME_PASSED}s). Testăm endpoint..."

# 3) Test efectiv
curl -I http://127.0.0.1:5000

# 4) oprește serverul curat
echo "Oprire server (PID $PID)..."
kill $PID
wait $PID 2>/dev/null || true

echo "✅ Test terminat."
