--use default database and default schema: yugabyte

--Parent table
CREATE TABLE User_Preferences (
     user_id varchar(50),
     account_id varchar(50),
     name varchar(50),
     contact_email varchar(50),
     communication jsonb,
     Start_page jsonb,
     account_nickname jsonb,
     preferred_region varchar(50),
     created_date TIMESTAMP DEFAULT NOW(),
     updated_date TIMESTAMP DEFAULT NOW()
) PARTITION BY LIST (preferred_region);

--crate tablespaces
CREATE TABLESPACE us_east_2_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"us_east_2","zone":"us_east_2a","min_num_replicas":1},
  {"cloud":"aws","region":"us_east_2","zone":"us_east_2b","min_num_replicas":1},
  {"cloud":"aws","region":"us_east_2","zone":"us_east_2c","min_num_replicas":1}]}'
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
  {"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1b","min_num_replicas":1},
  {"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1c","min_num_replicas":1}]}'
);

--create tables
CREATE TABLE User_Preferences_us_east
    PARTITION OF User_Preferences
      (user_id, name, contact_email, communication,
      Start_page, account_nickname,preferred_region,
      created_date, updated_date, 
      PRIMARY KEY (user_id HASH, account_id, preferred_region))
    FOR VALUES IN ('US-EAST-2') TABLESPACE us_east_2_tablespace;

CREATE INDEX ON User_Preferences_us_east(user_id) TABLESPACE us_east_2_tablespace;

CREATE TABLE User_Preferences_us_west
    PARTITION OF User_Preferences
      (user_id, name, contact_email, communication,
      Start_page, account_nickname,preferred_region,
      created_date, updated_date, 
      PRIMARY KEY (user_id HASH, account_id, preferred_region))
    FOR VALUES IN ('US-WEST-2') TABLESPACE us_west_2_tablespace;

CREATE INDEX ON User_Preferences_us_west(user_id) TABLESPACE us_west_2_tablespace;

CREATE TABLE User_Preferences_us_west
    PARTITION OF User_Preferences
      (user_id, name, contact_email, communication,
      Start_page, account_nickname,preferred_region,
      created_date, updated_date, 
      PRIMARY KEY (user_id HASH, account_id, preferred_region))
    FOR VALUES IN ('US-WEST-2') TABLESPACE us_west_2_tablespace;

CREATE INDEX ON User_Preferences_ap_southeast_1(user_id) TABLESPACE ap_southeast_1_tablespace;
