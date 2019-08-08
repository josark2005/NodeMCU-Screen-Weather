-- global singal
screen_stat = 1
stime = 15
skrn_time = stime

-- weather
gpio.mode(pin_btn, gpio.INT)
function onBtnUp()
    print('pressed')
	skrn_time = stime
	sp:start()
	-- disable btn
    gpio.trig(pin_btn)
    if (screen_stat == 0) then
		-- display on
		screen_stat = 1
        skrn.powerSave(0)
	else
		-- switch page
		skrn.clear()
		if (page == 1) then
			page = 2
			skrn.draw(3, 1, 40, "明")
			skrn.draw(3, 30, 16, wt.tomorrow['text_day'])
			skrn.draw(3, 30, 40, wt.tomorrow['low']..' - '..wt.tomorrow['high'])
			skrn.draw(3, 30, 64, wt.update)
		else
			page = 1
			skrn.draw(3, 1, 40, "今")
            skrn.draw(3, 30, 16, wt.today['text_day'])
			skrn.draw(3, 30, 40, wt.today['low']..' - '..wt.today['high'])
			skrn.draw(3, 30, 64, wt.update)
		end
    end
	-- enable btn
	local t = tmr.create()
    t:alarm(500, tmr.ALARM_SINGLE, function()
        gpio.trig(pin_btn, 'up', onBtnUp)
    end)
end

gpio.trig(pin_btn, 'up', onBtnUp)

-- screen protecter
sp = tmr.create()
sp:register(1000, tmr.ALARM_AUTO, function()
	local tip = 'SKRN_P:'..screen_stat..'-'..skrn_time
	print(tip)
	if (screen_stat == 1) then
		-- screen:on
		if (skrn_time > 0) then
			skrn_time = skrn_time - 1
		else
			skrn_time = stime
			-- close screen
			screen_stat = 0
			page = 2
			skrn.powerSave(1)
			sp:stop()
		end
	else
		sp:stop()
	end
end)

-- connect wifi
wf.conn(wifi_ssid, wifi_pwd)

