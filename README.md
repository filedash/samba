# Docker Samba Server

A simple, containerized Samba file server for easy network file sharing.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-filedash%2Fsamba-blue)](https://hub.docker.com/r/filedash/samba)

## Quick Start

```bash
# Pull and run
docker pull filedash/samba
docker run -d -p 139:139 -p 445:445 -v ./storage:/mount/storage filedash/samba
```

## Features

- 🐳 **Easy deployment** with Docker
- 👥 **Multi-user support** with individual shares
- 🔐 **Secure** SMB2/SMB3 authentication
- ⚙️ **Simple configuration** via text files
- 🎯 **Proper permissions** with UID/GID mapping

## Access Your Files

- **Windows**: `\\<server-ip>`
- **macOS**: `smb://<server-ip>`
- **Linux**: `smb://<server-ip>`

## Documentation

- � [Deployment Guide](docs/deployment.md) - Getting started
- ⚙️ [Configuration Guide](docs/configuration.md) - User management and settings
- 🗂️ [Mounting Guide](docs/mounting-guide.md) - OS-specific connection instructions
- 🔧 [Troubleshooting Guide](docs/troubleshooting.md) - Common issues and solutions

## License

MIT License - see [LICENSE](LICENSE) file for details.
