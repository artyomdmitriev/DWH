BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ext_countries_codes';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ext_countries_codes FOR sa_src.ext_countries_codes;