BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_shipping_couriers';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_shipping_couriers (
    shipping_courier_id          NUMBER(10) NOT NULL,
    shipping_courier_name        NVARCHAR2(255) NOT NULL,
    shipping_courier_full_name   NVARCHAR2(255) NOT NULL,
    shipping_courier_update_dt   DATE NOT NULL,
    shipping_courier_insert_dt   DATE NOT NULL
);

ALTER TABLE bl_3nf.ce_shipping_couriers ADD CONSTRAINT shipping_couriers_pk PRIMARY KEY ( shipping_courier_id );

INSERT INTO bl_3nf.ce_shipping_couriers (
    shipping_courier_id,
    shipping_courier_name,
    shipping_courier_full_name,
    shipping_courier_update_dt,
    shipping_courier_insert_dt
) VALUES (
    -1,
    'N/D',
    'N/D',
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    TO_DATE('01/01/1900','DD/MM/YYYY')
);

COMMIT;