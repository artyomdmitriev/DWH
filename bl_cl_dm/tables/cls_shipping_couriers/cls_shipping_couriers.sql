BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl_dm.cls_shipping_couriers';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl_dm.cls_shipping_couriers (
    shipping_courier_id_dm       NUMBER(10,0),
    shipping_courier_id          NUMBER(10,0),
    shipping_courier_name        NVARCHAR2(255),
    shipping_courier_full_name   NVARCHAR2(255)
);