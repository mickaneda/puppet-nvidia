#!/usr/bin/env bash
url=$1
script=$(basename $url)
curl -LO "$url"
chmod 755 $script
./$script --accept-license --silent --disable-nouveau  --no-opengl-files --no-libglx-indirect --dkms

ret=$?
rm -f $script
rm -f $0
exit $ret
