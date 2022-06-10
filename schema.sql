--login as superuser
./ysqlsh -h -U superuser

--change users
Set session authorization

CREATE database tradepref;

CREATE SEQUENCE IF NOT EXISTS s_user_id;

CREATE TABLE IF NOT EXISTS customers
(
  customer_id                integer,
  customer_name              varchar(50) NOT NULL,
  contact_email              varchar(50) ,
  customer_phone             varchar(20) ,
  preferred_region           varchar(20) NOT NULL,
  created_date               TIMESTAMP   DEFAULT NOW(),
  updated_date               TIMESTAMP   DEFAULT NOW(),
  PRIMARY KEY(customer_id HASH,preferred_region)
) PARTITION BY LIST (preferred_region);

--
CREATE TABLESPACE eu_central_1_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"eu-central-1","zone":"eu-central-1c","min_num_replicas":1},
  {"cloud":"aws","region":"eu-central-1","zone":"eu-central-1c","min_num_replicas":1},
  {"cloud":"aws","region":"eu-central-1","zone":"eu-central-1c","min_num_replicas":1}]}'
);

drop TABLESPACE us_east_2_tablespace;
CREATE TABLESPACE us_east_2_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"us-east-2","zone":"us-east-2c","min_num_replicas":1},
  {"cloud":"aws","region":"us-east-2","zone":"us-east-2c","min_num_replicas":1},
  {"cloud":"aws","region":"us-east-2","zone":"us-east-2c","min_num_replicas":1}]}'
);

drop TABLESPACE ap_southeast_1_tablespace;

CREATE TABLESPACE ap_southeast_1_tablespace WITH (
  replica_placement='{"num_replicas": 3, "placement_blocks":
  [{"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1c","min_num_replicas":1},
  {"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1c","min_num_replicas":1},
  {"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1c","min_num_replicas":1}]}'
);

--create unique index if not exists uk_cpref_userid on user_preferences using lsm (customer_id,preferred_region);

CREATE TABLE if not exists customer_us_east
  PARTITION OF customers
    (customer_id, customer_name, contact_email, customer_phone,
      preferred_region,created_date, updated_date)
    FOR VALUES IN ('US') TABLESPACE us_east_2_tablespace;

CREATE TABLE if not exists customer_eu_central
  PARTITION OF customers
    (customer_id, customer_name, contact_email, customer_phone,
      preferred_region,created_date, updated_date)
    FOR VALUES IN ('EU') TABLESPACE eu_central_1_tablespace;

CREATE TABLE if not exists customer_ap_southeast
  PARTITION OF customers
    (customer_id, customer_name, contact_email, customer_phone,
      preferred_region,created_date, updated_date)
    FOR VALUES IN ('AP') TABLESPACE ap_southeast_1_tablespace;


CREATE TABLE IF NOT EXISTS customer_preferences
(
  customer_id                    integer     DEFAULT nextval('s_user_id'),
  account_id                 varchar(50) NOT NULL,
  account_statement_delivery varchar(20) DEFAULT ('US_MAIL'),
  tax_forms_delivery         varchar(20) DEFAULT ('EDELIVERY'),
  trade_confirmation         varchar(20) DEFAULT ('EDELIVERY'),
  daily_trade_blog           varchar(10) DEFAULT ('OPT_IN'),
  weekly_trade_blog          varchar(10) DEFAULT ('OPT_IN'),
  monthly_newsletter         varchar(10) DEFAULT ('OPT_OUT'),
  created_date               TIMESTAMP   DEFAULT NOW(),
  updated_date               TIMESTAMP   DEFAULT NOW()
);

yugabyte=# \dt
                 List of relations
 Schema |         Name          | Type  |  Owner   
--------+-----------------------+-------+----------
 public | customer_ap_southeast | table | yugabyte
 public | customer_eu_central   | table | yugabyte
 public | customer_preferences  | table | yugabyte
 public | customer_us_east      | table | yugabyte
 public | customers             | table | yugabyte
(5 rows)


grant ALL PRIVILEGES on tablespace ap_southeast_1_tablespace to yugabyte;


insert into customer_preferences (customer_id, account_id, account_statement_delivery, tax_forms_delivery, trade_confirmation, daily_trade_blog )
values
  (1, 'ACTID-1', 'EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_IN'),
  (2, 'ACTID-2', 'EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_OUT'),
  (3, 'ACTID-3', 'EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_OUT');

SELECT pg_terminate_backend(pid) FROM pg_stat_activity 
WHERE   pid <> pg_backend_pid() AND datname = 'tradepref';
