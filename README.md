<h1 align="center">📚 Ed Tech</h1>

<p align="center">
  <b>One app where learners find programs and teachers manage them.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" alt="Figma">
  <img src="https://img.shields.io/badge/Team-6-25307C?style=for-the-badge" alt="Team 6">
  <img src="https://img.shields.io/badge/Status-Week%202%20Done-2ea44f?style=for-the-badge" alt="Status">
</p>

<p align="center">
  <a href="https://www.figma.com/design/QWMnhOtY99AqOI90lf4yMk/Team-6-Wireframes?node-id=0-1&t=R7Ajb2Jlw7v95zlR-1"><b>🎨 View Wireframes on Figma</b></a> •
  <a href="docs/ED_TECH_Team6_Week2_Deliverable_Report.pdf"><b>📄 Week 2 Deliverable PDF Report</b></a>
</p>

---

## 📖 About
**Ed Tech** is a mobile app built with Flutter where people who want to learn and people who want to teach can find each other. Teachers put their programs on the app. Learners browse them, pick one, pay for it and start learning, all from their phone.

This is the **Team 6** project for the **Excelerate Mobile App Development Remote Internship (Cohort 0510)**.

---

## 🚀 Week 2 Deliverable: Working UI Prototype (All 13 Screens)
For Week 2, our objective was to translate Week 1 wireframes into an interactive, functional Flutter UI prototype. While the minimum requirement was **4 core screens**, Team 6 has completed and integrated **all 13 interactive screens**!

### 🌟 Core 4 Mandatory Screens
1. **Login Screen (`lib/screens/common/login_screen.dart`):** Multi-role authentication (Learner/Teacher), email regex validation, password length check, show/hide password toggle, and navigation to Signup and Home.
2. **Home Screen (`lib/screens/learner/home_screen.dart`):** Personalized learner greeting, notifications badge, announcements carousel, active course progress bar, featured programs, and bottom navigation.
3. **Programs Listing Screen (`lib/screens/learner/programs_list_screen.dart`):** Mock JSON data loading (`assets/data/programs.json`), live search filter across titles, teachers, and topics, category filter chips (Mobile Dev, AI, UI/UX, Cloud), and interactive bookmark toggle.
4. **Program Details Screen (`lib/screens/learner/program_details_screen.dart`):** Dynamic argument reception (`Program` model passed from listing), category banner badge, syllabus details, "What's Included" checklist, share link, bookmark toggle, and sticky "Add to Cart" checkout footer.

---

### 📋 Full 13-Screen Implementation Matrix

| # | Screen Name | Assigned Developer | File Path | Status |
|---|---|---|---|:---:|
| 1 | **Role Selection (Learner)** | Irtaza Ahmad (Lead) | `flutterdemo/lib/screens/common/role_selection_screen.dart` | ✅ Complete |
| 2 | **Learner Login** | Fatima Zahid | `flutterdemo/lib/screens/common/login_screen.dart` | ✅ Complete |
| 3 | **Learner Signup** | Fatima Zahid | `flutterdemo/lib/screens/common/signup_screen.dart` | ✅ Complete |
| 4 | **Learner Home Portal** | Irtaza Ahmad (Lead) | `flutterdemo/lib/screens/learner/home_screen.dart` | ✅ Complete |
| 5 | **Programs Listing** | Idiris Hassan | `flutterdemo/lib/screens/learner/programs_list_screen.dart` | ✅ Complete |
| 6 | **Program Details (Dynamic)** | Sameer Rizwan | `flutterdemo/lib/screens/learner/program_details_screen.dart` | ✅ Complete |
| 7 | **My Cart** | Mannu | `flutterdemo/lib/screens/learner/cart_screen.dart` | ✅ Complete |
| 8 | **Payment & Checkout** | Akshata | `flutterdemo/lib/screens/learner/payment_screen.dart` | ✅ Complete |
| 9 | **Role Selection (Teacher)** | Irtaza Ahmad (Lead) | `flutterdemo/lib/screens/common/role_selection_screen.dart` | ✅ Complete |
| 10 | **Teacher Login** | Aishika Pal | `flutterdemo/lib/screens/teacher/teacher_login_screen.dart` | ✅ Complete |
| 11 | **Teacher Signup** | Aishika Pal | `flutterdemo/lib/screens/teacher/teacher_signup_screen.dart` | ✅ Complete |
| 12 | **Teacher Dashboard** | Jennifer Shantal | `flutterdemo/lib/screens/teacher/teacher_dashboard_screen.dart` | ✅ Complete |
| 13 | **Cart Management (Admin)** | Abdul Kadir Choudhury | `flutterdemo/lib/screens/teacher/cart_management_screen.dart` | ✅ Complete |

---

## 🧭 Navigation Flow

```
Welcome Screen (/)
      │
      ▼
Role Selection (/role_selection)
      │
      ├──────────────────────────────────────────────┐
      │ (Student Flow)                               │ (Teacher Flow)
      ▼                                              ▼
Learner Login / Signup                        Teacher Login / Signup
      │                                              │
      ▼                                              ▼
Learner Home Portal (/learner_home)           Teacher Dashboard (/teacher_dashboard)
      │                                              │
      ▼                                              ▼
Programs List (/programs_list)                Cart Management (/cart_management)
      │
      ▼
Program Details (/program_details)
      │
      ▼
My Cart (/cart)
      │
      ▼
Payment (/payment) ──► Confirmation Receipt ──► Back to Home
```

---

## 🛠️ Verification & Quality Assurance
- **Automated Tests:** `flutter test` passes 100% of widget tests.
- **Static Analysis:** `flutter analyze` passes with 0 compile errors.
- **Cross-Platform:** Verified on Chrome Web and Android mobile viewports.

---

## 🚀 Running the App Locally

```bash
# 1. Clone repository
git clone https://github.com/irtazaad328/ED-TECH_App.git

# 2. Navigate to project
cd ED-TECH_App/flutterdemo

# 3. Fetch dependencies
flutter pub get

# 4. Run on Chrome Web
flutter run -d chrome

# 5. Run on Connected Device / Emulator
flutter run
```

---

## 🤝 Team 6 Members
- **Irtaza Ahmad** (Team Lead)
- **Fatima Zahid**
- **Idiris Hassan**
- **Sameer Rizwan**
- **Mannu**
- **Akshata**
- **Aishika Pal**
- **Jennifer Shantal**
- **Abdul Kadir Choudhury**

---

## 🗺️ Roadmap
- [x] **Week 1:** Proposal, Figma wireframes, and project skeleton setup
- [x] **Week 2:** Build all 13 Flutter UI screens from wireframes, implement interactive navigation, automated tests, and deliverable report
- [ ] **Week 3:** Backend integration, state management, and real database persistence
