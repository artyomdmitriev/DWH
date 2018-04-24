BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl_dm.cls_order_items';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl_dm.cls_order_items (
    ord_it_id                NUMBER(15,0),
    ord_it_quantity          NUMBER(5,0),
    ord_it_tax_amount_eur    NUMBER(8,2),
    ord_it_total_price_eur   NUMBER(8,2),
    invoice_code             NVARCHAR2(50),
    packaging_type_id_dm     NUMBER(10,0),
    shipping_courier_id_dm   NUMBER(10,0),
    user_id_dm               NUMBER(10,0),
    delivery_address_id_dm   NUMBER(10,0),
    product_id_dm            NUMBER(10,0),
    date_dt_dm               DATE
);