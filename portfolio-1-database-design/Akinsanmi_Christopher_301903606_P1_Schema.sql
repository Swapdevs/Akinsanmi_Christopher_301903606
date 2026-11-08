-- Digital Wallet and Remittance System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customers" (
  "customer_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "registered_date" date NOT NULL,
  CONSTRAINT "pk_customers" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customers_0" UNIQUE ("email")
);
CREATE TABLE portfolio."wallets" (
  "wallet_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "currency" text NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  "opened_date" date NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_wallets" PRIMARY KEY ("wallet_id")
);
CREATE TABLE portfolio."remittances" (
  "remittance_id" bigint NOT NULL,
  "external_reference" text NOT NULL,
  "sender_wallet_id" bigint NOT NULL,
  "recipient_wallet_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "currency" text NOT NULL,
  "status" text NOT NULL,
  "initiated_at" timestamptz NOT NULL,
  "settled_at" timestamptz,
  CONSTRAINT "pk_remittances" PRIMARY KEY ("remittance_id"),
  CONSTRAINT "uq_remittances_0" UNIQUE ("external_reference")
);
ALTER TABLE portfolio."wallets" ADD CONSTRAINT "fk_wallets_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("customer_id");
ALTER TABLE portfolio."remittances" ADD CONSTRAINT "fk_remittances_0" FOREIGN KEY ("sender_wallet_id") REFERENCES portfolio."wallets" ("wallet_id");
ALTER TABLE portfolio."remittances" ADD CONSTRAINT "fk_remittances_1" FOREIGN KEY ("recipient_wallet_id") REFERENCES portfolio."wallets" ("wallet_id");
CREATE UNIQUE INDEX "active_currency_unique" ON portfolio."wallets" ("customer_id", "currency") WHERE ("active" IS NOT NULL);
ALTER TABLE portfolio."remittances" ADD CONSTRAINT "positive_remittance_amount" CHECK ("amount" > 0);
ALTER TABLE portfolio."remittances" ADD CONSTRAINT "distinct_wallet_roles" CHECK (("sender_wallet_id" > "recipient_wallet_id") OR ("recipient_wallet_id" > "sender_wallet_id"));
COMMIT;
