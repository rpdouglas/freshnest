# 🛡️ Role-Based Access Control (RBAC) Matrix

**Roles:** `admin` (Owner), `staff` (Worker)
**Enforcement:** 1. **Frontend:** UI Hiding via `useJobWorkflow` / `userRole`.
2. **Backend:** Firestore Security Rules (checks `resource.data.orgId`).

| Feature | Action | Admin | Staff | Notes |
| :--- | :--- | :---: | :---: | :--- |
| **Clients** | View List | ✅ | ✅ | Staff see all clients in Org. |
| | Create/Edit | ✅ | ❌ | |
| **Jobs** | View List | ✅ | ⚠️ | Staff only see *assigned* jobs. |
| | Create Job | ✅ | ❌ | |
| | Edit Details | ✅ | ❌ | Price, Notes, Service Type. |
| | Start Job | ✅ | ✅ | Only if assigned (Staff). |
| | Complete Job | ✅ | ✅ | Only if assigned (Staff). |
| | Cancel Job | ✅ | ❌ | |
| | Delete Job | ✅ | ❌ | |
| **Invoicing** | Generate | ✅ | ❌ | |
| | Mark Paid | ✅ | ❌ | |
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |

