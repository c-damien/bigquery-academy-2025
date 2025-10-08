/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * created by cdamien
 */
provider "google" {
   project = "${var.gcp_project_id}"
   region  = "${var.gcp_region}"
}

##APIs
resource "google_project_service" "apis" {
  # Replace with your actual project ID or use a variable.
  project = "${var.gcp_project_id}"
  service = "managedkafka.googleapis.com"
  disable_on_destroy = false
}

##VPC
resource "google_compute_network" "vpc_network" {
  project = "${var.gcp_project_id}"
  name = "lab-vpc"
  auto_create_subnetworks = false
}

##VPC subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "lab-vpc-subnet-us"
  ip_cidr_range = "10.140.0.0/20"
  region        = "${var.gcp_region}"
  network       = google_compute_network.vpc_network.name
  depends_on = [
    google_compute_network.vpc_network
  ]
}

##FW
resource "google_compute_firewall" "allow_all_internal" {
  name    = "allow-all-inter-vm-traffic"
  network = google_compute_network.vpc_network.name

  # 'INGRESS' applies the rule to incoming traffic to the VMs.
  direction = "INGRESS"

  allow {
    protocol = "all"
  }
  source_ranges = [google_compute_subnetwork.subnet.ip_cidr_range]
  depends_on = [
    google_compute_subnetwork.subnet
  ]
}

##GMK
resource "google_managed_kafka_cluster" "gmk" {
  cluster_id = "lab-kafka-cluster"
  location = "${var.gcp_region}"
  capacity_config {
    vcpu_count = 3
    memory_bytes = 3221225472
  }
  gcp_config {
    access_config {
      network_configs {
        subnet = "projects/${var.gcp_project_id}/regions/${var.gcp_region}/subnetworks/lab-vpc-subnet-us"
      }
    }
  }
  depends_on = [
    google_compute_subnetwork.subnet,
    google_project_service.apis
  ]
}
##topic
resource "google_managed_kafka_topic" "topic" {
  topic_id = "kafka-lab-topic"
  cluster = google_managed_kafka_cluster.gmk.cluster_id
  location = "${var.gcp_region}"
  partition_count = 2
  replication_factor = 3
  configs = {
    "cleanup.policy" = "compact"
  }
  depends_on = [
    google_managed_kafka_cluster.gmk
  ]
}


