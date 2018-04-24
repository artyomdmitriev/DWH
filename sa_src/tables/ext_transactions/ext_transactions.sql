BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sa_src.EXT_TRANSACTIONS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE sa_src.EXT_TRANSACTIONS
    (
     INVOICE_NO VARCHAR2(200),
     QUANTITY VARCHAR2(200),
     TAX_AMOUNT VARCHAR2(200),
     TOTAL_PRICE VARCHAR2(200),
     TRANSACTION_DATE VARCHAR2(200),
     USER_ID VARCHAR2(200),
     PRODUCT_ID VARCHAR2(200),
     COUNTRY VARCHAR2(200),
     CITY_CODE VARCHAR2(200),
     CITY VARCHAR2(200),
     STREET_CODE VARCHAR2(200),
     STREET_NAME VARCHAR2(200),
     BUILDING_CODE VARCHAR2(200),
     BUILDING VARCHAR2(200),
     APARTMENT VARCHAR2(200),
     POSTAL_CODE VARCHAR2(200)
     )
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
     DEFAULT DIRECTORY data_source_dir
     ACCESS PARAMETERS
        (RECORDS DELIMITED BY 0x'0D0A'
        CHARACTERSET WE8MSWIN1252
        SKIP 1
        BADFILE data_source_dir:'data.bad'
         nodiscardfile nologfile fields terminated by '|'
         missing field values are NULL 
            (
             INVOICE_NO CHAR(200),
             QUANTITY CHAR(200),
             TAX_AMOUNT CHAR(200),
             TOTAL_PRICE CHAR(200),
             TRANSACTION_DATE CHAR(200),
             USER_ID CHAR(200),
             PRODUCT_ID CHAR(200),
             COUNTRY CHAR(200),
             CITY_CODE CHAR(200),
             CITY CHAR(200),
             STREET_CODE CHAR(200),
             STREET_NAME CHAR(200),
             BUILDING_CODE CHAR(200),
             BUILDING CHAR(200),
             APARTMENT CHAR(200),
             POSTAL_CODE CHAR(200)    
             )
         )
     LOCATION ('transactions_spoiled.dsv')
)
reject LIMIT unlimited;