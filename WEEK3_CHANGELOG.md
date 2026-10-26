# 📋 Week 3 Deliverable: Documentation & Changelog

**Project:** Ed Tech Mobile App  
**Organization / Program:** Excelerate Mobile App Development Remote Internship (Cohort 0510)  
**Team:** Team 6  
**Lead:** Irtaza Ahmad (`irtazaad328@gmail.com`)  
**Repository:** [https://github.com/irtazaad328/ED-TECH_App](https://github.com/irtazaad328/ED-TECH_App)  
**Deliverable Status:** 100% Completed  

---

## 🎯 Executive Summary
For Week 3, the primary objective was transforming the static UI prototype developed in Week 2 into an **API/JSON-connected, interactive, and robustly validated functional application**.

Team 6 successfully implemented:
1. Dynamic data loading from mock JSON files with asynchronous decoding and model mapping.
2. Cross-screen dynamic argument passing (from catalog listing to deep details).
3. Production-grade form validation across multiple workflows (Learner Registration, Teacher Registration, Checkout & Payment).
4. Full loading indicator states (`CircularProgressIndicator`) and error handling (`Try Again` retries and user feedback Snackbars).
5. Comprehensive widget test suites verifying validation, dynamic calculations, and asynchronous states.

---

## 1. 🌐 Screens Fetching Data from JSON / API

### A. Programs Listing Screen (`lib/screens/learner/programs_list_screen.dart`)
- **Data Source:** `assets/data/programs.json` (Structured catalog containing course metadata, instructor info, ratings, enrollments, pricing, and curriculum checklists).
- **Implementation:**
  - Uses `rootBundle.loadString('assets/data/programs.json')` and `json.decode()` mapped via `Program.fromJson()`.
  - Asynchronous handling via Flutter's `FutureBuilder<List<Program>>`.
  - Dynamic category filtering (`Mobile Dev`, `Artificial Intelligence`, `UI/UX Design`, `Cloud Computing`).
  - Real-time client-side search query filtering across course titles, categories, and mentor names.

### B. Program Details Screen (`lib/screens/learner/program_details_screen.dart`)
- **Data Source:** Dynamically passed `Program` model object from `ProgramsListScreen` via Flutter navigation route arguments (`ModalRoute.of(context)?.settings.arguments`).
- **Implementation:**
  - Unpacks the selected program dynamically.
  - Renders mentor profile, course title, category pill badge, dynamic pricing, and dynamic rating.
  - Renders dynamic curriculum items from `whatIsIncluded` string array.
  - Sticky bottom navigation bar with live price and direct "Add to Cart" action.

### C. Cart & Enrollment Management Pipeline (`lib/screens/teacher/cart_management_screen.dart`)
- **Data Source:** Simulated backend instructor API dataset tracking active enrollments and pending cart abandonments.
- **Implementation:**
  - Live filtering by status tabs: `All`, `Paid`, `In Cart`.
  - Real-time search query filtering student names and emails.
  - Interactive reminder state machine: triggers payment reminder email feedback and toggles button to `'Reminder Sent'` with visual confirmation.

---

## 2. 📝 Forms Added & How They Work

### A. Learner Authentication & Registration Forms (`login_screen.dart` & `signup_screen.dart`)
- **Form Architecture:** Built using Flutter's native `Form` and `TextFormField` widgets connected via `GlobalKey<FormState>`.
- **Validation Rules:**
  - **Email:** Mandatory non-empty check + strict regex pattern verification (`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`).
  - **Password:** Minimum 6-character length enforcement, non-empty validation, and obscure-text toggle.
  - **Password Confirmation:** Verifies that both password and confirm-password fields match.
  - **Terms & Conditions:** Checkbox validator requiring explicit agreement prior to registration.

### B. Teacher Authentication Forms (`teacher_login_screen.dart` & `teacher_signup_screen.dart`)
- **Validation Rules:** Standardized through modular `AuthValidators` utility (`auth_validators.dart`).
- **Functionality:** Real-time feedback snackbars and inline form field validation preventing submission of malformed inputs.

### C. Multi-Method Payment & Checkout Form (`payment_screen.dart`)
- **Form Architecture:** Features distinct form states for Credit/Debit Card, Bank Transfer, and Mobile Wallet.
- **Validation Rules:**
  - **Card Number:** Strips whitespace and enforces exactly 16 digits (`^\d{16}$`).
  - **Expiry Date:** Enforces valid MM/YY format (`^(0[1-9]|1[0-2])\/([0-9]{2})$`).
  - **CVV / CVC:** Enforces 3 to 4 numeric digits (`^\d{3,4}$`).
  - **Mobile Wallet Number:** Enforces 11-digit mobile phone format (`^03\d{9}$`).

---

## 3. ⏳ Loading Indicators & Error Handling Features

### A. Asynchronous JSON Loading & Retry Mechanism
- **Loading State:** `FutureBuilder` displays a centered `CircularProgressIndicator` styled in `AppTheme.primary` while assets are loaded.
- **Error State:** If JSON parsing fails or the asset is missing, an error view renders with a clear error prompt and a functional **"Try Again"** button that restarts the loading future.
- **Empty State:** If search or filter returns zero matches, a dedicated illustration and helpful clear-filter action are displayed.

### B. Form Submission Loading Spinners
- Both Login/Signup and Checkout forms incorporate an `_isLoading` / `_isProcessing` boolean state.
- While the async submission simulates network processing:
  - Input fields and buttons are disabled to prevent duplicate submissions.
  - Primary button content switches smoothly to a lightweight `CircularProgressIndicator` (white color).

### C. Feedback & Error Snackbars
- Unsuccessful inputs trigger localized red-tinted SnackBar notifications explaining the exact error (e.g., mismatched passwords or unaccepted terms).
- Successful operations display floating confirmation Snackbars (e.g., bookmark toggled, sharing link copied, payment reminder sent).

---

## 4. 🧪 Automated Test Verification

Team 6 implemented automated widget test suites covering all Week 3 requirements:

| Test File | Description | Results |
|---|---|:---:|
| `test/auth_validation_test.dart` | Learner Login & Signup validation, regex, & loading state | ✅ 5/5 Passed |
| `test/teacher_auth_test.dart` | Teacher Login & Signup validation & loading state | ✅ 5/5 Passed |
| `test/payment_validation_test.dart` | Card, Bank, & Wallet payment form validations | ✅ 4/4 Passed |
| `test/cart_management_test.dart` | Cart management filter tabs, search, & reminder actions | ✅ 4/4 Passed |
| `test/learner_cart_test.dart` | Dynamic price calculation, item deletion, & empty state | ✅ 3/3 Passed |
| `test/program_details_test.dart` | Dynamic program model rendering, bookmarks, & actions | ✅ 4/4 Passed |
| **Total** | **All Week 3 Automated Tests** | **✅ 25/25 Passed (100%)** |
