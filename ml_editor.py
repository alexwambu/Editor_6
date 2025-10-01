from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline

app = FastAPI()
chatbot = pipeline("text-generation", model="distilgpt2")

# In-memory session
chat_history = []

class UserMessage(BaseModel):
    message: str

@app.post("/chat")
def chat(user: UserMessage):
    global chat_history
    input_text = user.message
    chat_history.append({"user": input_text})

    response = chatbot(input_text, max_length=100, num_return_sequences=1)[0]['generated_text']
    chat_history.append({"bot": response})
7
    return {"reply": response, "history": chat_history}

@app.get("/history")
def history():
    return {"chat_history": chat_history}
