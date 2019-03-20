#!/usr/bin/env bash
if [ -f /proc/driver/nvidia/version ];then
  rm -f $0
  exit
fi

url=$1
script=$(basename $url)
curl -LO "$url"
chmod 755 $script

# Need twice to load nvidia-uvm
./$script --accept-license --silent --disable-nouveau  --no-opengl-files --no-libglx-indirect --dkms
./$script --accept-license --silent --disable-nouveau  --no-opengl-files --no-libglx-indirect --dkms

ret=$?
rm -f $script
rm -f $0
exit $ret
