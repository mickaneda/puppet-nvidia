#!/usr/bin/env bash
version=${1/-/.}
url=$2
if [ -z "$version" ] || [ -z "$url" ];then
  echo "Usage: $0 CUDA_VERSION CUDNN_URL"
  exit 1
fi

cuda_path=/usr/local/cuda-${version}
if [ ! -d $cuda_path ];then
  echo "cuda-${version} has not been installed"
  exit 2
fi

file=$(basename $url)

tmpdir=$(mktemp -d)
cd $tmpdir

curl -LO "$url"
tar xzf $file

cp -f ./cuda/include/* $cuda_path/include/
cp -f ./cuda/lib64/* $cuda_path/lib64/

rm -rf $tmpdir
rm -rf $0
