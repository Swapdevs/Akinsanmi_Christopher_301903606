// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("remittance_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("remittance_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "remittance_initiated",
                    "remittance_authorized"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "remittances"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "remittance_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("remittance_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "remittance_initiated",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "remittances",
            "key": {
                "remittance_id": 201
            },
            "snapshot": {
                "remittance_id": 201,
                "external_reference": "REM-2026-0001",
                "sender_wallet_id": 101,
                "recipient_wallet_id": 103,
                "amount": 125.25,
                "currency": "USD",
                "status": "settled",
                "initiated_at": "2026-02-01T10:15:00Z",
                "settled_at": "2026-02-01T10:20:00Z"
            }
        },
        "embedded": {
            "customers": [
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "full_name": "Maya Chen",
                        "email": "maya.chen@example.test",
                        "registered_date": "2026-01-10"
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets.customer_id → customers"
                    ]
                },
                {
                    "key": {
                        "customer_id": 2
                    },
                    "snapshot": {
                        "customer_id": 2,
                        "full_name": "Owen Patel",
                        "email": "owen.patel@example.test",
                        "registered_date": "2026-01-11"
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets.customer_id → customers"
                    ]
                }
            ],
            "wallets": [
                {
                    "key": {
                        "wallet_id": 101
                    },
                    "snapshot": {
                        "wallet_id": 101,
                        "customer_id": 1,
                        "currency": "USD",
                        "balance": 1250.5,
                        "opened_date": "2026-01-12",
                        "active": true
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets"
                    ]
                },
                {
                    "key": {
                        "wallet_id": 103
                    },
                    "snapshot": {
                        "wallet_id": 103,
                        "customer_id": 2,
                        "currency": "USD",
                        "balance": 950.75,
                        "opened_date": "2026-01-14",
                        "active": true
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "remittance_authorized",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "remittances",
            "key": {
                "remittance_id": 201
            },
            "snapshot": {
                "remittance_id": 201,
                "external_reference": "REM-2026-0001",
                "sender_wallet_id": 101,
                "recipient_wallet_id": 103,
                "amount": 125.25,
                "currency": "USD",
                "status": "settled",
                "initiated_at": "2026-02-01T10:15:00Z",
                "settled_at": "2026-02-01T10:20:00Z"
            }
        },
        "embedded": {
            "customers": [
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "full_name": "Maya Chen",
                        "email": "maya.chen@example.test",
                        "registered_date": "2026-01-10"
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets.customer_id → customers"
                    ]
                },
                {
                    "key": {
                        "customer_id": 2
                    },
                    "snapshot": {
                        "customer_id": 2,
                        "full_name": "Owen Patel",
                        "email": "owen.patel@example.test",
                        "registered_date": "2026-01-11"
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets.customer_id → customers"
                    ]
                }
            ],
            "wallets": [
                {
                    "key": {
                        "wallet_id": 101
                    },
                    "snapshot": {
                        "wallet_id": 101,
                        "customer_id": 1,
                        "currency": "USD",
                        "balance": 1250.5,
                        "opened_date": "2026-01-12",
                        "active": true
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets"
                    ]
                },
                {
                    "key": {
                        "wallet_id": 103
                    },
                    "snapshot": {
                        "wallet_id": 103,
                        "customer_id": 2,
                        "currency": "USD",
                        "balance": 950.75,
                        "opened_date": "2026-01-14",
                        "active": true
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "failure_reason": "illustrative failure_reason",
                "compliance_metadata": "illustrative compliance_metadata",
                "provider_reference": "illustrative provider_reference",
                "exchange_rate": "illustrative exchange_rate"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "remittance_initiated",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "remittances",
            "key": {
                "remittance_id": 202
            },
            "snapshot": {
                "remittance_id": 202,
                "external_reference": "REM-2026-0002",
                "sender_wallet_id": 103,
                "recipient_wallet_id": 101,
                "amount": 75,
                "currency": "USD",
                "status": "pending",
                "initiated_at": "2026-02-02T09:00:00Z",
                "settled_at": null
            }
        },
        "embedded": {
            "customers": [
                {
                    "key": {
                        "customer_id": 2
                    },
                    "snapshot": {
                        "customer_id": 2,
                        "full_name": "Owen Patel",
                        "email": "owen.patel@example.test",
                        "registered_date": "2026-01-11"
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets.customer_id → customers"
                    ]
                },
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "full_name": "Maya Chen",
                        "email": "maya.chen@example.test",
                        "registered_date": "2026-01-10"
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets.customer_id → customers"
                    ]
                }
            ],
            "wallets": [
                {
                    "key": {
                        "wallet_id": 103
                    },
                    "snapshot": {
                        "wallet_id": 103,
                        "customer_id": 2,
                        "currency": "USD",
                        "balance": 950.75,
                        "opened_date": "2026-01-14",
                        "active": true
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets"
                    ]
                },
                {
                    "key": {
                        "wallet_id": 101
                    },
                    "snapshot": {
                        "wallet_id": 101,
                        "customer_id": 1,
                        "currency": "USD",
                        "balance": 1250.5,
                        "opened_date": "2026-01-12",
                        "active": true
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "remittance_authorized",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "remittances",
            "key": {
                "remittance_id": 202
            },
            "snapshot": {
                "remittance_id": 202,
                "external_reference": "REM-2026-0002",
                "sender_wallet_id": 103,
                "recipient_wallet_id": 101,
                "amount": 75,
                "currency": "USD",
                "status": "pending",
                "initiated_at": "2026-02-02T09:00:00Z",
                "settled_at": null
            }
        },
        "embedded": {
            "customers": [
                {
                    "key": {
                        "customer_id": 2
                    },
                    "snapshot": {
                        "customer_id": 2,
                        "full_name": "Owen Patel",
                        "email": "owen.patel@example.test",
                        "registered_date": "2026-01-11"
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets.customer_id → customers"
                    ]
                },
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "full_name": "Maya Chen",
                        "email": "maya.chen@example.test",
                        "registered_date": "2026-01-10"
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets.customer_id → customers"
                    ]
                }
            ],
            "wallets": [
                {
                    "key": {
                        "wallet_id": 103
                    },
                    "snapshot": {
                        "wallet_id": 103,
                        "customer_id": 2,
                        "currency": "USD",
                        "balance": 950.75,
                        "opened_date": "2026-01-14",
                        "active": true
                    },
                    "via": [
                        "remittances.sender_wallet_id → wallets"
                    ]
                },
                {
                    "key": {
                        "wallet_id": 101
                    },
                    "snapshot": {
                        "wallet_id": 101,
                        "customer_id": 1,
                        "currency": "USD",
                        "balance": 1250.5,
                        "opened_date": "2026-01-12",
                        "active": true
                    },
                    "via": [
                        "remittances.recipient_wallet_id → wallets"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "failure_reason": "illustrative failure_reason",
                "compliance_metadata": "illustrative compliance_metadata",
                "provider_reference": "illustrative provider_reference",
                "exchange_rate": "illustrative exchange_rate"
            }
        }
    }
]));
  await db.getCollection("remittance_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("remittance_events").find({"eventType":"remittance_initiated"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("remittance_events").find({"source.key.remittance_id":201}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("remittance_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("remittance_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("remittance_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "remittance_initiated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "remittances",
        "key": {
            "remittance_id": 201
        },
        "snapshot": {
            "remittance_id": 201,
            "external_reference": "REM-2026-0001",
            "sender_wallet_id": 101,
            "recipient_wallet_id": 103,
            "amount": 125.25,
            "currency": "USD",
            "status": "settled",
            "initiated_at": "2026-02-01T10:15:00Z",
            "settled_at": "2026-02-01T10:20:00Z"
        }
    },
    "embedded": {
        "customers": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "full_name": "Maya Chen",
                    "email": "maya.chen@example.test",
                    "registered_date": "2026-01-10"
                },
                "via": [
                    "remittances.sender_wallet_id → wallets.customer_id → customers"
                ]
            },
            {
                "key": {
                    "customer_id": 2
                },
                "snapshot": {
                    "customer_id": 2,
                    "full_name": "Owen Patel",
                    "email": "owen.patel@example.test",
                    "registered_date": "2026-01-11"
                },
                "via": [
                    "remittances.recipient_wallet_id → wallets.customer_id → customers"
                ]
            }
        ],
        "wallets": [
            {
                "key": {
                    "wallet_id": 101
                },
                "snapshot": {
                    "wallet_id": 101,
                    "customer_id": 1,
                    "currency": "USD",
                    "balance": 1250.5,
                    "opened_date": "2026-01-12",
                    "active": true
                },
                "via": [
                    "remittances.sender_wallet_id → wallets"
                ]
            },
            {
                "key": {
                    "wallet_id": 103
                },
                "snapshot": {
                    "wallet_id": 103,
                    "customer_id": 2,
                    "currency": "USD",
                    "balance": 950.75,
                    "opened_date": "2026-01-14",
                    "active": true
                },
                "via": [
                    "remittances.recipient_wallet_id → wallets"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("remittance_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "remittance_initiated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "remittances",
        "key": {
            "remittance_id": 201
        },
        "snapshot": {
            "remittance_id": 201,
            "external_reference": "REM-2026-0001",
            "sender_wallet_id": 101,
            "recipient_wallet_id": 103,
            "amount": 125.25,
            "currency": "USD",
            "status": "settled",
            "initiated_at": "2026-02-01T10:15:00Z",
            "settled_at": "2026-02-01T10:20:00Z"
        }
    },
    "embedded": {
        "customers": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "full_name": "Maya Chen",
                    "email": "maya.chen@example.test",
                    "registered_date": "2026-01-10"
                },
                "via": [
                    "remittances.sender_wallet_id → wallets.customer_id → customers"
                ]
            },
            {
                "key": {
                    "customer_id": 2
                },
                "snapshot": {
                    "customer_id": 2,
                    "full_name": "Owen Patel",
                    "email": "owen.patel@example.test",
                    "registered_date": "2026-01-11"
                },
                "via": [
                    "remittances.recipient_wallet_id → wallets.customer_id → customers"
                ]
            }
        ],
        "wallets": [
            {
                "key": {
                    "wallet_id": 101
                },
                "snapshot": {
                    "wallet_id": 101,
                    "customer_id": 1,
                    "currency": "USD",
                    "balance": 1250.5,
                    "opened_date": "2026-01-12",
                    "active": true
                },
                "via": [
                    "remittances.sender_wallet_id → wallets"
                ]
            },
            {
                "key": {
                    "wallet_id": 103
                },
                "snapshot": {
                    "wallet_id": 103,
                    "customer_id": 2,
                    "currency": "USD",
                    "balance": 950.75,
                    "opened_date": "2026-01-14",
                    "active": true
                },
                "via": [
                    "remittances.recipient_wallet_id → wallets"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("remittance_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
