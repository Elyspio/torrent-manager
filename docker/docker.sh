#!/bin/bash
origin=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rm -rdf "$DIR/../front/build"
rm -rdf "$DIR/../back/build"
# Check if we are running on WSL (use Powershell to increase performances a lot)
if [ "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')" = 'microsoft' ]; then
powershell.exe "cd ../front ; yarn build"
powershell.exe "cd ../back ; yarn build"
else
cd ../front ; yarn build
cd ../back ; yarn build
fi
cp "$DIR/DockerFile" "$DIR/../DockerFile"
cd "$DIR/.." && docker buildx build --platform linux/arm64,linux/amd64  -f ./DockerFile  -t elyspio/torrent-manager --push .
rm "$DIR/../DockerFile"
cd $origin