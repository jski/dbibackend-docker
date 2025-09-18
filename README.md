# DBI Server Docker

A Docker-based HTTP server setup for Nintendo Switch DBI network installations.

## Prerequisites

- Docker
- Docker Compose
- Network access to your Nintendo Switch
- At least 20GB free space for game storage

## Setup Instructions

1. Clone this repository:
```bash
git clone https://github.com/jski/dbibackend-docker
cd dbibackend-docker
```

2. Create the games directory structure:
```bash
mkdir -p nsw_games
```

3. Copy your Switch game files (NSP/NSZ/XCI/XCZ) to the `nsw_games` directory

4. Build and start the server:
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
4. Browse and install your games

## Notes

- The server runs on port 80 by default
- Maximum file upload size is set to 20GB
- Directory listing is enabled by default
- Make sure your firewall allows traffic on port 80

## Troubleshooting

1. If DBI can't connect, check:
   - Server IP address is correct in dbi.config
   - Switch and server are on same network
   - Port 80 is not blocked by firewall
   - Docker container is running (`docker-compose ps`)

2. For permission issues:
   - Ensure games directory has correct permissions
   - Check Docker logs for errors: `docker-compose logs`