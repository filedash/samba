# Docker Samba Server

A containerized Samba file server solution designed for easy deployment and user management. This project provides a complete Samba server setup with Docker Compose, featuring automatic user initialization, configurable shares, and proper permission handling.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-required-blue.svg)](https://www.docker.com/)

## Features

- 🐳 **Containerized**: Easy deployment with Docker and Docker Compose
- 👥 **Multi-user Support**: Configure multiple users with individual shares
- 🔐 **Secure**: SMB2/SMB3 protocol support with user authentication
- 📁 **Organized Storage**: Automatic directory creation for each user
- ⚙️ **Configurable**: Simple configuration via text files
- 🔄 **Auto-restart**: Container restarts automatically on failure
- 📊 **Monitoring**: Built-in logging and status monitoring
- 🎯 **UID/GID Mapping**: Proper file permission handling for host systems

## Quick Start

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd samba
   ```

2. **Configure users and shares**
   Edit `users.conf` to add your users and configure their shares:

   ```bash
   # Add users in format: username:password
   myuser:mypassword
   admin:adminpassword

   # Configure shares for each user
   [myuser]
   path = /mount/storage/myuser
   valid users = myuser admin
   read only = no
   browseable = yes
   writable = yes
   ```

3. **Start the server**

   ```bash
   docker-compose up -d
   ```

4. **Access your shares**

   - Windows: `\\<server-ip>`
   - macOS: `smb://<server-ip>`
   - Linux: `smb://<server-ip>` or mount via command line

   📖 **For detailed mounting instructions for all operating systems, see [Mounting Guide](docs/mounting-guide.md)**

## Configuration

### User Management

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

### Environment Variables

Set these in your environment or `.env` file:

- `UID`: Host user ID for file permissions (default: 1000)
- `GID`: Host group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: UTC)

### Storage

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

## Monitoring and Logs

### View Container Logs

```bash
docker-compose logs -f samba
```

### Check Samba Status

```bash
docker exec samba-server smbstatus
```

### Test Configuration

```bash
docker exec samba-server testparm
```

## Security Considerations

- Change default passwords in `users.conf`
- Use strong passwords for all accounts
- Consider using firewall rules to restrict access
- Regularly update the container image
- Monitor access logs for unusual activity

## Troubleshooting

### Common Issues

**Cannot connect to server:**

- Check if ports 139 and 445 are accessible
- Verify firewall settings
- Ensure the container is running: `docker ps`

**Permission denied:**

- Check UID/GID environment variables
- Verify user exists in `users.conf`
- Check file permissions on host storage directory

**Authentication failed:**

- Verify username/password in `users.conf`
- Check if user was created properly: `docker exec samba-server pdbedit -L`

### Debug Mode

Run with verbose logging:

```bash
docker-compose down
docker-compose up
```

## File Structure

```
.
├── docker-compose.yml    # Docker Compose configuration
├── Dockerfile           # Container build instructions
├── smb.conf            # Samba server configuration
├── users.conf          # User and share definitions
├── init_users.sh       # User initialization script
├── start_samba.sh      # Container startup script
├── storage/            # User data directory (created automatically)
├── docs/               # Documentation
│   └── mounting-guide.md # OS-specific mounting instructions
└── README.md           # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test them
4. Commit your changes: `git commit -am 'Add feature'`
5. Push to the branch: `git push origin feature-name`
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Samba Documentation](https://www.samba.org/samba/docs/)
- 🐳 [Docker Documentation](https://docs.docker.com/)
- �️ [Mounting Guide](docs/mounting-guide.md) - OS-specific instructions
- �🐛 [Report Issues](../../issues)

---

**Note**: This is an open-source project. Please ensure you comply with your organization's security policies before deploying in production environments.
