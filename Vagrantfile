# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'
require "erb"

Vagrant.require_version ">= 1.6.0"

K8S_VERSION = "v1.1.8"
K8S_CLUSTER_IP = "10.3.0.1"
K8S_NODE_IP = "172.16.10.10"
K8S_POD_IP_RANGE = "10.2.0.0/16"
K8S_SERVICE_IP_RANGE = "10.3.0.0/24"
K8S_API_SERVICE_IP = "10.3.0.1"
K8S_DNS_SERVICE_IP = "10.3.0.10"
ETCD_ENDPOINTS = "http://127.0.0.1:2379"

FILE_TEMPLATES = [
  "systemd/kubelet.service",
  "systemd/kube-apiserver.service",
  "systemd/kube-controller-manager.service",
  "systemd/kube-scheduler.service",
  "systemd/kube-proxy.service",
  "systemd/docker.service.d/10-dev.conf",
  "systemd/docker.service.d/40-flannel.conf",
  "systemd/flanneld.service.d/40-ExecStartPre-symlink.conf",
  "flannel/options.env",
  "scripts/init-flannel.sh",
  "scripts/init-kube-system.sh",
  "kubernetes/kube-system.json",
  "kubernetes/kube-dns-rc.json",
  "kubernetes/kube-dns-svc.json",
]

PATH_USER_DATA = "user-data"
PATH_TLS_TARBALL = "tls/controller.tar"

system("mkdir -p tls")
system("./utils/init-tls-ca tls") or abort ("failed generating TLS CA artifacts")
system("./utils/init-tls tls apiserver controller IP.1=#{K8S_NODE_IP},IP.2=#{K8S_CLUSTER_IP}") or abort ("failed generating TLS certificate artifacts")
system("./utils/init-tls tls admin kube-admin") or abort("failed generating admin TLS artifacts")

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  config.vm.box = "coreos-alpha"
  config.vm.box_version = ">= 970.0.0"
  config.vm.box_url = "http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"

  config.vm.network :private_network, ip: K8S_NODE_IP

  config.vm.provider :virtualbox do |v|
    v.name = "Kubernetes"
    v.cpus = 2
    v.memory = 4096
    v.gui = false
    v.check_guest_additions = false
    v.functional_vboxsf = false
  end

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  FILE_TEMPLATES.each do |template|
    dir = "files/" + File.dirname(template)
    if not Dir.exist?(dir) then
      FileUtils.mkdir_p(dir)
    end

    file = "files/#{template}"
    File.write(file, ERB.new(File.read("templates/#{template}")).result(binding))
    config.vm.provision :file, :source => file, :destination => "/tmp/#{file}"
  end

  config.vm.provision :file, :source => PATH_TLS_TARBALL, :destination => "/tmp/tls.tar"

  config.vm.provision :file, :source => PATH_USER_DATA, :destination => "/tmp/vagrantfile-user-data"
  config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
end

