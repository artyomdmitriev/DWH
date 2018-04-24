BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM dim_products_scd';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM dim_products_scd FOR bl_dm.dim_products_scd;