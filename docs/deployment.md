# Deployment Guide

## Quick Start with Docker Hub Image

```bash
# Pull the latest image
docker pull filedash/samba

# Create configuration files
cat > users.conf << EOF
# User credentials (username:password)
myuser:mypassword
admin:adminpassword

# Share configuration
[myuser]
path = /mount/storage/myuser
valid users = myuser admin
read only = no
browseable = yes
writable = yes
EOF

# Run the container
docker run -d \
  --name samba-server \
  -p 139:139 \
  -p 445:445 \
  -v $(pwd)/storage:/mount/storage \
  -v $(pwd)/users.conf:/etc/samba/users.conf \
  filedash/samba
```

## Docker Compose Deployment

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  samba:
    image: filedash/samba:latest
    container_name: samba-server
    restart: unless-stopped
    ports:
      - '139:139'
      - '445:445'
    volumes:
      - ./storage:/mount/storage
      - ./users.conf:/etc/samba/users.conf
    environment:
      - TZ=UTC
      - HOST_UID=1000
      - HOST_GID=1000
```

Then run:

```bash
docker-compose up -d
```

## Building from Source

```bash
git clone <repository-url>
cd samba
docker-compose up -d
```

## File Structure

```
.
├── docker-compose.yml    # Docker Compose configuration
├── users.conf          # User and share definitions
├── storage/            # User data directory (created automatically)
└── docs/               # Documentation
```

## Environment Variables

- `TZ`: Timezone (default: UTC)
- `HOST_UID`: Host user ID for file permissions (default: 1000)
- `HOST_GID`: Host group ID for file permissions (default: 1000)
