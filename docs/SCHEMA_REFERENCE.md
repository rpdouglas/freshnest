# 🗄️ Firestore Schema Reference

## `organizations/{orgId}`
* **name** (string): Display name.
* **settings** (map): `{ currency, geoFenceRadius }`.
* **plan** (string): Subscription tier.

## `users/{userId}`
* **email** (string)
* **fullName** (string)
* **orgId** (string): **CRITICAL**. Links user to tenant.
* **role** (string): `'admin'` | `'staff'`.

## `clients/{clientId}`
* **orgId** (string)
* **name** (string)
* **email** (string)
* **phone** (string)
* **address** (string): Text address.
* **coordinates** (map): `{ lat: number, lng: number }`. Used for Maps.

## `jobs/{jobId}`
* **orgId** (string)
* **clientId** (string): Ref to `clients`.
* **assignedTo** (array): List of `userId` strings.
* **status** (string): `'scheduled'` | `'in_progress'` | `'completed'` | `'cancelled'`.
* **serviceType** (string): `'standard'` | `'deep'` | etc.
* **price** (number): Estimated cost.
* **scheduledDate** (timestamp): When the job is.
* **startedAt** (timestamp): When status changed to in_progress.
* **completedAt** (timestamp): When status changed to completed.
* **invoiceNumber** (string): Generated ID (e.g., "2026-4821").
* **invoicedAt** (timestamp): When PDF was generated.

