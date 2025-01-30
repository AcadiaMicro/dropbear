## Dropbear SSH for Ampion Google Cloud Run
A smallish SSH server and client based on https://matt.ucc.asn.au/dropbear/dropbear.html

This implementation can be run on Google Cloud Run instances and make use of the reverse proxy `chisel` talking back to our jumpbox. Users with access to our jumpbox can get a shell or run commands on the instance through ssh.

### Building and deploying
A `Dockerfile` and `docker-compose.yml` are provided to build and push our modified `dropbear` to **Ampion**'s docker repository.  The executable for `dropbear` will be placed in `/usr/local/sbin` on the image. The other executables will be in `/usr/local/bin`. They can be copied from there to other images that would be deployed to Google Cloud Run.

The use of the `Dockerfile` and `docker-compose.yml` is quite simple.

Run the following commands to build the new image with the executables and push it to our docker repository
```
docker-compose build
docker-compose push
```

### Using the as-built image as a source for `dropbear`
The Google Cloud Run instance will need 2 files from this image.  They can be copied using something like the following lines in the `Dockerfile`that builds the image.
```
COPY --from=us-docker.pkg.dev/ampion-tech/ampion-docker/ampion-dropbear /usr/local/sbin/dropbear /usr/local/bin/dropbear
COPY --from=us-docker.pkg.dev/ampion-tech/ampion-docker/ampion-dropbear /hostkey /hostkey
```

Then in a script run on the container using this image, run something like the following where `DROPBEAR_PORT` is the port the `chisel` server will reverse-proxy to.
```
nohup /usr/local/bin/dropbear -F -p ${DROPBEAR_PORT} -E -r /hostkey &
```