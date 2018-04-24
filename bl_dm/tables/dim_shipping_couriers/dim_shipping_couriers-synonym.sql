BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM dim_shipping_couriers';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM dim_shipping_couriers FOR bl_dm.dim_shipping_couriers;