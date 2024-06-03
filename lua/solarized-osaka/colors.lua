local util = require("solarized-osaka.util")
local hslutil = require("solarized-osaka.hsl")
local hsl = hslutil.hslToHex

local M = {}

---@class Palette
M.default = {
  none = "NONE",

  base04 = hsl(216, 42, 5),
  base03 = hsl(218, 35, 12),
  base02 = hsl(218, 35, 16),
  base01 = hsl(217, 20, 35),
  base00 = hsl(217, 15, 45),
  base0 = hsl(218, 10, 64),
  base1 = hsl(211, 12, 71),
  base2 = hsl(249, 24, 89),
  base3 = hsl(245, 79, 94),
  base4 = hsl(0, 0, 100),
  yellow = hsl(51, 95, 46),
  yellow100 = hsl(47, 100, 73),
  yellow300 = hsl(47, 100, 50),
  yellow500 = hsl(45, 100, 35),
  yellow700 = hsl(45, 95, 25),
  yellow900 = hsl(51, 100, 10),
  orange = hsl(30, 90, 45),
  orange100 = hsl(24, 92, 66),
  orange300 = hsl(25, 100, 54),
  orange500 = hsl(23, 81, 44),
  orange700 = hsl(25, 95, 34),
  orange900 = hsl(18, 80, 20),
  red = hsl(362, 60, 55),
  red100 = hsl(360, 60, 72),
  red300 = hsl(362, 65, 57),
  red500 = hsl(360, 62, 46),
  red700 = hsl(1, 55, 35),
  red900 = hsl(1, 60, 20),
  magenta = hsl(326, 67, 53),
  magenta100 = hsl(326, 78, 70),
  magenta300 = hsl(329, 97, 68),
  magenta500 = hsl(326, 66, 52),
  magenta700 = hsl(326, 60, 38),
  magenta900 = hsl(330, 64, 24),
  violet = hsl(256, 43, 60),
  violet100 = hsl(260, 90, 90),
  violet300 = hsl(260, 69, 77),
  violet500 = hsl(260, 43, 60),
  violet700 = hsl(260, 43, 50),
  violet900 = hsl(260, 42, 25),
  blue = hsl(211, 58, 49),
  blue100 = hsl(219, 55, 82),
  blue300 = hsl(223, 55, 60),
  blue500 = hsl(218, 55, 46),
  blue700 = hsl(220, 55, 33),
  blue900 = hsl(224, 55, 20),
  cyan = hsl(181, 57, 43),
  cyan100 = hsl(183, 78, 82),
  cyan300 = hsl(183, 86, 53),
  cyan500 = hsl(183, 59, 40),
  cyan700 = hsl(183, 58, 25),
  cyan900 = hsl(183, 58, 15),
  green = hsl(122, 80, 35),
  green100 = hsl(122, 75, 78),
  green300 = hsl(122, 90, 49),
  green500 = hsl(122, 90, 32),
  green700 = hsl(122, 90, 20),
  green900 = hsl(122, 90, 10),

  bg = hsl(218, 84, 6),
  bg_highlight = hsl(212, 81, 12),
  fg = hsl(218, 12, 55),
}

---@return ColorScheme
function M.setup(opts)
  opts = opts or {}
  local config = require("solarized-osaka.config")

  -- local style = config.is_day() and config.options.light_style or config.options.style
  local style = "default"
  local palette = M[style] or {}
  if type(palette) == "function" then
    palette = palette()
  end

  -- Color Palette
  ---@class ColorScheme: Palette
  local colors = vim.tbl_deep_extend("force", vim.deepcopy(M.default), palette)

  util.bg = colors.bg
  util.day_brightness = config.options.day_brightness

  colors.black = util.darken(colors.bg, 0.8, "#000000")
  colors.border = colors.black

  -- Popups and statusline always get a dark background
  colors.bg_popup = colors.base04
  colors.bg_statusline = colors.base03

  -- Sidebar and Floats are configurable
  colors.bg_sidebar = config.options.styles.sidebars == "transparent" and colors.none
    or config.options.styles.sidebars == "dark" and colors.base04
    or colors.bg

  colors.bg_float = config.options.styles.floats == "transparent" and colors.none
    or config.options.styles.floats == "dark" and colors.base04
    or colors.bg

  -- colors.fg_float = config.options.styles.floats == "dark" and colors.base01 or colors.fg
  colors.fg_float = colors.fg

  colors.error = colors.red500
  colors.warning = colors.yellow500
  colors.info = colors.blue500
  colors.hint = colors.cyan500
  colors.todo = colors.violet500

  config.options.on_colors(colors)
  if opts.transform and config.is_day() then
    util.invert_colors(colors)
  end

  return colors
end

return M
