local fpsonnade = gui.Checkbox(gui.Reference("Visuals", "Local", "Helper"), "fpsonnade", "🐺手持投掷物时自动切换第一人称", 0)
local tpso = false
local tpsmc = false
client.AllowListener( "item_equip" );
callbacks.Register("FireGameEvent", function(Event)
 if not gui.GetValue("esp.master") or not fpsonnade:GetValue() or Event:GetName() ~= "item_equip" then
 return
    end 
    if client.GetLocalPlayerIndex() == client.GetPlayerIndexByUserID( Event:GetInt("userid") ) then
        if (Event:GetInt("weptype") ~= 9 and not gui.GetValue("esp.local.thirdperson") and not tpso) then tpsmc = true return end
 if Event:GetInt("weptype") == 9 and gui.GetValue("esp.local.thirdperson") then
 gui.SetValue("esp.local.thirdperson", 0)
            tpso = true
            tpsmc = false
        elseif not tpsmc and Event:GetInt("weptype") ~= 9 then
 gui.SetValue("esp.local.thirdperson" , 1)
            tpso = false
 end       
 end 
end)