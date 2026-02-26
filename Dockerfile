# Use the official Python image as a base (for validation and pip)
FROM python:3.11-slim

# Install system dependencies for Pandoc and LaTeX
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        pandoc \
        texlive-full \
        librsvg2-bin \
        git \
        make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /workspace

# Copy requirements and install Python dependencies
COPY scripts/requirements.txt scripts/requirements.txt
RUN pip install --no-cache-dir -r scripts/requirements.txt

# Copy the rest of the project
COPY . .

# Make build script executable
RUN chmod +x scripts/build.sh

# Default command: build the ebook
CMD ["bash", "scripts/build.sh"]
