local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local add = function(obj)
  ls.add_snippets("markdown", obj)
end

add({
  s("meta", {
    t({ "---",
      'title: "' }), t({ "My Document" }), t({ '"',    -- Default title
    'author: "' }), t({ "Abdullah Khawahir" }), t({ '"',     -- Default author
    'date: "' }), t({ os.date("%Y-%m-%d") }), t({ '"', -- Default to the current date
    'geometry: margin=1in',
    'fontsize: 12pt',
    'mainfont: "DejaVu Serif"',
    "---",
    "" }),
  }),
})
