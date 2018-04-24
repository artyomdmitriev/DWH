BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_order_items';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_order_items (
    ord_it_id                NUMBER(15) NOT NULL,
    ord_it_quantity          NUMBER(5) NOT NULL,
    ord_it_tax_amount_eur    NUMBER(8,2) NOT NULL,
    ord_it_total_price_eur   NUMBER(8,2) NOT NULL,
    invoice_id               NUMBER(10) NOT NULL,
    user_id                  NUMBER(10) NOT NULL,
    product_id               NUMBER(10) NOT NULL,
    building_id              NUMBER(10) NOT NULL
);

ALTER TABLE bl_3nf.ce_order_items ADD CONSTRAINT item_of_order_pk PRIMARY KEY ( ord_it_id );

ALTER TABLE bl_3nf.ce_order_items
    ADD CONSTRAINT invoices_fk FOREIGN KEY ( invoice_id )
        REFERENCES bl_3nf.ce_invoices ( invoice_id );

ALTER TABLE bl_3nf.ce_order_items
    ADD CONSTRAINT item_orders_buildings_fk FOREIGN KEY ( building_id )
        REFERENCES bl_3nf.ce_buildings ( building_id );

ALTER TABLE bl_3nf.ce_order_items
    ADD CONSTRAINT products_fk FOREIGN KEY ( product_id )
        REFERENCES bl_3nf.ce_products ( product_id );

ALTER TABLE bl_3nf.ce_order_items
    ADD CONSTRAINT users_fk FOREIGN KEY ( user_id )
        REFERENCES bl_3nf.ce_users ( user_id );

INSERT INTO bl_3nf.ce_order_items (
    ord_it_id,
    ord_it_quantity,
    ord_it_tax_amount_eur,
    ord_it_total_price_eur,
    invoice_id,
    user_id,
    product_id,
    building_id
) VALUES (
    -1,
    -1,
    -1.0,
    -1.0,
    -1,
    -1,
    -1,
    -1
);

COMMIT;