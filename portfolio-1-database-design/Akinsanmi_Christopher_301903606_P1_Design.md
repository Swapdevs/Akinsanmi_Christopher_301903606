# Digital Wallet and Remittance System — database design

My case study records customers, wallets, remittances.

## Users

- Customers manage wallets and send or receive remittances.
- Operations staff review pending, failed, and settled transfers.
- Analysts aggregate remittance activity by currency and status.

## Main operations

- Register customers and wallets.
- Initiate remittance transfers between wallets.
- Update transfer status and settlement timestamps.
- Review operational exceptions and completed transfers.
- Measure transfer counts and values by currency.

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Stores people who own digital wallets. |
| wallets | Stores currency-specific wallet accounts owned by customers. |
| remittances | Records transfers between wallets and their processing lifecycle. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| registered_date | DATE |  | Yes |
- Unique key: (email).

## wallets

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| wallet_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| currency | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| opened_date | DATE |  | Yes |
| active | BOOLEAN |  | Yes |
- customer_id → customers.customer_id

## remittances

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| remittance_id | BIGINT | PK | Yes |
| external_reference | TEXT | Unique | Yes |
| sender_wallet_id | BIGINT | FK | Yes |
| recipient_wallet_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| currency | TEXT |  | Yes |
| status | TEXT |  | Yes |
| initiated_at | TIMESTAMPTZ |  | Yes |
| settled_at | TIMESTAMPTZ |  | No |
- sender_wallet_id → wallets.wallet_id
- recipient_wallet_id → wallets.wallet_id
- Unique key: (external_reference).

## Relationships and business rules

- Every customer email is required and must be unique.
- Every wallet must reference an existing customer.
- A customer may have at most one active wallet for each currency; uniqueness applies only to active wallets.
- Every remittance amount must be greater than zero.
- A remittance sender wallet and recipient wallet must be different.
- Every sender wallet reference must identify an existing wallet.
- Every recipient wallet reference must identify an existing wallet.
- Each external reference is unique so retried submissions cannot create duplicate remittances.

## Assumptions

- Each customer may have at most one active wallet for a currency.
- Every wallet belongs to one registered customer.
- Every remittance has one sender wallet and one recipient wallet, and the two wallets must differ.
- Remittance currency matches the sender and recipient wallet currency.
- Amounts are positive decimal values and timestamps use one consistent UTC convention.
- Customer, wallet, and remittance primary keys use one globally unique single-column identifier namespace.
- A worked normalisation example starts with wallets, which references customers, and separates customer attributes from wallet attributes without repeating ancestor roles.
- All example customers, wallets, identifiers, currencies, timestamps, balances, and transfers are synthetic.

