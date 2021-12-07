local report_window = gui.Window("report", "🐺自动举报", 100, 100, 640, 310)
local start_box = gui.Groupbox(report_window, "🐺举报启动器", 10, 10, 200, 0)
local report_starter = gui.Checkbox(start_box, "starter", "启动举报", true)
local report_box = gui.Groupbox(report_window, "🐺设置", 10, 105, 200, 0 )
local report_delay = gui.Slider(report_box, "speed", "举报延迟 (秒)", 1, 0.2, 4)
local report_teammates = gui.Checkbox(report_box, "teammates", "举报队友", true)
local report_enemies = gui.Checkbox(report_box, "enemies", "举报敌人", true)
local report_for = gui.Groupbox(report_window, "🐺举报", 220, 10, 200, 0 )
local report_for_all =  gui.Checkbox(report_for, "for.all", "全部人", false)
local report_for_textabuse =  gui.Checkbox(report_for, "for.textabuse", "文本骚扰", false)
local report_for_griefing =  gui.Checkbox(report_for, "for.griefing", "恶意攻击队友", true)
local report_for_wallhack =  gui.Checkbox(report_for, "for.wallhack", "透视", true)
local report_for_aimbot =  gui.Checkbox(report_for, "for.aimbot", "自瞄", true)
local report_for_speedhack =  gui.Checkbox(report_for, "for.speedhack", "连跳脚本", true)
local report_by_event = gui.Groupbox(report_window, "🐺活动举报", 430, 10, 200, 0)
local report_everyone =  gui.Checkbox(report_by_event, "everyone", "向所有人举报", false)
local report_on_death =  gui.Checkbox(report_by_event, "on.death", "死亡举报", true)
local report_on_teamkill =  gui.Checkbox(report_by_event, "on.teamkill", "向恶意攻击队友的人举报", true)
local report_on_roundstart =  gui.Checkbox(report_by_event, "on.roundstart", "全面启动举报", true)

-- Variables
local i=1;
local Local_Index
local player
local report_tick = 0
local last_report = 10000
local Player_Index
local checker
local reported = {}
local reasons = {}
local report_on_death_running = false;

local function check_menu_state()
	if not gui.Reference("Menu"):IsActive() then
		report_window:SetInvisible(true)
	else
	report_window:SetInvisible(false)
	end	
end
callbacks.Register("Draw", 'check_menu_state', check_menu_state);


local function report_selections()
	reasons = {}
	if report_for_all:GetValue() then
		gui.SetValue("report.for.textabuse", true)		
		gui.SetValue("report.for.griefing", true)
		gui.SetValue("report.for.wallhack", true)		
		gui.SetValue("report.for.aimbot", true)		
		gui.SetValue("report.for.speedhack", true)		
	end

	if report_for_textabuse:GetValue() then
		table.insert(reasons, "textabuse")
	end
	if report_for_griefing:GetValue() then
		table.insert(reasons, "grief")
	end
	if report_for_wallhack:GetValue() then
		table.insert(reasons, "wallhack")
	end
	if report_for_aimbot:GetValue() then
		table.insert(reasons, "aimbot")
	end

	if report_for_speedhack:GetValue() then
		table.insert(reasons, "speedhack")
	end
	reasons = tostring(reasons)
end


client.AllowListener("player_death")
client.AllowListener("round_start")

callbacks.Register("FireGameEvent", function(event)
	if event:GetName() ~= "round_start" then
		return 
	end
	if report_starter:GetValue() == false or report_on_roundstart:GetValue() == false then
		return 
	end
	print("round started")
	reported = {}
	report_tick = 0
	last_report = 10000
	gui.SetValue("report.everyone", true)
end)



callbacks.Register("FireGameEvent", function(Event)
	if Event:GetName() ~= "player_death" then
		return 
	end	
	if client.GetPlayerIndexByUserID(Event:GetInt("userid")) ~= client.GetLocalPlayerIndex() then
		return 
	end
	if report_starter:GetValue() == false or report_on_death:GetValue() == false then
		return
	end
	report_selections();
	local killer_resources = entities.GetByUserID(Event:GetInt('attacker'))
	local killer_index = killer_resources:GetIndex()	
	Local_Index = client.GetLocalPlayerIndex()	
	Local_Player = entities.GetLocalPlayer()
	checker = globals.CurTime() - report_tick;
	if Local_Index == killer_index or client.GetPlayerInfo(killer_index)["IsBot"] == true or client.GetPlayerInfo(killer_index)["IsGOTV"] == true or checker < report_delay:GetValue() then
			return;
	end
	if killer_resources:GetTeamNumber() == Local_Player:GetTeamNumber() and report_on_teamkill:GetValue() == false then
		return
	end	
	panorama.RunScript(string.format([[GameStateAPI.SubmitPlayerReport(GameStateAPI.GetPlayerXuidStringFromEntIndex(%i),(%q));]],killer_index, reasons));
	report_tick = globals.CurTime()
end)


local function reporter()
		if report_starter:GetValue() and report_everyone:GetValue() then
		report_selections();
		local players = entities.FindByClass("CCSPlayer");
		Local_Index = client.GetLocalPlayerIndex()
		Local_Player = entities.GetLocalPlayer()
		player = players[i]
		Player_Index = player:GetIndex()
		checker = globals.CurTime() - report_tick;
		if report_teammates:GetValue() and Local_Index ~= Player_Index and client.GetPlayerInfo(Player_Index)["IsBot"] == false and client.GetPlayerInfo(Player_Index)["IsGOTV"] == false and reported[i] ~= true and checker > report_delay:GetValue() then
			if player:GetTeamNumber() == Local_Player:GetTeamNumber() then
				panorama.RunScript(string.format([[GameStateAPI.SubmitPlayerReport(GameStateAPI.GetPlayerXuidStringFromEntIndex(%i),(%q));]],Player_Index, reasons));
				report_tick = globals.CurTime()
				last_report = globals.CurTime()
				reported[i] = true;
			end
		end
		if report_enemies:GetValue() and Local_Index ~= Player_Index and client.GetPlayerInfo(Player_Index)["IsBot"] == false and client.GetPlayerInfo(Player_Index)["IsGOTV"] == false and reported[i] ~= true and checker > report_delay:GetValue() then
			if player:GetTeamNumber() ~= Local_Player:GetTeamNumber() then
				panorama.RunScript(string.format([[GameStateAPI.SubmitPlayerReport(GameStateAPI.GetPlayerXuidStringFromEntIndex(%i),(%q));]],Player_Index, reasons));
				report_tick = globals.CurTime()
				last_report = globals.CurTime()
				reported[i] = true;
			end
		end
		if i >= #players then
			i = 1
			return;
		else
			i = i + 1
		end
		if globals.CurTime() - last_report > 10 then
			gui.SetValue("report.everyone", false)
			reported = {}
			report_tick = 0
		end
	end
	
end
callbacks.Register("Draw", 'reporter', reporter)