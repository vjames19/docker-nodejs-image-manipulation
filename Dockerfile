FROM phusion/passenger-nodejs:0.9.14

MAINTAINER Victor J. Reventos <victor.reventos1@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# node-canvas dependencies.
RUN apt-get update && apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++

# Install Libvips dependencies
RUN apt-get install -y \
	gobject-introspection \
	gtk-doc-tools \
	libglib2.0-dev \
	libjpeg-turbo8-dev \
	libpng12-dev \
	libwebp-dev \
	libtiff5-dev \
	libexif-dev \
	libxml2-dev \
	swig \
	libmagickwand-dev \
	libgsf-1-dev \
	liblcms2-dev \
	libxml2-dev \
	libmagickcore-dev


# Build libvips
WORKDIR /tmp
ENV LIBVIPS_VERSION_MAJOR 7
ENV LIBVIPS_VERSION_MINOR 42
ENV LIBVIPS_VERSION_PATCH 3
ENV LIBVIPS_VERSION $LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR.$LIBVIPS_VERSION_PATCH
RUN \
  curl -O http://www.vips.ecs.soton.ac.uk/supported/$LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR/vips-$LIBVIPS_VERSION.tar.gz && \
  tar zvxf vips-$LIBVIPS_VERSION.tar.gz && \
  cd vips-$LIBVIPS_VERSION && \
  ./configure --enable-debug=no --enable-docs=no --enable-cxx=yes --without-python --without-orc --without-fftw --without-gsf $1 && \
  make && \
  make install && \
  ldconfig

WORKDIR /home/app

# Set the User home
RUN echo "/root" > /etc/container_environment/HOME

CMD ["/sbin/my_init"]
