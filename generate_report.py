import os
import shutil
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfgen import canvas

output_pdf = r"C:\Users\Administrator\Downloads\ED_TECH_Team6_Week2_Deliverable_Report.pdf"
docs_pdf = r"C:\Users\Administrator\ED-TECH_App\docs\ED_TECH_Team6_Week2_Deliverable_Report.pdf"
os.makedirs(os.path.dirname(docs_pdf), exist_ok=True)

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_header_footer(num_pages)
            super().showPage()
        super().save()

    def draw_header_footer(self, page_count):
        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#6B7280"))
        
        # Header (Pages 2+)
        if self._pageNumber > 1:
            self.drawString(45, 11 * inch - 36, "Excelerate Cohort 0510 • Team 6: ED-TECH App")
            self.drawRightString(8.5 * inch - 45, 11 * inch - 36, "Week 2 Deliverable Report")
            self.setStrokeColor(colors.HexColor("#E5E7EB"))
            self.setLineWidth(0.75)
            self.line(45, 11 * inch - 42, 8.5 * inch - 45, 11 * inch - 42)
            
        # Footer (All pages)
        self.setStrokeColor(colors.HexColor("#E5E7EB"))
        self.setLineWidth(0.75)
        self.line(45, 42, 8.5 * inch - 45, 42)
        self.setFont("Helvetica", 8)
        self.drawString(45, 30, "Excelerate Remote Internship • Team Lead: Irtaza Ahmad (irtazaad328@gmail.com)")
        self.drawRightString(8.5 * inch - 45, 30, f"Page {self._pageNumber} of {page_count}")
        self.restoreState()

doc = SimpleDocTemplate(
    output_pdf,
    pagesize=letter,
    leftMargin=45,
    rightMargin=45,
    topMargin=50,
    bottomMargin=50
)

styles = getSampleStyleSheet()

primary_color = colors.HexColor("#1E3A8A")   # Navy Blue
accent_color = colors.HexColor("#2563EB")    # Electric Blue
dark_text = colors.HexColor("#1F2937")       # Slate 800

title_style = ParagraphStyle(
    "DocTitle",
    parent=styles["Normal"],
    fontName="Helvetica-Bold",
    fontSize=20,
    leading=24,
    textColor=primary_color,
    spaceAfter=4
)

subtitle_style = ParagraphStyle(
    "DocSubTitle",
    parent=styles["Normal"],
    fontName="Helvetica",
    fontSize=10,
    leading=14,
    textColor=colors.HexColor("#4B5563"),
    spaceAfter=12
)

h1_style = ParagraphStyle(
    "H1",
    parent=styles["Normal"],
    fontName="Helvetica-Bold",
    fontSize=13,
    leading=16,
    textColor=primary_color,
    spaceBefore=10,
    spaceAfter=5
)

body_style = ParagraphStyle(
    "Body",
    parent=styles["Normal"],
    fontName="Helvetica",
    fontSize=9,
    leading=13,
    textColor=dark_text,
    spaceAfter=5
)

bullet_style = ParagraphStyle(
    "Bullet",
    parent=styles["Normal"],
    fontName="Helvetica",
    fontSize=8.5,
    leading=12,
    textColor=dark_text,
    leftIndent=14,
    firstLineIndent=-10,
    spaceAfter=3
)

table_header_style = ParagraphStyle(
    "TH",
    parent=styles["Normal"],
    fontName="Helvetica-Bold",
    fontSize=8.5,
    leading=11,
    textColor=colors.white,
    alignment=1
)

table_body_style = ParagraphStyle(
    "TB",
    parent=styles["Normal"],
    fontName="Helvetica",
    fontSize=8,
    leading=10.5,
    textColor=dark_text
)

story = []

# Title & Header
story.append(Paragraph("EXCELERATE MOBILE APP DEVELOPMENT INTERNSHIP • COHORT 0510", ParagraphStyle("Tag", fontName="Helvetica-Bold", fontSize=8.5, textColor=accent_color, leading=11)))
story.append(Paragraph("Week 2 Deliverable: Working UI Prototype Report", title_style))
story.append(Paragraph("Project: <b>ED-TECH App (Team 6)</b> &nbsp;|&nbsp; Submission Date: <b>October 19, 2026</b> &nbsp;|&nbsp; Lead: <b>Irtaza Ahmad</b>", subtitle_style))
story.append(HRFlowable(width="100%", thickness=1.5, color=primary_color, spaceAfter=8))

# Meta Table
meta_data = [
    [Paragraph("<b>GitHub Repository:</b>", table_body_style), Paragraph("<font color='#2563EB'><u>https://github.com/irtazaad328/ED-TECH_App</u></font>", table_body_style)],
    [Paragraph("<b>Figma Wireframes:</b>", table_body_style), Paragraph("<font color='#2563EB'><u>https://www.figma.com/design/QWMnhOtY99AqOI90lf4yMk/Team-6-Wireframes</u></font>", table_body_style)],
    [Paragraph("<b>Project Scope:</b>", table_body_style), Paragraph("13 Complete Interactive Screens (Learner Journey & Teacher Management)", table_body_style)],
    [Paragraph("<b>Technology Stack:</b>", table_body_style), Paragraph("Flutter 3.47.4 • Dart 3.13.3 • Material Design 3", table_body_style)],
]
meta_table = Table(meta_data, colWidths=[1.8 * inch, 5.2 * inch])
meta_table.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
    ("BOX", (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
    ("INNERGRID", (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
    ("TOPPADDING", (0,0), (-1,-1), 3),
    ("BOTTOMPADDING", (0,0), (-1,-1), 3),
    ("LEFTPADDING", (0,0), (-1,-1), 6),
    ("RIGHTPADDING", (0,0), (-1,-1), 6),
]))
story.append(meta_table)
story.append(Spacer(1, 8))

# 1. Executive Summary
story.append(Paragraph("1. Executive Summary & Week 2 Objective Alignment", h1_style))
story.append(Paragraph(
    "For Week 2, the core objective was translating low-fidelity Figma wireframes into an interactive, functional Flutter UI prototype. "
    "While Excelerate guidelines mandated at least <b>four core screens</b> (Login, Home, Program Listing, and Program Details), <b>Team 6 has built and deployed all 13 interactive screens</b> "
    "covering both Learner and Teacher operational flows. All 13 screens feature full navigation, responsive layouts, data models, state handling, and 100% passing automated tests.",
    body_style
))

# 2. Four Core Screens Deep Dive
story.append(Paragraph("2. Mandatory Deliverables: Core 4-Screen Flow Deep-Dive", h1_style))
core_screens_data = [
    [Paragraph("Screen", table_header_style), Paragraph("Figma Mapping", table_header_style), Paragraph("Key Features & Interactivity Implemented", table_header_style)],
    [
        Paragraph("<b>1. Login Screen</b><br/><font color='#6B7280'>login_screen.dart</font>", table_body_style),
        Paragraph("Screen 2 (Learner)<br/>Screen 10 (Teacher)", table_body_style),
        Paragraph("• Multi-role support (Student / Teacher toggle)<br/>• Email regex validation & 6+ character password check<br/>• Password visibility eye toggle & interactive error toasts<br/>• Direct routing to Signup or Home/Dashboard upon login", table_body_style)
    ],
    [
        Paragraph("<b>2. Home Screen</b><br/><font color='#6B7280'>home_screen.dart</font>", table_body_style),
        Paragraph("Screen 4 (Learner Home)", table_body_style),
        Paragraph("• Learner greeting banner & active notifications badge<br/>• Live Announcements card carousel<br/>• Ongoing course progress card with linear progress bar<br/>• Featured Programs explorer & bottom navigation bar", table_body_style)
    ],
    [
        Paragraph("<b>3. Programs Listing</b><br/><font color='#6B7280'>programs_list_screen.dart</font>", table_body_style),
        Paragraph("Screen 5 (Course Explorer)", table_body_style),
        Paragraph("• Loads mock courses from assets/data/programs.json<br/>• Real-time search filter across titles, teachers, and topics<br/>• Category filter chips (Mobile Dev, AI, UI/UX, Cloud)<br/>• Bookmark toggle with instant snackbar notification", table_body_style)
    ],
    [
        Paragraph("<b>4. Program Details</b><br/><font color='#6B7280'>program_details_screen.dart</font>", table_body_style),
        Paragraph("Screen 6 (Course Details)", table_body_style),
        Paragraph("• Dynamic arguments extraction via ModalRoute (title, teacher, price, rating)<br/>• Detailed course syllabus & 'What is Included' checklist<br/>• Interactive Bookmark and Share buttons<br/>• Sticky bottom checkout bar with 'Add to Cart' transition", table_body_style)
    ],
]
core_table = Table(core_screens_data, colWidths=[1.8 * inch, 1.4 * inch, 3.8 * inch])
core_table.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), primary_color),
    ("GRID", (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
    ("ROWBACKGROUNDS", (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ("TOPPADDING", (0,0), (-1,-1), 4),
    ("BOTTOMPADDING", (0,0), (-1,-1), 4),
    ("LEFTPADDING", (0,0), (-1,-1), 6),
    ("RIGHTPADDING", (0,0), (-1,-1), 6),
]))
story.append(core_table)
story.append(Spacer(1, 10))

# 3. Full 13-Screen Matrix
story.append(Paragraph("3. Complete Team 6 Screen Implementation Matrix (All 13 Screens)", h1_style))
all_screens_data = [
    [Paragraph("#", table_header_style), Paragraph("Screen Name", table_header_style), Paragraph("Implementation File", table_header_style), Paragraph("Owner", table_header_style), Paragraph("Status", table_header_style)],
    [Paragraph("1", table_body_style), Paragraph("Role Selection (Learner)", table_body_style), Paragraph("role_selection_screen.dart", table_body_style), Paragraph("Irtaza Ahmad", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("2", table_body_style), Paragraph("Learner Login", table_body_style), Paragraph("login_screen.dart", table_body_style), Paragraph("Fatima Zahid", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("3", table_body_style), Paragraph("Learner Signup", table_body_style), Paragraph("signup_screen.dart", table_body_style), Paragraph("Fatima Zahid", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("4", table_body_style), Paragraph("Learner Home Portal", table_body_style), Paragraph("home_screen.dart", table_body_style), Paragraph("Irtaza Ahmad", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("5", table_body_style), Paragraph("Programs List", table_body_style), Paragraph("programs_list_screen.dart", table_body_style), Paragraph("Idiris Hassan", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("6", table_body_style), Paragraph("Program Details", table_body_style), Paragraph("program_details_screen.dart", table_body_style), Paragraph("Sameer Rizwan", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("7", table_body_style), Paragraph("My Cart Screen", table_body_style), Paragraph("cart_screen.dart", table_body_style), Paragraph("Mannu", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("8", table_body_style), Paragraph("Payment & Checkout", table_body_style), Paragraph("payment_screen.dart", table_body_style), Paragraph("Akshata", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("9", table_body_style), Paragraph("Role Selection (Teacher)", table_body_style), Paragraph("role_selection_screen.dart", table_body_style), Paragraph("Irtaza Ahmad", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("10", table_body_style), Paragraph("Teacher Login", table_body_style), Paragraph("teacher_login_screen.dart", table_body_style), Paragraph("Aishika Pal", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("11", table_body_style), Paragraph("Teacher Signup", table_body_style), Paragraph("teacher_signup_screen.dart", table_body_style), Paragraph("Aishika Pal", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("12", table_body_style), Paragraph("Teacher Dashboard", table_body_style), Paragraph("teacher_dashboard_screen.dart", table_body_style), Paragraph("Jennifer Shantal", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
    [Paragraph("13", table_body_style), Paragraph("Cart Management", table_body_style), Paragraph("cart_management_screen.dart", table_body_style), Paragraph("Abdul Kadir", table_body_style), Paragraph("<b>100% Passed</b>", table_body_style)],
]
all_table = Table(all_screens_data, colWidths=[0.3 * inch, 1.8 * inch, 2.2 * inch, 1.6 * inch, 1.1 * inch])
all_table.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), primary_color),
    ("GRID", (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
    ("ROWBACKGROUNDS", (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ("TOPPADDING", (0,0), (-1,-1), 3),
    ("BOTTOMPADDING", (0,0), (-1,-1), 3),
    ("LEFTPADDING", (0,0), (-1,-1), 5),
    ("RIGHTPADDING", (0,0), (-1,-1), 5),
    ("ALIGN", (0,0), (0,-1), "CENTER"),
    ("ALIGN", (-1,0), (-1,-1), "CENTER"),
]))
story.append(all_table)
story.append(Spacer(1, 10))

# 4. Navigation Architecture
story.append(Paragraph("4. Navigation Architecture & Route Verification", h1_style))
story.append(Paragraph(
    "The application relies on declarative named routes (<code>AppRoutes</code>) defined in <code>lib/routes/app_routes.dart</code>. "
    "Users begin at <code>AppRoutes.welcome</code> and navigate seamlessly through two designated application branches:",
    body_style
))
story.append(Paragraph("• <b>Learner Flow:</b> Welcome → Role Selection (Student) → Login / Signup → Home Portal → Programs List → Program Details → My Cart → Payment (Card / Bank / Mobile Wallet) → Confirmation Receipt → Home.", bullet_style))
story.append(Paragraph("• <b>Teacher / Admin Flow:</b> Welcome → Role Selection (Teacher) → Teacher Login / Signup → Teacher Dashboard (Metrics & Quick Actions) → Cart Management (Pipeline Status Filter & Reminders).", bullet_style))

# 5. Quality Assurance & Testing
story.append(Paragraph("5. Quality Assurance, Build & Git Verification", h1_style))
story.append(Paragraph("• <b>Automated Testing:</b> <code>flutter test</code> executed with <b>100% passing rate</b> across all widget test suites.", bullet_style))
story.append(Paragraph("• <b>Static Analysis:</b> <code>flutter analyze</code> verified with <b>0 compile errors</b> and clean import references.", bullet_style))
story.append(Paragraph("• <b>Cross-Platform Verification:</b> Production Web build (<code>flutter build web</code>) compiled successfully.", bullet_style))
story.append(Paragraph("• <b>Version Control:</b> All member Pull Requests (#1, #2, #3, #6, #7) cleanly reviewed and merged into <code>main</code> with meaningful commit histories.", bullet_style))

# 6. Demo Video Walkthrough Guide
story.append(Paragraph("6. Demo Video Walkthrough Guide (2–3 Minutes)", h1_style))
story.append(Paragraph(
    "To satisfy the recommended video deliverable, Team Lead Irtaza Ahmad structured the presentation into a 4-part walkthrough:<br/>"
    "• <b>0:00 - 0:35:</b> Welcome screen & role selection demonstration (Learner vs Teacher).<br/>"
    "• <b>0:35 - 1:15:</b> Learner authentication (validation & visibility toggle) followed by Home Portal tour.<br/>"
    "• <b>1:15 - 2:00:</b> Programs List live search, category filtering, and Program Details argument reception.<br/>"
    "• <b>2:00 - 2:45:</b> Cart checkout, multi-method payment receipt dialog, and Teacher Dashboard review.",
    body_style
))

doc.build(story, canvasmaker=NumberedCanvas)
shutil.copy(output_pdf, docs_pdf)
print("PDF report built successfully at:", output_pdf)
