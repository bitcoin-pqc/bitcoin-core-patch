FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    bsdmainutils \
    python3 \
    git \
    libevent-dev \
    libboost-dev \
    libsqlite3-dev \
    libminiupnpc-dev \
    libnatpmp-dev \
    libzmq3-dev \
    libqrencode-dev \
    libdb-dev \
    libdb++-dev &&
    rm -rf /var/lib/apt/lists/*

# Create bitcoin user
RUN useradd -m -s /bin/bash bitcoin

# Clone and build Bitcoin Core
WORKDIR /home/bitcoin
RUN git clone https://github.com/bitcoin/bitcoin.git &&
    cd bitcoin &&
    git checkout v25.0 &&
    ./autogen.sh &&
    ./configure --disable-wallet --with-gui=no &&
    make -j$(nproc) &&
    make install &&
    cd .. &&
    rm -rf bitcoin

# Switch to bitcoin user
USER bitcoin

# Expose ports
EXPOSE 18444 18445

# Default command
CMD ["bitcoind"]
