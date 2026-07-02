# My Positive Health — iOS app

A SwiftUI iOS app based on the **Positive Health** dialogue tools by
[Positive Health International](https://positivehealth-international.com/dialogue-tools/)
in collaboration with the institute for Positive Health (iPH), founded on the
work of Machteld Huber.

Positive Health shifts the conversation from *"what is the matter with you?"*
to *"what matters to you?"*. People score how they feel about ~40 aspects of
their life across six dimensions of health; the result is drawn as a **spider
web** — a personal, norm-free overview that works as a conversation starter.

## Features

- **All three official dialogue tools**, reproduced verbatim from the English
  PDFs (v. downloaded 2026-07-02):
  - Adults — Dialogue tool 2.0 (44 aspects)
  - Adolescents / young adults 16–25 — Tool 1.1 (43 aspects)
  - Children 8–16 — Children's tool 1.1 (39 aspects, with the "from 12 years"
    items toggleable)
- **Questionnaire** — one page per dimension, each aspect scored 0–10 with a
  slider and smiley feedback, plus the tool's reflection question
  (*"The following is particularly important to me"*).
- **Spider web** — a hexagonal radar chart in the official dimension colours,
  drawn with SwiftUI Canvas.
- **The other conversation** — after filling in the web, the app asks the
  three follow-up questions used in practice: what would you like to give more
  attention to, what small step could you take, and who or what could support
  you.
- **History & comparison** — assessments are stored locally with SwiftData
  (no account, no server, no tracking) and any result can be overlaid on the
  previous one of the same version.
- **About** — the concept, the six dimensions and the three-step method.

## Project structure

```
PositiveHealth/
├── PositiveHealth.xcodeproj      Xcode 16 project (folder-synchronized)
└── PositiveHealth/
    ├── PositiveHealthApp.swift   App entry point (SwiftData container)
    ├── Models/
    │   ├── PositiveHealthContent.swift   Dimensions & aspects of all 3 tools
    │   └── Assessment.swift              SwiftData model for saved results
    └── Views/
        ├── HomeView.swift        History list + start a new assessment
        ├── QuestionnaireView.swift   Paged questionnaire with sliders
        ├── SpiderWebView.swift   Hexagonal radar chart (Canvas)
        ├── ResultView.swift      Spider web, scores, conversation questions
        └── AboutView.swift       About Positive Health
```

## Building

Requires **Xcode 16 or later** (the project uses folder-synchronized groups)
and targets **iOS 17+**. Open `PositiveHealth.xcodeproj`, select a simulator
or device, set your development team under *Signing & Capabilities*, and run.
There are no third-party dependencies.

## Important — content licence

The wording of the dimensions and aspects is **© iPH/PHi** and reproduced from
the freely downloadable official tools. Positive Health International states
that its materials may **not be edited or digitally reformatted without
permission**. This project is intended for personal/educational use; **before
distributing the app (e.g. on the App Store), contact Positive Health
International / iPH for permission** via
[positivehealth-international.com](https://positivehealth-international.com/).

The app is not a medical device and provides no diagnosis or medical advice.

## Roadmap ideas

- Localization (the official tools exist in 12 languages; the online tool in
  English, German and Dutch).
- The *network intake* mind-mapping tool used alongside Positive Health in
  the adolescent care project.
- Export / share the spider web as an image or PDF for use in a consultation.
- The children's smiley questionnaire variant.
