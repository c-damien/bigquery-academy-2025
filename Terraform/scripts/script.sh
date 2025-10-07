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

gcloud compute networks subnets update lab-vpc-subnet-us \
--region=${REGION} \
--enable-private-ip-google-access