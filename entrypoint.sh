#!/bin/bash
set -e

echo "[INFO] Starting GBT ML Editor with lightweight Geth"

# Define default genesis path
GENESIS_FILE="/app/genesis.json"

# If no genesis.json exists, create one dynamically
if [ ! -f "$GENESIS_FILE" ]; then
    echo "[INFO] No genesis.json found. Creating default Clique genesis..."
    cat > $GENESIS_FILE <<EOF
{
  "config": {
    "chainId": 999,
    "clique": {"period": 5, "epoch": 30000}
  },
  "difficulty": "1",
  "gasLimit": "8000000",
  "alloc": {
    "0x0000000000000000000000000000000000000001": {
      "balance": "1000000000000000000000000"
    }
  },
  "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000\
0000000000000000000000000000000000000000000000000000000000000000000000000000\
0000000000000000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x0"
}
EOF
fi

# Initialize chain with genesis
geth init $GENESIS_FILE

# Start health server in background
python3 /app/health_server.py &

# Start ML editor in background
uvicorn ml_editor:app --host 0.0.0.0 --port 8080 &

# Run geth node
exec geth \
  --http --http.addr "0.0.0.0" --http.port 9636 \
  --http.api "eth,net,web3,personal" \
  --networkid 999 \
  --nodiscover \
  --allow-insecure-unlock \
  --http.corsdomain "*" \
  --port 30303 \
  --ipcdisable
