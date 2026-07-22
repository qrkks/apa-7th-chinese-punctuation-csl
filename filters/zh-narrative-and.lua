-- Run citeproc, then localize the author connector in narrative citations.
--
-- Only standalone ampersands joining two personal authors in AuthorInText
-- citations are changed. Existing Space nodes around the connector are
-- preserved; corporate authors, parenthetical citations, and bibliography
-- entries are untouched.

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

local function is_localizable_narrative(inline, localizable_ids)
  if inline.t ~= "Cite" or #inline.citations == 0 then
    return false
  end

  for _, citation in ipairs(inline.citations) do
    if tostring(citation.mode) == "AuthorInText" and localizable_ids[citation.id] then
      return true
    end
  end

  return false
end

local function localize_author_connector(inline)
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

  for index = 1, year_start - 1 do
    local item = inline.content[index]
    if item.t == "Str" and item.text == "&" then
      item.text = "和"
    end
  end

  return inline
end

function Pandoc(doc)
  local localizable_ids = personal_two_author_references(doc)
  doc = pandoc.utils.citeproc(doc)

  return doc:walk {
    Cite = function(inline)
      if is_localizable_narrative(inline, localizable_ids) then
        return localize_author_connector(inline)
      end

      return inline
    end
  }
end
