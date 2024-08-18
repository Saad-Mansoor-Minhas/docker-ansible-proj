FROM python:3.9-alpine

# Add a non-root user
RUN adduser --disabled-password --gecos '' myuser

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY app/requirements.txt .

# Install build dependencies, then remove them
RUN apk add --no-cache --virtual .build-deps gcc musl-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps

# Copy the rest of the application code
COPY /app .

# Change to non-root user
USER myuser

# Expose the application port
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run the application using Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
