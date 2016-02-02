# Minecraft Server
This is a Docker Compose application for Minecraft Server. This app has backup and restore mechanism. Also if you use Slack, you can notify user events to Slack (ex. who is login, logout, dead, archived...)

## SUPPORTED TAGS

- `latest`
 - Minecraft Server 1.8.7

## HOW TO USE
### Start the server
To start Minecraft Server, just start server service.

```
$ compose up -d server
```

If you want to configure server setting, modify config files under `config` dir and rebuild the docker image.

```
$ ls config
banned-ips.json
banned-players.json
eula.txt
ops.json
server.properties
whitelist.json
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
S3_BUCKET_NAME=my-minecraft-backup
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

Then start fluentd service.

```
$ compose up -d fluentd
```

fluentd service gets Minecraft Server's log and extracts user events and posts it to Slack.
