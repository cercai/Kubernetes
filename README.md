# Install Kubernetes

## Download the binaries in the jumpbox (or in local)

Clone the repository
```console
# Clone the repo
$ git clone https://github.com/cercai/Kubernetes.git
$ cd Kubernetes

# Download the binaries
$ ./download-binaries.sh

# Make sure the clients are installed
$ crictl --version
$ etcdctl version
$ kubectl version
```

