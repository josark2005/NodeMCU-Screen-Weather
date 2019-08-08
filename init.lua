-- configurations
wifi_ssid = ""
wifi_pwd = ""

location = "yourCity"

-- seniverse API SK
weather_sk = ""

-- BTN PIN
pin_btn = 3

-- weather
busy_flag = 0
page = 1

-- load modules
dofile('skrn')
-- initialize
skrn.init(8, 2, 0, 1)
dofile('weather')
dofile('wifi_controller')
dofile('index')