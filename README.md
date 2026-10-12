<h1 align="center">📚 Ed Tech</h1>

<p align="center">
  <b>One app where learners find programs and teachers manage them.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" alt="Figma">
  <img src="https://img.shields.io/badge/Team-6-25307C?style=for-the-badge" alt="Team 6">
  <img src="https://img.shields.io/badge/Status-Week%201%20done-2ea44f?style=for-the-badge" alt="Status">
</p>

<p align="center">
  <a href="https://www.figma.com/design/QWMnhOtY99AqOI90lf4yMk/Team-6-Wireframes?node-id=0-1&t=R7Ajb2Jlw7v95zlR-1"><b>🎨 View the wireframes on Figma</b></a>
</p>

---

**Quick links:** [About](#-about) · [Vision](#-vision) · [Objectives](#-objectives) · [Users](#-target-users) · [Features](#-features) · [Navigation](#-navigation-flow) · [Wireframes](#-wireframes) · [Setup](#-getting-started) · [Team](#-team-6) · [Roadmap](#-roadmap)

---

## 📖 About

Ed Tech is a mobile app built with Flutter where people who want to learn and people who want to teach can find each other. Teachers put their programs on the app. Learners browse them, pick one, pay for it and start learning, all from their phone.

This is the Team 6 project for our Flutter app development course. Week 1 is the planning week: the proposal, the wireframes and the project setup. The real screens start in Week 2.

## 🎯 Vision

Right now, a student who wants to learn something new has to jump between websites, social media pages and WhatsApp groups to find a decent course. It is hard to see who is teaching, what the price is, or what you have already joined. Teachers have the same problem from their side, because they have no simple way to see who signed up or how much they earned.

We want Ed Tech to fix both sides: a simple app for finding programs, and a simple dashboard for managing them.

## ✅ Objectives

- Make it easy for learners to find and buy programs in one place.
- Give teachers a simple dashboard to manage programs and see their learners and earnings.
- Keep the screens simple, so a new user can go from opening the app to paying in a few taps.
- Plan every screen and the navigation first with wireframes, then build the Flutter UI step by step.

## 👥 Target users

| | Who they are | What they need |
|---|---|---|
| 🎓 **Learners** | University and college students, and anyone who wants to pick up a new skill | Search programs, check the price and teacher, pay, and track progress |
| 🧑‍🏫 **Teachers (admins)** | Instructors who create and sell programs | Add programs, post announcements, see analytics, and check who has paid or still has a program in the cart |

## ✨ Features

<table>
<tr>
<td width="50%" valign="top">

### 🎓 For learners
- Role selection, then login or signup (email and password, or Google)
- Home with announcements, featured programs, a progress card and a notifications bell
- Programs list with search and cards (image, title, teacher, price, bookmark)
- Program details with description, what is included, Add to Cart and Bookmark
- Cart (programs from one teacher only) and payment by card, bank transfer or wallet
- Bottom navigation: Home, Programs, Bookmarks, Profile

</td>
<td width="50%" valign="top">

### 🧑‍🏫 For teachers
- Teacher login and signup (name, email, password, phone, area of expertise)
- Dashboard with number of programs, number of learners and total earnings
- Quick actions: Add Program, Announcements, Analytics
- Cart management list with learner, program and status (In cart or Paid), with filters
- Menu: Dashboard, Programs, Users

</td>
</tr>
</table>

> Bookmarks, Profile, Notifications, Announcements, Analytics and the lessons screens are planned, but were not drawn in Week 1.

## 🧭 Navigation flow

The app opens on Role Selection and splits into two paths.

**🎓 Learner**

`Role Selection` → `Learner Login / Signup` → `Home` → `Programs List` → `Program Details` → `My Cart` → `Payment` → back to `Home`

**🧑‍🏫 Teacher**

`Role Selection` → `Teacher Login / Signup` → `Teacher Dashboard` → `Cart Management`

## 🖼️ Wireframes

Low-fidelity black and white wireframes, drawn in Figma on an iPhone 14 frame (390 x 844).

🔗 [Open the Team-6-Wireframes file](https://www.figma.com/design/QWMnhOtY99AqOI90lf4yMk/Team-6-Wireframes?node-id=0-1&t=R7Ajb2Jlw7v95zlR-1)

| Learner screens | Teacher screens |
|---|---|
| Role Selection | Role Selection (teacher) |
| Learner Login | Teacher Login |
| Learner Signup | Teacher Signup |
| Home | Teacher Dashboard |
| Programs List | Cart Management |
| Program Details | |
| My Cart | |
| Payment | |

## 🛠️ Tech

| Tool | Used for |
|---|---|
| Flutter (Dart) | Android and iOS app from one codebase |
| Git and GitHub | Version control and teamwork |
| Figma | Wireframes |

## 🚀 Getting started

Make sure Flutter is installed (`flutter doctor` should look fine), then:

```bash
git clone https://github.com/irtazaad328/ED-TECH_App.git
cd ED-TECH_App
flutter pub get
flutter run
```

## 🤝 Team 6

Mannu · Irtaza · Idiris · Akshata · Aishika · Jennifer · Fatima · Kadir · Martha

## 🗺️ Roadmap

- [x] **Week 1:** proposal, wireframes and repository setup
- [ ] **Week 2:** build the main Flutter screens from the wireframes and connect them with navigation
- [ ] **Later:** add the remaining features, then test and polish
