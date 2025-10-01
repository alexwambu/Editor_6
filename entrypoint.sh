from fastapi import FastAPI
import uvicorn, time, threading

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok", "service": "GBT ML Editor + Geth"}

def keep_alive():
    while True:
        print("[HEALTH] Node alive and running...")
        time.sleep(18)

threading.Thread(target=keep_alive, daemon=True).start()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
