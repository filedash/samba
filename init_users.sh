#!/bin/bash

# Initialize Samba users from configuration
echo "Initializing Samba users and directories..."

# Create mount directories based on share configurations under /mount/storage
echo "Creating user directories under /mount/storage..."
while read -r line; do
    # Look for share section headers [sharename]
    if [[ $line =~ ^\[([^]]+)\]$ ]]; then
        share_name="${BASH_REMATCH[1]}"
        share_dir="/mount/storage/$share_name"
        
        if [ -d "$share_dir" ]; then
            echo "Directory already exists: $share_dir"
        else
            echo "Creating directory: $share_dir"
            mkdir -p "$share_dir"
        fi
    fi
done < /etc/samba/users.conf

# Read user credentials from users.conf and create system users
echo "Creating Samba users..."
while IFS=':' read -r username password; do
    # Skip comments and empty lines
    if [[ $username =~ ^#.*$ ]] || [[ -z "$username" ]] || [[ $username == "["* ]]; then
        continue
    fi
    
    echo "Processing user: $username"
    
    # Create system user if it doesn't exist
    if ! id "$username" &>/dev/null; then
        echo "Creating system user: $username"
        useradd -M -s /bin/false "$username"
    else
        echo "System user already exists: $username"
    fi
    
    # Check if Samba user already exists
    if pdbedit -L | grep -q "^$username:"; then
        echo "Samba user already exists: $username"
        # Update password in case it changed
        echo -e "$password\n$password" | smbpasswd -s "$username"
    else
        echo "Creating Samba user: $username"
        # Set Samba password
        echo -e "$password\n$password" | smbpasswd -a -s "$username"
    fi
    
    # Ensure the user is enabled
    smbpasswd -e "$username"
    
done < <(grep -E '^[^#\[].*:.*' /etc/samba/users.conf)

echo "User and directory initialization complete."
