BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ce_packaging_types';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ce_packaging_types FOR bl_3nf.ce_packaging_types;