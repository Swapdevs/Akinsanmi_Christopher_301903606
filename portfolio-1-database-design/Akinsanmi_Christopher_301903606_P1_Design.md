# Digital Wallet and Remittance System: Database Design

**Christopher Akinsanmi** · Student ID 301903606
MIT 8103 Advanced Database Systems · Portfolio 1

## 1. Introduction

This document sets out the relational design for my case study, a digital wallet and remittance system. The system records the people who hold wallets, the currency-specific wallets they own, and the transfers (remittances) that move money between those wallets. The design targets PostgreSQL. All customers, wallets, identifiers, balances, timestamps and transfers used as examples are synthetic.

## 2. Users and requirements

Three groups of people interact with the data, and each places different demands on the design.

| User group | Needs |
| --- | --- |
| Customers | Manage their wallets, and send and receive remittances |
| Operations staff | Review pending, failed and settled transfers |
| Analysts | Aggregate remittance activity by currency and status |

These needs translate into five main operations:

1. Register customers and wallets.
2. Initiate remittance transfers between wallets.
3. Update a transfer's status and settlement timestamp.
4. Review operational exceptions and completed transfers.
5. Measure transfer counts and values by currency.

The first three are write-oriented and depend on integrity rules, such as valid references and unique identifiers. The last two are read-oriented and depend on currency and status being recorded consistently on each transfer.

## 3. Entities

The design identifies three entities.

| Entity | Role in the system |
| --- | --- |
| `customers` | People who own digital wallets |
| `wallets` | Currency-specific accounts owned by customers |
| `remittances` | Transfers between two wallets, together with their processing lifecycle |

Their relationships are one-to-many. One customer owns many wallets, and one wallet takes part in many remittances, as either sender or recipient. Each remittance has exactly one sender wallet and exactly one recipient wallet. The ER diagram and the normalisation document show these relationships in detail.

## 4. Table specifications

### 4.1 `customers`

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| `customer_id` | BIGINT | Primary key | Yes |
| `full_name` | TEXT | | Yes |
| `email` | TEXT | Unique | Yes |
| `registered_date` | DATE | | Yes |

Candidate keys: `customer_id` (chosen as primary key) and `email`.

### 4.2 `wallets`

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| `wallet_id` | BIGINT | Primary key | Yes |
| `customer_id` | BIGINT | Foreign key | Yes |
| `currency` | TEXT | | Yes |
| `balance` | NUMERIC(18,2) | | Yes |
| `opened_date` | DATE | | Yes |
| `active` | BOOLEAN | | Yes |

Foreign key: `customer_id` references `customers.customer_id`.

### 4.3 `remittances`

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| `remittance_id` | BIGINT | Primary key | Yes |
| `external_reference` | TEXT | Unique | Yes |
| `sender_wallet_id` | BIGINT | Foreign key | Yes |
| `recipient_wallet_id` | BIGINT | Foreign key | Yes |
| `amount` | NUMERIC(18,2) | | Yes |
| `currency` | TEXT | | Yes |
| `status` | TEXT | | Yes |
| `initiated_at` | TIMESTAMPTZ | | Yes |
| `settled_at` | TIMESTAMPTZ | | No |

Foreign keys: `sender_wallet_id` and `recipient_wallet_id` each reference `wallets.wallet_id`. Candidate keys: `remittance_id` (primary key) and `external_reference`.

`settled_at` is the only optional field. A transfer that is still pending has not settled, so a missing value is meaningful there and not an omission.

### 4.4 Choice of data types

Monetary values (`balance` and `amount`) use `NUMERIC(18,2)` and not a floating-point type, because exact decimal arithmetic avoids rounding errors in financial figures. Event times use `TIMESTAMPTZ` so that instants are stored unambiguously regardless of the session's time zone. Identifiers use `BIGINT` to leave room for growth.

## 5. Business rules and their enforcement

The table below lists each rule and the mechanism that enforces it in the schema.

| Rule | Enforced by |
| --- | --- |
| Every customer has an email, and no two customers share one | `NOT NULL` and unique constraint on `customers.email` |
| Every wallet belongs to an existing customer | Foreign key from `wallets.customer_id` |
| A customer may have at most one active wallet per currency | Unique index `active_currency_unique` on (`customer_id`, `currency`) |
| A remittance amount is greater than zero | Check constraint `positive_remittance_amount` |
| A remittance has different sender and recipient wallets | Check constraint `distinct_wallet_roles` |
| Sender and recipient must each identify an existing wallet | Two foreign keys from `remittances` to `wallets` |
| A retried submission cannot create a duplicate remittance | Unique constraint on `remittances.external_reference` |

The unique `external_reference` acts as an idempotency key. If a client resubmits a transfer after a timeout, the database rejects the second insert, and the transfer is recorded only once.

## 6. Assumptions

The design rests on the following assumptions, some of which the database does not enforce by itself.

1. **Wallet ownership.** Every wallet belongs to exactly one registered customer.
2. **Active wallets.** A customer has at most one active wallet in any given currency.
3. **Transfer parties.** Every remittance has one sender wallet and one recipient wallet, and these must differ.
4. **Currency consistency.** A remittance's currency matches the currency of both its sender and recipient wallets. *This is not enforced by a constraint, so it relies on the application.*
5. **Status values.** Remittance status takes values such as `pending`, `settled` and `failed`. *The column is free text, with no check constraint restricting the vocabulary.*
6. **Amounts and time.** Amounts are positive decimal values, and all timestamps follow one consistent UTC convention.
7. **Identifiers.** Primary keys are single-column identifiers from one shared numbering scheme, so an identifier is not reused across entities. In the sample data, customers use 1–2, wallets 101–103 and remittances 201–202.
8. **Synthetic data.** All example records are fictional and carry no real personal or financial information.

Assumptions 4 and 5 mark the points where integrity depends on application behaviour. A future revision could enforce them with a composite foreign key or trigger (for currency) and a check constraint or lookup table (for status).

## 7. Relationship to normalisation

The three-table structure comes from the normalisation process described in the companion document. That process begins with a wallet table that carries customer details, identifies the dependency of customer attributes on the customer and not on the wallet, and separates them into their own table. Wallets then refer to customers by key, and remittances refer to wallets by key, so no entity's details are stored twice.