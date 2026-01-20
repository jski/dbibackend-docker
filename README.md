# DBI Server Docker

A minimal Docker-based HTTP server for Nintendo Switch DBI network installs.

## Prerequisites

- Docker
- Docker Compose
- Network access to your Nintendo Switch
- At least 20GB free space for game storage

## Quickstart (Local Folder)

1. Clone this repository:
```bash
git clone https://github.com/jski/dbibackend-docker
cd dbibackend-docker
```

2. Create the games directory:
```bash
mkdir -p nsw_games
```

3. Copy your NSP/NSZ/XCI/XCZ files into `nsw_games`

4. Start the server:
```bash
docker-compose up -d
```

Your DBI URL will be:

```
http://YOUR_SERVER_IP:65080/nsw_games/
```

## Remote Share (CIFS/SMB)

If your files live on a NAS, use the CIFS volume in `docker-compose.yaml`:

1. Comment out the local bind mount and enable the CIFS volume.
2. Copy `.env.example` to `.env` and fill in your NAS details.
3. Start the server:

```bash
docker-compose up -d
```

## Configuration

### DBI Configuration

On your Nintendo Switch, edit the `dbi.config` file and add:

```ini
[Network sources]
Home server=ApacheHTTP|http://YOUR_SERVER_IP:65080/nsw_games/
```

Replace `YOUR_SERVER_IP` with your server's IP address.

> [!NOTE]
> dbi.config should live next to wherever you have dbi.nro on your Switch. Could be in /switch/ or /switch/DBI/, so use what you have!

### Filename Safety (Recommended)

DBI can be picky about filenames served via HTTP. This image validates names on startup and fails fast if it finds anything risky.

Allowed characters (safe ASCII allowlist):

- Letters and numbers
- Space
- `-` `_` `.` `(` `)` `[` `]`
- `+` `'`

It also rejects leading/trailing spaces and trailing dots.

If the container refuses to start, check logs and rename the files or folders it reports.

You can control the validator with env vars:

- `DBI_VALIDATE_FILENAMES=0` to disable
- `DBI_VALIDATE_DIR=/var/www/html/nsw_games` to override the target directory

### Environment File

`.env` is ignored by git. Use `.env.example` as your template for local settings.

### Security Configuration (Optional)

To restrict access to specific IP addresses, uncomment and modify these lines in `nginx.conf`:

```nginx
allow 192.168.1.0/24;  # Replace with your network range
deny all;
```

## Usage

1. Start the server using `docker-compose up -d`
2. Launch DBI on your Switch
3. Select "Home server" from the main menu
4. Browse and install your files

To run the filename check on demand:

```bash
docker-compose exec nginx /docker-entrypoint.d/10-validate-filenames.sh
```

## Notes

- The container listens on port 80; the host port is `65080` by default
- Maximum file upload size is set to 20GB
- Directory listing is enabled by default
- Make sure your firewall allows traffic on port 80

## Security Notes

- This is intended for local networks only; do not expose it to the public internet.
- If you need extra safety, restrict access with `allow`/`deny` in `nginx.conf`.

## Credits

- DBI is developed by https://github.com/rashevskyv/dbi

## Troubleshooting

1. If DBI can't connect, check:
   - Server IP address is correct in dbi.config
   - Switch and server are on same network
   - Port 80 is not blocked by firewall
   - Docker container is running (`docker-compose ps`)

2. For permission issues:
   - Ensure files directory has correct permissions
   - Check Docker logs for errors: `docker-compose logs`

3. For remote share (CIFS) issues:
   - Verify `.env` credentials and `CIFS_DEVICE` path
   - Confirm the NAS share is reachable from the Docker host
   - Check Docker logs for mount errors: `docker-compose logs`
