type state = {colors: (string, string)}

type action =
  | SetForegroundColor(string)
  | SetBackgroundColor(string)

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) => {
    let (foregroundColor, backgroundColor) = state.colors

    switch action {
    | SetBackgroundColor(color) => {colors: (foregroundColor, color)}
    | SetForegroundColor(color) => {colors: (color, backgroundColor)}
    }
  }, {colors: ("#ffffff", "#000000")})
  let (foregroundColor, backgroundColor) = state.colors

  let handleChange = event => {
    (event->ReactEvent.Form.target)["value"]->Js.String2.trim
  }

  <div className="flex flex-col min-h-screen ">
    <div
      className="relative flex flex-col items-center justify-center flex-1"
      style={ReactDOMStyle.make(~backgroundColor=WCAG.Validate.parse(backgroundColor), ())}>
      <div
        className="text-6xl font-bold"
        style={ReactDOMStyle.make(~color=WCAG.Validate.parse(foregroundColor), ())}>
        {switch WCAG.Score.make(foregroundColor, backgroundColor)->WCAG.Score.toString {
        | Some("Equal") =>
          <div
            style={ReactDOMStyle.make(
              ~color=WCAG.Best.make("#ffffff", "#000000", backgroundColor),
              (),
            )}>
            {"Colors are the same"->React.string}
          </div>
        | Some(score) => score->React.string
        | None => React.null
        }}
      </div>
      <div
        className="text-lg w-3/5 md:w-1/3 ml-auto mr-auto text-center"
        style={ReactDOMStyle.make(
          ~color=WCAG.Best.make("#ffffff", "#000000", backgroundColor),
          (),
        )}>
        <Score foregroundColor backgroundColor />
      </div>
      <PasteBoard
        setForegroundColor={color => dispatch(SetForegroundColor(color))}
        setBackgroundColor={color => dispatch(SetBackgroundColor(color))}
      />
    </div>
    <div className="flex flex-col items-center py-4 pb-5 bg-white border-t border-color-gray200">
      <div className="flex space-x-2 mb-4">
        <ColorField
          id="foreground-color"
          label="Foreground color"
          onChange={e => {
            let value = handleChange(e)
            dispatch(SetForegroundColor(value))
          }}
          value=foregroundColor
        />
        <ColorField
          id="background-color"
          label="Background color"
          onChange={e => {
            let value = handleChange(e)
            dispatch(SetBackgroundColor(value))
          }}
          value=backgroundColor
        />
      </div>
      <div className="text-gray-700 text-xs">
        {"Psst.. You can also paste colors on the page"->React.string}
      </div>
    </div>
  </div>
}
