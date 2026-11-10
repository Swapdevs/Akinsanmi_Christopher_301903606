# Digital Wallet and Remittance System - ER diagram

```mermaid
erDiagram
    direction LR
    customers {
        bigint customer_id PK
        text full_name
        text email UK
        date registered_date
    }
    wallets {
        bigint wallet_id PK
        bigint customer_id FK
        text currency
        numeric balance
        date opened_date
        boolean active
    }
    remittances {
        bigint remittance_id PK
        text external_reference UK
        bigint sender_wallet_id FK
        bigint recipient_wallet_id FK
        numeric amount
        text currency
        text status
        timestamptz initiated_at
        timestamptz settled_at "Optional"
    }
    customers ||--o{ wallets : "customer_id"
    wallets ||--o{ remittances : "sender_wallet_id"
    wallets ||--o{ remittances : "recipient_wallet_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Akinsanmi_Christopher_301903606_ERDiagram.png)
