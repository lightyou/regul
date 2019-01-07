heating = {
    power = false
}

function heating.init()
end

function heating.isHeatingOn(temp, setPoint, hystersis)
    if temp <= (setPoint - hystersis) then
        heating.power = true
    elseif temp >= (setPoint + hystersis) then
        heating.power = false
    end
    return heating.power
end



return heating