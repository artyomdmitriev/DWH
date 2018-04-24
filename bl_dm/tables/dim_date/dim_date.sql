/**===============================================*\
Name...............:   dim_date
Contents...........:   Contains dates
Author.............:   Artsemi Dzmitryieu
Date...............:   04/05/2018
\*=============================================== */

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.dim_date';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/


CREATE OR REPLACE TYPE bl_dm.date_obj AS OBJECT (
    date_dt                  DATE,
    day_of_month             SMALLINT,
    cal_day_of_year          SMALLINT,
    day_of_week_full_name    VARCHAR2(9),
    day_of_week_short_name   CHAR(3),
    cal_month_full_name      VARCHAR2(9),
    cal_month_short_name     CHAR(3),
    cal_month_enum           SMALLINT,
    cal_qtr_name             CHAR(2),
    cal_qtr_enum             SMALLINT,
    cal_hyr_name             CHAR(2),
    cal_hyr_enum             SMALLINT,
    cal_year                 INT,
    start_of_month           DATE,
    end_of_month             DATE
);
/

CREATE OR REPLACE TYPE bl_dm.calendar_dates IS
    TABLE OF date_obj;
/

CREATE OR REPLACE FUNCTION bl_dm.udf_calendar_generator (
    start_date   IN DATE,
    end_date     IN DATE
) RETURN calendar_dates IS
    calendar_date   calendar_dates;
BEGIN
    SELECT
        CAST(MULTISET(
            WITH rcte_dates(date_dt) AS(
                SELECT
                    start_date AS date_dt
                FROM
                    dual
                UNION ALL
                SELECT
                    date_dt + 1 AS date_dt
                FROM
                    rcte_dates
                WHERE
                    date_dt + 1 <= end_date
            ) SELECT
                date_dt,
                EXTRACT(DAY FROM date_dt) AS day_of_month,
                CAST(TO_CHAR(date_dt,'DDD') AS SMALLINT) AS cal_day_of_year,
                TO_CHAR(date_dt,'DAY') AS day_of_week_full_name,
                TO_CHAR(date_dt,'DY') AS day_of_week_short_name,
                TO_CHAR(date_dt,'MONTH') AS cal_month_full_name,
                TO_CHAR(date_dt,'MON') AS cal_month_short_name,
                EXTRACT(MONTH FROM date_dt) AS cal_month_enum,
                'Q'
                || TO_CHAR(date_dt,'Q') AS cal_qtr_name,
                CAST(TO_CHAR(date_dt,'Q') AS SMALLINT) AS cal_qtr_enum,
                'H'
                ||
                    CASE
                        WHEN EXTRACT(MONTH FROM date_dt) IN(
                            1,2,3,4,5,6
                        ) THEN 1
                        ELSE 2
                    END
                AS cal_hyr_name,
                CASE
                        WHEN EXTRACT(MONTH FROM date_dt) IN(
                            1,2,3,4,5,6
                        ) THEN 1
                        ELSE 2
                    END
                AS cal_hyr_enum,
                EXTRACT(YEAR FROM date_dt) AS cal_year,
                trunc(date_dt,'MONTH') AS start_of_month,
                trunc(add_months(date_dt,1),'MONTH') - 1 AS end_of_month
              FROM
                rcte_dates
            UNION
            SELECT
                TO_DATE('31-DEC-9999','DD-MON-YYYY') AS date_dt,
                0 AS day_of_month,
                0 AS cal_day_of_year,
                'NA' AS day_of_week_full_name,
                'NA' AS day_of_week_short_name,
                'NA' AS cal_month_full_name,
                'NA' AS cal_month_short_name,
                0 AS cal_month_enum,
                'NA' AS cal_qtr_name,
                0 AS cal_qtr_enum,
                'NA' AS cal_hyr_name,
                0 AS cal_hyr_enum,
                9999 AS cal_year,
                TO_DATE('31-DEC-9999','DD-MON-YYYY') AS start_of_month,
                TO_DATE('31-DEC-9999','DD-MON-YYYY') AS end_of_month
            FROM
                dual
        ) AS calendar_dates)
    INTO
        calendar_date
    FROM
        dual;

    RETURN calendar_date;
END;
/

ALTER SESSION SET nls_date_format = 'MM/DD/YYYY';
/

CREATE TABLE bl_dm.dim_date
    AS
        SELECT
            *
        FROM
            TABLE ( bl_dm.udf_calendar_generator(CAST('01/01/1900' AS DATE),CAST('12/31/2100' AS DATE) ) );
/

ALTER TABLE bl_dm.dim_date ADD CONSTRAINT dates_pk PRIMARY KEY ( date_dt );
/