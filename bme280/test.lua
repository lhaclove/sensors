sda, scl = 2, 1
i2c.setup(0, sda, scl, i2c.SLOW) -- call i2c.setup() only once
bme280.setup(nil, nil, nil, 0) -- initialize to sleep mode
bme280.startreadout(0, function ()
  T, P = bme280.read()
  local Tsgn = (T < 0 and -1 or 1); T = Tsgn*T
  print(string.format("T=%s%d.%02d", Tsgn<0 and "-" or "", T/100, T%100))
end)    