#!/bin/bash
#install kubectl
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
chmod +x /kubectl
mkdir -p /root/bin && cp -r /kubectl /root/bin/kubectl && export PATH=/root/bin:$PATH
echo 'export PATH=/root/bin:$PATH' >> ~/.bashrc
source /root/.bashrc

#install aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
chmod +x /aws-iam-authenticator
cp -r /aws-iam-authenticator /root/bin/aws-iam-authenticator

#Describe kubeconfig
mkdir -p /root/.kube/
cat > config <<EOF
${config}
EOF
mv config /root/.kube/

cd /root/

#Joining WorkerNodes
cat > auth.yaml <<EOF
${auth}
EOF

yum install jq -y 
curl -sS "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/alb-ingress-controller.yaml" > alb-ingress-controller.yaml
