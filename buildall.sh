#/bin/sh

###########################################################################
# Build all the simh images, optionally including the base -allsims image
#
# Usage: buildall.sh [-ba]
# 
#     -ba: Build also the -allsims image
#
###########################################################################

IMAGES="simh-pdpbsd simh-pdpv7 simh-vaxbsd simh-vaxnbsd simh-os8"
TAG="latest"

if [ "$1" == "-ba" ]; then
    echo "Building the idiotoflinux/simh-allsims:$TAG image."
    docker buildx build --platform linux/arm64 -t idiotoflinux/simh-allsims:$TAG -f Dockerfile-allsims .
fi

for i in $IMAGES; do
    FILESUF=`echo $i | cut -d'-' -f 2`
    echo "Building image: idiotoflinux/$i:$TAG based on Dockerfile-$FILESUF"
    docker buildx build --platform linux/arm64 -t idiotoflinux/$i:$TAG -f Dockerfile-$FILESUF .
done
