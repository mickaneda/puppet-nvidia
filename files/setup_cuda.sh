if [ -n "$1" ];then
  CUDA_VERSION=$1
fi
export CUDA_VERSION
if [ -n "$CUDA_VERSION" ];then
  export CUDA_HOME=/usr/local/cuda-$CUDA_VERSION
else
  export CUDA_HOME=/usr/local/cuda
fi
export PATH=$CUDA_HOME/bin${PATH:+:$PATH}
export LD_LIBRARY_PATH=$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export INCLUDE_PATH=$CUDA_HOME/include${INCLUDE_PATH:+:$INCLUDE_PATH}
export CPATH=$CUDA_HOME/include${CPATH:+:$CPATH}
