function sendData(x)
id = '4'
print(x)
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

inpin=1
gpio.mode(inpin, gpio.INT)

start=tmr.time()
lastEnd=0

function motionStart()
  start=tmr.time()
  print('Motion detected!')
  
  print('[DEBUG] start: '..start..', last: '..lastEnd..
        ', break: '..start - lastEnd)
  sendData(start - lastEnd)
  tmr.delay(1000000)
  gpio.trig(inpin, "down", motionStop)
end

function motionStop()
  duration = tmr.time() - start
  print('motion ended after '..duration..' seconds.')
  print('[DEBUG] start: '..start..', duration: '..duration)
  tmr.delay(1000000)
  lastEnd=start + duration
  gpio.trig(inpin, "up", motionStart)
end

gpio.trig(inpin, "up", motionStart)
    


