BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_invoices';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_invoices (
    invoice_id            NUMBER(10,0) NOT NULL,
    invoice_code          NVARCHAR2(50) NOT NULL,
    invoice_order_dt      DATE NOT NULL,
    shipping_courier_id   NUMBER(10,0) NOT NULL,
    packaging_type_id     NUMBER(10,0) NOT NULL
);