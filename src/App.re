[@react.component]
let make = () => {
  let (backgroundColor, setBackgroundColor) = React.useState(() => "#000000");
  let (foregroundColor, setForegroundColor) = React.useState(() => "#ffffff");
  let (displayPasteBoard, setDisplayPasteBoard) = React.useState(() => false);
  let (clipboardData, setClipboardData) = Clipboard.use();

  React.useEffect1(
    () => {
      switch (clipboardData) {
      | Some(_) => setDisplayPasteBoard(_ => true)
      | None => ()
      };

      None;
    },
    [|clipboardData|],
  );

  let setPasteAsForegroundColor = _ => {
    switch (clipboardData) {
    | Some(data) =>
      setForegroundColor(_ => data);
      setClipboardData(_ => None);
      setDisplayPasteBoard(_ => false);
    | None => ()
    };
  };

  let setPasteAsBackgroundColor = _ => {
    switch (clipboardData) {
    | Some(data) =>
      setBackgroundColor(_ => data);
      setClipboardData(_ => None);
      setDisplayPasteBoard(_ => false);
    | None => ()
    };
  };

  <div className="flex flex-col min-h-screen ">
    <div
      className="relative flex flex-col items-center justify-center flex-1"
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
        className="flex items-center text-lg space-x-2"
        style={ReactDOMStyle.make(
          ~color=WCAG.Best.make("#A0AEC0", "#4A5568", backgroundColor),
          (),
        )}>
        {switch (WCAG.Score.make(foregroundColor, backgroundColor)) {
         | AAA
         | AA
         | AALarge =>
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
         | Fail
         | Invalid => React.null
         }}
        <span>
          {switch (WCAG.Ratio.make(foregroundColor, backgroundColor)) {
           | Some(r) => React.string("Score: " ++ Js.Float.toString(r))
           | None => React.null
           }}
        </span>
      </div>
      {switch (displayPasteBoard) {
       | false => React.null
       | true =>
         <div
           className="absolute inset-0 flex flex-col items-center justify-center text-gray-800 bg-black bg-opacity-75">
           <div className="p-5 py-6 bg-white rounded">
             {switch (clipboardData) {
              | Some(color) =>
                <div className="flex flex-col items-center mb-5 font-bold">
                  <div
                    className="w-16 h-16 mb-2 rounded shadow-lg"
                    style={ReactDOMStyle.make(~backgroundColor=color, ())}
                  />
                  {React.string(color)}
                </div>
              | None => React.null
              }}
             <div className="flex space-x-2">
               <button
                 className="px-5 py-2 text-sm font-medium text-white rounded-sm bg-primary"
                 onClick=setPasteAsForegroundColor>
                 {React.string("Set as foreground color")}
               </button>
               <button
                 className="px-5 py-2 text-sm font-medium text-white rounded-sm bg-primary"
                 onClick=setPasteAsBackgroundColor>
                 {React.string("Set as background color")}
               </button>
             </div>
           </div>
         </div>
       }}
    </div>
    <div
      className="flex justify-center py-4 bg-white border-t space-x-2 border-color-gray200">
      <ColorField
        id="foreground-color"
        label="Foreground color"
        onChange={e => {
          let value = e->ReactEvent.Form.target##value;

          setForegroundColor(_ => Js.String2.trim(value));
        }}
        value=foregroundColor
      />
      <ColorField
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
