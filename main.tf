resource "ibm_is_vpc" "example" {
  name = "vpctest"
  resource_group=var.resource_group

}

resource "ibm_is_subnet" "subnet1" {
  name                     = "mysubnet1"
  vpc                      = ibm_is_vpc.example.id
  zone                     = "us-south-1"
  total_ipv4_address_count = 256
  resource_group=var.resource_group
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "test-cluster"
  vpc_id            = ibm_is_vpc.example.id
  flavor            = "bx2.4x16"
  worker_count      = 3
  resource_group_id=var.resource_group_id
  kube_version      = "1.25.8"  
  update_all_workers     = true
  wait_for_worker_update = true
  zones {
    subnet_id = ibm_is_subnet.subnet1.id
    name      = "us-south-1"
  }
}

# resource "ibm_container_vpc_worker_pool" "cluster_pool" {
#   cluster           = ibm_container_vpc_cluster.cluster.id
#   worker_pool_name  = "mywp"
#   flavor            = "bx2.2x8"
#   vpc_id            = ibm_is_vpc.example.id
#   worker_count      = 3
#   resource_group_id = var.resource_group_id
#   zones {
#     name      = "us-south-1"
#     subnet_id = ibm_is_subnet.subnet1.id
#   }
# }

# resource "ibm_container_vpc_cluster" "cluster" {
#   name                   = "test-cluster"
#   vpc_id                 = ibm_is_vpc.example.id
#   flavor                 = "bx2.16x64"
#   worker_count           = 1
#   kube_version           = "1.26.3"
#   update_all_workers     = true
#   wait_for_worker_update = true
#   resource_group_id=var.resource_group_id

#   zones {
    
#       subnet_id = ibm_is_subnet.subnet1.id
#       name      =  "us-south-1"
#   }
# }

# resource "ibm_is_subnet" "subnet1" {  
#   name = "subnet-1"  
#   vpc =ibm_is_vpc.example.id  
#   # zone="eu-de-1"
#   # ipv4_cidr_block = "10.0.1.0/24"
#   zone = "us-south-1" 
#   # ipv4_cidr_block = "10.240.0.0/24"
#    total_ipv4_address_count = 256
#   resource_group=var.resource_group
#   # cidr_block          = "10.0.1.0/24"
#   # ipv4_cidr_block     = cidrsubnet("10.0.1.0/24", 8, 2)
#  }


