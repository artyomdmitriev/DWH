BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sa_src.ext_countries_codes';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE sa_src.ext_countries_codes (
    country_id     NUMBER(10),
    country_desc   VARCHAR2(200 CHAR),
    country_code   VARCHAR2(3)
)

organization EXTERNAL (TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_source_dir
ACCESS PARAMETERS ( RECORDS DELIMITED BY 0x '0D0A'
    BADFILE data_source_dir :'data.bad'
    NODISCARDFILE
    NOLOGFILE
    FIELDS TERMINATED BY ';' MISSING FIELD VALUES ARE NULL (
        country_id INTEGER EXTERNAL ( 4 ),
        country_desc CHAR ( 200 ),
        country_code CHAR ( 3 )
    )
) location('iso_3166.tab') ) reject limit unlimited;