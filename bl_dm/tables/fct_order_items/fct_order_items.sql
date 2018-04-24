/**===============================================*\
Name...............:   fct_order_items
Contents...........:   Products sold as a part of orders
Author.............:   Artsemi Dzmitryieu
Date...............:   04/09/2018
\*=============================================== */
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.fct_order_items';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_dm.fct_order_items (
    ord_it_id                NUMBER(15) NOT NULL,
    ord_it_quantity          NUMBER(5) NOT NULL,
    ord_it_tax_amount_eur    NUMBER(8,2) NOT NULL,
    ord_it_total_price_eur   NUMBER(8,2) NOT NULL,
    invoice_code             NVARCHAR2(50) NOT NULL,
    packaging_type_id_dm     NUMBER(10) NOT NULL,
    shipping_courier_id_dm   NUMBER(10) NOT NULL,
    user_id_dm               NUMBER(10) NOT NULL,
    delivery_address_id_dm   NUMBER(10) NOT NULL,
    product_id_dm            NUMBER(10) NOT NULL,
    date_dt_dm               DATE NOT NULL
)
    PARTITION BY RANGE ( date_dt_dm )
    ( PARTITION year_2008
        VALUES LESS THAN ( TO_DATE('01-01-2008','dd-mm-yyyy') ),
    PARTITION year_2009
        VALUES LESS THAN ( TO_DATE('01-01-2009','dd-mm-yyyy') ),
    PARTITION year_2010
        VALUES LESS THAN ( TO_DATE('01-01-2010','dd-mm-yyyy') ),
    PARTITION year_2011
        VALUES LESS THAN ( TO_DATE('01-01-2011','dd-mm-yyyy') ),
    PARTITION year_2012
        VALUES LESS THAN ( TO_DATE('01-01-2012','dd-mm-yyyy') ),
    PARTITION year_2013
        VALUES LESS THAN ( TO_DATE('01-01-2013','dd-mm-yyyy') ),
    PARTITION year_2014
        VALUES LESS THAN ( TO_DATE('01-01-2014','dd-mm-yyyy') ),
    PARTITION year_2015
        VALUES LESS THAN ( TO_DATE('01-01-2015','dd-mm-yyyy') ),
    PARTITION year_2016
        VALUES LESS THAN ( TO_DATE('01-01-2016','dd-mm-yyyy') ),
    PARTITION year_2017
        VALUES LESS THAN ( TO_DATE('01-01-2017','dd-mm-yyyy') ),
    PARTITION year_other
        VALUES LESS THAN ( TO_DATE('31-12-9999','dd-mm-yyyy') )
    );

ALTER TABLE bl_dm.fct_order_items
    ADD CONSTRAINT order_items_pk PRIMARY KEY ( ord_it_id,
    product_id_dm,
    delivery_address_id_dm,
    user_id_dm,
    shipping_courier_id_dm,
    packaging_type_id_dm,
    invoice_code,
    date_dt_dm );

COMMENT ON TABLE bl_dm.fct_order_items
IS
  'Table Content: sale of the product inside order
   Refresh Cycle/Window: data is refreshed on the 1st day of the month for the previous month
  ';

COMMENT ON column bl_dm.fct_order_items.invoice_code             IS 'Business key of the invoice';
COMMENT ON column bl_dm.fct_order_items.packaging_type_id_dm     IS 'Foreign key to Packaging Types Dimension';
COMMENT ON column bl_dm.fct_order_items.shipping_courier_id_dm   IS 'Foreign key to Shipping Couriers Dimension';
COMMENT ON column bl_dm.fct_order_items.user_id_dm               IS 'Foreign key to Users Dimension';
COMMENT ON column bl_dm.fct_order_items.date_dt_dm               IS 'Foreign key to Date Dimension';
COMMENT ON column bl_dm.fct_order_items.delivery_address_id_dm   IS 'Foreign key to Delivery Addresses Dimension';
COMMENT ON column bl_dm.fct_order_items.product_id_dm            IS 'Foreign key to Products Dimension';
COMMENT ON column bl_dm.fct_order_items.ord_it_id                IS 'Surrogate key of Order Item';
COMMENT ON column bl_dm.fct_order_items.ord_it_quantity          IS 'Fact: Number of products items ordered';
COMMENT ON column bl_dm.fct_order_items.ord_it_tax_amount_eur    IS 'Fact: Tax amount for product in eur';
COMMENT ON column bl_dm.fct_order_items.ord_it_total_price_eur   IS 'Fact: Total price for product in eur';