# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1 # Prevents python from writing pyc files
ENV PYTHONUNBUFFERED 1       # Prevents python from buffering stdout/stderr

# Set the working directory in the container
WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Render dynamically assigns a port via the PORT environment variable.
# Default to 8080 if PORT is not set (useful for local testing).
ENV PORT ${PORT:-8080}

# Expose the port the app runs on (dynamically set by Render)
EXPOSE $PORT

# Command to run the application using Uvicorn.
# It will listen on the port specified by the PORT environment variable.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "$PORT"]

