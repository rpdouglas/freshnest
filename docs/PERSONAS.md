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

