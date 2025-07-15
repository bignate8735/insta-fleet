import os
import sys
from logging.config import fileConfig

from sqlalchemy import engine_from_config, pool
from alembic import context
from dotenv import load_dotenv

# --- 1. Set up paths so Alembic can find project modules ---
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# --- 2. Load environment variables ---

# Load .env.local from root (used for host-based migrations)
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../../../.env.local'))

# Load .env inside service directory (used in container)
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '..', '.env'))


# --- 3. Setup database connection string ---

# Try to use explicitly provided DATABASE_URL first
DATABASE_URL = os.getenv("DRIVER_DATABASE_URL") or os.getenv("DATABASE_URL")

# Fallback to build DB URL from individual parts (if not already set)
if not DATABASE_URL:
    DB_USER = os.getenv("DB_USER", "instaflite_user")
    DB_PASS = os.getenv("DB_PASS", "password")
    DB_HOST = os.getenv("DB_HOST", "driver-db")  # from docker-compose
    DB_PORT = os.getenv("DB_PORT", "3306")
    DB_NAME = os.getenv("DB_NAME", "driver_db")
    DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

print("Running migrations using host:", os.getenv("DB_HOST"))
print("DATABASE_URL:", DATABASE_URL)

# --- 4. Configure Alembic ---
config = context.config
config.set_main_option("sqlalchemy.url", DATABASE_URL)

# Logging config
if config.config_file_name:
    fileConfig(config.config_file_name)

# --- 5. Metadata target for autogeneration ---
from database.database import Base  # Must come after sys.path append
from models.driver import Driver  # Ensures model is registered

target_metadata = Base.metadata

# --- 6. Migration runners ---

def run_migrations_offline():
    """Run migrations in 'offline' mode."""
    context.configure(
        url=DATABASE_URL,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    """Run migrations in 'online' mode."""
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()

# --- 7. Run ---
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()

# --- 1. Set up paths so Alembic can find project modules ---
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# --- 2. Load environment variables ---

# Load .env inside service directory (used in container)
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '..', '.env'))

# Load .env.local from root (used for host-based migrations)
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../../../.env.local'))

# --- 3. Setup database connection string ---

# Try to use explicitly provided DATABASE_URL first
DATABASE_URL = os.getenv("DRIVER_DATABASE_URL") or os.getenv("DATABASE_URL")

# Fallback to build DB URL from individual parts (if not already set)
if not DATABASE_URL:
    DB_USER = os.getenv("DB_USER", "instaflite_user")
    DB_PASS = os.getenv("DB_PASS", "password")
    DB_HOST = os.getenv("DB_HOST", "driver-db")  # from docker-compose
    DB_PORT = os.getenv("DB_PORT", "3306")
    DB_NAME = os.getenv("DB_NAME", "driver_db")
    DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# --- 4. Configure Alembic ---
config = context.config
config.set_main_option("sqlalchemy.url", DATABASE_URL)

# Logging config
if config.config_file_name:
    fileConfig(config.config_file_name)

# --- 5. Metadata target for autogeneration ---
from database.database import Base  # Must come after sys.path append
from models.driver import Driver  # Ensures model is registered

target_metadata = Base.metadata

# --- 6. Migration runners ---

def run_migrations_offline():
    """Run migrations in 'offline' mode."""
    context.configure(
        url=DATABASE_URL,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    """Run migrations in 'online' mode."""
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()

# --- 7. Run ---
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()