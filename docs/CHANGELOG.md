# 📜 Changelog

## [v0.6.0] - 2026-01-14
### Added
* **Revenue Dashboard:** Admin view with Total Revenue, Jobs Completed, and Avg Ticket KPIs.
* **Visualizations:** Monthly Revenue Bar Chart using `recharts` with horizontal scrolling for mobile.
* **Staff Dashboard:** Restricted view showing only assigned upcoming jobs.
* **Security:** Implemented Client-Side role checks to prevent data leaks.

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices to bypass PDF iframe limitations.
* **UI:** Added "Generate Invoice" button to Mobile Job Card.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation using `@react-pdf/renderer`.
* **Tracking:** `invoicedAt` and `invoiceNumber` fields added to Job Schema.
