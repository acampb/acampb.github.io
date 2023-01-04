#!/bin/sh
DESIRED_VERSION="v0.109.0"

# use wget to download latest hugo extended version
echo "Downloading hugo extended version $DESIRED_VERSION"
VERSION_TRIMMED=$(echo $DESIRED_VERSION | tr -d 'v')
wget "https://github.com/gohugoio/hugo/releases/download/${DESIRED_VERSION}/hugo_extended_${VERSION_TRIMMED}_linux-arm64.deb"

# install hugo extended
echo "Installing hugo extended version $DESIRED_VERSION"
sudo dpkg -i hugo_extended_${VERSION_TRIMMED}_linux-arm64.deb

# remove downloaded file
echo "Removing downloaded file"
rm hugo_extended_${VERSION_TRIMMED}_linux-arm64.deb

# check if desired version is the latest version
# query github api for latest release
LATEST_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq .tag_name | tr -d '"')

# check if latest version is the same as desired version
if [ "$LATEST_VERSION" != "$DESIRED_VERSION" ]; then
    echo ""
    echo "!! Newer version is available: $LATEST_VERSION"
    echo "https://github.com/gohugoio/hugo/releases"
fi
