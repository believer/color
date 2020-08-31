@react.component
let make = (~foregroundColor, ~backgroundColor) => {
  let score = WCAG.Score.make(foregroundColor, backgroundColor)

  <>
    <div className="flex items-center space-x-2 text-lg justify-center mb-5">
      {switch score {
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
      | Equal | Fail | Invalid => React.null
      }}
      {switch WCAG.Ratio.make(foregroundColor, backgroundColor) {
      | Some(r) => <span> {React.string("Score: ")} {React.float(r)} </span>
      | None => React.null
      }}
    </div>
    <div className="text-sm">
      {switch score {
      | AAA => "AAA (> 7) is an enhanced contrast ratio. This is valuable for texts that will be read for a longer period of time."
      | AA => "AA (> 4.5) is what you should aim for with text sizes below 18px"
      | AALarge => "AA Large (> 3) is the least amount of contrast for font size 18px and larger"
      | Fail | Equal | Invalid => "Your text has a contrast ratio of less than 3.0"
      }->React.string}
    </div>
  </>
}
