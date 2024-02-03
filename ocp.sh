#!/bin/bash
#Maintainer DineshReddy Kayithi kdinesh.in
OPENSHIFT_VERSION=4.14                            # Enter OpenShift Version -4.12/4.13/4.14
BASE_DOMAIN=dineshreddyk.com                      # Enter Base Domain Name 
CLUSTER_NAME=openshift                            # Cluster Name
AWS_REGION=ap-south-1                             # Enter AWS Region name ,In which region you want to deploy 
AWS_ZONE1=ap-south-1a                             # Enter AWS Zone name        
AWS_ZONE2=ap-south-1b                             # Enter AWS Zone2 name
CONREOLPLANE_NODE_FLAVOR=m6i.xlarge
WORKER_NODE_FLAVOR=m6i.xlarge
NUMBER_OF_WORKER_NODES=3                          # Number of Worker Nodes
NETWORK_TYPE=OVNKubernetes                        # OVNKubenetes or openshiftSDN
CLUSTER_NETWORK_CIDR=10.128.0.0/14
MACHINE_NETWORK_CIDR=10.0.0.0/16
SERVICE_NETWORK_CIDR=172.30.0.0/16
PULLSECRET_KEY=                                    # Convert and paste pullsecret key in base64 Format 
AWS_ACCESS_KEY_DATA=                                    # Convert and paste AWS ACCESS  key in base64 Format
AWS_SECRET_ACCESSKEY_DATA=                              # Convert and paste AWS SECRET  key in base64 Format 

#OpenShift Deployment Configuration 

ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
apt install curl unzip -y 
curl "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-$OPENSHIFT_VERSION/openshift-install-linux.tar.gz" | tar xz -C /tmp
mv /tmp/openshift-install /usr/bin
curl "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-$OPENSHIFT_VERSION/openshift-client-linux.tar.gz" | tar xz -C /tmp
mv /tmp/oc /usr/bin
mv /tmp/kubectl /usr/bin
mkdir -p $HOME/.cache
export XDG_CACHE_HOME="$HOME/.cache"
mkdir ocp
cd /ocp/
SSH_KEY_DATA=$( cat /root/.ssh/id_ed25519.pub )
SSH_KEY=$(echo "${SSH_KEY_DATA}" | awk -F '"' '{print $1}')
PULLSECRET=$(echo "${PULLSECRET_KEY}" | awk -F '"' '{print $1}' | base64 --decode )
AWS_ACCESS_KEY=$(echo "${AWS_ACCESS_KEY_DATA}" | awk -F '"' '{print $1}' | base64 --decode )
AWS_SECRET_ACCESSKEY=$(echo "${AWS_SECRET_ACCESSKEY_DATA}" | awk -F '"' '{print $1}' | base64 --decode )
mkdir ~/.aws
cat<< EOF > ~/.aws/credentials
[default] 
aws_access_key_id= $AWS_ACCESS_KEY
aws_secret_access_key=$AWS_SECRET_ACCESSKEY
EOF

cat << EOF > install-config.yaml
apiVersion: v1
baseDomain: $BASE_DOMAIN
controlPlane:
  hyperthreading: Enabled
  name: master
  platform:
    aws:
      zones:
      - $AWS_ZONE1
      - $AWS_ZONE2
      rootVolume:
        iops: 4000
        size: 500
        type: io1
      type: $CONREOLPLANE_NODE_FLAVOR
  replicas: 3
compute:
- hyperthreading: Enabled
  name: worker
  platform:
    aws:
      rootVolume:
        iops: 2000
        size: 500
        type: io1
      type: $WORKER_NODE_FLAVOR
      zones:
      - $AWS_ZONE1
      - $AWS_ZONE2
  replicas: $NUMBER_OF_WORKER_NODES
metadata:
  name: $CLUSTER_NAME
networking:
  clusterNetwork:
  - cidr: $CLUSTER_NETWORK_CIDR
    hostPrefix: 23
  machineNetwork:
  - cidr: $MACHINE_NETWORK_CIDR
  networkType: $NETWORK_TYPE
  serviceNetwork:
  - $SERVICE_NETWORK_CIDR
platform:
  aws:
    region: $AWS_REGION
fips: false
sshKey: $SSH_KEY
pullSecret: '$PULLSECRET'
EOF
sudo openshift-install create cluster --log-level=info
