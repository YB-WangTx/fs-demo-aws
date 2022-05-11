insert into user_preferences (user_id, account_id,name,contact_email,communication,preferred_region)
values(1000, 'x1000', 'test1', 'test1@gmail.com', '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account activity and service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}','US-EAST');
  
  
  create table test (id int, communication jsonb)
  
  insert into test values (1000, '{"Account_documents":{"Statements":"eDelivery", "Trade_confirmations":"eDelivery"},
  "Account_and_service_communications":{"Account_activity_and_service emails":"opt-in"},"Subscriptions":{"Viewpoints_Weekly_Edition":"opt-in", "Trading_and_Investing_Webinars":"opt-out"}}')
