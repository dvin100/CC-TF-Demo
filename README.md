# CC-TF-Workshop
Demo on how to create a complete Confluent Cloud workflow with Terraform



# Infrastructure for the workshop
We will deploy the following components in Confluent Cloud:
-Environment
-Schema Registry
-Basic cluster
-ksqlDB
-Connectors (MySQL Source, Mongo Sink and a Datagen Source)

External components:
-The MySQL database is an existing DB (info below)
-Mongo DB will require a Mongo subscription (how-to below)

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/74eb3a46-4a9b-4fd7-939e-45bdfc4af494)



# Dataflow - Credit Cards transaction
This workshop will demonstrate how to deploy an end-to-end dataflow like the one below

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/5dc8f444-bf78-462a-9a07-fcd9b59d616a)



# Create a Confluent Cloud account
Browse to https://www.confluent.io/get-started/ and sign-in with Google or fill the form:

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/d544b6f1-ad62-47c0-9df1-332ca845164e)

Verify your email and sign-in to Confluent Cloud. You can skip all tutorials, claim the free credit and get started!



# Create a Confluent Cloud API-Key
This API-Key will be used by Terraform to create all the resources in Confluent Cloud
