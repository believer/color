open TestFramework
open WCAG

describe("Best", ({test}) => {
  test("finds the best foreground color for a given background", ({expect}) => {
    list{
      ("#ffffff", "#000000", "#ffffff", "#000000"),
      ("#ffffff", "#000000", "#000000", "#ffffff"),
      ("rgb(255,255,255)", "#000000", "#979798", "#000000"),
      ("rgb(255,255,255)", "#000000", "#fd8b56", "#000000"),
      ("hsl(0,0,100%)", "#000000", "#3e74b1", "hsl(0,0,100%)"),
    }->Belt.List.forEach(((one, two, bg, expected)) => {
      expect.string(Best.make(one, two, bg)).toEqual(expected)
    })
  })
})

describe("Ratio", ({test}) => {
  test("color ratios", ({expect}) => {
    list{
      ("#ffffff", "#ffffff", 1.0),
      ("ffffff", "ffffff", 1.0),
      ("rgb(255, 255, 255)", "rgb(255, 255, 255)", 1.0),
      ("rgb(255,255,255)", "rgb(255, 255, 255)", 1.0),
      ("hsl(255, 30%, 40%)", "hsl(255, 30%, 40%)", 1.0),
      ("hsl(255,30,40)", "hsl(255, 30%, 40%)", 1.0),
      ("#ffffff", "rgb(255, 255, 255)", 1.0),
      ("#ffffff", "#000000", 21.0),
      ("#ffffff", "#777777", 4.48),
      ("#0088FF", "#C611AB", 1.47),
      ("ffffff", "777777", 4.48),
      ("fff", "777", 4.48),
      ("08f", "fff", 3.52),
      ("rgb(255,255,255)", "#777777", 4.48),
      ("rgb(255,255,255)", "rgb(77,77,77)", 8.45),
      ("hsl(0, 0%, 20%)", "#ffffff", 12.63),
      ("hsl(210, 30%, 48%)", "#ffffff", 4.47),
      ("hsl(210, 30%, 68%)", "#ffffff", 2.31),
      ("hsl(0, 0%, 20%)", "hsl(0, 0%, 100%)", 12.63),
      ("hsl(0, 100%, 40%)", "#fff", 5.89),
      ("hsl(360, 100%, 40%)", "#fff", 5.89),
    }->Belt.List.forEach(((fg, bg, expected)) => {
      expect.value(Ratio.make(fg, bg)).toEqual(Some(expected))
    })
  })

  test("validates colors", ({expect}) => {
    expect.value(Ratio.make("#ffff", "#000000")).toEqual(None)
  })
})

describe("Score", ({test}) => {
  test("#calculateFromRatio", ({expect}) => {
    list{
      (Some(7.1), Score.AAA),
      (Some(4.6), AA),
      (Some(3.9), AALarge),
      (Some(2.9), Fail),
    }->Belt.List.forEach(((ratio, score)) => {
      expect.value(Score.calculateFromRatio(ratio)).toEqual(score)
    })
  })

  test("#make", ({expect}) =>
    list{
      ("#ffffff", "#000000", Score.AAA),
      ("#ffffff", "#666666", AA),
      ("#ffffff", "#888888", AALarge),
      ("#ffffff", "#cccccc", Fail),
    }->Belt.List.forEach(((foreground, background, score)) => {
      expect.value(Score.make(foreground, background)).toEqual(score)
    })
  )
})
