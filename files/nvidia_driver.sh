#!/usr/bin/env bash
url=$1
script=$(basename $url)
curl -LO "$url"
chmod 755 $script
./$script --accept-license --silent --disable-nouveau --dkms
rm -f $script
rm -f $0
