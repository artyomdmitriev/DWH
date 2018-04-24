BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM dim_delivery_addresses_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM dim_delivery_addresses_seq FOR bl_dm.dim_delivery_addresses_seq;