BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sa_src.ext_products';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE sa_src.ext_products (
    prod_no        VARCHAR2(200),
    prod_name      VARCHAR2(200),
    prod_price     VARCHAR2(200),
    prod_in_sale   VARCHAR2(200)
)

organization EXTERNAL (TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_source_dir
ACCESS PARAMETERS ( RECORDS DELIMITED BY 0x '0D0A'
    SKIP 1
    BADFILE data_source_dir :'data.bad'
    NODISCARDFILE
    NOLOGFILE
    FIELDS TERMINATED BY '|' MISSING FIELD VALUES ARE NULL (
        prod_no CHAR ( 200 ),
        prod_name CHAR ( 200 ),
        prod_price CHAR ( 200 ),
        prod_in_sale CHAR ( 200 )
    )
) location('products_spoiled.dsv') ) reject limit unlimited;