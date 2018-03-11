local secret = "hello_in_openresty_world"
local images_dir = "/usr/local/openresty/nginx/images/"
local html_result = ""

local function response(msg)
  ngx.status = ngx.HTTP_OK
  ngx.header["Content-type"] = "text/html"
  ngx.say(msg or "OK OK")
  ngx.exit(0)
end

local function calculate_signature(str)
  return ngx.encode_base64(ngx.hmac_sha1(secret, str))
    :gsub("[+/=]", {["+"] = "-", ["/"] = "_", ["="] = ","})
    :sub(1,12)
end

local function values(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end

local function create_link(res, file)
  local sig = calculate_signature(res .. "/" .. file)
  local href="http://localhost/images/" .. sig .. "/" .. res .. "/" .. file
  html_result = html_result .. "<a href='" .. href .. "'>" .. file .. " (" .. res .. ")</a><br/><br/>"
end

local resolutions = {"1280x1024", "640x480"}
local lfs = require "lfs"

for file in lfs.dir(images_dir) do
  local attr = lfs.attributes(images_dir .. "/" .. file)
  if attr.mode == "file" then
    for res in values(resolutions) do
      create_link(res, file)
      create_link("nz-" .. res, file)
    end
    html_result = html_result .. "<br/><br/>"
  end
end

response(html_result)
