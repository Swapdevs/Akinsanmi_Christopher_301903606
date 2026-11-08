-- A separate performance table using the case's remittances.status type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."remittances" AS
SELECT "status", 0::bigint AS "lab_row_id" FROM portfolio."remittances" WITH NO DATA;
INSERT INTO query_lab."remittances" ("status", "lab_row_id")
SELECT ('value-' || (g % 1000)::text), g FROM generate_series(1, 20000) AS g;
ANALYZE query_lab."remittances";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."remittances" USING btree ("status");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "status"
FROM query_lab."remittances"
WHERE "status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
