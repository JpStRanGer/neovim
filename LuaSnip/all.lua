
-- Place this in ~/.config/nvim/LuaSnip/all.lua

local ls = require("luasnip")
local s = ls.snippet       -- Shortcut for defining a snippet
local t = ls.text_node     -- Shortcut for inserting plain text

return {
  -- A snippet that expands the trigger "hi" into the string "Hello, world!".
  s("hi", {
    t("Hello, world!"),
  }),

  -- Another snippet that expands the trigger "foo" into "Another snippet."
  s({ trig = "foo" }, {
    t("Another snippet."),
  }),
}
