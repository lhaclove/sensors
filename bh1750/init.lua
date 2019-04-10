wifi.setmode(wifi.STATION)
wifi.sta.config("VT538","12345678")
print(wifi.sta.getip())
--dofile('light.lua')
