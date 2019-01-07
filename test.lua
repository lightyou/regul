local pwm = require('pwm')
local lunit = require('lunatest')
local heating = require('heating')

local assert_true = lunit.assert_true
local assert_false = lunit.assert_false

--lunit.suite("TestClass")

--TestClass = {}
--function TestClass.testItShouldStopHeatingWhenTemperatureExceedThresholdPlusHysteresis()
    function testItShouldStopHeatingWhenTemperatureExceedThresholdPlusHysteresis()
        local temp = 20
        local hysteresis = .5
        local setPoint = 19
        assert_false(heating.isHeatingOn(temp, setPoint, hysteresis))
    end
    
    function testItShouldStartHeatingWhenTemperatureIsBelowThresholdMinusHysteresis()
        local temp = 20
        local hysteresis = .5
        local setPoint = 21
        assert_true(heating.isHeatingOn(temp, setPoint, hysteresis))
    end

--oo
--    _
--   / \   _
----/---\-/-\------------------------------------------------------
-- /         \
--/

    function testItShouldNotStopHeatingWhenTemperatureIsBelowThreshold()
        local temp = 20
        local hysteresis = .5
        local setPoint = 21
        assert_true(heating.isHeatingOn(temp, setPoint, hysteresis))
        temp = 21
        assert_true(heating.isHeatingOn(temp, setPoint, hysteresis))
        temp = 21.4
        assert_true(heating.isHeatingOn(temp, setPoint, hysteresis))
        temp = 21.5
        assert_false(heating.isHeatingOn(temp, setPoint, hysteresis))
    end

    function testEventPWMShouldStartHeating()
        local temp = {
            temperature = 20
        }
        local setPoint = {
            temperature = 21
        }
        local data = {
            temperatureReadings = {
                getLatest = function(p)
                    print(p)
                    return temp 
                end,
                add = function(val)
                    print(val)
                end
            }
        }
        local p = false
        local heat = {
            power = false,
            switchOn = function(self)
                print(self)
                p = true
            end,
            switchOff = function(self)
                print(self)
                p = false
            end
        }
        local domoticz = {
            devices = function(dev)
                if dev == 'Temp' then
                    return temp
                elseif dev == 'setPoint' then
                    return setPoint
                elseif dev == 'chauffage salon' then
                    return heat
                elseif dev == 'chauffage sam' then
                    return heat
                end
            end,
            data =  data
        }
        pwm.execute(domoticz)
        assert_true(p)
        temp.temperature = 21
        pwm.execute(domoticz)
        assert_false(p)
    end

lunit.run()