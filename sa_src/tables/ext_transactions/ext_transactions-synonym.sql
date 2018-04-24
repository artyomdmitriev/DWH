BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ext_transactions';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM ext_transactions FOR sa_src.ext_transactions;