local sig, size, path, ext =
  ngx.var.sig, ngx.var.size, ngx.var.path, ngx.var.ext

local secret = "hello_in_openresty_world"
local images_dir = "/usr/local/openresty/nginx/images/"
local cache_dir = "/usr/local/openresty/nginx/cache/"

function string.starts(String,Start)
  return string.sub(String,1,string.len(Start))==Start
end

local function return_not_found(msg)
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.header["Content-type"] = "text/html"
  ngx.say(msg or "not found")
  ngx.exit(0)
end

local function calculate_signature(str)
  return ngx.encode_base64(ngx.hmac_sha1(secret, str))
    :gsub("[+/=]", {["+"] = "-", ["/"] = "_", ["="] = ","})
    :sub(1,12)
end

local signature = calculate_signature(size .. "/" .. path)
if signature ~= sig then
  return_not_found("invalid signature, valid one is: " .. signature)
end

local source_fname = images_dir .. path

-- make sure the file exists
local file = io.open(source_fname)

if not file then
  return_not_found("file " .. path .. " not found")
end

file:close()

local dest_fname = cache_dir .. ngx.md5(size .. "/" .. path) .. "." .. ext

-- resize the image
local magick = require("magick")

magick.thumb(source_fname, size, dest_fname)

ngx.exec(ngx.var.request_uri)
