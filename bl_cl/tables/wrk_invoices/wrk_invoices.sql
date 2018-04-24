BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.wrk_invoices';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.wrk_invoices (
    invoice_no                    VARCHAR2(200),
    shipping_courier_short_name   VARCHAR2(200),
    shipping_courier_full_name    VARCHAR2(200),
    packaging                     VARCHAR2(200),
    packaging_code                VARCHAR2(200),
    weight                        VARCHAR2(200)
);
