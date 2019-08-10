-- weather module
-- !!global variale busy_flag needed
print "-- weather module has loaded"

wt = {}

link = "http://api.seniverse.com/v3/weather/daily.json?key="..weather_sk.."&location="..location.."&language=zh-Hans&unit=c&start=0&days=2"

function wt.get()
    print('Getting wearther...')
	skrn.clearDisplay()
	skrn.draw(3, 16, 24, "获取天气中")
    if (busy_flag == 0) then
		wt.getWeather()
	end
end

function wt.getWeather()
	print(link)
	busy_flag = 1
	http.get(link, nil, function(code, data)
		print('complete')
		busy_flag = 0
		if (code < 0) then
		  print("HTTP request failed")
		  print(code, data)
		  skrn.draw(3, 16, 24, "获取天气失败")
		else
			print(code, data)
			if (code ~= 200) then
				print('warning')
				skrn.draw(3, 16, 24, "获取天气失败")
			else
				-- show weather status
				local ret = sjson.decode(data)
				wt.today = ret['results'][1]['daily'][1]
				wt.tomorrow = ret['results'][1]['daily'][2]
				wt.update = string.sub(ret['results'][1]['last_update'], 12, 16)
				skrn.clearDisplay()
				print('just update...')
			end
		end
	end)
end
