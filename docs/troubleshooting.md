# Troubleshooting Guide

## Common Issues

### Cannot connect to server

**Symptoms:**

- Client cannot reach the Samba server
- Connection timeouts

**Solutions:**

- Check if ports 139 and 445 are accessible
- Verify firewall settings on host and client
- Ensure the container is running: `docker ps`
- Test network connectivity: `telnet <server-ip> 445`

### Permission denied

**Symptoms:**

- Cannot read/write files
- Access denied errors

**Solutions:**

- Check UID/GID environment variables match your host user
- Verify user exists in `users.conf`
- Check file permissions on host storage directory
- Ensure share configuration allows write access

### Authentication failed

**Symptoms:**

- Invalid username/password errors
- Cannot log in to shares

**Solutions:**

- Verify username/password in `users.conf`
- Check if user was created properly: `docker exec samba-server pdbedit -L`
- Restart container after user changes
- Clear client credential cache

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

### Debug Mode

Run with verbose logging:

```bash
docker-compose down
docker-compose up
```

## Security Considerations

- Change default passwords in `users.conf`
- Use strong passwords for all accounts
- Consider using firewall rules to restrict access
- Regularly update the container image
- Monitor access logs for unusual activity
- Use VPN for remote access when possible
