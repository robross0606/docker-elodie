# elodie-docker

Docker container for a more recently updated fork of [Elodie](https://github.com/D3Zyre/Elodie.git)

<p align="center"><img src ="https://raw.githubusercontent.com/D3Zyre/elodie/master/creative/logo@300x.png" /></p>

The container default command is to watch a source folder using `inotifywait` or [`inotifywait-polling`](https://github.com/javanile/inotifywait-polling) and automatically execute `elodie` to import added images to a destination folder.

## Usage

```
docker run \
  -name elodie
  -v /path/to/source:/source \
  -v /path/to/destination:/destination \
  -e PUID=1000 \
  -e PGID=1000 \
  --restart unless-stopped \
  pbuyle/elodie
```

## Configuration

### Environment Variables

| Name                         | default value | Description
| ---------------------------- |:-------------:| -----------
| PUID                         | 1000          | for user id - see below for explanation
| PGID                         | 1000          | for group id - see below for explanation
| SOURCE                       | /source       | Import files from this directory
| DESTINATION                  | /destination  | Copy imported files into this directory
| TRASH                        |               | Set to move files to this trash folder after copying files
| EXCLUDE                      |               | Regular expression for directories or files to exclude
| ALLOW_DUPLICATE              |               | Set to import the files even if theu have already been imported
| ALBUM_FROM_FOLDER            |               | Set to use images' folders as their album names
| MAPQUEST_KEY                 |               | Mapquest API key for geo-code location from EXIF's GPS fields
| DEBUG                        |               | Set to enable debug messages
| INOTIFYWAIT_POLLING          |               | Set to enable use of inotifywait polling.  Useful for CIFS/SMB/NFS mounts.

### Advanced configurtion

Mount a custom `/elodie/config.ini` to set configuration.

```
docker run \
  -name elodie
  -v /path/to/source:/source \
  -v /path/to/destination:/destination \
  -v /path/to/config.ini:/elodie/config.ini:ro \
  -e PUID=1000 \
  -e PGID=1000 \
  --restart unless-stopped \
  pbuyle/elodie
```

Note: If a custom configuration file is used then setting the `MAPQUEST_KEY` environment variable will have not effect.

### User / Group Identifiers

When using volumes (-v flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user PUID and group PGID.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance PUID=1000 and PGID=1000, to find yours use id user as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```
