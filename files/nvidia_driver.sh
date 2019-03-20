#!/usr/bin/env bash
nvidia-smi >&/dev/null
ret=$?
if [ $ret -eq 0 ];then
  rm -f $0
  exit
fi

url=$1
script=$(basename $url)
curl -LO "$url"
chmod 755 $script

# Need twice to load nvidia-uvm
./$script --accept-license --silent --disable-nouveau  --no-opengl-files --no-libglx-indirect --dkms
nvidia-smi >&/dev/null
ret=$?
if [ $ret -ne 0 ];then
  ./$script --accept-license --silent --disable-nouveau  --no-opengl-files --no-libglx-indirect --dkms
fi
nvidia-smi >&/dev/null
ret=$?
rm -f $script
rm -f $0
exit $ret
