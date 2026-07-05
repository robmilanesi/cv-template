// ============================================================
// main.typ — Unique ENTRYPOINT
// ============================================================
// Sceglie il template in base al parametro "template" passato
// da riga di comando. Default: "clean".
//
//   typst compile main.typ                          -> usa template-clean.typ
//   typst compile main.typ --input template=sidebar -> usa template.typ (con foto)
//
// Oppure usa ./build.sh per un menu interattivo.
// ============================================================

#import "template.typ": render-cv as render-sidebar
#import "template-clean.typ": render-cv as render-clean

#let which = sys.inputs.at("template", default: "clean")
#let data = yaml("data.yaml")

#if which == "sidebar" {
  render-sidebar(data)
} else {
  render-clean(data)
}
