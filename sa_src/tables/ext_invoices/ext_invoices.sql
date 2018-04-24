BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sa_src.EXT_INVOICES';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE sa_src.EXT_INVOICES
    (
     INVOICE_NO VARCHAR2(200),
     SHIPPING_COURIER_SHORT_NAME VARCHAR(200),
     SHIPPING_COURIER_FULL_NAME VARCHAR(200),
     PACKAGING VARCHAR(200),
     PACKAGING_CODE VARCHAR(200),
     WEIGHT VARCHAR(200)
     )
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
     DEFAULT DIRECTORY data_source_dir
     ACCESS PARAMETERS
        (RECORDS DELIMITED BY 0x'0D0A'
        SKIP 1
        BADFILE data_source_dir:'data.bad'
         nodiscardfile nologfile fields terminated by '|'
         missing field values are NULL 
            (
                 INVOICE_NO CHAR(200),
                 SHIPPING_COURIER_SHORT_NAME CHAR(200),
                 SHIPPING_COURIER_FULL_NAME CHAR(200),
                 PACKAGING CHAR(200),
                 PACKAGING_CODE CHAR(200),
                 WEIGHT CHAR(200)
                 
             )
         )
     LOCATION ('invoices_spoiled.csv')
)
reject LIMIT unlimited;