open Webapi

module Data = {
  external toClipboardEvent: Dom.Event.t => Dom.ClipboardEvent.t = "%identity"
  @bs.send external make: ('a, string) => string = "getData"
}

let use = () => {
  let (clipboardData, setClipboardData) = React.useState(() => None)

  React.useEffect0(() => {
    let listener = event => {
      let data = event->Data.toClipboardEvent->Dom.ClipboardEvent.clipboardData->Data.make("text")

      setClipboardData(_ => Some(data))
    }

    Dom.window |> Dom.Window.addEventListener("paste", listener)

    Some(() => {Dom.window |> Dom.Window.removeEventListener("paste", listener)})
  })

  (clipboardData, setClipboardData)
}
