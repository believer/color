module Url = {
  type t

  @new external params: string => t = "URLSearchParams"
  @send external get: (t, string) => Js.Nullable.t<string> = "get"
}

let useColorFromUrl = () => {
  let url = ReasonReactRouter.useUrl()
  let defaultColors = ("#ffffff", "#000000")

  let colors = switch url.search {
  | "" => defaultColors
  | search =>
    switch (
      Url.params(search)->Url.get("fg")->Js.Nullable.toOption,
      Url.params(search)->Url.get("bg")->Js.Nullable.toOption,
    ) {
    | (Some(fg), Some(bg)) =>
      switch (fg, bg) {
      | ("", "") => defaultColors
      | (fg, bg) => (fg, bg)
      }

    | (Some(fg), None) =>
      switch fg {
      | "" => defaultColors
      | fg => (fg, "#000000")
      }

    | (None, Some(bg)) =>
      switch bg {
      | "" => defaultColors
      | bg => ("#ffffff", bg)
      }

    | (None, None) => defaultColors
    }
  }

  colors
}
