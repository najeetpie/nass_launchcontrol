Config = {}
Config.RollingBurnout = true ---Allows linelock to end for a rolling burnout when close to tire temps
Config.Limiter = true --- allows vehicle to hit engine limiter on rolling burnout
Config.Cars = {
    --[GetHashKey("vehicle spawn name")] = {launchrpm = rpm the vehicle launches at, tractionControlValue = traction loss number(higher the number, higher the traction loss), lowSpeedTractionControlValue = low speed traction loss value(higher the number, higher the traction loss)
    [GetHashKey("comet7")] = {launchrpm = 5000, tractionControlValue = 3, lowSpeedTractionControlValue = 1.5},
}
