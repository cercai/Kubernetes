# SSH access

Create the user *kube* on each node of the cluster
```console
$ sudo -i
$ adduser kube
```

Generate a key in the jumpbox machine
```console
$ su - kube
$ ssh-keygen -t ecdsa

$ cat ~/.ssh/id_ecdsa.pub 
"ecdsa-sha2-nistp256 AAA"
```

Create the *.ssh* directory on all the nodes
```console
$ mkdir -p /home/kube/.ssh
$ chmod 700 /home/kube/.ssh
$ chown kube:kube /home/kube/.ssh

# Copy the content of the public key on all the nodes of the cluster
$ echo "ecdsa-sha2-nistp256 AAAAE2VjZHN.. kube@home" > /home/kube/.ssh/authorized_keys
$ chmod 600 /home/kube/.ssh/authorized_keys
$ chown kube:kube /home/kube/.ssh/authorized_keys
```


Run the ssh-agent to avoid writing the passphrase each time you connect in ssh to the remote server
```console
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_ecdsa
```

Add the nodes to the hosts file of the jumpbox
```console
$ sudo -i
$ echo "" >> /etc/hosts
$ cat machines.list >> /etc/hosts

# Make sure the nodes are reachable
$ ping controle-plane-1
$ ping worker-1
$ ping worker-2
```

Create our first aliases on the jumpbox
```console
cat << EOF > /home/kube/.bashrc
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ecdsa

alias cp1="ssh kube@controle-plane-1"
alias w1="ssh kube@worker-1"
alias w2="ssh kube@worker-2"
EOF
```



