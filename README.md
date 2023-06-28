# CC-TF-Workshop
Demo on how to create a complete Confluent Cloud workflow with Terraform

# Context

## Infrastructure for the workshop
We will deploy the following components in Confluent Cloud:
- Environment  
- Schema Registry  
- Basic cluster  
- ksqlDB  
- Connectors (MySQL Source, Mongo Sink and a Datagen Source)  

External components:
- The MySQL database is an existing DB (info below)
- Mongo DB will require a Mongo subscription (how-to below)

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/74eb3a46-4a9b-4fd7-939e-45bdfc4af494)



## Use case - Credit Cards transaction
This workshop will demonstrate how to deploy an end-to-end dataflow like the one below.  
We will be using a MySQL CDC connector to source data from tables and write them to kafka topics.  
Another connector (datagen source) will produce ramdom transactions  
ksqlDB will be used to transform, join and do real-time analytics on data to detect potential fraulent activities  
We will consume the full transaction with a Mongo Sink connector to write the data to a MongoDB  
Finally, we will use the ksqlDB API to get the fraudulent cards  

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/5dc8f444-bf78-462a-9a07-fcd9b59d616a)


# Prerequisites 

## Install Terraform on your laptop
https://developer.hashicorp.com/terraform/downloads

## Create a Confluent Cloud account
Browse to https://www.confluent.io/get-started/ and sign-in with Google or fill the form:

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/d544b6f1-ad62-47c0-9df1-332ca845164e)

Verify your email and sign-in to Confluent Cloud. You can skip all tutorials, claim the free credit and get started!


## Create a Confluent Cloud API-Key
This API-Key will be used by Terraform to create all the resources in Confluent Cloud

1. In the Confluent Cloud UI, click on the 3 horizontal bars on the top right and then [Cloud API keys]
![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/007139f2-869f-4354-97e0-6a35bc05d04d)

2. Click [Create Key]
3. Select [Global access] + next
4. Add a description (optional) and click [Download and continue]
5. This will save the file containing API-Key and Secret that we will need for next steps to update the following values   
    cloud_api_key = "[cloud_api_key]"  
    cloud_api_secret = "[cloud_api_secret]"  


## Create a MongoDB Atlas account and database
Browse to https://www.mongodb.com/cloud/atlas/register and sign-in with Google or fill the form.

Create a new database with the following parameters:
- Select M0 Free tier
- Provider: AWS
- Region: N.Virginia (us-east-1)
- Name: mongodb

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/8c17e6c8-04a9-414f-9e63-8c33d0ce5e20)

For the next step, under security quickstart
Step 1 - How would you like to authenticate your connection?
1. Enter a username and password that will be used by the connector to authenticate to the DB
2. Click [Create User]
3. This username and password will be needed for next steps to update the following values  
    mongo_username = "[mongo_username]"    
    mongo_password = "[mongo_password]"  
    
![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/30be95a1-86e2-4f68-a432-0b52b5f49057)

Step 2 - Where would you like to connect from?
1. Select [Cloud Environment]
2. Click [Configure] under IP Access List
3. In IP Address enter: 0.0.0.0 and click [Add Entry]
4. Click [Finish and close]
   
    
Once finished, in this view, click [Connect]
![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/a563d80a-caf7-480b-979f-1a0fa9c8e10e)

In the next window, click [Drivers]   
Then, copy the FQDN after the @ sign. In the example below: ***mongodb.ykqlpcn.mongodb.net***     
Keep this as we will need it in the following steps to update the following values:      
       mongo_endpoint = "[mongo_endpoint]"    

![image](https://github.com/dvin100/CC-TF-Demo/assets/22193622/f308cdb3-3fa0-47c1-b451-c82533576203)


# Setup Terraform 

1. Download the Terraform script    
    **wget https://github.com/dvin100/CC-TF-Demo/archive/refs/heads/main.zip**

2. Unzip the file   
    **unzip main.zip**

3. Switch to the unzipped directory  
   **cd CC-TF-Demo-main**

4.  Update the **values.tfvars** file with the values that were gathered throuhout the steps above  
     
    cloud_api_key     = "[cloud_api_key]"  
    cloud_api_secret  = "[cloud_api_secret]"  
          
    mongo_username    = "[mongo_username]"  
    mongo_password    = "[mongo_password]"  
    mongo_endpoint    = "[mongo_endpoint]"  


# Run Terraform to create everything

From the command line, run the following commands:   

1. terraform init
2. terraform plan -var-file values.tfvars
3. terraform apply -auto-approve -var-file values.tfvars

Once the script has completed, you can go to next steps.


# Confluent Cloud validation and ksqlDB script 

1. Login to Confluent Cloud and click on [View environments] -- https://confluent.cloud/
2. Click on the [WORKSHOP] environment
3. Click on the [CREDITCARDS-WORKSHOP] cluster
4. Click on [Topics] and validate that topics where created
5. Click on the [transactions] topic and then [Messages] to view event coming in the topic
6. Click on [Connectors]. You should see 3 connectors
7. Click on [ksqlDB] and then [ksqlDB-CreditCards]
8. In the [Editor], change the [auto.offset.reset] to [Earliest]
9. Copy the content of the ksqlDB.sql file and paste it in the editor  
10. Click [Run query] and let it complete
11. In the [Editor], change the [auto.offset.reset] to [Latest]
12. In the [Editor], paste the following select statement to view the real-time enriched stream containing transactions, users, credit cards and store information combined together   
    **select * from TRANSACTIONS_FULL EMIT CHANGES;**
13. Click [Run query] and eventually [Stop] 
14. In the [Editor], paste the following select statement to view the potential fraudulent credit cards activities   
    **select * from FRAUD EMIT CHANGES;** 
15. Click [Run query] and eventually [Stop] 

# MongoDB validation

1. Login your MongoDB account -- https://cloud.mongodb.com/
2. On the left, click [Database]
3. Under Database Deployment, beside your mongodb database, click on [Browse Collections]
4. Under [mongodb.TRANSACTION_FULL], you should see values coming from our Confluent Cloud [TRANSACTION_FULL] topic

# Cleanup everything
From the command line, run the following commands;

1. **cd CC-TF-Demo-main**
2. **terraform destroy -auto-approve -var-file values.tfvars**
