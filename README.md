# Minecraft Server [![Docker Repository on Quay](https://quay.io/repository/spesnova/minecraft/status "Docker Repository on Quay")](https://quay.io/repository/spesnova/minecraft)
This is a Docker Compose application for Minecraft Server.

This app has backup and restore mechanism. Also if you are using Slack, you can notify user events to Slack (ex. who is joined, left, dead, archived...)

## SUPPORTED TAGS

- `latest`
 - Minecraft Server: Spigot 1.8
 - Plugin: AutosaveWorld 4.14.2
 - Plugin: JoinAndLeaveMessages 1.2
 - Plugin: Dynmap v2.2

## HOW TO USE
### Start a Minecraft Server
To start a Minecraft Server, just start server service.

```
$ compose up -d server
```

If you want to configure server setting, modify config files under `data` dir and rebuild the docker image.

```bash
$ tree data
data
├── banned-ips.json
├── banned-players.json
├── bukkit.yml
├── commands.yml
├── config
├── eula.txt
├── help.yml
├── logs
├── mods
├── ops.json
├── permissions.yml
├── plugins
│   ├── AutoSaveWorld
│   │   ├── config.yml
│   │   └── configmsg.yml
│   ├── JoinAndLeaveMessages
│   │   └── config.yml
│   └── dynmap
├── server.properties
├── spigot.yml
└── whitelist.json

7 directories, 14 files
```

```bash
$ compose build server
```

### Backup worlds data
To backup worlds data, start backup service.
Backup service will take a backup and upload it to S3 bucket regularly.
See for more detail: [spesnova/dockup](https://github.com/spesnova/dockup)

Backup service requires AWS security credentials.
So set them to `.env`.

```
# .env
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
```

Also, you can configure which bucket to save it and when backup should starts.

```
# .env
BACKUP_NAME=worlds
MAX_NUMBER_OF_BACKUPS=10
S3_BUCKET_NAME=my-minecraft-backup
PATHS_TO_BACKUP=/data/world /data/world_nether /data/world_the_end /data/plugins/dynmap/web/tiles/world
CRON_TIME=3 0-23/3 * * *
```

Then, start backup service.

```
$ compose up -d backup
```

### Restore from backup
To restore with backup data on S3, run restore service.

Same as backup mechanism, restore service requires AWS security credentials.

```
# .env
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
```

Start or Restart server service after restore service finished restoring operation.

```
$ compose up restore
...
...
minecraft_restore_1 exited with code 0

$ compose up -d server
```

### Notify user events to Slack
First, get your incoming webhook URL.
See: https://api.slack.com/incoming-webhooks

Second, configure your Slack setting in `.env`

```
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxxx/xxxx/xxxxx
SLACK_CHANNEL=minecraft
SLACK_USERNAME=Minecraft Server
SLACK_ICON_EMOJI=minecraft
```

Then start notify service.

```
$ compose up -d notify
```

notify service gets Minecraft Server's log and extracts user events and posts it to Slack.
