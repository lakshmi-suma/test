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


# data "ibm_is_subnet_reserved_ips" "example" {
#   subnet = ibm_is_subnet.subnet1.id
#   depends_on = [ ibm_container_vpc_cluster.cluster ]
# }

# output "reserved_ips" {
#   value=data.ibm_is_subnet_reserved_ips.example.reserved_ips.address
#   depends_on = [ data.ibm_is_subnet_reserved_ips.example ]

  
# }

data "ibm_container_vpc_cluster" "cluster" {
  name  = "test-cluster"
  depends_on = [ ibm_container_vpc_cluster.cluster ]
  
}

output "workers" {
  value = data.ibm_container_vpc_cluster.cluster.workers
  depends_on = [ data.ibm_container_vpc_cluster.cluster ]
  
}

data "ibm_container_vpc_cluster_worker" "worker1" {
  # worker_id=[for a in data.ibm_container_vpc_cluster.cluster.workers]
  worker_id       = "kube-cgnsv2ud0jhkn4p263d0-testcluster-default-0000042d"
  # concat(var.ips,lookup(data.ibm_container_vpc_cluster_worker.worker_foo.network_interfaces[0],"ip_address",""))
  cluster_name_id = "test-cluster"
  depends_on = [ ibm_container_vpc_cluster.cluster ]
}
data "ibm_container_vpc_cluster_worker" "worker2" {
  worker_id       = "kube-cgnsv2ud0jhkn4p263d0-testcluster-default-000005f4"
  cluster_name_id = "test-cluster"
  depends_on = [ ibm_container_vpc_cluster.cluster ]
}
output "ip_address1" {
  value=concat(var.ips,lookup(data.ibm_container_vpc_cluster_worker.worker1.network_interfaces[0],"ip_address",""))
  depends_on = [ data.ibm_container_vpc_cluster_worker.worker1 ]
  
}
output "ip_address2" {
  value=concat(var.ips,lookup(data.ibm_container_vpc_cluster_worker.worker2.network_interfaces[0],"ip_address",""))
  depends_on = [ data.ibm_container_vpc_cluster_worker.worker2 ]
  
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


