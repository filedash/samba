# Configuration Guide

## User Management

Edit `users.conf` to manage users and shares:

```conf
# User credentials (username:password)
user1:password1
user2:password2
admin:adminpassword

# Share configuration
[user1]
path = /mount/storage/user1
valid users = user1 admin
read only = no
browseable = yes
writable = yes
guest ok = no
create mask = 0664
directory mask = 0775
```

## Environment Variables

Set these in your environment or `.env` file:

- `UID`: Host user ID for file permissions (default: 1000)
- `GID`: Host group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: UTC)

## Storage

- All user data is stored in `./storage/` directory
- Each user gets their own subdirectory
- Files maintain proper permissions with host system

## Network Configuration

The server exposes standard Samba ports:

- **139**: NetBIOS Session Service
- **445**: Microsoft-DS (SMB over TCP)

## Advanced Usage

### Custom Samba Configuration

Modify `smb.conf` for advanced Samba settings:

```conf
[global]
    workgroup = WORKGROUP
    server string = Samba Server
    security = user
    min protocol = SMB2
    max protocol = SMB3
```

### Multiple Shares per User

You can create multiple shares for a single user by adding multiple share sections in `users.conf`:

```conf
[user1-documents]
path = /mount/storage/user1/documents
valid users = user1

[user1-media]
path = /mount/storage/user1/media
valid users = user1
```

### Docker Compose Customization

Customize the deployment by modifying `docker-compose.yml`:

```yaml
services:
  samba:
    build: .
    ports:
      - '139:139'
      - '445:445'
    volumes:
      - ./storage:/mount/storage
      - ./users.conf:/etc/samba/users.conf
    environment:
      - TZ=America/New_York
      - HOST_UID=1000
      - HOST_GID=1000
```
