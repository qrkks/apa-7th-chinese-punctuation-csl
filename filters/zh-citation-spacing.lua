-- Remove source-authored spaces at Chinese citation boundaries.
--
-- Parenthetical citations lose adjacent spaces on both sides. Narrative
-- citations retain their preceding source space and APA's internal author-year
-- spacing, but lose a following source space before Chinese continuation text.
-- Ordinary parentheses, equations, and bibliography entries are untouched.

local function citation_kind(inline)
  if inline.t ~= "Cite" or #inline.citations == 0 then
    return nil
  end

  for _, citation in ipairs(inline.citations) do
    if tostring(citation.mode) == "AuthorInText" then
      return "narrative"
    end
  end

  return "parenthetical"
end

function Inlines(inlines)
  local result = pandoc.List()
  local remove_next_space = false

  for _, inline in ipairs(inlines) do
    local kind = citation_kind(inline)
    if inline.t == "Space" and remove_next_space then
      remove_next_space = false
    elseif kind ~= nil then
      if kind == "parenthetical" and #result > 0 and result[#result].t == "Space" then
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
