variable "env_name" {
    type = string
}

variable "sa_name" {
    type = string
}

variable "cloud_provider" {
    type = string
}

variable "region" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "ksqlDB_name" {
    type = string
}

variable topics {
    type = list(string)
}


variable cloud_api_key {
    type = string
}

variable cloud_api_secret {
    type = string
}

variable mongo_username {
    type = string
}

variable mongo_password {
    type = string
}

variable mongo_endpoint {
    type = string
}