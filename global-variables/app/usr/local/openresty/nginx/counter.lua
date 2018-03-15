local _M = {}

local count = 0

function _M.increment()
  count = count + 1
  return count
end

return _M
