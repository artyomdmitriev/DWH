BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ce_cities';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ce_cities FOR bl_3nf.ce_cities;