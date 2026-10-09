#!/usr/bin/env bash

# LinkedIn Automation Bot - macOS/Linux Launcher
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "Starting LinkedIn Automation Bot..."

# Ensure venv exists
if [ ! -d ".venv" ]; then
    echo "Setting up Python virtual environment..."
    python3 -m venv .venv
    .venv/bin/pip install -r requirements.txt
fi

# Ensure frontend dependencies are installed
if [ ! -d "ui/node_modules" ]; then
    echo "Installing frontend dependencies..."
    (cd ui && npm install)
fi

# Start Backend API Server (Port 5001)
echo "Starting backend on http://localhost:5001..."
.venv/bin/python3 server.py &
BACKEND_PID=$!

# Start Frontend UI Server (Port 5173)
echo "Starting frontend on http://localhost:5173..."
(cd ui && npm run dev) &
FRONTEND_PID=$!

# Cleanup on exit
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null" EXIT

# Wait a moment and open browser
sleep 2
open "http://localhost:5173" 2>/dev/null || true

echo ""
echo "🚀 LinkedIn Automator is running!"
echo "Website URL: http://localhost:5173"
echo "Backend API: http://localhost:5001"
echo ""
echo "Press Ctrl+C to stop both servers."

wait
