# List current pods

kubectl get pods -n kube-system

# Install calico CNI

curl https://docs.projectcalico.org/manifests/calico.yaml -O

# Modify the part CALICO_IPV4POOL_CIDR to any CIDR block for Pod

# then

kubectl apply -f calico.yaml

# Generate new join token with

kubeadm token create --print-join-command

# Reemove taint from master node

for node in $(kubectl get nodes --selector='node-role.kubernetes.io/master' | awk 'NR>1 {print $1}' ) ; do kubectl taint node $node node-role.kubernetes.io/master- ; done

# Apply dashboard

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
