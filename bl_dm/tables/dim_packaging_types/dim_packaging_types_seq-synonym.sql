BEGIN
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM dim_packaging_types_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1432 THEN
         RAISE;
      END IF;
END;
/

CREATE PUBLIC SYNONYM dim_packaging_types_seq FOR bl_dm.dim_packaging_types_seq;