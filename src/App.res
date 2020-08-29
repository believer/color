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
      style={ReactDOMStyle.make(~backgroundColor, ())}>
      <div className="text-6xl font-bold" style={ReactDOMStyle.make(~color=foregroundColor, ())}>
        {switch WCAG.Score.make(foregroundColor, backgroundColor)->WCAG.Score.toString {
        | Some(score) => score->React.string
        | None => React.null
        }}
      </div>
      <div
        className="flex items-center text-lg space-x-2"
        style={ReactDOMStyle.make(
          ~color=WCAG.Best.make("#ffffff", "#000000", backgroundColor),
          (),
        )}>
        {switch WCAG.Score.make(foregroundColor, backgroundColor) {
        | AAA | AA | AALarge =>
          <span className="w-6 h-6 text-green-500">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"
              />
            </svg>
          </span>
        | Fail | Invalid => React.null
        }}
        {switch WCAG.Ratio.make(foregroundColor, backgroundColor) {
        | Some(r) => <span> {React.float(r)} </span>
        | None => React.null
        }}
      </div>
      <PasteBoard
        setForegroundColor={color => dispatch(SetForegroundColor(color))}
        setBackgroundColor={color => dispatch(SetBackgroundColor(color))}
      />
    </div>
    <div className="flex justify-center py-4 bg-white border-t space-x-2 border-color-gray200">
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
  </div>
}
