-- sidebar.lua: Map Pandoc Divs with class 'sidebar' to LaTeX sidebar environment
function Div(el)
  if el.classes:includes('sidebar') then
    local title = el.attributes['title'] or ''
    if FORMAT:match("latex") then
      local content = pandoc.write(pandoc.Pandoc(el.content), "latex")
      return pandoc.RawBlock('latex', string.format('\\begin{sidebar}[]{%s}\n%s\n\\end{sidebar}', title, content))
    end
  end
end
