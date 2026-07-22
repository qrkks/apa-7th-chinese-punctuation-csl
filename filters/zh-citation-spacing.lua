-- Remove source-authored spaces immediately around parenthetical citations.
--
-- This filter is intentionally narrow: it only changes Space nodes adjacent
-- to Cite nodes whose citations are not in AuthorInText mode. It does not
-- rewrite ordinary parentheses, bibliography entries, or narrative citations.

local function is_parenthetical_cite(inline)
  if inline.t ~= "Cite" or #inline.citations == 0 then
    return false
  end

  for _, citation in ipairs(inline.citations) do
    if tostring(citation.mode) == "AuthorInText" then
      return false
    end
  end

  return true
end

function Inlines(inlines)
  local result = pandoc.List()
  local remove_next_space = false

  for _, inline in ipairs(inlines) do
    if inline.t == "Space" and remove_next_space then
      remove_next_space = false
    elseif is_parenthetical_cite(inline) then
      if #result > 0 and result[#result].t == "Space" then
        result:remove(#result)
      end
      result:insert(inline)
      remove_next_space = true
    else
      remove_next_space = false
      result:insert(inline)
    end
  end

  return result
end
