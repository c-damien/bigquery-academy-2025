#!/bin/sh
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# created by cdamien


# Environment Variables
PROJECT_ID=$1
REGION=$2
ZONE=$3

# Set the Platform Project
gcloud config set project $PROJECT_ID

echo "------------PROJECT ${PROJECT_ID}"

gcloud services enable managedkafka.googleapis.com

echo "------------kafka api activated"


gcloud compute networks create lab-vpc 
	--subnet-mode=custom \
	--max-retries 10 \
	--min-retry-delay 10 

echo "------------VPC lab-vpc created"

gcloud compute networks subnets create lab-vpc-subnet-us \
    --network=lab-vpc \
    --range=10.140.0.0/20 \
    --region=${REGION} \
    --enable-private-ip-google-access \



echo "------------VPC lab-vpc-subnet-us subnet created"


gcloud compute networks subnets update lab-vpc-subnet-us \
--region=${REGION} \
--enable-private-ip-google-access










gcloud compute firewall-rules create lab-vpc-allow-internal \
    --network=lab-vpc \
    --action=ALLOW \
    --direction=INGRESS \
    --rules=all \
    --source-ranges=10.140.0.0/20 \



echo "------------VPC firewall rules added"


gcloud managed-kafka clusters create lab-kafka-cluster \
    --location=${REGION} \
    --subnets=projects/${PROJECT_ID}/regions/${REGION}/subnetworks/lab-vpc-subnet-us \
    --cpu=3 \
    --auto-rebalance \
    --memory=12GB \
    --max-retries 10 \
    --min-retry-delay 10

echo "------------Main Kafka cluster created"


#qwiklabs-gcp-03-d40f073aa029


#gcloud managed-kafka clusters create lab-kafka-cluster \
#    --location=us-central1 \
#    --subnets=projects/qwiklabs-gcp-03-d40f073aa029/regions/us-central1/subnetworks/lab-vpc-subnet-us \
#    --cpu=3 \
#    --auto-rebalance \
#    --memory=12GB





