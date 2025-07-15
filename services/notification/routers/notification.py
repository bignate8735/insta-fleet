from fastapi import APIRouter, HTTPException
from schemas.notification import EmailRequest, SMSRequest
from database.database import db
from datetime import datetime

router = APIRouter()

@router.post("/email")
async def send_email(req: EmailRequest):
    """
    Simulates sending an email. Stores the record in MongoDB.
    """
    try:
        result = await db.notifications.insert_one({
            "type": "email",
            "to": req.to,
            "subject": req.subject,
            "body": req.body,
            "status": "sent",
            "timestamp": datetime.utcnow()
        })
        return {"status": "sent", "method": "email", "to": req.to, "id": str(result.inserted_id)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {e}")

@router.post("/sms")
async def send_sms(req: SMSRequest):
    """
    Simulates sending an SMS. Stores the record in MongoDB.
    """
    try:
        result = await db.notifications.insert_one({
            "type": "sms",
            "to": req.to,
            "message": req.message,
            "status": "sent",
            "timestamp": datetime.utcnow()
        })
        return {"status": "sent", "method": "sms", "to": req.to, "id": str(result.inserted_id)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send SMS: {e}")