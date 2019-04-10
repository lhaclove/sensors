SDA_PIN = 4 -- sda pin, GPIO0
SCL_PIN = 3 -- scl pin, GPIO2
function sendData()
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult) / mult
end
 
bh1750 = require("bh1750")
bh1750.init(SDA_PIN, SCL_PIN)
bh1750.read(OSS)
lux = bh1750.getlux()
y = round(lux / 100, 2)
print(y)
id = '3'
reqstr = '/set?id='..id..'&date='..y
conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) print(payload) end)

conn:connect(80,'13.53.149.166')
conn:send("GET "..reqstr.." HTTP/1.1\r\n") 
conn:send("Host: 10.18.51.103\r\n") 
conn:send("Accept: */*\r\n") 
conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
conn:send("\r\n")
conn:on("sent",function(conn)
                     --  print("Closing connection")
                      conn:close()
                  end)
conn:on("disconnection", function(conn)
                               -- print("Got disconnection...")
  end)
end
-- sendData()
-- send data every 60000 ms to thing speak
tmr.alarm(0, 2500, 1, function() sendData() end )












