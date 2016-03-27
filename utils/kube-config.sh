kubectl config set-cluster dev-cluster --server=https://172.16.10.10:443 --certificate-authority=${PWD}/tls/ca.pem
kubectl config set-credentials dev-admin --certificate-authority=${PWD}/ssl/ca.pem --client-key=${PWD}/tls/admin-key.pem --client-certificate=${PWD}/tls/admin.pem
kubectl config set-context dev --cluster=dev-cluster --user=dev-admin
kubectl config use-context dev
kubectl config view
