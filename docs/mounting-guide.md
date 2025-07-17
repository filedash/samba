# Samba Share Mounting Guide

This guide provides detailed instructions for mounting Samba shares on different operating systems.

## Table of Contents

- [Windows](#windows)
- [macOS](#macos)
- [Ubuntu/Linux](#ubuntulinux)
- [General Troubleshooting](#general-troubleshooting)

## Windows

### Method 1: File Explorer (GUI)

1. Open **File Explorer**
2. Click on **This PC** in the left sidebar
3. Click **Map network drive** in the toolbar
4. Choose a drive letter (e.g., Z:)
5. Enter the folder path: `\\<server-ip>\<share-name>`
   - Example: `\\192.168.1.100\user1`
6. Check **"Connect using different credentials"** if needed
7. Click **Finish**
8. Enter your username and password when prompted

### Method 2: Command Line

```cmd
# Map a network drive
net use Z: \\<server-ip>\<share-name> /persistent:yes

# With credentials
net use Z: \\<server-ip>\<share-name> /user:<username> <password> /persistent:yes

# Example
net use Z: \\192.168.1.100\user1 /user:user1 mypassword /persistent:yes
```

### Method 3: PowerShell

```powershell
# Map network drive
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\<server-ip>\<share-name>" -Persist

# With credentials
$credential = Get-Credential
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\<server-ip>\<share-name>" -Credential $credential -Persist

# Example
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\192.168.1.100\user1" -Persist
```

### Disconnect Drive

```cmd
# Disconnect network drive
net use Z: /delete

# Disconnect all network drives
net use * /delete
```

## macOS

### Method 1: Finder (GUI)

1. Open **Finder**
2. Press `Cmd + K` or go to **Go** → **Connect to Server**
3. Enter the server address: `smb://<server-ip>`
   - Example: `smb://192.168.1.100`
4. Click **Connect**
5. Choose **Registered User**
6. Enter your username and password
7. Select the share you want to mount
8. Click **OK**

### Method 2: Terminal

```bash
# Create mount point
sudo mkdir -p /Volumes/<share-name>

# Mount the share
sudo mount -t smbfs //username:password@<server-ip>/<share-name> /Volumes/<share-name>

# Example
sudo mkdir -p /Volumes/user1
sudo mount -t smbfs //user1:mypassword@192.168.1.100/user1 /Volumes/user1
```

### Method 3: Mount with Keychain (Secure)

```bash
# Mount without password in command (will prompt)
sudo mount -t smbfs //username@<server-ip>/<share-name> /Volumes/<share-name>

# Example
sudo mkdir -p /Volumes/user1
sudo mount -t smbfs //user1@192.168.1.100/user1 /Volumes/user1
```

### Unmount

```bash
# Unmount the share
sudo umount /Volumes/<share-name>

# Example
sudo umount /Volumes/user1
```

### Auto-mount on Login

1. Go to **System Preferences** → **Users & Groups**
2. Select your user and click **Login Items**
3. Click the **+** button
4. Add the mounted share from `/Volumes/`

## Ubuntu/Linux

### Method 1: File Manager (GUI)

#### GNOME (Ubuntu default)

1. Open **Files** (Nautilus)
2. Click **Other Locations** in the sidebar
3. In the **Connect to Server** field, enter: `smb://<server-ip>`
4. Press **Enter**
5. Enter your username and password
6. Select the share to mount

#### KDE (Dolphin)

1. Open **Dolphin**
2. Enter in the address bar: `smb://<server-ip>`
3. Enter credentials when prompted

### Method 2: Command Line (Temporary Mount)

```bash
# Install smbclient if not already installed
sudo apt update
sudo apt install cifs-utils

# Create mount point
sudo mkdir -p /mnt/<share-name>

# Mount the share
sudo mount -t cifs //<server-ip>/<share-name> /mnt/<share-name> -o username=<username>,password=<password>

# Example
sudo mkdir -p /mnt/user1
sudo mount -t cifs //192.168.1.100/user1 /mnt/user1 -o username=user1,password=mypassword
```

### Method 3: Secure Mount (Credentials File)

```bash
# Create credentials file
sudo nano /etc/samba/credentials

# Add to the file:
username=user1
password=mypassword
domain=WORKGROUP

# Secure the file
sudo chmod 600 /etc/samba/credentials

# Mount using credentials file
sudo mount -t cifs //<server-ip>/<share-name> /mnt/<share-name> -o credentials=/etc/samba/credentials

# Example
sudo mount -t cifs //192.168.1.100/user1 /mnt/user1 -o credentials=/etc/samba/credentials
```

### Method 4: Permanent Mount (fstab)

```bash
# Edit fstab
sudo nano /etc/fstab

# Add line to fstab:
//<server-ip>/<share-name> /mnt/<share-name> cifs credentials=/etc/samba/credentials,uid=1000,gid=1000,iocharset=utf8 0 0

# Example:
//192.168.1.100/user1 /mnt/user1 cifs credentials=/etc/samba/credentials,uid=1000,gid=1000,iocharset=utf8 0 0

# Test the mount
sudo mount -a

# Or mount specific entry
sudo mount /mnt/<share-name>
```

### Unmount

```bash
# Unmount the share
sudo umount /mnt/<share-name>

# Example
sudo umount /mnt/user1
```

### Advanced Linux Options

```bash
# Mount with specific user/group ownership
sudo mount -t cifs //<server-ip>/<share-name> /mnt/<share-name> -o username=<username>,password=<password>,uid=1000,gid=1000

# Mount with specific permissions
sudo mount -t cifs //<server-ip>/<share-name> /mnt/<share-name> -o username=<username>,password=<password>,file_mode=0755,dir_mode=0755

# Mount with SMB version specification
sudo mount -t cifs //<server-ip>/<share-name> /mnt/<share-name> -o username=<username>,password=<password>,vers=3.0
```

## General Troubleshooting

### Common Connection Issues

**"Network path not found" or "Connection refused":**

```bash
# Test if server is reachable
ping <server-ip>

# Test if Samba ports are open
telnet <server-ip> 445
# or
nc -zv <server-ip> 445

# List available shares
smbclient -L <server-ip> -U <username>
```

**Authentication errors:**

```bash
# Test credentials
smbclient //<server-ip>/<share-name> -U <username>

# Check user exists on server
# (run on server)
docker exec samba-server pdbedit -L
```

**Permission denied after mounting:**

- Check UID/GID mapping in docker-compose.yml
- Verify file permissions on the server
- Use uid/gid options when mounting on Linux

### Performance Optimization

**Linux mount options for better performance:**

```bash
sudo mount -t cifs //<server-ip>/<share-name> /mnt/<share-name> -o username=<username>,password=<password>,cache=strict,rsize=1048576,wsize=1048576
```

**Windows: Disable opportunistic locking if having issues:**

```cmd
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v EnableOplocks /t REG_DWORD /d 0 /f
```

### Security Notes

1. **Avoid passwords in command line** - use credential files or prompts
2. **Use strong passwords** for Samba accounts
3. **Consider VPN** for remote access instead of exposing Samba ports
4. **Regular updates** of client systems for security patches
5. **Monitor access logs** on the server

### Quick Reference

| OS      | Quick Connect                         |
| ------- | ------------------------------------- |
| Windows | `\\<server-ip>\<share>`               |
| macOS   | `smb://<server-ip>`                   |
| Linux   | `smb://<server-ip>` or mount commands |

### Example Scenarios

**Home Network Setup:**

- Server IP: 192.168.1.100
- Share: user1
- Username: user1
- Password: mypassword

**Windows:** `\\192.168.1.100\user1`
**macOS:** `smb://192.168.1.100`
**Linux:** `sudo mount -t cifs //192.168.1.100/user1 /mnt/user1 -o username=user1`
