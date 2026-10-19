<h1 align="center">📚 Ed Tech</h1>

<p align="center">
  <b>One unified Flutter mobile application connecting learners with top programs and instructors with powerful management tools.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" alt="Figma">
  <img src="https://img.shields.io/badge/Team-6-25307C?style=for-the-badge" alt="Team 6">
  <img src="https://img.shields.io/badge/Status-Week%202%20Done-2ea44f?style=for-the-badge" alt="Status">
</p>

<p align="center">
  <a href="https://www.figma.com/design/QWMnhOtY99AqOI90lf4yMk/Team-6-Wireframes?node-id=0-1&t=R7Ajb2Jlw7v95zlR-1"><b>🎨 View Wireframes on Figma</b></a>
</p>

---

## 📖 About the Project
**Ed Tech** is a cross-platform mobile application developed with Flutter and Dart for the **Excelerate Mobile App Development Remote Internship (Cohort 0510)** by **Team 6**. 

The app bridges the gap between students seeking structured learning programs and teachers managing their courses, enrolled learners, and revenue.

---

## 📱 App in Action — UI Showcase (All Screenshots)

### 🎓 1. Learner Journey: Onboarding & Home Portal

| Role Selection | Learner Login | Learner Signup | Learner Home Portal |
|:---:|:---:|:---:|:---:|
| <img src="flutterdemo/assets/screenshots/01_role_selection.png" width="220" alt="Role Selection"> | <img src="flutterdemo/assets/screenshots/02_learner_login.png" width="220" alt="Learner Login"> | <img src="flutterdemo/assets/screenshots/03_learner_signup.png" width="220" alt="Learner Signup"> | <img src="flutterdemo/assets/screenshots/04_learner_home.png" width="220" alt="Learner Home"> |
| *Role selector (Student vs Teacher)* | *Email & password validation* | *Registration with terms check* | *Progress tracking & announcements* |

---

### 📚 2. Program Discovery, Course Details & Checkout

| Programs List | Program Details | My Cart | Checkout & Payment |
|:---:|:---:|:---:|:---:|
| <img src="flutterdemo/assets/screenshots/05_programs_list.png" width="220" alt="Programs List"> | <img src="flutterdemo/assets/screenshots/08_program_details.png" width="220" alt="Program Details"> | <img src="flutterdemo/assets/screenshots/06_cart.png" width="220" alt="My Cart"> | <img src="flutterdemo/assets/screenshots/07_payment.png" width="220" alt="Payment"> |
| *Live search & category filters* | *Dynamic course info & syllabus* | *Item removal & cost breakdown* | *Card, Bank & Mobile Wallets* |

---

### 🧑‍🏫 3. Teacher / Admin Flow: Authentication & Dashboard

| Teacher Login | Teacher Signup | Teacher Dashboard | Cart & Enrollment Pipeline |
|:---:|:---:|:---:|:---:|
| <img src="flutterdemo/assets/screenshots/09_teacher_login.png" width="220" alt="Teacher Login"> | <img src="flutterdemo/assets/screenshots/10_teacher_signup.png" width="220" alt="Teacher Signup"> | <img src="flutterdemo/assets/screenshots/11_teacher_dashboard.png" width="220" alt="Teacher Dashboard"> | <img src="flutterdemo/assets/screenshots/12_cart_management.png" width="220" alt="Cart Pipeline"> |
| *Teacher authentication wireframe* | *Instructor account creation* | *Programs, learners & revenue KPIs* | *Student pipeline & reminders* |

---

## 🌟 Week 2 Deliverables Summary

For Week 2, the core objective was translating Week 1 wireframes into an interactive, functional Flutter UI prototype. While Excelerate guidelines required at least **4 core screens**, Team 6 has completed **all 13 interactive screens**!

### Core 4 Mandatory Screens:
1. **Login Screen (`lib/screens/common/login_screen.dart`):** Multi-role authentication, email regex validation, password toggle, and navigation.
2. **Home Screen (`lib/screens/learner/home_screen.dart`):** Student greeting, active course progress card, live announcements, and bottom navigation.
3. **Programs Listing Screen (`lib/screens/learner/programs_list_screen.dart`):** JSON data loading (`assets/data/programs.json`), real-time search across titles and mentors, category filter chips (Mobile Dev, AI, UI/UX, Cloud), and bookmark toggles.
4. **Program Details Screen (`lib/screens/learner/program_details_screen.dart`):** Dynamically unpacks selected course arguments, displays syllabus, "What's Included" checklist, share link, bookmarks, and sticky "Add to Cart" button.

---

## 📋 Complete 13-Screen Implementation Matrix

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

## 🧭 Navigation Architecture

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
- **Cross-Platform:** Responsive on Mobile (iPhone 14 / Android) and Web.

---

## 🚀 Running the Project Locally

```bash
# 1. Clone the repository
git clone https://github.com/irtazaad328/ED-TECH_App.git

# 2. Open project folder
cd ED-TECH_App/flutterdemo

# 3. Fetch Flutter packages
flutter pub get

# 4. Run on Chrome Web (Press F12 -> Ctrl+Shift+M for Mobile View)
flutter run -d chrome

# 5. Run on Connected Device / Android Emulator
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

## 🗺️ Project Roadmap
- [x] **Week 1:** Proposal, Figma wireframes, and project skeleton setup
- [x] **Week 2:** Build all 13 interactive Flutter UI screens, implement navigation flows, automated tests, and screenshots showcase
- [ ] **Week 3:** Backend integration, state management, and real database persistence
