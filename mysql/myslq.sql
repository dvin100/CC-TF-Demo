# If you have to create the database
# Use AWS RDS for mysql
# Set following the DB for the parameter group
#     binlog_format = ROW
#     binlog_row_image = full
# Allow traffic 0.0.0.0 on port 3306


create database if not exists creditcards;

CREATE TABLE creditcards.users (
  userid VARCHAR(10) PRIMARY KEY,
  name VARCHAR(45),
  phone VARCHAR(45));
  


CREATE TABLE creditcards.cards (
  card_id VARCHAR(10) PRIMARY KEY,
  number BIGINT,
  cvv INT,
  expiration VARCHAR(5));


CREATE TABLE creditcards.stores (
  store_id VARCHAR(10) PRIMARY KEY,
  name VARCHAR(20),
  state VARCHAR(2));


insert into creditcards.cards (card_id, number, cvv, expiration)values ("1", 3647909300927735,123,"10/28");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("2", 2583445922584416,889,"01/27");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("3", 4669555422369999,456,"03/25");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("4", 5469215924562587,753,"05/24");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("5", 224955233369999,588,"06/30");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("6", 5487542528816225,585,"07/25");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("7", 5678256941236658,654,"12/27");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("8", 7854228966661111,752,"11/26");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("9", 3647908855444455,775,"01/25");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("10", 5874236956561144,558,"08/27");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("11", 3458952454585421,588,"05/26");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("12", 5488774411223366,657,"06/25");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("13", 3815634987415425,678,"10/29");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("14", 9856321459874563,754,"12/28");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("15", 5552444877741112,567,"12/27");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("16", 2596414152526363,177,"08/26");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("17", 8745896521459825,623,"07/29");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("18", 4563225877412269,679,"04/25");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("19", 8745125698544569,908,"09/26");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("20", 4585774233695585,539,"01/27");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("21", 4582458512368521,846,"10/28");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("22", 7415734965841254,927,"12/27");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("23", 4586321425125525,023,"11/26");
insert into creditcards.cards (card_id, number, cvv, expiration)values ("24", 7456332584190254,468,"03/28");


insert into creditcards.users (userid, name, phone)values ("User_1", "Elvis Presley", "555-658-9852");
insert into creditcards.users (userid, name, phone)values ("User_2", "Betty Boop", "555-251-5624");
insert into creditcards.users (userid, name, phone)values ("User_3", "Bugs Bunny", "555-458-9966");
insert into creditcards.users (userid, name, phone)values ("User_4", "Santa Claus", "555-000-0000");
insert into creditcards.users (userid, name, phone)values ("User_5", "Marilyn Monroe", "555-521-7777");
insert into creditcards.users (userid, name, phone)values ("User_6", "John Doe", "555-999-8741");
insert into creditcards.users (userid, name, phone)values ("User_7", "Jane Doe", "555-113-2211");
insert into creditcards.users (userid, name, phone)values ("User_8", "Minnie Mouse", "555-321-9876");
insert into creditcards.users (userid, name, phone)values ("User_9", "Mickey Mouse", "555-789-1234");


insert into creditcards.stores (store_id, name, state)values ("1", "Harware ABC", "NC");
insert into creditcards.stores (store_id, name, state)values ("2", "Beauty Shop", "CA");
insert into creditcards.stores (store_id, name, state)values ("3", "Grocery Store", "TX");
insert into creditcards.stores (store_id, name, state)values ("4", "Sporties", "VT");
insert into creditcards.stores (store_id, name, state)values ("5", "Books and more", "MA");
insert into creditcards.stores (store_id, name, state)values ("6", "All music", "CA");
insert into creditcards.stores (store_id, name, state)values ("7", "Food and Drink", "TX");




drop user 'ro_user'@'%';
CREATE USER 'ro_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT LOCK TABLES, RELOAD, REPLICATION CLIENT, REPLICATION SLAVE, EXECUTE, LOCK TABLES, SELECT, SHOW VIEW on *.* TO 'ro_user'@'%';
