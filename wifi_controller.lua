-- wifi module
print "-- wifi module has loaded"

wf = {}

-- skrn
loading_bar = 1
wf.loading = tmr.create()
wf.loading:register(1000, tmr.ALARM_AUTO, function()
		skrn.draw(3, 16, 24, '等待无线网络')
		if( loading_bar == 1 ) then
			skrn.draw(1, 16, 40, '.')
			loading_bar = loading_bar + 1
		elseif( loading_bar == 2 ) then
			skrn.draw(1, 16, 40, '..')
			loading_bar = loading_bar + 1
		elseif( loading_bar == 3 ) then
			skrn.draw(1, 16, 40, '...')
			loading_bar = 1
		end
		skrn.clear()
    end)
wf.loading:start()


function wf.conn(ssid, pwd)
    local msg = "-- start wifi connection:"..ssid;
    print(msg)
    wifi.setmode(wifi.STATION, false)
    local cfg = {}
    cfg.ssid = wifi_ssid
    cfg.pwd = wifi_pwd
    cfg.auto = auto
    wifi.sta.config(cfg)
end

-- listen
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED,function(t)
    print('-- wifi connected')
	wf.loading:stop()
	-- auto update
	au = tmr.create()
	-- update weather data every 30 min
	au:register(60000 * 5, tmr.ALARM_AUTO, function()
		if (busy_flag == 0) then
			print('AUTO UPDATING...')
			wt.get()
		end
	end)
	au:start()
	wt.get(1)
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,function(t)
    print('-- wifi disconnected')
	print('-- schedule removed')
	wf.loading:start()
	au:stop()
end)
