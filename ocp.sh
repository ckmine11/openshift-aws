#!/bin/bash
#Maintainer Chandan kumar outoftheboxmine.online
OPENSHIFT_VERSION=4.14                            # Enter OpenShift Version -4.12/4.13/4.14
BASE_DOMAIN=outoftheboxmine.online                      # Enter Base Domain Name 
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
#---------------------------------------------------------------------------------------------------------------
#PULLSECRET_KEY=                                         # Convert and paste pullsecret key in base64 Format 
AWS_ACCESS_KEY_DATA=QUtJQVFFSVAzS1lWWFdQQUlDN1M=                                   # Convert and paste AWS ACCESS  key in base64 Format
AWS_SECRET_ACCESSKEY_DATA=Ni9vR0xEQ3VVWjMzaVAyc1EzNFVPY1Z5K2twUWRJVkQxUjBhNmQzTQ==                             # Convert and paste AWS SECRET  key in base64 Format 
#---------------------------------------------------------------------------------------------------------------

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
SSH_KEY=$SSH_KEY_DATA
PULLSECRET={"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfMDI5YzFhNDFlNjA0NDI5MDk1ZTIxNzNkMjBhYjVhZGI6M1NYRzNWT0g1QjM0U01TN09WQVBNVzc5Q0ZYV0xWTUdVTjNGSzMxQkZXUUI3VFQ0WVBXTVhEMTM4SzZYSU9TMQ==","email":"ck769184@gmail.com"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfMDI5YzFhNDFlNjA0NDI5MDk1ZTIxNzNkMjBhYjVhZGI6M1NYRzNWT0g1QjM0U01TN09WQVBNVzc5Q0ZYV0xWTUdVTjNGSzMxQkZXUUI3VFQ0WVBXTVhEMTM4SzZYSU9TMQ==","email":"ck769184@gmail.com"},"registry.connect.redhat.com":{"auth":"fHVoYy1wb29sLTM2MWYwNTVjLWMzODEtNGJlOS05ZmFlLTU5ZTM2ZGJhZDcwODpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtNalprTURreFlqZzNaalEwTUdZMU9URTFZVFJoT0RJMk1tWTRZemxpTkNKOS5BbE5aVXRnZnY2bWc1TUtNTGpBZGVuVk5DTDNJRV9mMGh5RVlwd0FzQnlBVUltR1kyRHNQOURGMm9tdHJEWGkyMm50RWh0VXR0NmptN0ZYaTVBT3daM1gtbUN0OTFzVGFsRHlzLWxpekd2RTg4dHpRMHcyZHJNVFd2ajBueXItLUNXaU84VXVaazBqSEM2emktUmtYc2hIZWpPV1BvMFE3N1hhM2pZVXNxMENDN2FjcTFyN0pOSDZGSVVCc2NnOTB5c1RVbGJNblJlVWhyMVhZLWk2NWphZnFaZFdJX3hycjVJV3RNUWI5cnFrOWxyZFF0cWtjWlRUemRpQndUN19RLUJYUURwejI3a2FoUDhyTHZib0ViVk1XcEFDM0FJZ0pJOF8ySkZlYzNIeXdwbmNZRWdka2V1Z0pkOU1STU90RC1fQU5GT3pXWGxnaWFwV0xzUk55WDZHTVNpdE5RTEZ6NXczdHg1RllBQkV2aFI2NDVMSnpsV1hQeG1LaGEyV1VkcHdiMklrbGdaVEI0VGF2M1djaF9CQ0NXVkxrd1phbkZlWnhVSWhwT2l5b0RPdHhwdHVLbkplczRYTnhndzBoc1V4d3Vid1JKdDF0cjR6RHVUOE94UDJ4NVhCOFlPWEJwOG95eVl4MVNhUk5zM1dBc3A5eHcwbHdwdjdiVV96OUpSa2ZLbkJMZE1wTW84X2Q2cTdxd3FkQ2FwQ2MwMGtkU1hIVzV1ZXlHbWt5eTZDTDdGajFmZmNSY3FIU24za3owWUhsNEZmbmlIckdXdm83emIwamtFaE1rSHR4eVc0YzUyd0NKYUFYSDlvamh3R1ZDR09uYjNfcjhyR3pQWV9JVHZlbmprRE5xbVlJd1h0MlljUG0tZHlYa0k2RExwVHJqLXNLZ3ZSSVVyMA==","email":"ck769184@gmail.com"},"registry.redhat.io":{"auth":"fHVoYy1wb29sLTM2MWYwNTVjLWMzODEtNGJlOS05ZmFlLTU5ZTM2ZGJhZDcwODpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtNalprTURreFlqZzNaalEwTUdZMU9URTFZVFJoT0RJMk1tWTRZemxpTkNKOS5BbE5aVXRnZnY2bWc1TUtNTGpBZGVuVk5DTDNJRV9mMGh5RVlwd0FzQnlBVUltR1kyRHNQOURGMm9tdHJEWGkyMm50RWh0VXR0NmptN0ZYaTVBT3daM1gtbUN0OTFzVGFsRHlzLWxpekd2RTg4dHpRMHcyZHJNVFd2ajBueXItLUNXaU84VXVaazBqSEM2emktUmtYc2hIZWpPV1BvMFE3N1hhM2pZVXNxMENDN2FjcTFyN0pOSDZGSVVCc2NnOTB5c1RVbGJNblJlVWhyMVhZLWk2NWphZnFaZFdJX3hycjVJV3RNUWI5cnFrOWxyZFF0cWtjWlRUemRpQndUN19RLUJYUURwejI3a2FoUDhyTHZib0ViVk1XcEFDM0FJZ0pJOF8ySkZlYzNIeXdwbmNZRWdka2V1Z0pkOU1STU90RC1fQU5GT3pXWGxnaWFwV0xzUk55WDZHTVNpdE5RTEZ6NXczdHg1RllBQkV2aFI2NDVMSnpsV1hQeG1LaGEyV1VkcHdiMklrbGdaVEI0VGF2M1djaF9CQ0NXVkxrd1phbkZlWnhVSWhwT2l5b0RPdHhwdHVLbkplczRYTnhndzBoc1V4d3Vid1JKdDF0cjR6RHVUOE94UDJ4NVhCOFlPWEJwOG95eVl4MVNhUk5zM1dBc3A5eHcwbHdwdjdiVV96OUpSa2ZLbkJMZE1wTW84X2Q2cTdxd3FkQ2FwQ2MwMGtkU1hIVzV1ZXlHbWt5eTZDTDdGajFmZmNSY3FIU24za3owWUhsNEZmbmlIckdXdm83emIwamtFaE1rSHR4eVc0YzUyd0NKYUFYSDlvamh3R1ZDR09uYjNfcjhyR3pQWV9JVHZlbmprRE5xbVlJd1h0MlljUG0tZHlYa0k2RExwVHJqLXNLZ3ZSSVVyMA==","email":"ck769184@gmail.com"}}}                      # paste pullsecret key
#AWS_ACCESS_KEY=QUtJQVFFSVAzS1lWWFdQQUlDN1M=  # paste AWS_ACCESS_KEY
#AWS_SECRET_ACCESSKEY=Ni9vR0xEQ3VVWjMzaVAyc1EzNFVPY1Z5K2twUWRJVkQxUjBhNmQzTQ==    # AWS_SECRET_ACCESSKEY
#---------------------------------------------------------------------------------------------------------------------
#SSH_KEY=$(echo "${SSH_KEY_DATA}" | awk -F '"' '{print $1}')     # provide .pub key here
#PULLSECRET=$(echo "${PULLSECRET_KEY}" | awk -F '"' '{print $1}' | base64 --decode )   # paste pullsecret key
AWS_ACCESS_KEY=$(echo "${AWS_ACCESS_KEY_DATA}" | awk -F '"' '{print $1}' | base64 --decode ) # paste AWS_ACCESS_KEY
AWS_SECRET_ACCESSKEY=$(echo "${AWS_SECRET_ACCESSKEY_DATA}" | awk -F '"' '{print $1}' | base64 --decode ) # AWS_SECRET_ACCESSKEY
#----------------------------------------------------------------------------------------------------------------------------

mkdir ~/.aws
cat<< EOF > ~/.aws/credentials
[default] 
aws_access_key_id=$AWS_ACCESS_KEY
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
pullSecret: '{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfMDI5YzFhNDFlNjA0NDI5MDk1ZTIxNzNkMjBhYjVhZGI6M1NYRzNWT0g1QjM0U01TN09WQVBNVzc5Q0ZYV0xWTUdVTjNGSzMxQkZXUUI3VFQ0WVBXTVhEMTM4SzZYSU9TMQ==","email":"ck769184@gmail.com"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfMDI5YzFhNDFlNjA0NDI5MDk1ZTIxNzNkMjBhYjVhZGI6M1NYRzNWT0g1QjM0U01TN09WQVBNVzc5Q0ZYV0xWTUdVTjNGSzMxQkZXUUI3VFQ0WVBXTVhEMTM4SzZYSU9TMQ==","email":"ck769184@gmail.com"},"registry.connect.redhat.com":{"auth":"fHVoYy1wb29sLTM2MWYwNTVjLWMzODEtNGJlOS05ZmFlLTU5ZTM2ZGJhZDcwODpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtNalprTURreFlqZzNaalEwTUdZMU9URTFZVFJoT0RJMk1tWTRZemxpTkNKOS5BbE5aVXRnZnY2bWc1TUtNTGpBZGVuVk5DTDNJRV9mMGh5RVlwd0FzQnlBVUltR1kyRHNQOURGMm9tdHJEWGkyMm50RWh0VXR0NmptN0ZYaTVBT3daM1gtbUN0OTFzVGFsRHlzLWxpekd2RTg4dHpRMHcyZHJNVFd2ajBueXItLUNXaU84VXVaazBqSEM2emktUmtYc2hIZWpPV1BvMFE3N1hhM2pZVXNxMENDN2FjcTFyN0pOSDZGSVVCc2NnOTB5c1RVbGJNblJlVWhyMVhZLWk2NWphZnFaZFdJX3hycjVJV3RNUWI5cnFrOWxyZFF0cWtjWlRUemRpQndUN19RLUJYUURwejI3a2FoUDhyTHZib0ViVk1XcEFDM0FJZ0pJOF8ySkZlYzNIeXdwbmNZRWdka2V1Z0pkOU1STU90RC1fQU5GT3pXWGxnaWFwV0xzUk55WDZHTVNpdE5RTEZ6NXczdHg1RllBQkV2aFI2NDVMSnpsV1hQeG1LaGEyV1VkcHdiMklrbGdaVEI0VGF2M1djaF9CQ0NXVkxrd1phbkZlWnhVSWhwT2l5b0RPdHhwdHVLbkplczRYTnhndzBoc1V4d3Vid1JKdDF0cjR6RHVUOE94UDJ4NVhCOFlPWEJwOG95eVl4MVNhUk5zM1dBc3A5eHcwbHdwdjdiVV96OUpSa2ZLbkJMZE1wTW84X2Q2cTdxd3FkQ2FwQ2MwMGtkU1hIVzV1ZXlHbWt5eTZDTDdGajFmZmNSY3FIU24za3owWUhsNEZmbmlIckdXdm83emIwamtFaE1rSHR4eVc0YzUyd0NKYUFYSDlvamh3R1ZDR09uYjNfcjhyR3pQWV9JVHZlbmprRE5xbVlJd1h0MlljUG0tZHlYa0k2RExwVHJqLXNLZ3ZSSVVyMA==","email":"ck769184@gmail.com"},"registry.redhat.io":{"auth":"fHVoYy1wb29sLTM2MWYwNTVjLWMzODEtNGJlOS05ZmFlLTU5ZTM2ZGJhZDcwODpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtNalprTURreFlqZzNaalEwTUdZMU9URTFZVFJoT0RJMk1tWTRZemxpTkNKOS5BbE5aVXRnZnY2bWc1TUtNTGpBZGVuVk5DTDNJRV9mMGh5RVlwd0FzQnlBVUltR1kyRHNQOURGMm9tdHJEWGkyMm50RWh0VXR0NmptN0ZYaTVBT3daM1gtbUN0OTFzVGFsRHlzLWxpekd2RTg4dHpRMHcyZHJNVFd2ajBueXItLUNXaU84VXVaazBqSEM2emktUmtYc2hIZWpPV1BvMFE3N1hhM2pZVXNxMENDN2FjcTFyN0pOSDZGSVVCc2NnOTB5c1RVbGJNblJlVWhyMVhZLWk2NWphZnFaZFdJX3hycjVJV3RNUWI5cnFrOWxyZFF0cWtjWlRUemRpQndUN19RLUJYUURwejI3a2FoUDhyTHZib0ViVk1XcEFDM0FJZ0pJOF8ySkZlYzNIeXdwbmNZRWdka2V1Z0pkOU1STU90RC1fQU5GT3pXWGxnaWFwV0xzUk55WDZHTVNpdE5RTEZ6NXczdHg1RllBQkV2aFI2NDVMSnpsV1hQeG1LaGEyV1VkcHdiMklrbGdaVEI0VGF2M1djaF9CQ0NXVkxrd1phbkZlWnhVSWhwT2l5b0RPdHhwdHVLbkplczRYTnhndzBoc1V4d3Vid1JKdDF0cjR6RHVUOE94UDJ4NVhCOFlPWEJwOG95eVl4MVNhUk5zM1dBc3A5eHcwbHdwdjdiVV96OUpSa2ZLbkJMZE1wTW84X2Q2cTdxd3FkQ2FwQ2MwMGtkU1hIVzV1ZXlHbWt5eTZDTDdGajFmZmNSY3FIU24za3owWUhsNEZmbmlIckdXdm83emIwamtFaE1rSHR4eVc0YzUyd0NKYUFYSDlvamh3R1ZDR09uYjNfcjhyR3pQWV9JVHZlbmprRE5xbVlJd1h0MlljUG0tZHlYa0k2RExwVHJqLXNLZ3ZSSVVyMA==","email":"ck769184@gmail.com"}}}'
EOF
sudo openshift-install create cluster --log-level=info
