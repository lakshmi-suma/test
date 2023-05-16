resource "ibm_is_vpc" "example" {
  name = "vpctest1"
  resource_group=var.resource_group

}

resource "ibm_is_subnet" "subnet1" {
  name                     = "testsubnet"
  vpc                      = ibm_is_vpc.example.id
  zone                     = "us-south-1"
  total_ipv4_address_count = 256
  resource_group=var.resource_group
  # public_gateway = true
}
resource "ibm_is_public_gateway" "example" {
  name = "example-gateway"
  vpc  = ibm_is_vpc.example.id
  zone = "us-south-1"
  resource_group=var.resource_group
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "test-cluster"
  vpc_id            = ibm_is_vpc.example.id
  flavor            = "bx2.4x16"
  worker_count      = 3
  resource_group_id=var.resource_group_id
  kube_version      = "1.26.3"  
  update_all_workers     = true
  wait_for_worker_update = true
  depends_on = [ ibm_is_subnet.subnet1 ]
  zones {
    subnet_id = ibm_is_subnet.subnet1.id
    name      = "us-south-1"
    
  }
}




#To fetch information about the vpc cluster
data "ibm_container_vpc_cluster" "cluster" {
  name  = "test-cluster"
  depends_on = [ ibm_container_vpc_cluster.cluster ]
  
}
# Print the id's of the workers
output "workers" {
  value = data.ibm_container_vpc_cluster.cluster.workers
  depends_on = [ data.ibm_container_vpc_cluster.cluster ]
  
}

#To fetch information about each worker node
data "ibm_container_vpc_cluster_worker" "worker1" {
  for_each= toset(data.ibm_container_vpc_cluster.cluster.workers)
  worker_id = each.value
  cluster_name_id = "test-cluster"
  depends_on = [ ibm_container_vpc_cluster.cluster ]
}

#To print the information about the workers
output "ip_address" {
  value=data.ibm_container_vpc_cluster_worker.worker1
  depends_on = [ data.ibm_container_vpc_cluster_worker.worker1 ]
}

#To filter the ip address and store in a list
output "ip" {
  depends_on = [ data.ibm_container_vpc_cluster_worker.worker1 ]
  value = [
    for i in data.ibm_container_vpc_cluster.cluster.workers:
    lookup(lookup(lookup(data.ibm_container_vpc_cluster_worker.worker1,i),"network_interfaces")[0],"ip_address")
    
  ]
  
}

data "ibm_container_vpc_cluster_worker" "worker2" {
  worker_id       = "kube-cgnsv2ud0jhkn4p263d0-testcluster-mywp-00000761"
  cluster_name_id = "test-cluster"
  depends_on = [ ibm_container_vpc_cluster.cluster ]
}

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # value = [
  #   for worker_id in data.ibm_container_vpc_cluster_worker.worker1:
  #   # azurerm_storage_account.my_storage.example[storage].id
  #   lookup(data.ibm_container_vpc_cluster_worker.worker1[each.key].network_interfaces[0],"ip_address","")
  # ]
# }

# locals {
#   ip1="${lookup(data.ibm_container_vpc_cluster_worker.worker1.network_interfaces[0],"ip_address","")}"
#   ip2="${lookup(data.ibm_container_vpc_cluster_worker.worker2.network_interfaces[0],"ip_address","")}"


# output "ip_address1" {
#   value=lookup(data.ibm_container_vpc_cluster_worker.worker1.network_interfaces[0],"ip_address","")
#   depends_on = [ data.ibm_container_vpc_cluster_worker.worker1 ]
  
# }
# output "ip_address2" {
#   value=lookup(data.ibm_container_vpc_cluster_worker.worker2.network_interfaces[0],"ip_address","")
#   depends_on = [ data.ibm_container_vpc_cluster_worker.worker2 ]
  
# }
# output "varia" {
#   value=var.ips
  
# }
# variable "add" {
#   type = list(string)
  
  
# }

# resource "ibm_container_vpc_worker_pool" "cluster_pool" {
#   cluster           = ibm_container_vpc_cluster.cluster.id
#   worker_pool_name  = "mywp"
#   flavor            = "bx2.2x8"
#   vpc_id            = ibm_is_vpc.example.id
#   worker_count      = 2
#   resource_group_id = var.resource_group_id
#   zones {
#     name      = "us-south-1"
#     subnet_id = ibm_is_subnet.subnet1.id
#   }
# }

# data "ibm_is_subnet_reserved_ips" "example" {
#   subnet = ibm_is_subnet.subnet1.id
#   depends_on = [ ibm_container_vpc_cluster.cluster ]
# }

# output "reserved_ips" {
#   value=data.ibm_is_subnet_reserved_ips.example.reserved_ips.address
#   depends_on = [ data.ibm_is_subnet_reserved_ips.example ]

  
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


