# Yet another Vagrantfile for Kubernetes

This repository provides a template Vagrantfile to create a CoreOS with Kubernetes using VirtualBox. This repository is forked from [coreos/coreos-kubernetes](https://github.com/coreos/coreos-kubernetes).

## Usage

Start the virtual machine with Vagrantfile.

```
$ vagrant up
```

Setup the configuration of Kubernetes.

```
$ sh utils/kube-config.sh
```

Access to the Kubernetes on virtual machine.

```
$ kubectl get nodes
NAME           LABELS                                STATUS    AGE
172.16.10.10   kubernetes.io/hostname=172.16.10.10   Ready     20m
```

Access to the Docker on virtual machine.

```
$ docker -H 172.16.10.10:2375 info
Containers: 17
Images: 8
Server Version: 1.10.1
Storage Driver: overlay
 Backing Filesystem: extfs
 Execution Driver: native-0.2
 Logging Driver: json-file
 Kernel Version: 4.4.1-coreos
 Operating System: CoreOS 970.1.0 (Coeur Rouge)
 CPUs: 2
 Total Memory: 3.864 GiB
 Name: localhost
 ID: 2RMB:4ZZI:4EON:6A5Z:3ITS:V37A:AR73:Z2PI:H2NI:JSFL:BRZZ:6FWQ
 Username: summerwind
 Registry: https://index.docker.io/v1/
```

