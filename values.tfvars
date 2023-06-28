cloud_provider = "AWS"
region         = "us-east-1"

env_name       = "workshop"
cluster_name   = "CreditCards-Workshop"
sa_name        = "tf-demo"

ksqlDB_name    = "ksqlDB-CreditCards"

topics         = ["cc-workshop.creditcards.users","cc-workshop.creditcards.stores","cc-workshop.creditcards.cards","transactions", "TRANSACTION_FULL"]

#######################
#
# Update the values between square braquets with the actual values
# ex: replace [cloud_api_key] with the Api Key you created and keep the double quotes 
#     cloud_api_key     = "xxxxxxxxxxx"
#
#######################

cloud_api_key     = "[cloud_api_key]"
cloud_api_secret  = "[cloud_api_secret]"

mongo_username    = "[mongo_username]"
mongo_password    = "[mongo_password]"
mongo_endpoint    = "[mongo_endpoint]"

