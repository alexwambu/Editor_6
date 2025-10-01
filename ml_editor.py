from fastapi import FastAPI
from transformers import pipeline

app = FastAPI()

# Load model once at startup
try:
    generator = pipeline("text-generation", model="distilgpt2")
    model_status = "ready"
except Exception as e:
    generator = None
    model_status = f"error: {e}"

@app.get("/ml/health")
def ml_health():
    """Check if ML model is loaded correctly"""
    return {"service": "ML Editor", "status": model_status}

@app.post("/ml/generate")
def generate_text(prompt: str):
    """Generate text from prompt using distilgpt2"""
    if generator is None:
        return {"error": "Model not loaded"}
    output = generator(prompt, max_length=50, num_return_sequences=1)
    return {"prompt": prompt, "generated": output[0]["generated_text"]}
