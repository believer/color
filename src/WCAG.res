module Utils = {
  let removeHash = str => str |> Js.String.replace("#", "")
}

module Luminance = {
  let toSRGB = color => color /. 255.0
  let toRGB = color =>
    color <= 0.03928 ? color /. 12.92 : Js.Math.pow_float(~base=(color +. 0.055) /. 1.055, ~exp=2.4)

  let relative = rgb =>
    switch rgb {
    | [r, g, b] => r *. 0.2126 +. g *. 0.7152 +. b *. 0.0722
    | _ => 0.0
    }

  /*
   * https://www.w3.org/WAI/GL/wiki/Relative_luminance
   */
  let convert = color => {
    open Js.Array

    color |> map(toSRGB) |> map(toRGB) |> relative
  }
}

module HSL = {
  let hueToRgb = (p, q, t) => {
    switch t {
    | x when x < 1.0 /. 6.0 => p +. (q -. p) *. 6.0 *. x
    | x when x < 0.5 => q
    | x when x < 2.0 /. 3.0 => p +. (q -. p) *. 6.0 *. (2.0 /. 3.0 -. x)
    | _ => p
    }
  }

  let createRgbFromHsl = (h, s, l) => {
    /* Get hue by rotation (360deg) */
    let hue = h /. 3.6
    let tempR = hue +. 1.0 /. 3.0
    let tempB = hue -. 1.0 /. 3.0

    let q = switch l {
    | l when l < 0.5 => l *. (1.0 +. s)
    | _ => l +. s -. l *. s
    }
    let p = 2.0 *. l -. q
    let rgb = hueToRgb(p, q)

    let b = switch tempB {
    | x when x < 0. => 0.
    | x => x
    }

    [rgb(tempR), rgb(hue), rgb(b)]
  }

  /*
   * http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
   * https://gist.github.com/mjackson/5311256
   */
  let convert = hsl => {
    hsl
    |> Js.Array.map(x => x /. 100.0)
    |> (hsl =>
      switch hsl {
      | [_, 0.0, l] => [l, l, l]
      | [h, s, l] when h === 3.6 => createRgbFromHsl(0., s, l)
      | [h, s, l] => createRgbFromHsl(h, s, l)
      | _ => []
      })
    |> Js.Array.map(x => x *. 255.0)
  }
}

module HEX = {
  let defaultArray = str => str->Belt.Option.getWithDefault([])

  let hexParts = t => {
    switch t->Js.String.length {
    | 3 => Js.String2.match_(t, %re("/.{1}/g")) |> defaultArray |> Js.Array.map(x => x ++ x)
    | _ => Js.String2.match_(t, %re("/.{2}/g")) |> defaultArray
    }
  }

  let convert = hex => {
    hex |> hexParts |> Js.Array.map(x => "0x" ++ x |> float_of_string)
  }
}

module Validate = {
  let make = input => {
    let valid = %re(
      `/(^#\\w{3}$)|(^#\\w{6}$)|(^rgb\\(\\d{1,3},\\s?\\d{1,3},\\s?\\d{1,3}\\)$)|(^hsl\\(\\d{1,3},\\s?\\d{1,3}%,\\s?\\d{1,3}%\\)$)/`
    )

    Js.Re.test_(valid, input)
  }
}

module Ratio = {
  type t =
    | HSL
    | RGB
    | HEX

  let typeOfColor = color =>
    switch color |> Js.String.substring(~from=0, ~to_=3) {
    | "rgb" => RGB
    | "hsl" => HSL
    | _ => HEX
    }

  let parseNumbers = rgb => {
    switch rgb->Js.String2.match_(%re("/\\d+/g")) {
    | Some(colors) => colors |> Js.Array.map(x => x->float_of_string)
    | None => []
    }
  }

  let parseColor = color =>
    switch color |> typeOfColor {
    | HEX => color |> HEX.convert
    | HSL => color |> parseNumbers |> HSL.convert
    | RGB => color |> parseNumbers
    }
    |> Luminance.convert
    |> (v => v +. 0.05)

  let make = (foreground, background) => {
    switch (Validate.make(foreground), Validate.make(background)) {
    | (true, true) =>
      switch (foreground |> Utils.removeHash, background |> Utils.removeHash) {
      | (fg, bg) when fg === bg => Some(1.0)
      | (fg, bg) =>
        Some(
          switch (fg |> parseColor, bg |> parseColor) {
          | (f, b) when f > b => f /. b
          | (f, b) => b /. f
          }
          |> Js.Float.toFixedWithPrecision(~digits=2)
          |> Js.Float.fromString,
        )
      }
    | _ => None
    }
  }
}

module Score = {
  type t =
    | AAA
    | AA
    | AALarge
    | Fail
    | Invalid

  let calculateFromRatio = ratio =>
    switch ratio {
    | Some(r) when r >= 7.0 => AAA
    | Some(r) when r >= 4.5 => AA
    | Some(r) when r >= 3.0 => AALarge
    | Some(_) => Fail
    | None => Invalid
    }

  let toString = value =>
    switch value {
    | AAA => Some("AAA")
    | AA => Some("AA")
    | AALarge => Some("AA Large")
    | Fail => Some("Fail")
    | Invalid => None
    }

  let make = (foreground, background) => Ratio.make(foreground, background) |> calculateFromRatio
}

module Best = {
  let make = (first, second, background) => {
    let firstRatio = Ratio.make(first, background)
    let secondRatio = Ratio.make(second, background)

    switch (firstRatio, secondRatio) {
    | (Some(f), Some(s)) when f > s => first
    | _ => second
    }
  }
}
