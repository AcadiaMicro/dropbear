FROM amd64/gcc:4.9

LABEL org.opencontainers.image.authors="Kevin O\'Connor"
LABEL project=Ampion
LABEL version=DROPBEAR_2024.86_Ampion
LABEL description="gcc 4.9, mkj/dropbear DROPBEAR_2024.86"

COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

# Build our version of dropbear.  The build executable (unstripped and build for linux/amd64) will be in /usr/local/sbin for dropbear, /usr/local/bin for the others
RUN <<END_OF_RUN
./configure
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
make install
cp hostkey /
make distclean
END_OF_RUN

# we have no need for a CMD or ENTRYPOING