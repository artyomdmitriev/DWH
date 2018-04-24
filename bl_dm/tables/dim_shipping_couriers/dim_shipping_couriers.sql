/**===============================================*\
Name...............:   dim_shipping_couriers
Contents...........:   Contains shipping couriers information
Author.............:   Artsemi Dzmitryieu
Date...............:   04/04/2018
\*=============================================== */
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.dim_shipping_couriers';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_dm.dim_shipping_couriers (
    shipping_courier_id_dm       NUMBER(10) NOT NULL,
    shipping_courier_id          NUMBER(10) NOT NULL,
    shipping_courier_name        NVARCHAR2(255) NOT NULL,
    shipping_courier_full_name   NVARCHAR2(255) NOT NULL,
    shipping_courier_update_dt   DATE NOT NULL,
    shipping_courier_insert_dt   DATE NOT NULL
);

ALTER TABLE bl_dm.dim_shipping_couriers ADD CONSTRAINT dim_shipping_courier_pk PRIMARY KEY ( shipping_courier_id_dm );

COMMENT ON TABLE bl_dm.dim_shipping_couriers
IS
  'Table Content: shipping couriers
   Refresh Cycle/Window: data is refreshed on the 1st day of the month for the previous month
  ';

COMMENT ON column bl_dm.dim_shipping_couriers.shipping_courier_id_dm         IS 'Dimension surrogate key';
COMMENT ON column bl_dm.dim_shipping_couriers.shipping_courier_id            IS 'Surrogate key for shipping couriers';
COMMENT ON column bl_dm.dim_shipping_couriers.shipping_courier_name          IS 'Name of the shipping courier';
COMMENT ON column bl_dm.dim_shipping_couriers.shipping_courier_full_name     IS 'Full name of the shipping courier';
COMMENT ON column bl_dm.dim_shipping_couriers.shipping_courier_update_dt     IS 'Update date of the record';
COMMENT ON column bl_dm.dim_shipping_couriers.shipping_courier_insert_dt     IS 'Insert date of the record';