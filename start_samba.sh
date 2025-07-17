#!/bin/bash

echo "Starting Samba container..."

# Get host user ID from environment or use default
HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-1000}

echo "Using HOST_UID=$HOST_UID and HOST_GID=$HOST_GID"

# Initialize users
/init_users.sh

# Set proper permissions for storage directory
# Use host user/group IDs for better compatibility
chown -R $HOST_UID:$HOST_GID /mount/storage
chmod -R 775 /mount/storage

# Create log directory
mkdir -p /var/log/samba

# Test Samba configuration
testparm -s

# Start Samba services
echo "Starting nmbd..."
nmbd -D

echo "Starting smbd..."
smbd -D

# Keep container running and show logs
echo "Samba server is running..."
# Wait for log files to be created, then tail them
sleep 2
if ls /var/log/samba/*.log 1> /dev/null 2>&1; then
    tail -f /var/log/samba/*.log
else
    echo "No log files found yet, monitoring..."
    # Keep container alive
    while true; do
        sleep 60
        if ls /var/log/samba/*.log 1> /dev/null 2>&1; then
            echo "Log files found, starting to monitor..."
            tail -f /var/log/samba/*.log
            break
        fi
    done
fi
