import os
import smtplib
from email.mime.text import MIMEText
from fastapi import FastAPI, Request, BackgroundTasks, status
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, EmailStr
from dotenv import load_dotenv  # <-- ✅ IMPORT DOTENV

# Load the environment variables from the .env file
load_dotenv()

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

class EmailRequest(BaseModel):
    email: EmailStr

def send_email_worker(recipient_email: str):
    SMTP_SERVER = "smtp.gmail.com"
    SMTP_PORT = 465 # SSL Port
    
    # ✅ SECURE: Fetching credentials from the hidden environment settings
    SENDER_EMAIL = os.getenv("SENDER_EMAIL")
    SENDER_PASSWORD = os.getenv("SENDER_PASSWORD")

    # Fallback safety check in case the .env file is missing or misconfigured
    if not SENDER_EMAIL or not SENDER_PASSWORD:
        print("❌ Error: Missing email credentials in the environment variables.")
        return

    msg = MIMEText("Hello World, from fastapi checkout the project at https://github.com/deepak-k-marian/DockerAssignment !", "plain")
    msg["Subject"] = "FastAPI Hello World Notification"
    msg["From"] = f"Docker Assignment App <{SENDER_EMAIL}>"
    msg["To"] = recipient_email

    try:
        with smtplib.SMTP_SSL(SMTP_SERVER, SMTP_PORT) as server:
            server.login(SENDER_EMAIL, SENDER_PASSWORD)
            server.send_message(msg)
        print(f"✅ Email successfully delivered to {recipient_email}")
    except Exception as e:
        print(f"❌ Failed to send email to {recipient_email}. Error: {str(e)}")

@app.get("/", response_class=HTMLResponse)
def response(request: Request):
	return templates.TemplateResponse(request=request, name="index.html")

@app.post("/send-email", status_code=status.HTTP_202_ACCEPTED)
async def handle_email_request(payload: EmailRequest, background_tasks: BackgroundTasks):
    background_tasks.add_task(send_email_worker, payload.email)
    return {"status": "success", "message": "Email transmission initialized successfully."}
