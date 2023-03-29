resource "ibm_is_vpc" "example" {
  name = "test-vpc"
}






resource "ibm_container_vpc_cluster" "cluster" {
  name                   = "test-cluster"
  vpc_id                 = ibm_is_vpc.example.id
  flavor                 = "bx2.16x64"
  worker_count           = "1"
  kube_version           = "1.26.3"
  //entitlement          = var.entitlement --> required for OpenShift cluster
  //cos_instance_crn     = var.cos_instance_id --> required for OpenShift cluster
  update_all_workers     = true
  wait_for_worker_update = true

  dynamic zones {
    for_each = var.subnets
    content {
      subnet_id = zones.value.id
      name      = zones.value.zone
    }
  }
}


