
function sendDataHuminity()
sda, scl = 6, 5
i2c.setup(0, sda, scl, i2c.SLOW) -- call i2c.setup() only once
bme280.setup()
H, T = bme280.humi()
local Tsgn = (T < 0 and -1 or 1); T = Tsgn*T
x = string.format(H/1000, H%1000)
print(x)

id = '8'

reqstr = '/savedata.php?t='..x..'&s='..id

conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) print(payload) end)

conn:connect(80,'13.53.149.166') 
conn:send("GET "..reqstr.." HTTP/1.1\r\n") 
conn:send("Host: 10.18.49.131\r\n") 
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
tmr.alarm(0, 1000 , 1, function() sendDataHuminity() end )
