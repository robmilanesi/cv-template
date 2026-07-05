#let render-cv(data) = {

  let accent = rgb(data.at("accent_color", default: "#1D546D"))
  let ink = rgb("#1A1A1A")
  let muted = rgb("#5A5A5A")
  let hairline = rgb("#D9D9D9")
  let font-body = data.at("font", default: "Libertinus Serif")
  let font-mono = data.at("font-mono", default: "DejaVu Sans Mono")

  set page(paper: "a4", margin: (top: 1.9cm, bottom: 1.9cm, left: 2.1cm, right: 2.1cm))
  set text(font: font-body, size: 10pt, fill: ink, lang: "it")
  set par(justify: false, leading: 0.6em, spacing: 0pt)
  set block(spacing: 0pt)

  // ---- helper: titolo di sezione (niente spazi negativi) ----
  let section-title(title) = block(above: 24pt, below: 8pt)[
    #text(size: 10.5pt, weight: "bold", fill: accent, tracking: 1.2pt)[#upper(title)]
    #v(4pt)
    #line(length: 100%, stroke: 0.6pt + hairline)
  ]

  // ---- helper: riga ruolo con date allineate a destra ----
  let role-line(title, meta, date) = block(above: 0pt, below: 4pt)[
    #grid(
      columns: (1fr, auto),
      text(weight: "bold", size: 10.3pt)[#title],
      align(right, text(size: 9.3pt, fill: muted, style: "italic")[#date]),
    )
    #if meta != none [
      #v(8pt)
      #text(size: 9.5pt, fill: muted)[#meta]
    ]
  ]

  // ---- helper: blocco esperienza ----
  let experience(title, company, date, bullets, note: none) = block(above: 11pt, below: 0pt)[
    #role-line(title, company, date)
    #if note != none [
      #v(5pt)
      #text(size: 9.5pt, fill: muted, style: "italic")[#note]
    ]
    #v(8pt)
    #for b in bullets [
      #block(above: 0pt, below: 8pt)[
        #grid(columns: (9pt, 1fr), text(fill: accent, size: 9.8pt)[--], text(size: 9.8pt)[#b])
      ]
    ]
  ]

  // ============================================================
  // HEADER (senza foto)
  // ============================================================
  block(above: 0pt, below: 10pt)[
    #text(size: 21pt, weight: "bold")[#data.name]
    #v(7pt)
    #text(size: 12pt, fill: muted)[#data.title]
  ]

  // ---- helper: monogramma LinkedIn disegnato a mano (niente asset esterni, niente problemi di marchio) ----
  let linkedin-mark = box(width: 9.5pt, height: 9.5pt, radius: 1.5pt, stroke: 0.8pt + muted)[
    #align(center + horizon)[#text(size: 6.5pt, weight: "bold", fill: muted)[in]]
  ]

  // ---- helper: singola voce di contatto con icona ----
  let contact-item(icon, body) = grid(
    columns: (10pt, auto),
    column-gutter: 4pt,
    align: horizon,
    icon,
    text(size: 9.3pt, fill: muted)[#body],
  )

  let contact-entries = ()
  if "linkedin" in data.contact {
    contact-entries.push(contact-item(linkedin-mark, link(data.contact.linkedin.url)[#data.contact.linkedin.label]))
  }
  contact-entries.push(contact-item(image("assets/mail.svg", width: 9pt), data.contact.email))
  contact-entries.push(contact-item(image("assets/phone.svg", width: 9pt), data.contact.phone))
  contact-entries.push(contact-item(image("assets/map-pin.svg", width: 9pt), data.contact.location))

  block(above: 0pt, below: 8pt)[
    #grid(
      columns: contact-entries.map(x => auto),
      column-gutter: 14pt,
      align: horizon,
      ..contact-entries,
    )
  ]

  line(length: 100%, stroke: 1pt + accent)

  // ============================================================
  // SUMMARY
  // ============================================================
  section-title("Profile")
  block(above: 0pt, below: 0pt)[#text(size: 10pt)[#data.summary]]

  // ============================================================
  // EXPERIENCE
  // ============================================================
  section-title("Experience")
  for job in data.experience {
    experience(job.title, job.company, job.date, job.bullets, note: job.at("note", default: none))
  }

  // ============================================================
  // SKILLS
  // ============================================================
  section-title("Skills")
  for s in data.skills {
    block(above: 0pt, below: 14pt)[
      #text(weight: "bold", size: 9.8pt)[#s.category]
      #v(8pt)
      #text(size: 9.8pt)[#s.info]
    ]
  }

  // ============================================================
  // EDUCATION & CERTIFICATIONS
  // ============================================================
  section-title("Education & Certifications")
  for e in data.education {
    block(above: 0pt, below: 9pt)[
      #text(weight: "bold", size: 9.8pt)[#e.title] #text(size: 9.8pt)[ — #e.info]
    ]
  }
  for c in data.at("certifications", default: ()) {
    let label-content = if "url" in c { link(c.url)[#c.label] } else { c.label }
    block(above: 0pt, below: 9pt)[
      #text(weight: "bold", size: 9.8pt)[#c.title] #text(size: 9.8pt, fill: accent)[ — #label-content]
    ]
  }

  // ============================================================
  // LANGUAGES
  // ============================================================
  section-title("Languages")
  block(above: 0pt, below: 0pt)[
    #text(size: 9.8pt)[#data.languages.join("   ·   ")]
  ]
}
