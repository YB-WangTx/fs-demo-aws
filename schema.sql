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
  PRIMARY KEY(customer_id, preferred_region)
) PARTITION BY LIST (preferred_region);

--create unique index if not exists uk_cpref_userid on user_preferences using lsm (customer_id,preferred_region);

CREATE TABLE if not exists customer_us_west
  PARTITION OF customers
    (customer_id, customer_name, contact_email, customer_phone,
      preferred_region,created_date, updated_date)
    FOR VALUES IN ('US');-- TABLESPACE us_west_2_tablespace

CREATE TABLE if not exists customer_eu_central
  PARTITION OF customers
    (customer_id, customer_name, contact_email, customer_phone,
      preferred_region,created_date, updated_date)
    FOR VALUES IN ('EU'); --TABLESPACE eu_central_1_tablespace;

CREATE TABLE if not exists customer_ap_southeast
  PARTITION OF customers
    (customer_id, customer_name, contact_email, customer_phone,
      preferred_region,created_date, updated_date)
    FOR VALUES IN ('AP'); --TABLESPACE ap_southeast_1_tablespace;


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

insert into customer_preferences (customer_id, account_id, account_statement_delivery, tax_forms_delivery, trade_confirmation, daily_trade_blog )
values
  (1, 'ACTID-1', 'EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_IN'),
  (2, 'ACTID-2', 'EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_OUT'),
  (3, 'ACTID-3', 'EDELIVERY', 'EDELIVERY', 'EDELIVERY', 'OPT_OUT');

SELECT pg_terminate_backend(pid) FROM pg_stat_activity 
WHERE   pid <> pg_backend_pid() AND datname = 'tradepref';
