@react.component
let make = (~id, ~value, ~label, ~onChange) => {
  <div>
    <label className="block mb-1 text-xs font-bold text-gray-700" htmlFor=id>
      {React.string(label)}
    </label>
    <div className="flex h-10">
      <label
        className="w-10 h-full border border-r-0 border-gray-500 rounded-l"
        style={ReactDOMStyle.make(
          ~backgroundColor=WCAG.Validate.parse(value),
          ~borderColor={WCAG.Validate.make(value) ? "" : "#f56565"},
          (),
        )}>
        <input className="opacity-0" onChange type_="color" />
      </label>
      <input
        className="px-4 py-2 text-sm bg-transparent border border-gray-500 rounded-r outline-none"
        id
        type_="text"
        style={ReactDOMStyle.make(~borderColor={WCAG.Validate.make(value) ? "" : "#f56565"}, ())}
        onChange
        value
      />
    </div>
  </div>
}
