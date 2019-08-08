-- Screen Controller
print('Loading Screen Controller...')

skrn = {}

-- configuration
skrn.cs  = 8 -- GPIO15, pull-down 10k to GND
skrn.dc  = 2 -- GPIO2
skrn.res = 0 -- GPIO16
skrn.bus = 1

-- powerSave
function skrn.powerSave(stat)
	skrn.disp:setPowerSave(stat)
end

-- initialize
function skrn.init(cs, dc, res, bus)
	print('intializing screen controller...')
	skrn.cs  = cs or 8
	skrn.dc  = dc or 2
	skrn.res = res or 0
	skrn.bus = bus or 1
	spi.setup(bus, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
	gpio.mode(8, gpio.INPUT, gpio.PULLUP)
	skrn.disp = u8g2.ssd1306_128x64_noname(skrn.bus, skrn.cs, skrn.dc, skrn.res)
	skrn.disp:setPowerSave(0)
	skrn.disp:clearBuffer()
end

-- draw
function skrn.draw(font_id, x, y, text)
	local font;
	if (font_id == 1) then
		skrn.disp:setFont(u8g2.font_6x10_tf)
	elseif (font_id == 2) then
		skrn.disp:setFont(u8g2.font_unifont_t_symbols)
	elseif (font_id == 3) then
		skrn.disp:setFont(u8g2.font_wqy16_t_gb2312)
	end
	skrn.disp:drawUTF8(x, y, text)
	skrn.show()
end      

-- display
function skrn.show()
	skrn.disp:sendBuffer()
end

-- clear
function skrn.clear()
	skrn.disp:clearBuffer()
end

-- clearDisplay
function skrn.clearDisplay()
	skrn.disp:clearBuffer()
	skrn.disp:sendBuffer()
end
