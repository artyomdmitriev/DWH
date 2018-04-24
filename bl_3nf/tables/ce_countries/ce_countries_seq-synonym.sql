BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ce_countries_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ce_countries_seq FOR bl_3nf.ce_countries_seq;