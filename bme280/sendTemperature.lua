function sendHuminity()
dofile("DHT11.lua")
x = Temperature.."."..TemperatureDec
id = '3'
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
tmr.alarm(0, 5000 , 1, function() sendDataHumidity() end )
