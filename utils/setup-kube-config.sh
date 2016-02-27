kubectl config set-cluster coreos-dev-cluster --server=https://172.16.10.10:443 --certificate-authority=${PWD}/ssl/ca.pem
kubectl config set-credentials coreos-dev-admin --certificate-authority=${PWD}/ssl/ca.pem --client-key=${PWD}/ssl/admin-key.pem --client-certificate=${PWD}/ssl/admin.pem
kubectl config set-context coreos-dev --cluster=coreos-dev-cluster --user=coreos-dev-admin
kubectl config use-context coreos-dev
kubectl config view
