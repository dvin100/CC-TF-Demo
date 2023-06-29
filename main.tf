terraform {
    required_providers {
        confluent = {
            source = "confluentinc/confluent"
            version = "1.46.0"
        }
    }
}

provider "confluent" {
  # Could be set through env vars
  cloud_api_key    = var.cloud_api_key   
  cloud_api_secret = var.cloud_api_secret
}

# -------------------------------------------------------
# Environment 
# terraform import confluent_environment.demo_env env-2rd3po
# -------------------------------------------------------
resource "confluent_environment" "demo_env" {
    display_name = var.env_name
    lifecycle {
        prevent_destroy = false
    }
}


# --------------------------------------------------------
# Schema Registry
# terraform import confluent_schema_registry_cluster.sr_cluster env-2rd3po/lsrc-m8j021
# --------------------------------------------------------
data "confluent_schema_registry_region" "sr_region" {
    cloud = var.cloud_provider
    region = var.region
    package = "ADVANCED" 
}
resource "confluent_schema_registry_cluster" "sr_cluster" {
    package = data.confluent_schema_registry_region.sr_region.package
    environment {
        id = confluent_environment.demo_env.id 
    }
    region {
        id = data.confluent_schema_registry_region.sr_region.id
    }

    depends_on = [confluent_environment.demo_env]

    lifecycle {
        prevent_destroy = false
    }
}


# --------------------------------------------------------
# Cluster
# --------------------------------------------------------
resource "confluent_kafka_cluster" "cluster" {
    display_name = var.cluster_name
    availability = "SINGLE_ZONE"
    cloud = var.cloud_provider
    region = var.region
    basic {}
    environment {
        id = confluent_environment.demo_env.id
    }

    depends_on = [confluent_schema_registry_cluster.sr_cluster]

    lifecycle {
        prevent_destroy = false
    }
}

# --------------------------------------------------------
# Service Account, API-Keys and Role assignment
# --------------------------------------------------------
resource "confluent_service_account" "sa-tf" {
  display_name = var.sa_name
  description  = "Service Account created by TF for Demos"
}

resource "confluent_api_key" "sa-tf-kafka-api-key" {
  display_name = "sa-tf-kafka-api-key"
  description  = "Kafka API Key that is owned by 'tf-sa-demo' service account"
  owner {
    id          = confluent_service_account.sa-tf.id
    api_version = "iam/v2"
    kind        = "ServiceAccount"
  }

  managed_resource {
    id          = confluent_kafka_cluster.cluster.id
    api_version = confluent_kafka_cluster.cluster.api_version
    kind        = confluent_kafka_cluster.cluster.kind

    environment {
      id = confluent_environment.demo_env.id
    }
  }

  depends_on = [confluent_service_account.sa-tf, confluent_kafka_cluster.cluster]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_role_binding" "environment-rb" {
  principal   = "User:${confluent_service_account.sa-tf.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.demo_env.resource_name
  depends_on = [confluent_api_key.sa-tf-kafka-api-key]
}

# --------------------------------------------------------
# Topics
# --------------------------------------------------------
resource "confluent_kafka_topic" "topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }
  topic_name         = each.value
  partitions_count   = 6
  for_each = toset(var.topics) 
  rest_endpoint      = confluent_kafka_cluster.cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.sa-tf-kafka-api-key.id
    secret = confluent_api_key.sa-tf-kafka-api-key.secret
  }

  depends_on = [confluent_role_binding.environment-rb, confluent_kafka_cluster.cluster]

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Connectors - datagen
# --------------------------------------------------------
resource "confluent_connector" "datagen_conn" {
  environment {
    id = confluent_environment.demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }

  config_sensitive = {}

  config_nonsensitive = {
        "connector.class"            = "DatagenSource"        
        "kafka.auth.mode"            = "SERVICE_ACCOUNT"    
        "output.data.format"         = "AVRO"         
        "tasks.max"                  = "1"  
        "kafka.service.account.id"   = confluent_service_account.sa-tf.id 
        "name"                       = "transactions_connector"
        "quickstart"                 = "TRANSACTIONS"
        "kafka.topic"                ="transactions"            
  }

    depends_on = [confluent_kafka_topic.topics, confluent_api_key.sa-tf-kafka-api-key] 

   lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Connectors - MySQL
# --------------------------------------------------------
resource "confluent_connector" "mysql_conn" {
 
  environment {
    id = confluent_environment.demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }

  config_sensitive = {}

  config_nonsensitive = {
      "connector.class" = "MySqlCdcSource"
      "name" = "MySQL-CREDITCARDS-Connector"
      "kafka.auth.mode" = "SERVICE_ACCOUNT"
      "kafka.service.account.id"   = confluent_service_account.sa-tf.id
      "database.hostname" = "cc-workshop.c598y8lhnjcw.us-east-1.rds.amazonaws.com"
      "database.port" = "3306"
      "database.user" = "ro_user"
      "database.password" = "password"
      "database.server.name" = "cc-workshop"
      "database.ssl.mode" = "preferred"
      "snapshot.mode" = "when_needed"
      "snapshot.locking.mode" = "minimal"
      "tombstones.on.delete" = "true"
      "poll.interval.ms" = "1000"
      "max.batch.size" = "1000"
      "event.processing.failure.handling.mode" = "fail"
      "heartbeat.interval.ms" = "0"
      "database.history.skip.unparseable.ddl" = "false"
      "event.deserialization.failure.handling.mode" = "fail"
      "inconsistent.schema.handling.mode" = "fail"
      "provide.transaction.metadata" = "false"
      "decimal.handling.mode" = "precise"
      "binary.handling.mode" = "bytes"
      "time.precision.mode" = "connect"
      "cleanup.policy" = "delete"
      "bigint.unsigned.handling.mode" = "long"
      "enable.time.adjuster" = "true"
      "output.data.format" = "AVRO"
      "after.state.only" = "true"
      "output.key.format" = "JSON"
      "json.output.decimal.format" = "BASE64"
      "tasks.max" = "1"
}
  depends_on = [confluent_kafka_topic.topics, confluent_api_key.sa-tf-kafka-api-key] 

   lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Connectors - MongoDB
# --------------------------------------------------------
resource "confluent_connector" "mongodb_conn" {
 
  environment {
    id = confluent_environment.demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }

  config_sensitive = {}

  config_nonsensitive = {
     "connector.class": "MongoDbAtlasSink",
     "name": "MongoDbAtlasSinkConnector",
     "input.data.format": "AVRO",
     "kafka.auth.mode" = "SERVICE_ACCOUNT"
     "kafka.service.account.id"   = confluent_service_account.sa-tf.id
     "topics": "TRANSACTION_FULL"
     "connection.host": var.mongo_endpoint
     "connection.user": var.mongo_username
     "connection.password": var.mongo_password
     "database": "mongodb",
     "tasks.max": "1"
}
  depends_on = [confluent_kafka_topic.topics, confluent_api_key.sa-tf-kafka-api-key] 

   lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# ksqlDB
# --------------------------------------------------------
resource "confluent_ksql_cluster" "ksql" {
  display_name = var.ksqlDB_name
  csu          = 1
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }
  credential_identity {
    id = confluent_service_account.sa-tf.id
  }
  environment {
    id = confluent_environment.demo_env.id
  }
 
  depends_on = [confluent_api_key.sa-tf-kafka-api-key]
  lifecycle {
    prevent_destroy = false
  }
}


