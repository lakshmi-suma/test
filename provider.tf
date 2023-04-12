provider "ibm" {
  region = "us-south"
  # generation=2
}

provider "kubernetes" {
  config_path = data.ibm_container_cluster_config.cluster_config.config_file_path
  //config_path = "~/.kube/config"
}

