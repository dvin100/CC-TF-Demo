# CC-TF-Workshop
Demo on how to create a complete Confluent Cloud workflow with Terraform

# Context

## Infrastructure for the workshop
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



## Use case - Credit Cards transaction
This workshop will demonstrate how to deploy an end-to-end dataflow like the one below.
We will be using a MySQL CDC connector to source data from tables and write them to kafka topics.
Another connector (datagen source) will produce ramdom transactions
ksqlDB will be used to transform, join and do real-time analytics on data to detect potential fraulent activities
We will consume the full transaction with a Mongo Sink connector to write the data to a MongoDB
Finally, we will use the ksqlDB API to get the fraudulent cards

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/5dc8f444-bf78-462a-9a07-fcd9b59d616a)



# Create a Confluent Cloud account
Browse to https://www.confluent.io/get-started/ and sign-in with Google or fill the form:

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/d544b6f1-ad62-47c0-9df1-332ca845164e)

Verify your email and sign-in to Confluent Cloud. You can skip all tutorials, claim the free credit and get started!



# Create a Confluent Cloud API-Key
This API-Key will be used by Terraform to create all the resources in Confluent Cloud


1. In the Confluent Cloud UI, click on the 3 horizontal bars on the top right and then [Cloud API keys]
![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/007139f2-869f-4354-97e0-6a35bc05d04d)

2. Click [Create Key]
3. Select [Global access] + next
4. Add a description (optional) and click [Download and continue]
5. This will save the file containing API-Key and Secret that we will need for next step




