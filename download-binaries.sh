#!/bin/bash

readonly DOWNLOADS=downloads

sudo apt-get update
sudo apt-get -y install \
    wget \
    curl \
    vim \
    openssl \
    git


wget -q --show-progress \
  --https-only \
  --timestamping \
  -P $DOWNLOADS \
  -i binaries.list

mkdir -p $DOWNLOADS/{cp,worker,client,etcd,cni,cr,csi}


for file in $(ls $DOWNLOADS/*gz); do
  echo "Exctracting $file...."

  if [[ "$file" =~ crictl ]]; then
    tar xzf $file --directory $DOWNLOADS/client/

  elif [[ "$file" =~ etcd ]]; then
    tar xzf $file --directory $DOWNLOADS/etcd
    cp $(find . -name etcdctl -type f) $DOWNLOADS/client/
    cp $(find . -name etcd -type f) $DOWNLOADS/cp/
    rm -rf $DOWNLOADS/etcd

  elif [[ "$file" =~ containerd ]]; then
    tar xzf $file --directory $DOWNLOADS/cr
    cp -r $DOWNLOADS/cr/ $DOWNLOADS/worker/
    cp -r $DOWNLOADS/cr/ $DOWNLOADS/cp/
    rm -rf $DOWNLOADS/cr

  elif [[ "$file" =~ cni-plugins ]]; then
    tar xzf $file --directory $DOWNLOADS/cni

  fi
  rm $file
done

mv $DOWNLOADS/kubectl $DOWNLOADS/client/
mv $DOWNLOADS/{kube-apiserver,kube-scheduler,kube-controller-manager} $DOWNLOADS/cp/

mv $DOWNLOADS/runc.amd64 $DOWNLOADS/runc
cp $DOWNLOADS/{kube-proxy,kubelet,runc} $DOWNLOADS/worker/
mv $DOWNLOADS/{kubelet,runc} $DOWNLOADS/cp/

rm $DOWNLOADS/kube-proxy

chmod +x $DOWNLOADS/{client,cp,worker}/*
sudo cp $DOWNLOADS/client/{kubectl,etcdctl,crictl} /usr/local/bin/
