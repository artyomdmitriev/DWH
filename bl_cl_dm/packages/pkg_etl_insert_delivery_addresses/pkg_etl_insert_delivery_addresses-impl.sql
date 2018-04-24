CREATE OR REPLACE PACKAGE BODY pkg_etl_insert_delivery_addresses AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_packaging_types
  Contents...........:   Implementation of ETL process of loading data into dim_delivery_addresses
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_cls_delivery_addresses
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_delivery_addresses';
        INSERT INTO cls_delivery_addresses
            SELECT
                DECODE(dim_delivery_addresses.building_id,NULL,dim_delivery_addresses_seq.NEXTVAL,dim_delivery_addresses.delivery_address_id_dm),
                daddr.building_id,
                daddr.building_code,
                daddr.building_number,
                daddr.street_id,
                daddr.street_code,
                daddr.street_name,
                daddr.postal_code_id,
                daddr.postal_code,
                daddr.city_id,
                daddr.city_code,
                daddr.city_name,
                daddr.country_id,
                daddr.country_code,
                daddr.country_name
            FROM
                (
                    SELECT
                        cb.building_id,
                        cb.building_code,
                        cb.building_number,
                        cs.street_id,
                        cs.street_code,
                        cs.street_name,
                        cpc.postal_code_id,
                        cpc.postal_code,
                        cc.city_id,
                        cc.city_code,
                        cc.city_name,
                        cco.country_id,
                        cco.country_code,
                        cco.country_name
                    FROM
                        ce_order_items coi,
                        ce_buildings cb,
                        ce_streets cs,
                        ce_postal_codes cpc,
                        ce_cities cc,
                        ce_countries cco
                    WHERE
                        coi.building_id = cb.building_id
                        AND   cb.street_id = cs.street_id
                        AND   cs.postal_code_id = cpc.postal_code_id
                        AND   cs.city_id = cc.city_id
                        AND   cc.country_id = cco.country_id
                    GROUP BY
                        cb.building_id,
                        cb.building_code,
                        cb.building_number,
                        cs.street_id,
                        cs.street_code,
                        cs.street_name,
                        cpc.postal_code_id,
                        cpc.postal_code,
                        cc.city_id,
                        cc.city_code,
                        cc.city_name,
                        cco.country_id,
                        cco.country_code,
                        cco.country_name
                ) daddr,
                dim_delivery_addresses
            WHERE
                daddr.building_id = dim_delivery_addresses.building_id (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_delivery_addresses;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_dim_delivery_addresses
        IS
    BEGIN
        MERGE INTO dim_delivery_addresses dest USING ( SELECT
            delivery_address_id_dm,
            building_id,
            building_code,
            building_number,
            street_id,
            street_code,
            street_name,
            postal_code_id,
            postal_code,
            city_id,
            city_code,
            city_name,
            country_id,
            country_code,
            country_name
                                                       FROM
            cls_delivery_addresses
        MINUS
        SELECT
            delivery_address_id_dm,
            building_id,
            building_code,
            building_number,
            street_id,
            street_code,
            street_name,
            postal_code_id,
            postal_code,
            city_id,
            city_code,
            city_name,
            country_id,
            country_code,
            country_name
        FROM
            dim_delivery_addresses
        )
        src ON ( src.delivery_address_id_dm = dest.delivery_address_id_dm )
        WHEN MATCHED THEN UPDATE SET dest.building_id = src.building_id,
        dest.building_code = src.building_code,
        dest.building_number = src.building_number,
        dest.street_id = src.street_id,
        dest.street_code = src.street_code,
        dest.street_name = src.street_name,
        dest.postal_code_id = src.postal_code_id,
        dest.postal_code = src.postal_code,
        dest.city_id = src.city_id,
        dest.city_code = src.city_code,
        dest.city_name = src.city_name,
        dest.country_id = src.country_id,
        dest.country_code = src.country_code,
        dest.country_name = src.country_name
        WHEN NOT MATCHED THEN INSERT (
            delivery_address_id_dm,
                                                                building_id,
                                                            building_code,
                                                        building_number,
                                                    street_id,
                                                street_code,
                                            street_name,
                                        postal_code_id,
                                    postal_code,
                                city_id,
                            city_code,
                        city_name,
                    country_id,
                country_code,
            country_name
        ) VALUES (
            src.delivery_address_id_dm,
                                                                src.building_id,
                                                            src.building_code,
                                                        src.building_number,
                                                    src.street_id,
                                                src.street_code,
                                            src.street_name,
                                        src.postal_code_id,
                                    src.postal_code,
                                src.city_id,
                            src.city_code,
                        src.city_name,
                    src.country_id,
                src.country_code,
            src.country_name
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_dim_delivery_addresses;

END;
/