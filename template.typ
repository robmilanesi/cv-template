#let render-cv(data) = {

  let accent = rgb(data.at("accent_color", default: "#1D546D"))
  let font-body = data.at("font", default: "IBM Plex Sans")
  let font-mono = data.at("font-mono", default: "IBM Plex Mono")
  
  set page(
    paper: "a4",
    margin: (top: 0%, rest: 1.25cm),
    background: place(top)[
      #rect(width: 100%, height: 16%, fill: accent)
    ],
  )

  set text(font: font-body, size: 10pt, weight: "light", lang: "it")

  // ---- helper: titolo di sezione ----
  let section-title(title) = {
    set text(size: 14pt, weight: "bold", fill: accent)
    upper(title)
    v(-10pt)
    line(length: 100%, stroke: 1pt + gray)
    v(1pt)
  }

  // ---- helper: riga di contatto semplice ----
  let contact-item(label, value) = {
    text(size: 10pt)[#text(weight: "bold")[#label:] #value]
    linebreak()
  }

  // ---- helper: riga di contatto con icona/link ----
  let contact-item-link(label, url, icon: none) = {
    if icon != none {
      grid(
        columns: (12pt, auto),
        gutter: 5pt,
        align: horizon,
        image(icon, width: 10pt),
        link(url)[#text(fill: accent, weight: "semibold")[#label]],
      )
    } else {
      link(url)[#text(fill: accent, weight: "semibold")[#label]]
    }
  }

  // ---- helper: categoria di skill ----
  let skill-cat(title, info) = {
    stack(
      spacing: 4pt,
      text(size: 10pt, weight: "bold", fill: accent, upper(title)),
      v(10pt),
      text(size: 9pt, font: font-mono, info),
      v(8pt),
    )
  }

  // ---- helper: voce di formazione/certificazione ----
  let edu-cat(title, body) = {
    stack(spacing: 10pt, text(size: 10pt, weight: "bold", fill: accent, upper(title)), body, v(15pt))
  }

  // ---- helper: blocco esperienza ----
  // "bullets" è una lista di stringhe (arriva così da YAML)
  let experience(title, company, date, bullets) = {
    block(breakable: false)[
      #rect(
        width: 100%,
        fill: rgb("#f0f4f8"),
        stroke: (left: 3pt + accent),
        inset: 8pt,
        radius: (top-right: 4pt, bottom-right: 4pt),
      )[
        #grid(
          columns: (1fr, auto),
          rows: (auto, auto),
          gutter: 4pt,
          [*#title*], [#text(style: "italic", date)],
          [#company], [],
        )
      ]
      #pad(left: 12pt, top: 0pt, bottom: 0pt)[
        #set text(size: 10pt)
        #for b in bullets [
          - #b
        ]
      ]
    ]
  }

  // ============================================================
  // HEADER: foto + nome + titolo
  // ============================================================
  place(top, dy: 1%)[
    #grid(
      columns: (auto, 1fr),
      align: horizon,
      gutter: 20pt,
      box(
        clip: true,
        radius: 50%,
        stroke: 3pt + white,
        width: 120pt,
        height: 120pt,
        image(data.photo, width: 120pt, height: 120pt, fit: "cover"),
      ),
      column-gutter: 10pt,
      [
        #set text(fill: white)
        #text(size: 32pt, weight: "bold")[#data.name] \
        #v(-5pt)
        #text(size: 16pt, weight: "light")[#data.title]
      ],
    )
  ]
  v(20%)

  // ============================================================
  // BODY: colonna sinistra (contatti/skill) + destra (esperienza)
  // ============================================================
  grid(
    columns: (30%, 70%),
    column-gutter: 20pt,

    // --- COLONNA SINISTRA ---
    [
      #section-title("Contact")
      #if "linkedin" in data.contact [
        #contact-item-link(data.contact.linkedin.label, data.contact.linkedin.url, icon: data.at("linkedin-icon", default: "assets/linkedin-icon.png"))
      ]
      #contact-item("Email", data.contact.email)
      #contact-item("Phone", data.contact.phone)
      #contact-item("Location", data.contact.location)

      #v(8pt)
      #section-title("Languages")
      #for lang in data.languages [
        - #lang
      ]

      #v(8pt)
      #section-title("Skills")
      #for s in data.skills [
        #skill-cat(s.category, s.info)
      ]

      #v(8pt)
      #section-title("Education")
      #for e in data.education [
        #edu-cat(e.title, text(size: 9pt)[#e.info])
      ]
      #for c in data.at("certifications", default: ()) [
        #edu-cat(
          c.title,
          if "url" in c {
            link(c.url)[#text(fill: accent, weight: "bold")[#c.label]]
          } else {
            text(fill: accent, weight: "bold")[#c.label]
          },
        )
      ]
    ],

    // --- COLONNA DESTRA ---
    [
      #section-title("Summary")
      #data.summary

      #v(8pt)
      #section-title("Experience")
      #for job in data.experience [
        #experience(job.title, job.company, job.date, job.bullets)
      ]
    ],
  )
}
