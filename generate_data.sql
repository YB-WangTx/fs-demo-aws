insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
values(1000, 'x1000', 'test1', 'test1000@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','US-EAST-2');
  
  insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
values(2000, 'x2000', 'test2000', 'test2000@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','AP-SOUTHEAST-1');
  
  
  insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
values(3000, 'x3000', 'test3000', 'test3000@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','US-WEST-2');
  
  --distributed transactions
  SET force_global_transaction = TRUE;
  BEGIN;
   insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
   values(1001, 'x1001', 'test1001', 'test1001@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','US-EAST-2');
  
  insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
  values(2001, 'x2001', 'test2001', 'test2001@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','AP-SOUTHEAST-1');
  
  COMMIT;

---
  select * from User_Preferences_us_east;
  
  select * from User_Preferences_ap_southeast;
  
  select * from User_Preferences_us_west;
  
  select * from User_Preferences where preferred_region='AP-SOUTHEAST-1';
  select * from User_Preferences where preferred_region='US-EAST-3';
  select * from User_Preferences where preferred_region='US-WEST-2';
  
  select name, account_id, communication->'Subscriptions'->'Viewpoints_Weekly_Edition', communication->'Account_documents'->'Statements' from user_preferences;
