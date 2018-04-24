BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ce_postal_codes';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ce_postal_codes FOR bl_3nf.ce_postal_codes;