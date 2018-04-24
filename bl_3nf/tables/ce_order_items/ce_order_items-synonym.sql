BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ce_order_items';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ce_order_items FOR bl_3nf.ce_order_items;