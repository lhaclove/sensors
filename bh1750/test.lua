SDA_PIN = 4 -- sda pin, GPIO0
SCL_PIN = 3 -- scl pin, GPIO2
local x = {}
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult) / mult
end
 
bh1750 = require("bh1750")
bh1750.init(SDA_PIN, SCL_PIN)
bh1750.read(OSS)
lux = bh1750.getlux()
y = round(lux / 100, 2)
