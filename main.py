import smtplib
from email.mime.text import MIMEText
from fastapi import FastAPI, Request, BackgroundTasks, status
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, EmailStr

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

class EmailRequest(BaseModel):
    email: EmailStr

def send_email_worker(recipient_email: str):
    SMTP_SERVER = "smtp.gmail.com"
    SMTP_PORT = 465 # SSL Port
    SENDER_EMAIL = "your-email@gmail.com"
    SENDER_PASSWORD = "your-app-password"

    msg = MIMEText("Hello! Your FastAPI Docker assignment email test is working perfectly! 🚀", "plain")
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
