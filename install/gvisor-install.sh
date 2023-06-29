display_error() {
    echo "an error has occurred : $1"
    exit 1
}

set -e
ARCH=$(uname -m)
URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}

# Downloading files
wget ${URL}/runsc ${URL}/runsc.sha512 \
    ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512

# Checksums verification
sha512sum -c runsc.sha512 -c containerd-shim-runsc-v1.sha512

# Deleting checksum files
rm -f *.sha512

# Setting permissions
chmod a+rx runsc containerd-shim-runsc-v1

# Move files to /usr/local/bin with error checking
if ! sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin; then
    display_error "Failed to move files to /usr/local/bin."
fi

# Installation of runsc
if ! /usr/local/bin/runsc install; then
    display_error "Failed to install runsc."
fi

# Reloading Docker
if ! sudo systemctl reload docker; then
    display_error "Failure when reloading Docker."
fi

echo "The script run successfully."
