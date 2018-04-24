BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE bl_3nf.ce_users_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN
         RAISE;
      END IF;
END;
/

CREATE SEQUENCE bl_3nf.ce_users_seq START WITH 1 INCREMENT BY 1;