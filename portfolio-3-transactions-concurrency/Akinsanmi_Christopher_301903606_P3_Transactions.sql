-- This helper counter exists only in the temporary transaction exercise.
-- Original case columns and constraints are preserved. It is not part of the P1 design.
ALTER TABLE portfolio."remittances" ADD COLUMN "p3_processed_count" integer NOT NULL DEFAULT 0;
ALTER TABLE portfolio."remittances" ADD CONSTRAINT "p3_count_nonnegative" CHECK ("p3_processed_count" >= 0);

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."remittances" SET "p3_processed_count" = "p3_processed_count" + 1 WHERE "remittance_id" IS NOT DISTINCT FROM 201 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "remittance_id", "p3_processed_count" FROM portfolio."remittances" WHERE "remittance_id" IS NOT DISTINCT FROM 201;

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."remittances" SET "p3_processed_count" = "p3_processed_count" + 10 WHERE "remittance_id" IS NOT DISTINCT FROM 201 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A negative counter deliberately fails its CHECK. Keep psql open so ROLLBACK can run.
\set ON_ERROR_STOP off
\set VERBOSITY verbose
UPDATE portfolio."remittances" SET "p3_processed_count" = -1 WHERE "remittance_id" IS NOT DISTINCT FROM 201 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A failed transaction rejects another statement until it is rolled back.
SELECT 1;
ROLLBACK;
\set ON_ERROR_STOP on
SELECT "remittance_id", "p3_processed_count" FROM portfolio."remittances" WHERE "remittance_id" IS NOT DISTINCT FROM 201;
