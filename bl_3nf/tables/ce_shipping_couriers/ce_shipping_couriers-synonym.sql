BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ce_shipping_couriers';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ce_shipping_couriers FOR bl_3nf.ce_shipping_couriers;