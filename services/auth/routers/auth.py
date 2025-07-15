from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy.exc import IntegrityError

from database.database import get_db
from models.user import User
from utils.password import hash_password, verify_password
from utils.jwt import create_access_token

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)

# -------------------------------
# Request & Response Schemas
# -------------------------------

class RegisterRequest(BaseModel):
    email: EmailStr = Field(..., example="user@example.com", description="Valid user email")
    password: str = Field(..., min_length=6, example="strongpassword", description="User password")

class LoginRequest(BaseModel):
    email: EmailStr = Field(..., example="user@example.com", description="Registered email address")
    password: str = Field(..., example="strongpassword", description="User's password")

class AuthResponse(BaseModel):
    access_token: str = Field(..., example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    token_type: str = Field(default="bearer", example="bearer")

class MessageResponse(BaseModel):
    message: str = Field(..., example="User successfully registered.")

# -------------------------------
# Register Endpoint
# POST /auth/register
# -------------------------------
@router.post(
    "/register",
    response_model=MessageResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new user",
    description="""
    Register a new user with a unique email and a password.

    This endpoint hashes the password securely before saving to the database.
    """
)
def register_user(data: RegisterRequest, db: Session = Depends(get_db)):
    """
    Create a new user in the database with hashed password.

    Returns a success message on completion.
    """
    user = User(email=data.email, hashed_password=hash_password(data.password))
    
    try:
        db.add(user)
        db.commit()
        db.refresh(user)
        return {"message": "User successfully registered."}
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Email already registered")

# -------------------------------
# Login Endpoint
# POST /auth/login
# -------------------------------
@router.post(
    "/login",
    response_model=AuthResponse,
    summary="Authenticate a user",
    description="""
    Login a registered user and receive a JWT token in response.

    Token is valid for 30 minutes (or as configured via ENV).
    """
)
def login_user(data: LoginRequest, db: Session = Depends(get_db)):
    """
    Verifies the email and password.
    
    If successful, returns an access token to be used for protected routes.
    """
    user = db.query(User).filter(User.email == data.email).first()

    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid email or password")

    token = create_access_token({"sub": user.email})
    return {"access_token": token, "token_type": "bearer"}