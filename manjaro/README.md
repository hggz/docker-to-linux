# some variant of this to build
docker build -f host.Dockerfile -t manjaro_xfce_host .
# some variant of this to run (mac example below)
docker container run --privileged -e DISPLAY=docker.for.mac.host.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix --net host -it manjaro_xfce_host
