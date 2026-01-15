#!/bin/bash

echo "👥 Injecting Persona-Based Documentation..."

# 1. Create PERSONAS.md (The Source of Truth for Human Constraints)
echo "📝 Creating docs/PERSONAS.md..."
cat << 'INNER_EOF' > docs/PERSONAS.md
# 👥 Fresh Nest Personas (Technical Constraints)

These are not just user stories. These are **System Constraints**. Every feature must be validated against these realities.

## 1. Carla - The "Financial Anchor" (ODSP)
* **Context:** Single mother, relies on Ontario Disability Support Program (ODSP).
* **Hard Constraint:** **Earnings Cap.** She *cannot* earn more than her allowable limit (e.g., $1,000/mo) without triggering a clawback mechanism that destabilizes her housing.
* **Tech Requirement:** * `user.financials.limit`: Hard integer limit.
    * **Pre-Claim Check:** System must block a shift claim if `(currentMonthEarnings + shiftPrice) > limit`.
    * **Visuals:** "Safe to Earn" progress bar.

## 2. Jasmine - The "Transit Rider"
* **Context:** No vehicle. Relies on Cornwall Transit.
* **Hard Constraint:** **Travel Time Buffers.** She cannot teleport. A 1:00 PM job across town after a 12:00 PM job is physically impossible.
* **Tech Requirement:**
    * `user.constraints.transport`: 'transit'.
    * **Conflict Engine:** Auto-calculate travel time via Google Maps Transit API (future) or enforce 60-min buffers between sites.

## 3. Mike - The "Recovery Worker"
* **Context:** Re-entering workforce. Attends mandatory support meetings (e.g., AA) every Tuesday at 7 PM.
* **Hard Constraint:** **Blocked Windows.**
* **Tech Requirement:**
    * `user.constraints.blockedWindows`: Array of recurring time slots.
    * **Visibility Filter:** Shifts overlapping these windows must be strictly hidden from his view.

## 4. Ahmed - The "Newcomer" (ESL)
* **Context:** Recent immigrant. High work ethic, low English literacy.
* **Hard Constraint:** **Cognitive Load.** Text-heavy instructions result in errors.
* **Tech Requirement:**
    * **Icon-First UI:** Tasks must use visual icons (Mop, Key, Trash).
    * **Language Toggle:** One-tap switch between English/French/Arabic.

## 5. Brenda - The "Visual Verifier"
* **Context:** Detail-oriented, anxious about "he said/she said" disputes.
* **Hard Constraint:** **Trust.** Needs proof she did the job right.
* **Tech Requirement:**
    * **Photo Uploads:** Mandatory "Before" and "After" photos for specific high-value items (e.g., Stove).
    * **Metadata:** Photos must be timestamped and geo-tagged.

## 6. Sarah - The "Owner" (Compliance)
* **Context:** Business owner. Terrified of labor board audits and liability.
* **Hard Constraint:** **Audit Trail.**
* **Tech Requirement:**
    * **Version Control:** `acceptedTermsVersion` stored on every user profile.
    * **Rate Snapshots:** Every shift record must freeze the pay rate at the time of claim.

INNER_EOF

# 2. Update CONTEXT_DUMP to reference Personas
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Location:** Cornwall, Ontario, Canada
**Mission:** Worker Support Platform (Safety First).

## 🧠 The "Prime Directive"
We build for **Personas**, not just Users. 
* Before building a feature, check **`docs/PERSONAS.md`**.
* **Safety > Efficiency.** It is better to block a shift claim than to let Carla lose her benefits.

## Documentation References
* **Personas:** See `docs/PERSONAS.md` (CRITICAL)
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security:** See `docs/RBAC_MATRIX.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Complete files only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security:** Use Profile-based RBAC (`users/{uid}`).
5. **Logic:** Client-side aggregation for Dashboards is acceptable for MVP.
INNER_EOF

# 3. Update SCHEMA_REFERENCE to match Master Plan 9
echo "📝 Updating docs/SCHEMA_REFERENCE.md..."
cat << 'INNER_EOF' > docs/SCHEMA_REFERENCE.md
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

INNER_EOF

echo "✅ Persona System Injected into Documentation."
