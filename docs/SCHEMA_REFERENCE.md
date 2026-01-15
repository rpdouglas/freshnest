# 🗄️ Firestore Schema & Business Logic

## `users/{userId}`
* **profile** (map):
  * `name` (string)
  * `language` (string): 'en', 'fr', etc. (For Ahmed)
  * `transport` (string): 'transit' | 'vehicle' (For Jasmine)
  * `acceptedTermsVersion` (string): e.g., "v1.0_2025" (For Sarah)
* **financials** (map):
  * `mode`: 'cap' | 'unlimited'
  * `limit` (number): Monthly hard cap (For Carla)
  * `currentMonthAccrued` (number): Real-time counter.
* **constraints** (map):
  * `blockedWindows` (array): Time slots (For Mike)
  * `heavyLifting` (boolean)
* **role** (string): 'admin' | 'staff' | 'care_coordinator'
* **orgId** (string)

## `jobs/{jobId}` (aka Shifts)
* **status**: 'open' | 'claimed' | 'completed' | 'cancelled'
* **contractLedger** (map): (Financial Audit Trail)
  * `claimedBy`: userId
  * `claimedAt`: timestamp
  * `rateSnapshot`: number (Hourly/Fixed rate at time of claim)
* **requirements** (map):
  * `photos`: array of URLs (For Brenda)
* **time**:
  * `start`: timestamp
  * `end`: timestamp
* **location**:
  * `address`: string
  * `coordinates`: { lat, lng }

## `clients/{clientId}`
* **Standard fields**: name, address, etc.

