from pydantic import BaseModel, EmailStr

class EmailRequest(BaseModel):
    to: EmailStr
    subject: str
    body: str

class SMSRequest(BaseModel):
    to: str  # Consider validating phone format later
    message: str