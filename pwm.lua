local HYSTERESIS = 0.5 -- temp has to drop this value below setpoint before boiler is on again
local SMOOTH_FACTOR = 3

local heating = require('heating')

return {
	active = true,
	on = {
		['timer'] = {
			'every minute'
		}
	},
	data = {
        temperatureReadings = { history = true, maxItems = SMOOTH_FACTOR }
    }
    ,execute = function(domoticz)
        local last_temperature = domoticz.data.temperatureReadings.getLatest(1)
        local temperature = domoticz.devices('Temp').temperature
        domoticz.data.temperatureReadings.add(temperature)
        local setpoint = domoticz.devices('setPoint').temperature
        local chauffage_salon = domoticz.devices('chauffage salon')
        local chauffage_sam = domoticz.devices('chauffage sam')
        if heating.isHeatingOn(temperature, setpoint, 0.5) then
            chauffage_salon.switchOn()
            chauffage_sam.switchOn()
        else
            chauffage_salon.switchOff()
            chauffage_sam.switchOff()
        end
    end
}
