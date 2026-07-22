-- Run citeproc, then normalize narrative citations for Chinese prose.
--
-- The Space immediately before the full-width year parenthesis is removed from
-- every AuthorInText citation. Only standalone ampersands joining two personal
-- authors are changed to 和; existing Space nodes around 和 are preserved.
-- Corporate author names, parenthetical citations, and bibliography entries
-- are otherwise untouched.

local function personal_two_author_references(doc)
  local result = {}

  for _, reference in ipairs(pandoc.utils.references(doc)) do
    local authors = reference.author
    if authors ~= nil and #authors == 2 then
      local personal_names = true
      for _, author in ipairs(authors) do
        if author.literal ~= nil then
          personal_names = false
          break
        end
      end

      if personal_names then
        result[pandoc.utils.stringify(reference.id)] = true
      end
    end
  end

  return result
end

local function narrative_citation_id(inline)
  if inline.t ~= "Cite" or #inline.citations == 0 then
    return nil
  end

  for _, citation in ipairs(inline.citations) do
    if tostring(citation.mode) == "AuthorInText" then
      return citation.id
    end
  end

  return nil
end

local function normalize_narrative(inline, localize_connector)
  local year_start = nil

  for index, item in ipairs(inline.content) do
    if item.t == "Str" and item.text:find("（", 1, true) then
      year_start = index
      break
    end
  end

  -- No full-width year parenthesis means citeproc has not run yet, or this is
  -- not output from the companion CSL style. Leave it unchanged in either case.
  if year_start == nil then
    return inline
  end

  if localize_connector then
    for index = 1, year_start - 1 do
      local item = inline.content[index]
      if item.t == "Str" and item.text == "&" then
        item.text = "和"
      end
    end
  end

  if year_start > 1 and inline.content[year_start - 1].t == "Space" then
    inline.content:remove(year_start - 1)
  end

  return inline
end

function Pandoc(doc)
  local localizable_ids = personal_two_author_references(doc)
  doc = pandoc.utils.citeproc(doc)

  return doc:walk {
    Cite = function(inline)
      local citation_id = narrative_citation_id(inline)
      if citation_id ~= nil then
        return normalize_narrative(inline, localizable_ids[citation_id] == true)
      end

      return inline
    end
  }
end
