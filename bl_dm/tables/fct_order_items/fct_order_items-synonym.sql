BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM fct_order_items';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM fct_order_items FOR bl_dm.fct_order_items;