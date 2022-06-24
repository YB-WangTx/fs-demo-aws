--login as superuser
./ysqlsh -h -U superuser

--change users
--Set session authorization

CREATE TABLE IF NOT EXISTS customers
(
  customer_id                SERIAL,
  full_name                  VARCHAR(50)  NOT NULL,
  email                      VARCHAR(50),
  password                   VARCHAR(500) NOT NULL,
  enabled                    BOOLEAN      NOT NULL DEFAULT TRUE,
  phone_number               VARCHAR(20),
  preferred_region           VARCHAR(20)  NOT NULL,
  account_statement_delivery VARCHAR(20)  NOT NULL DEFAULT ('US_MAIL'),
  tax_forms_delivery         VARCHAR(20)  NOT NULL DEFAULT ('EDELIVERY'),
  trade_confirmation          VARCHAR(20) NOT NULL DEFAULT ('EDELIVERY'),
  subscribe_blog             VARCHAR(10)  NOT NULL DEFAULT ('OPT_IN'),
  subscribe_webinar          VARCHAR(10)  NOT NULL DEFAULT ('OPT_IN'),
  subscribe_newsletter       VARCHAR(10)  NOT NULL DEFAULT ('OPT_OUT'),
  created_date               TIMESTAMP             DEFAULT NOW(),
  updated_date               TIMESTAMP             DEFAULT NOW()

    CONSTRAINT preferred_region_values CHECK ( preferred_region IN ('US', 'AP', 'EU') )
    CONSTRAINT tax_form_delivery_values CHECK ( tax_forms_delivery IN ('US_MAIL', 'EDELIVERY') )
    CONSTRAINT trade_confirmation_values CHECK ( trade_confirmation IN ('US_MAIL', 'EDELIVERY') )
    CONSTRAINT account_statement_delivery_values CHECK ( account_statement_delivery IN ('US_MAIL', 'EDELIVERY') )
    CONSTRAINT subscribe_blog_values CHECK ( subscribe_blog IN ('OPT_IN', 'OPT_OUT') )
    CONSTRAINT subscribe_webinar_values CHECK ( subscribe_webinar IN ('OPT_IN', 'OPT_OUT') )
    CONSTRAINT subscribe_newsletter_values CHECK ( subscribe_newsletter IN ('OPT_IN', 'OPT_OUT') ),


  PRIMARY KEY (customer_id, preferred_region)
) PARTITION BY LIST (preferred_region);
--
-- CREATE TABLESPACE us_tablespace WITH (
--   replica_placement='{ "num_replicas": 1, "placement_blocks":[{"cloud":"aws","region":"us-east-2","zone":"us-east-2c","min_num_replicas":1}]}'
--   );
--
-- CREATE TABLESPACE eu_tablespace WITH (
--   replica_placement='{"num_replicas": 1, "placement_blocks":[{"cloud":"aws","region":"eu-central-1","zone":"eu-central-1c","min_num_replicas":1}]}'
--   );
--
-- CREATE TABLESPACE ap_tablespace WITH (
--   replica_placement='{"num_replicas": 1, "placement_blocks":[{"cloud":"aws","region":"ap-southeast-1","zone":"ap-southeast-1c","min_num_replicas":1}]}'
--   );
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


CREATE TABLE IF NOT EXISTS customer_us
  PARTITION OF customers
    (
      customer_id,
      full_name,
      email,
      password,
      enabled,
      phone_number,
      preferred_region,
      account_statement_delivery,
      tax_forms_delivery,
      trade_confirmation,
      subscribe_blog,
      subscribe_webinar,
      subscribe_newsletter,
      created_date,
      updated_date
      )
    FOR VALUES IN ('US')
  TABLESPACE us_tablespace;

CREATE TABLE if not exists customer_eu
  PARTITION OF customers
    (
      customer_id,
      full_name,
      email,
      password,
      enabled,
      phone_number,
      preferred_region,
      account_statement_delivery,
      tax_forms_delivery,
      trade_confirmation,
      subscribe_blog,
      subscribe_webinar,
      subscribe_newsletter,
      created_date,
      updated_date
      )
    FOR VALUES IN ('EU')
  TABLESPACE eu_tablespace;

CREATE TABLE if not exists customer_ap
  PARTITION OF customers
    (
      customer_id,
      full_name,
      email,
      password,
      enabled,
      phone_number,
      preferred_region,
      account_statement_delivery,
      tax_forms_delivery,
      trade_confirmation,
      subscribe_blog,
      subscribe_webinar,
      subscribe_newsletter,
      created_date,
      updated_date
      )
    FOR VALUES IN ('AP')
  TABLESPACE ap_tablespace;
  
CREATE SEQUENCE IF NOT EXISTS s_user_id;




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
