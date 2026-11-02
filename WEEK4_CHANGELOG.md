# 🎓 Week 4 Final Deliverable: Documentation & Changelog

**Project:** Ed Tech Mobile App  
**Organization / Program:** Excelerate Mobile App Development Remote Internship (Cohort 0510)  
**Team:** Team 6  
**Lead:** Irtaza Ahmad (`irtazaad328@gmail.com`)  
**Repository:** [https://github.com/irtazaad328/ED-TECH_App](https://github.com/irtazaad328/ED-TECH_App)  
**Deliverable Status:** 100% Completed (Graduation Release)  

---

## 🎯 Executive Summary
Week 4 represents the final graduation milestone for the Excelerate Mobile App Development Internship. The goal was to deliver a complete, cohesive, production-grade Flutter application combining all learner and teacher journeys with full data integration, validated interactive forms, user profile management, promo code calculation, dynamic enrollment synchronization, and comprehensive automated test coverage.

Team 6 has successfully integrated and polished:
1. **Dynamic Cart & Enrollment Synchronization:** Seamless cross-screen persistence per learner using `EnrollmentService`.
2. **Program Details & Syllabus Accordion:** Enrolled badge state, expandable syllabus modules, and lesson locking.
3. **Interactive Course Feedback Form:** 5-star interactive rating, feedback categories, character length validation, loading state, and confirmation dialogs.
4. **User Profile & Settings:** Profile customization dialog, dark theme toggle, notifications switch, dynamic enrolled count, and secure logout.
5. **Promo Coupon & Payment Receipt:** Validated `EXCELERATE10` discount code (10% off), dynamic subtotal/total calculations, and detailed payment receipt dialog.
6. **Teacher Analytics Dashboard:** Enhanced KPI metric cards and enrollment progress bars.
7. **Comprehensive Test Suite:** 100% pass rate across 55 test cases in 12 test files.

---

## 1. 📱 Key Screens & New Features Added in Week 4

### A. Course Feedback & Rating Form (`lib/screens/learner/feedback_screen.dart`) — Fatima Zahid
- **Purpose:** Enables enrolled students to submit qualitative and quantitative course feedback.
- **Features:**
  - Dynamic course selection or pre-populated course title.
  - Interactive 5-star rating widget with real-time score display (1 to 5 Stars).
  - Feedback category dropdown (`Course Content`, `Instructor Quality`, `Platform & UI`, `Assignments & Exercises`, `Other`).
  - Multi-line feedback input with strict validation (minimum 10 characters required).
  - Submission loading state with `CircularProgressIndicator`.
  - Professional "Thank You" confirmation dialog with rating and feedback summary.
- **Tests:** `test/feedback_form_test.dart` (3 tests verifying rendering, input validation, and successful submission).

### B. User Profile & Settings Screen (`lib/screens/common/profile_settings_screen.dart`) — Aishika Pal
- **Purpose:** Gives learners and instructors central management of their account settings, preferences, and personal statistics.
- **Features:**
  - Dynamic user profile data (`UserProfile` model) displaying avatar initials, name, email, and role badge.
  - Real-time enrolled course count badge bound to `EnrollmentService`.
  - Preferences section with working switches for **Dark Theme** and **Push Notifications**.
  - Interactive "Edit Profile" dialog allowing in-place name and email updates.
  - Logout confirmation dialog with secure session exit back to Role Selection.
- **Tests:** `test/profile_settings_screen_test.dart` (6 tests verifying rendering, edit dialog, toggles, and logout flow).

### C. Dynamic Cart with Promo Code & Receipt (`lib/screens/learner/cart_screen.dart`) — Mannu
- **Purpose:** Manages learner checkout pipeline with promotional discount capability and receipt verification.
- **Features:**
  - Bound to `EnrollmentService.instance.cart` for real-time per-user cart management.
  - Interactive coupon input row supporting `EXCELERATE10` (10% discount).
  - Dynamic real-time calculation of Subtotal, Promo Discount, and Total.
  - Instant removal of cart items with automatic total recomputation.
  - Integrated Payment Receipt dialog reflecting the exact discounted amount.
- **Tests:** `test/cart_receipt_test.dart` & `test/learner_cart_test.dart` (9 tests verifying discount calculation, empty states, and receipt figures).

### D. Program Details & Syllabus Accordion (`lib/screens/learner/program_details_screen.dart`) — Idiris Hassan
- **Purpose:** Deep dive course screen with curriculum transparency and enrollment awareness.
- **Features:**
  - Conditional header badge (`Enrolled` vs `Not Enrolled`) dynamically checking learner enrollment status.
  - Expandable Syllabus accordion with collapsible modules, lesson counts, durations, and preview locks.
  - Sticky bottom action bar adapting between "Add to Cart" and "Already Enrolled / Go to Course".
- **Tests:** `test/program_details_test.dart` (5 tests verifying syllabus parsing, expansion, and enrollment states).

### E. Teacher Dashboard Analytics (`lib/screens/teacher/teacher_dashboard_screen.dart`) — Jennifer Shantal
- **Purpose:** Instructor intelligence hub providing high-level operational metrics.
- **Features:**
  - Summary KPI cards: Total Programs, Active Learners, Completion Rate, and Net Revenue.
  - Course enrollment progress bars visualizing capacity utilization.
  - One-tap navigation to Cart & Enrollment Management pipeline.
- **Tests:** `test/teacher_dashboard_test.dart` (4 tests verifying KPI rendering, progress indicators, and navigation).

---

## 2. 🧩 State Architecture & Data Integration

### Unified Enrollment Service (`lib/services/enrollment_service.dart`)
- Implements a reactive singleton (`EnrollmentService.instance`) managing:
  - User session identity (`currentUser`).
  - Active cart items per user (`ValueNotifier<List<Program>>`).
  - Confirmed enrolled programs per user (`ValueNotifier<List<Program>>`).
- Prevents cross-account data leakage by isolating student carts upon login/logout.
- Automatically syncs UI components across `HomeScreen`, `ProgramsListScreen`, `ProgramDetailsScreen`, and `CartScreen`.

---

## 3. 🧪 Quality Assurance & Test Verification

The application maintains a **100% test pass rate** with 55 tests passing across 12 test suites:

| Test Suite File | Feature Area | Tests Passed |
|---|---|:---:|
| `test/auth_validation_test.dart` | Learner Login/Signup Validation & Spinners | 7 / 7 |
| `test/teacher_auth_test.dart` | Teacher Authentication & Form Rules | 8 / 8 |
| `test/payment_validation_test.dart` | Card, Expiry, CVV & Wallet Validation | 11 / 11 |
| `test/cart_receipt_test.dart` | Promo Coupon & Discounted Receipt Verification | 4 / 4 |
| `test/learner_cart_test.dart` | Dynamic Cart Operations & Pricing Calculation | 5 / 5 |
| `test/cart_management_test.dart` | Teacher Pipeline, Search & Payment Reminders | 4 / 4 |
| `test/program_details_test.dart` | Syllabus Accordion & Enrollment Status | 5 / 5 |
| `test/profile_settings_screen_test.dart` | Profile Dialog, Toggles & Logout Confirmation | 6 / 6 |
| `test/feedback_form_test.dart` | 5-Star Rating, Validation & Submission Dialog | 3 / 3 |
| `test/teacher_dashboard_test.dart` | Teacher Analytics KPIs & Navigation | 4 / 4 |
| `test/home_my_programs_test.dart` | My Programs Section Visibility | 1 / 1 |
| `test/widget_test.dart` | App Boot & Welcome Screen Rendering | 1 / 1 |
| **Total** | **Full Application Test Coverage** | **55 / 55 (100%)** |

All tests pass cleanly via:
```bash
flutter test
```

---

## 4. 👥 Team 6 Contributions Matrix

| Member | Assigned Week 4 Module | Files Contributed / Polished | Status |
|---|---|---|:---:|
| **Irtaza Ahmad** | Team Lead, Code Review, Conflict Resolution, Release Management, Architecture | `main.dart`, `app_routes.dart`, `README.md`, `WEEK4_CHANGELOG.md` | ✅ Merged & Verified |
| **Idiris Hassan** | Syllabus Accordion, Enrolled Badging, Dynamic Cart State | `program_details_screen.dart`, `enrollment_service.dart` | ✅ Merged & Verified |
| **Fatima Zahid** | Interactive Course Feedback & Rating Form, Input Validation | `feedback_screen.dart`, `feedback_form_test.dart` | ✅ Merged & Verified |
| **Aishika Pal** | User Profile & Settings Screen, Dark Theme & Preferences | `profile_settings_screen.dart`, `user_profile.dart`, `profile_settings_screen_test.dart` | ✅ Merged & Verified |
| **Mannu** | Promotional Coupon Validation (`EXCELERATE10`), Discount Calculations, Receipt Audit | `cart_screen.dart`, `cart_receipt_test.dart`, `learner_cart_test.dart` | ✅ Merged & Verified |
| **Jennifer Shantal** | Teacher Dashboard Analytics & KPI Visualizations | `teacher_dashboard_screen.dart`, `teacher_dashboard_test.dart` | ✅ Merged & Verified |
| **Sameer Rizwan** | Program Details Architecture & Catalog Data Model | `program_model.dart`, `programs.json` | ✅ Complete |
| **Akshata** | Payment Gateway & Form Validation | `payment_screen.dart`, `payment_validation_test.dart` | ✅ Complete |
| **Abdul Kadir** | Cart Management Pipeline & Search Filters | `cart_management_screen.dart`, `cart_management_test.dart` | ✅ Complete |
