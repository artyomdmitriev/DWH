BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ext_products';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ext_products FOR sa_src.ext_products;