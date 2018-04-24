BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_invoices';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_invoices (
    invoice_id            NUMBER(10) NOT NULL,
    invoice_code          NVARCHAR2(50) NOT NULL,
    invoice_order_dt      DATE NOT NULL,
    shipping_courier_id   NUMBER(10) NOT NULL,
    packaging_type_id     NUMBER(10) NOT NULL
);

ALTER TABLE bl_3nf.ce_invoices ADD CONSTRAINT invoices_pk PRIMARY KEY ( invoice_id );

ALTER TABLE bl_3nf.ce_invoices
    ADD CONSTRAINT invoices_packaging_types_fk FOREIGN KEY ( packaging_type_id )
        REFERENCES bl_3nf.ce_packaging_types ( packaging_type_id );

ALTER TABLE bl_3nf.ce_invoices
    ADD CONSTRAINT invoices_shipping_couriers_fk FOREIGN KEY ( shipping_courier_id )
        REFERENCES bl_3nf.ce_shipping_couriers ( shipping_courier_id );

INSERT INTO bl_3nf.ce_invoices (
    invoice_id,
    invoice_code,
    invoice_order_dt,
    shipping_courier_id,
    packaging_type_id
) VALUES (
    -1,
    'N/D',
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    -1,
    -1
);

COMMIT;