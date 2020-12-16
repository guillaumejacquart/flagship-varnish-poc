# Dependencies

- Docker
- Docker Compose
- GCC & build essentials for building the library

# Build

## Go C Wrapper library
run `make build` to build the Go C Wrapper for the varnish module

## Varnish with varnish module
run `docker-compose build varnish` to build the Varnish image with the Flagship module enabled

# Configure

Fill out the `FS_ENV_ID` and `FS_API_KEY` environment variables in the docker-compose.yml file:

```yaml
environment: 
    FS_ENV_ID: your_env_id
    FS_API_KEY: your_api_key
```

# Run

```bash
docker-compose up -d
``` 

Then go to `http://localhost:8081` to see the website