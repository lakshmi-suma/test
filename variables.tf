# variable subnets {
#   description = "List of subnets for the vpc. For each item in each array, a subnet will be created. Items can be either CIDR blocks or total ipv4 addressess. Public gateways will be enabled only in zones where a gateway has been created"
#   type        = object({
#     zone-1 = list(object({
#       name           = string
#       cidr           = string
#       public_gateway = bool
#     }))
#     zone-2 = list(object({
#       name           = string
#       cidr           = string
#       public_gateway = bool
#     }))
   
#   })
#   default = {
#     zone-1 = [{
#       name           = "subnet-1"
#       cidr           = "172.17.0.0/24"
#       public_gateway = true
#     }],
#     zone-2 = [{
#       name           = "subnet-2"
#       cidr           = "172.17.64.0/24"
#       public_gateway = true
#     }],
    
#   }

  
# }
variable "resource_group_id" {
    type = string
  
}
variable "resource_group" {
    type = string
  
}
variable "ips" {
    type=list(string)
    default = [lookup(data.ibm_container_vpc_cluster_worker.worker1.network_interfaces[0],"ip_address",""),
    lookup(data.ibm_container_vpc_cluster_worker.worker2.network_interfaces[0],"ip_address","")]
    depends_on=[data.ibm_container_vpc_cluster_worker.worker1,data.ibm_container_vpc_cluster_worker.worker2]
  
}

# variable "worker_ids" {
#     type=list(data.ibm_container_vpc_cluster.cluster.workers)
#     # depends_on=[data.ibm_container_vpc_cluster_worker]
  
# }