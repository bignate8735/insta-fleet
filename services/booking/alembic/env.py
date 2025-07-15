from logging.config import fileConfig
import os
import sys

from sqlalchemy import engine_from_config, pool
from alembic import context
from dotenv import load_dotenv

# Add root project dir to sys.path so Alembic can find your code
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Load environment variables from .env
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '..', '.env'))

# Import the Base metadata for autogeneration
from database.database import Base

# Alembic Config object
config = context.config

# Dynamically build DATABASE_URL if not explicitly provided
DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    DB_USER = os.getenv("DB_USER", "instaflite_user")
    DB_PASS = os.getenv("DB_PASS", "password")
    DB_HOST = os.getenv("DB_HOST", "booking-db")  # change accordingly
    DB_PORT = os.getenv("DB_PORT", "3306")
    DB_NAME = os.getenv("DB_NAME", "booking_db")  # or booking_db
    DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

config.set_main_option("sqlalchemy.url", DATABASE_URL)

# Configure logging
if config.config_file_name:
    fileConfig(config.config_file_name)

# Setup target metadata
target_metadata = Base.metadata

def run_migrations_offline():
    context.configure(
        url=DATABASE_URL,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()