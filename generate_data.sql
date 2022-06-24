
SET force_global_transaction = TRUE;
INSERT INTO customers (customer_id, full_name, email, password, enabled, phone_number, preferred_region, account_statement_delivery, tax_forms_delivery, trade_confirmation, subscribe_newsletter, subscribe_webinar, subscribe_blog)
VALUES (nextval('customers_customer_id_seq'), 'Demo US User', 'us-user@example.com','$2a$10$GddY6N91rEZb2w8HctJ22OpTew9rEbBOzvHmoNBRW0eBTns57cLPW', TRUE, '512-000-0212', 'US','EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_IN', 'OPT_IN','OPT_OUT'),
       (nextval('customers_customer_id_seq'), 'Demo EU User', 'eu-user@example.com','$2a$10$yff4ZmyqBIOsYPBe.NDnte7DR7bTdT.4T/YlkeB02boc5HdH/hg1W', TRUE, '787-000-0212', 'EU','US_MAIL', 'EDELIVERY', 'EDELIVERY', 'OPT_OUT', 'OPT_OUT','OPT_OUT'),
       (nextval('customers_customer_id_seq'), 'Demo AP User', 'ap-user@example.com','$2a$10$v7K90bPUvAubpRMBcjEdQOaQR87LsGLN0kOCELk24GB3cMy7siWNi', TRUE, '888-000-0212', 'AP','EDELIVERY', 'US_MAIL', 'EDELIVERY', 'OPT_OUT', 'OPT_OUT','OPT_IN');
SET force_global_transaction = FALSE;

  --distributed transactions
 /* SET force_global_transaction = TRUE;
  BEGIN;
   insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
   values(1001, 'x1001', 'test1001', 'test1001@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','US-EAST-2');
  
  insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
  values(2001, 'x2001', 'test2001', 'test2001@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','AP-SOUTHEAST-1');
  
  COMMIT;
*/
---
  
  # wget https://github.com/yugabyte/yb-sample-apps/releases/download/1.3.9/yb-sample-apps.jar

# BLUE client - 54.80.165.241
java -jar /home/centos/yb-sample-apps.jar \
  --workload SqlInserts \
  --nodes 20.10.2.174:5433 \
  --num_unique_keys 20000000000 \
  --num_reads -1 \
  --num_writes -1 \
  --num_threads_read 1 \
  --num_threads_write 4 \
  --create_table_name t_blue \
  --truncate

# GREEN client - 3.142.241.200
java -jar /home/centos/yb-sample-apps.jar \
  --workload SqlInserts \
  --nodes 20.11.1.89:5433 \
  --num_unique_keys 20000000000 \
  --num_reads -1 \
  --num_writes -1 \
  --num_threads_read 1 \
  --num_threads_write 4 \
  --create_table_name t_green \
  --truncate
  
  
  java -jar yb-sample-apps.jar --workload SqlInserts --nodes 172.161.21.64:5433 --num_partitions 1  --nouuid --num_unique_keys 10000000 --num_reads 10000000 --num_writes 10000000 --tablespaces "regular_tablespace" --password Hsunder@1 --username yugabyte  --run_time 7200 --default_postgres_database yugabyte --num_threads_read 1 -num_threads_write 1 --create_table_name table_EastUS2a --truncate
  
