
--Parent table
create sequence s_user_id;
drop table User_Preferences cascade;
CREATE TABLE User_Preferences (
     user_id integer DEFAULT nextval('s_user_id'),
     account_id varchar(50),
     name varchar(50),
     contact_email varchar(50),
     account_statement_delivery varchar(50) DEFAULT ('eDelivery'),
     sub_view_points varchar(50)  DEFAULT ('Opt-in'),
     preferred_region varchar(50),
     created_date TIMESTAMP DEFAULT NOW(),
     updated_date TIMESTAMP DEFAULT NOW()
) PARTITION BY LIST (preferred_region);

--crate tablespaces
drop tablespace  eu_central_1_tablespace;
CREATE TABLESPACE eu_central_1_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"eu-central-1","zone":"eu-central-1a","min_num_replicas":1},
  {"cloud":"aws","region":"eu-central-1","zone":"eu-central-1b","min_num_replicas":1},
  {"cloud":"aws","region":"eu-central-1","zone":"eu-central-1c","min_num_replicas":1}]}'
);

CREATE TABLESPACE us_west_2_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"us-west-2","zone":"us-west-2a","min_num_replicas":1},
  {"cloud":"aws","region":"us-west-2","zone":"us-west-2b","min_num_replicas":1},
  {"cloud":"aws","region":"us-west-2","zone":"us-west-2c","min_num_replicas":1}]}'
);

CREATE TABLESPACE ap_southeast_1_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1a","min_num_replicas":1},
  {"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1a","min_num_replicas":1},
  {"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1a","min_num_replicas":1}]}'
);

--create tables
CREATE TABLE User_Preferences_eu_central
    PARTITION OF User_Preferences
      (user_id, name, contact_email, account_statement_delivery, sub_view_points, preferred_region,
      created_date, updated_date, 
      PRIMARY KEY (user_id HASH, account_id))
    FOR VALUES IN ('EU') TABLESPACE eu_central_1_tablespace;

CREATE INDEX ON User_Preferences_us_east(user_id) TABLESPACE eu_central_1_tablespace;


CREATE TABLE User_Preferences_us_west
    PARTITION OF User_Preferences
      (user_id, name, contact_email, account_statement_delivery, sub_view_points, preferred_region,
      created_date, updated_date, 
       PRIMARY KEY (user_id HASH, account_id))
    FOR VALUES IN ('US-WEST') TABLESPACE us_west_2_tablespace;

CREATE INDEX ON User_Preferences_us_west(user_id) TABLESPACE us_west_2_tablespace;

CREATE TABLE User_Preferences_ap_southeast
    PARTITION OF User_Preferences
      (user_id, name, contact_email, account_statement_delivery, sub_view_points, preferred_region,
      created_date, updated_date, 
       PRIMARY KEY (user_id HASH, account_id))
    FOR VALUES IN ('Asian') TABLESPACE ap_southeast_1_tablespace;

CREATE INDEX ON User_Preferences_ap_southeast(user_id) TABLESPACE ap_southeast_1_tablespace;
