import lustre
import lustre/attribute
import lustre/element/html
import lustre/event

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#build-widget", Nil)
  Nil
}

type Model {
  Model(expanded: Bool)
}

type Message {
  ToggleDetails
}

fn init(_arguments: Nil) -> Model {
  Model(expanded: False)
}

fn update(model: Model, message: Message) -> Model {
  case message {
    ToggleDetails -> Model(expanded: !model.expanded)
  }
}

fn view(model: Model) {
  html.section([attribute.class("build-island")], [
    html.div([attribute.class("build-island-copy")], [
      html.span([attribute.class("island-label")], [html.text("Lustre island")]),
      html.h3([], [html.text("Inspect the build receipt")]),
      html.p([], [
        html.text(
          "This control owns only this panel. The rest of the page remains static HTML.",
        ),
      ]),
    ]),
    html.div([attribute.class("build-receipt")], [
      html.div([attribute.class("receipt-status")], [
        html.span([], [html.text("Latest build")]),
        html.strong([], [html.text("Passed")]),
      ]),
      details(model.expanded),
      html.button(
        [attribute.class("receipt-button"), event.on_click(ToggleDetails)],
        [
          html.text(case model.expanded {
            True -> "Hide build details"
            False -> "Show build details"
          }),
        ],
      ),
    ]),
  ])
}

fn details(expanded: Bool) {
  case expanded {
    False -> html.div([], [])
    True ->
      html.ul([attribute.class("receipt-details")], [
        step("01", "Markdown parsed"),
        step("02", "Layouts applied"),
        step("03", "Assets optimized"),
        step("04", "Static output written"),
      ])
  }
}

fn step(number: String, label: String) {
  html.li([], [html.span([], [html.text(number)]), html.text(label)])
}
