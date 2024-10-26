# Aiken Docs Generator 

Docker container that builds the Aiken stdlib and serves the generated docs at runtime.

It also optionally saves the generated docs to a volume mount.

## Usage

```
docker-compose up -d
```

You can also set the `STDLIB_VERSION` and `AIKEN_VERSION` variables to override the default versions in the `docker-compose.yml` file.
