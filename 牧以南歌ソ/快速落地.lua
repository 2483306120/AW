local tab = gui.Tab(gui.Reference("Ragebot"), "tab", "🐺快速落地")
local disable_auto_jump_inair = gui.Checkbox(tab, "Chicken.disable_auto_jump.air", "🐺可视范围内有敌人则禁用跳跃功能", false)
local auto_speedburst_in_air = gui.Checkbox(tab, "Chicken.auto_speedburst_in_air.air",
 "🐺可视范围内有敌人则快速从空中落地", false)

local has_target = false
callbacks.Register("AimbotTarget", function(t)
	has_target = t:GetIndex()
end)

callbacks.Register("CreateMove", function(cmd)
	local in_air_and_target = has_target and bit.band(entities.GetLocalPlayer():GetPropInt("m_fFlags"), 1) == 0
	
	if auto_speedburst_in_air:GetValue() and in_air_and_target then
		cheat.RequestSpeedBurst()
	end
	
	if disable_auto_jump_inair:GetValue() then
		gui.SetValue("misc.autojump", has_target and 0 or 1)
		gui.SetValue("misc.strafe.enable", not has_target)
	end
end)