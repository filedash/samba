FROM ubuntu:22.04

# Install Samba and necessary tools
RUN apt-get update && \
    apt-get install -y samba samba-common-bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create storage mount directory
RUN mkdir -p /mount/storage

# Copy configuration files
COPY smb.conf /etc/samba/smb.conf
COPY users.conf /etc/samba/users.conf
COPY init_users.sh /init_users.sh

# Make init script executable
RUN chmod +x /init_users.sh

# Create a startup script
COPY start_samba.sh /start_samba.sh
RUN chmod +x /start_samba.sh

# Expose Samba ports
EXPOSE 139 445

# Set the entrypoint
ENTRYPOINT ["/start_samba.sh"]
