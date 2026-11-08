# Digital Wallet and Remittance System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | wallets records (list) |
| --- | --- |
| 1 | [101,102] |
| 2 | [103] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| wallets.wallet_id | wallets.customer_id | wallets.currency | customers.customer_id | customers.full_name |
| --- | --- | --- | --- | --- |
| 101 | 1 | USD | 1 | Maya Chen |
| 102 | 1 | EUR | 1 | Maya Chen |
| 103 | 2 | USD | 2 | Owen Patel |

Key: wallet_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## wallets_example

| wallets.wallet_id | wallets.customer_id | wallets.currency | customers.customer_id | customers.full_name |
| --- | --- | --- | --- | --- |
| 101 | 1 | USD | 1 | Maya Chen |
| 102 | 1 | EUR | 1 | Maya Chen |
| 103 | 2 | USD | 2 | Owen Patel |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| customer_id | full_name | email | registered_date |
| --- | --- | --- | --- |
| 1 | Maya Chen | maya.chen@example.test | 2026-01-10 |
| 2 | Owen Patel | owen.patel@example.test | 2026-01-11 |

## wallets

| wallet_id | customer_id | currency | balance | opened_date | active |
| --- | --- | --- | --- | --- | --- |
| 101 | 1 | USD | 1250.5 | 2026-01-12 | true |
| 102 | 1 | EUR | 800 | 2026-01-13 | true |
| 103 | 2 | USD | 950.75 | 2026-01-14 | true |

## remittances

| remittance_id | external_reference | sender_wallet_id | recipient_wallet_id | amount | currency | status | initiated_at | settled_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | REM-2026-0001 | 101 | 103 | 125.25 | USD | settled | 2026-02-01T10:15:00+00:00 | 2026-02-01T10:20:00+00:00 |
| 202 | REM-2026-0002 | 103 | 101 | 75 | USD | pending | 2026-02-02T09:00:00+00:00 | NULL |

## Dependencies

- customers: (customer_id) → full_name, email, registered_date
- wallets: (wallet_id) → customer_id, currency, balance, opened_date, active
- remittances: (remittance_id) → external_reference, sender_wallet_id, recipient_wallet_id, amount, currency, status, initiated_at, settled_at

Joining the decomposed sample tables reproduces the original 3 example rows. The design assumes the declared keys describe the relevant business dependencies.
