[@react.component]
let make = () => {
  let (backgroundColor, setBackgroundColor) = React.useState(() => "#000000");
  let (foregroundColor, setForegroundColor) = React.useState(() => "#ffffff");

  <div className="flex flex-col min-h-screen">
    <div
      className="flex flex-col items-center justify-center flex-1"
      style={ReactDOMStyle.make(~backgroundColor, ())}>
      <div
        className="text-6xl font-bold"
        style={ReactDOMStyle.make(~color=foregroundColor, ())}>
        {switch (WCAG.Score.make(foregroundColor, backgroundColor)) {
         | AAA => "AAA"->React.string
         | AA => "AA"->React.string
         | AALarge => "AA Large"->React.string
         | Fail => "Fail"->React.string
         | Invalid => React.null
         }}
      </div>
      <div
        className="text-lg"
        style={ReactDOMStyle.make(~color=foregroundColor, ())}>
        {switch (WCAG.Ratio.make(foregroundColor, backgroundColor)) {
         | Some(r) => React.string("Score: " ++ Js.Float.toString(r))
         | None => React.null
         }}
      </div>
    </div>
    <div
      className="flex justify-center py-4 bg-white border-t space-x-2 border-color-gray200">
      <TextField
        id="foreground-color"
        label="Foreground color"
        onChange={e => {
          let value = e->ReactEvent.Form.target##value;

          setForegroundColor(_ => Js.String2.trim(value));
        }}
        value=foregroundColor
      />
      <TextField
        id="background-color"
        label="Background color"
        onChange={e => {
          let value = e->ReactEvent.Form.target##value;
          setBackgroundColor(_ => Js.String2.trim(value));
        }}
        value=backgroundColor
      />
    </div>
  </div>;
};
