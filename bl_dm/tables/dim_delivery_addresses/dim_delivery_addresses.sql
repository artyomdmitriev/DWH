/**===============================================*\
Name...............:   dim_delivery_addresses
Contents...........:   Contains addresses where products are delivered
Author.............:   Artsemi Dzmitryieu
Date...............:   04/04/2018
\*=============================================== */

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.dim_delivery_addresses';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_dm.dim_delivery_addresses (
    delivery_address_id_dm   NUMBER(10) NOT NULL,
    building_id          NUMBER(10) NOT NULL,
    building_code        NVARCHAR2(50) NOT NULL,
    building_number      NVARCHAR2(50) NOT NULL,
    street_id            NUMBER(10) NOT NULL,
    street_code          NVARCHAR2(50) NOT NULL,
    street_name          NVARCHAR2(255) NOT NULL,
    postal_code_id       NUMBER(10) NOT NULL,
    postal_code          NVARCHAR2(50) NOT NULL,
    city_id              NUMBER(10) NOT NULL,
    city_code            NVARCHAR2(50) NOT NULL,
    city_name            NVARCHAR2(255) NOT NULL,
    country_id           NUMBER(10) NOT NULL,
    country_code         NVARCHAR2(50) NOT NULL,
    country_name         NVARCHAR2(255) NOT NULL
);

ALTER TABLE bl_dm.dim_delivery_addresses ADD CONSTRAINT delivery_address_pk PRIMARY KEY ( delivery_address_id_dm );

COMMENT ON TABLE bl_dm.dim_delivery_addresses
IS
  'Table Content: delivery addresses
   Refresh Cycle/Window: data is refreshed on the 1st day of the month for the previous month
  ';

COMMENT ON column bl_dm.dim_delivery_addresses.delivery_address_id_dm     IS 'Dimension surrogate key';
COMMENT ON column bl_dm.dim_delivery_addresses.building_id                IS 'Surrogate key for buildings';
COMMENT ON column bl_dm.dim_delivery_addresses.building_code              IS 'Business key for buildings';
COMMENT ON column bl_dm.dim_delivery_addresses.street_id                  IS 'Surrogate key for streets';
COMMENT ON column bl_dm.dim_delivery_addresses.street_name                IS 'Name of the street';
COMMENT ON column bl_dm.dim_delivery_addresses.postal_code_id             IS 'Surrogate key for postal codes';
COMMENT ON column bl_dm.dim_delivery_addresses.postal_code                IS 'Business key for postal codes';
COMMENT ON column bl_dm.dim_delivery_addresses.city_id                    IS 'Surrogate key for cities';
COMMENT ON column bl_dm.dim_delivery_addresses.city_name                  IS 'Name of the city';
COMMENT ON column bl_dm.dim_delivery_addresses.country_id                 IS 'Surrogate key for countries';
COMMENT ON column bl_dm.dim_delivery_addresses.country_code               IS 'Business key for countries';
COMMENT ON column bl_dm.dim_delivery_addresses.country_name               IS 'Name of the country';