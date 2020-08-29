@react.component
let make = (~setForegroundColor, ~setBackgroundColor) => {
  let (clipboardData, setClipboardData) = Clipboard.use()
  let (displayPasteBoard, setDisplayPasteBoard) = React.useState(() => false)

  React.useEffect1(() => {
    switch clipboardData {
    | Some(data) => WCAG.Validate.make(data) ? setDisplayPasteBoard(_ => true) : ()
    | None => ()
    }

    None
  }, [clipboardData])

  let setPasteAsForegroundColor = _ => {
    switch clipboardData {
    | Some(data) =>
      setForegroundColor(data)
      setClipboardData(_ => None)
      setDisplayPasteBoard(_ => false)
    | None => ()
    }
  }

  let setPasteAsBackgroundColor = _ => {
    switch clipboardData {
    | Some(data) =>
      setBackgroundColor(data)
      setClipboardData(_ => None)
      setDisplayPasteBoard(_ => false)
    | None => ()
    }
  }

  switch displayPasteBoard {
  | false => React.null
  | true =>
    <div
      className="absolute inset-0 flex flex-col items-center justify-center text-gray-800 bg-black bg-opacity-75">
      <div className="p-5 py-6 bg-white rounded">
        {switch clipboardData {
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
  }
}
