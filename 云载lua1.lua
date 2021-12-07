--自定义观看者列表
local draw = require and require "draw" or draw
local menu = gui.Reference("menu")

local spectators_win_h = 36
local spectators_icon =
    draw.CreateTexture(
    common.RasterizeSVG(
        [[<svg t="1632482623198" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="943" width="20" height="20"><path d="M670.036 177.44h0.198c107.59 0 194.794 87.303 194.794 194.978 0 47.378-17.032 91.88-46.536 126.497C925.208 565.727 994.56 701.09 994.56 852c0 11.173-0.377 22.292-1.126 33.339-1.23 18.137-16.301 32.221-34.48 32.221H833.13a461.441 461.441 0 0 1-5.526 48.41C824.69 983.305 809.682 996 792.104 996H71.896c-17.578 0-32.586-12.695-35.501-30.03C32.151 940.734 30 915.006 30 889c0-167.175 89.604-315.879 224.761-387.01C195.891 451.93 160 377.723 160 297c0-148.565 120.435-269 269-269 105.617 0 197.018 60.869 241.036 149.44z m23.648 71.307A270.587 270.587 0 0 1 698 297c0 75.568-31.452 145.458-83.827 195.164 2.107 4.506 3.17 9.375 3.225 14.243 119.641 66.648 201.947 194.9 214.833 342.033h93.194c-1.21-144.087-75.772-268.233-180.294-309.536-26.06-10.298-29.675-45.702-6.232-61.054 35.315-23.126 57.009-62.401 57.009-105.432 0-61.49-44.029-112.67-102.224-123.67z" p-id="944" fill="#cdcdcd"></path></svg>]]
    )
)


local spectators_win = gui.Window("newspectators", "🐺观察者列表", 20, 20, 200, spectators_win_h)
spectators_win:SetIcon(spectators_icon, 0.7)

local spectators_set = gui.Window("newspectators.set", "🐺设置", 20, 20, 160, 106)
local spectators_set_active = false

local g_name_clr = gui.ColorPicker(spectators_set, "nameclr", "名字颜色", 255, 255, 255, 255)
local g_show_avatar = gui.Checkbox(spectators_set, "showavatar", "显示当前观察者", 1)

local function clamp(val, min, max)
    return val > max and max or val < min and min or val
end

local fonts = {}
local function setup_font(name, size, dpi, width, out)
    local dpi = dpi or 1
    fonts[dpi] = fonts[dpi] or draw.CreateFont(name, size * dpi, width or 0, out or false)
    return draw.SetFont(fonts[dpi])
end

local alpha = {}
local function get_spectators(ent, fade)
    if not ent then
        return
    end
    local ent_idx = ent:GetIndex()
    local temp = {}

    for k, v in pairs(entities.FindByClass("CCSPlayer")) do
        local idx = v:GetIndex()
        if v:GetName() ~= "GOTV" then
            local observer_idx = v:GetPropEntity("m_hObserverTarget"):GetIndex()

            alpha[idx] = alpha[idx] or 0
            alpha[idx] =
                clamp(
                alpha[idx] + (observer_idx == ent_idx and not entities.GetPlayerResources():GetPropBool("m_bAlive", v:GetIndex()) and fade or -fade),
                0,
                1
            )

            if alpha[idx] ~= 0 then
                temp[#temp + 1] = {player = v, alpha = alpha[idx]}
            end
        end
    end
    return temp
end

local function setup_spectator()
    local spectators = {}

    callbacks.Register(
        "Draw",
        function()
            local lp = entities.GetLocalPlayer()
            local fade = globals.FrameTime() * 5
            spectators = get_spectators(lp, fade) or {}
            spectators_win:SetActive(#spectators > 0 or menu:IsActive())
        end
    )

    gui.Custom(
        spectators_win,
        "",
        0,
        -10,
        200,
        12,
        function(x1, y1, x2, y2, active)
            local lp = entities.GetLocalPlayer()

            local dpi = (gui.GetValue("adv.dpi") + 3) * 0.25
            local fade = globals.FrameTime() * 6

            local w, h = x2 - x1, y2 - y1

            local nr, ng, nb, na = g_name_clr:GetValue()

            setup_font("Bahnschrift", 15, dpi)

            spectators_win:SetHeight(spectators_win_h)

            for k, v in pairs(spectators) do
                local name = v.player:GetName()
                local name = #name > 20 and (name:sub(0, 20) .. "...") or name

                local tx, ty = x1 + 15 * dpi, y1 + 20 * dpi * k
                local tw, th = draw.GetTextSize(name)

                local ax, ay = x1 + 165 * dpi, y1 + 20 * dpi * k - 5 * dpi
                local aw, ah = ax + 20 * dpi, ay + 20 * dpi

                spectators_win:SetHeight(spectators_win_h + k * 20)

                draw.Color(255, 255, 255, v.alpha * 50)
                draw.SetScissorRect(tx, ty - 5 * dpi, w, (th + 15 * dpi) * v.alpha)

                do
                    if g_show_avatar:GetValue() then
                        local avatar = draw.GetSteamAvatar and draw.GetSteamAvatar(client.GetPlayerInfo(v.player:GetIndex()).SteamID, 1)
                        if avatar then
                            draw.Color(11, 11, 11, v.alpha * 255)
                            draw.ShadowRect(ax, ay, aw, ah, 3)
                            draw.Color(255, 255, 255, v.alpha * 255)
                            draw.SetTexture(avatar)
                            draw.FilledRect(ax + 1, ay + 1, aw - 1, ah - 1)
                            draw.SetTexture(nil)
                        else
                            draw.Color(11, 11, 11, v.alpha * 255)
                            draw.ShadowRect(ax, ay, aw, ah, 3)
                            draw.Color(34, 34, 34, v.alpha * 255)
                            draw.FilledRect(ax + 1, ay + 1, aw - 1, ah - 1)
                            draw.Color(255, 255, 255, v.alpha * 255)

                            draw.Text(aw - 13 * dpi, ah - 15 * dpi, "?")
                        end
                    end
                end

                draw.Color(nr, ng, nb, v.alpha * na)
                draw.Text(tx, ty, name)
            end

            draw.SetScissorRect(0, 0, draw.GetScreenSize())
        end
    )
end

setup_spectator()

local function intersect(x, y, w, h)
    local cx, cy = input.GetMousePos()
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

gui.Custom(
    spectators_win,
    "",
    0,
    -24,
    200,
    24,
    function(x1, y1, x2, y2, active)
        local dpi = (gui.GetValue("adv.dpi") + 3) * 0.25
        local w, h = x2 - x1, y2 - y1

        local sx, sy = gui.GetValue("newspectators.set")

        if intersect(x1, y1, w, h) and menu:IsActive() then
            draw.Color(255, 255, 255, 100)
            draw.Text(x1 + 5 * dpi, y1 - 14 * dpi, "右键单击可启用其他设置")
        end

        if intersect(x1, y1, w, h) and menu:IsActive() and input.IsButtonPressed(0x02) then
            local x, y = input.GetMousePos()
            spectators_set:SetPosX(x)
            spectators_set:SetPosY(y)
            spectators_set_active = true
        elseif not intersect(sx, sy, 160, 106) and active and input.IsButtonPressed(0x01) or input.IsButtonPressed(0x02) then
            spectators_set_active = false
        end

        if not spectators_win:IsActive() then
            spectators_set_active = false
        end

        spectators_set:SetActive(spectators_win:IsActive() and spectators_set_active)
    end
)


--自动举报
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


--电击枪警告
local zeus_svg =
    draw.CreateTexture(
    common.RasterizeSVG(
        '<svg id="svg" version="1.1" width="500" height="500" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ><g id="svgg"><path id="path0" d="M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 " stroke="none" fill="#fff200" fill-rule="evenodd"></path></g></svg>',
        0.04
    )
)
local function zeus_warn(builder)
    local ent = builder:GetEntity()
    local lp = entities.GetLocalPlayer()
    if
        ent:IsAlive() and ent:IsPlayer() and ent:GetTeamNumber() ~= lp:GetTeamNumber() and ent:GetPropEntity("m_hMyWeapons", "003"):GetName() and
            ent:GetPropEntity("m_hMyWeapons", "003"):GetName() == "weapon_taser"
     then
        if ent:GetWeaponID() == 31 then
            builder:Color(255, 0, 0, 255)
        else
            builder:Color(255, 242, 0, 255)
        end
        builder:AddIconLeft(zeus_svg)
    end
end
callbacks.Register("DrawESP", zeus_warn)


--敌方假蹲指示器
local storedTick = 0
local crouched_ticks = { }


local function toBits(num)
    local t = { }
    while num > 0 do
        rest = math.fmod(num,2)
        t[#t+1] = rest
        num = (num-rest) / 2
    end

    return t
end

callbacks.Register("DrawESP", "FD_Indicator", function(Builder)
    local g_Local = entities.GetLocalPlayer()
    local Entity = Builder:GetEntity()

   

    if g_Local == nil or Entity == nil or not Entity:IsAlive() then
        return
    end

    local index = Entity:GetIndex()
    local m_flDuckAmount = Entity:GetProp("m_flDuckAmount")
    local m_flDuckSpeed = Entity:GetProp("m_flDuckSpeed")
    local m_fFlags = Entity:GetProp("m_fFlags")

    if crouched_ticks[index] == nil then
        crouched_ticks[index] = 0
    end

    if m_flDuckSpeed ~= nil and m_flDuckAmount ~= nil then
        if m_flDuckSpeed == 8 and m_flDuckAmount <= 0.9 and m_flDuckAmount > 0.01 and toBits(m_fFlags)[1] == 1 then
            if storedTick ~= globals.TickCount() then
                crouched_ticks[index] = crouched_ticks[index] + 1
                storedTick = globals.TickCount()
            end

            if crouched_ticks[index] >= 5 then
                Builder:Color(255, 255, 0, 255)
                Builder:AddTextRight("FD")
            end
        else
            crouched_ticks[index] = 0
        end
    end
end)


--抖腿
--gui
local legshaking = gui.Checkbox(gui.Reference("Misc","Movement","Other"),"legfucker","🐺抖腿", false)
local legshakingtime = gui.Slider(gui.Reference("Misc","Movement","Other"), "legshaking.time", "抖腿间隔", 0.00, 0.00, 0.2, 0.01)

--var
local time = globals.CurTime()
local state = true

--function

local function Onlegshaking()
    if globals.CurTime() > time then
        state = not state
        time = globals.CurTime() + legshakingtime:GetValue()
        entities.GetLocalPlayer():SetPropInt(0, "m_flPoseParameter")
    end
    gui.SetValue("misc.slidewalk", state)
end

--callbacks
callbacks.Register("Draw", function()

    if entities.GetLocalPlayer() and legshaking:GetValue() then 
        entities.GetLocalPlayer():SetPropInt(1, "m_flPoseParameter")
        Onlegshaking()
    end
end)
--抖腿

--gui
local legshaking = gui.Checkbox(gui.Reference("Misc","Movement","Other"),"legfucker","🐺抖腿", false)
local legshakingtime = gui.Slider(gui.Reference("Misc","Movement","Other"), "legshaking.time", "抖腿间隔", 0.00, 0.00, 0.2, 0.01)

--var
local time = globals.CurTime()
local state = true

--function

local function Onlegshaking()
    if globals.CurTime() > time then
        state = not state
        time = globals.CurTime() + legshakingtime:GetValue()
        entities.GetLocalPlayer():SetPropInt(0, "m_flPoseParameter")
    end
    gui.SetValue("misc.slidewalk", state)
end

--callbacks
callbacks.Register("Draw", function()

    if entities.GetLocalPlayer() and legshaking:GetValue() then 
        entities.GetLocalPlayer():SetPropInt(1, "m_flPoseParameter")
        Onlegshaking()
    end
end)



--按键绑定弹窗版

local menu = gui.Reference("Misc", "General", "Extra")
local menu = gui.Checkbox(menu, "Aimware", "🐺打开按键列表", true);
mgWindow = gui.Window("muguoWindow", "🐺Aimware 2.0", 100, 50, 500, 500);
gui.Text( mgWindow, "------------------------------------\n按键列表\n------------------------------------\nF7\t\t绿演(触发键Mouse4)\nF8\t\t红演(合法)\nF9\t\t红演(暴力)\nF11\t\t低头摇\nF1\t\t自动穿墙\nI\t\t\t普通视觉(Fps偏低)\nO\t\t线条视觉\t(Fps大幅度提升)\nT\t\tAwp强制Baim(只对Awp有效)\nN\t\t点位助手+暴力投掷点\nH\t\t不抬头\nL\t\t鬼探头\nP\t\t假延迟\nAlt\t\t假蹲\nZXC\t左后右藏头\nshift\t慢走(不容易被抓头)\nM4\t\tautopeek\nM5\t伤害覆盖\nCap\tDT\n -----------------------------------\n更新时间：2021年12月4日\n------------------------------------\n⠄⠄⠄⢰⣧⣼⣯⠄⣸⣠⣶⣶⣦⣾⠄⠄⠄⠄⡀⠄⢀⣿⣿⠄⠄⠄⢸⡇⠄⠄\n  ⠄⠄⠄⣾⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄\n ⠄⠄⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄\n ⠄⠄⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄\n ⠄⢀⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰\n ⠄⣼⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤\n ⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗\n ⢀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄\n ⢸⣿⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄\n ⠘⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃⠄\n ⠄⠘⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃⠄⠄\n ⠄⠄⠈⠻⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁⠄⠄⠄\n ⠄⠄⠄⠄⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛⠁⠄⠄⠄⠄⠄\n ⠄⠄⠄⠄⠄⠄⠄⠉⠻⣿⣿⣾⣦⡙⠻⣷⣾⣿⠃⠿⠋⠁⠄⠄⠄⠄⠄⢀⣠⣴\n ⣿⣿⣿⣶⣶⣮⣥⣒⠲⢮⣝⡿⣿⣿⡆⣿⡿⠃⠄⠄⠄⠄⠄⠄⠄⣠⣴⣿⣿⣿ \n")

menu:SetDescription("显示功能绑定按键")

function muguo_Window()
    if(menu:GetValue() == true) then
      mgWindow:SetActive(gui.Reference("MENU"):IsActive())
    end
    if(menu:GetValue() == false) then
      mgWindow:SetActive(false)
    end
end


callbacks.Register('Draw', 'huizhif', huizhif);
callbacks.Register('Draw', 'muguo_Window', muguo_Window);

--baim击杀指示器
local damageTable = {
	[1] = { 38, 0.9320 }, -- deagle
	[2] = { 15, 0.5750 }, -- elites
	[3] = { 20, 0.9115 }, -- five seven
	[4] = { 11, 0.4700 }, -- glock
	[7] = { 27, 0.7750 }, -- ak47
	[8] = { 24, 0.9000 }, -- aug
	[9] = { 110, 0.9750 }, -- awp
	[10] = { 19, 0.7000 }, -- famas
	[11] = { 63, 0.8250 }, -- g3sg1
	[13] = { 22, 0.7750 }, -- galil
	[14] = { 24, 0.8000 }, -- m249
	[16] = { 22, 0.7000 }, -- m4a4
	[17] = { 14, 0.5750 }, -- mac10
	[19] = { 14, 0.6900 }, -- p90
	[23] = { 13, 0.6250 }, -- mp5
	[24] = { 14, 0.6500 }, -- ump
	[25] = { 110, 0.8000 }, -- xm1014
	[26] = { 12, 0.6000 }, -- bizon
	[27] = { 200, 0.7500 }, -- mag7
	[28] = { 23, 0.7100 }, -- negev
	[29] = { 200, 0.7500 }, -- sawed off
	[30] = { 20, 0.9015 }, -- tec9
	[31] = { 500, 1.0000 }, -- taser
	[32] = { 15, 0.5050 }, -- hkp2000
	[33] = { 13, 0.6250 }, -- mp7
	[34] = { 12, 0.6000 }, -- mp9
	[35] = { 200, 0.5000 }, -- nova
	[36] = { 20, 0.6400 }, -- p250
	[38] = { 63, 0.8250 }, -- scar20
	[39] = { 29, 1.0000 }, -- sg556
	[40] = { 72, 0.8500 }, -- ssg08
	[59] = { 26, 0.7000 }, -- m4a1-s
	[60] = { 15, 0.5050 }, -- usp-s
	[63] = { 18, 0.7765 }, -- cz75
	[64] = { 72, 0.9320 } -- revolver
}

local lethalEnemies = { }

callbacks.Register("CreateMove", function(UserCmd)
	lethalEnemies = { }
	
	local localPlayer = entities.GetLocalPlayer()
	local localPlayerTeam = localPlayer:GetTeamNumber()
	local localPlayerHealth = localPlayer:GetHealth()
	local localPlayerHasArmor = localPlayer:GetProp("m_ArmorValue") > 0
	local localPlayerDamageTable = damageTable[localPlayer:GetWeaponID()]
	for i = 1, globals.MaxClients() do
		local currentEntity = entities.GetByIndex(i)
		if currentEntity ~= nil then
			if currentEntity:IsPlayer() and currentEntity:IsAlive() and currentEntity:GetTeamNumber() ~= localPlayerTeam then
				-- 0 = not lethal
				-- 1 = enemy lethal to us
				-- 2 = we're lethal to enemy
				-- 3 = both
				local lethalMode = 0
				local weaponDamageTable = damageTable[currentEntity:GetWeaponID()]
				if weaponDamageTable ~= nil then
					if ((weaponDamageTable[1] * 1.25) * (localPlayerHasArmor and weaponDamageTable[2] or 1)) >= localPlayerHealth then
						lethalMode = 1
					end					
				end
				
				if localPlayerDamageTable ~= nil then
					if ((localPlayerDamageTable[1] * 1.25) * ((currentEntity:GetProp("m_ArmorValue") > 0) and localPlayerDamageTable[2] or 1)) >= currentEntity:GetHealth() then
						lethalMode = lethalMode + 2
					end
				end
				
				if lethalMode ~= 0 then
					lethalEnemies[#lethalEnemies + 1] = { currentEntity, lethalMode }
				end
			end
		end
	end
end)

callbacks.Register("DrawESP", function(EspBuilder)
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end

	for i = 1, #lethalEnemies do
		local currentLethalEnemy = lethalEnemies[i]
		if currentLethalEnemy[1]:GetIndex() == EspBuilder:GetEntity():GetIndex() then
			local lethalMode = currentLethalEnemy[2]
			local currentColor = { 0, 0, 0, 255 }
			if lethalMode == 1 then
				currentColor[1] = 255
			elseif lethalMode == 2 then
				currentColor[2] = 255
			elseif lethalMode == 3 then
				currentColor[1] = 255
				currentColor[2] = 255
			end
			
			EspBuilder:Color(currentColor[1], currentColor[2], currentColor[3], currentColor[4])
			EspBuilder:AddTextRight("Baim")
		end
	end
end)



--FPS指示器
--region fps
local frametimes = {}
local fps_prev = 0
local last_update_time = 0
local function accumulate_fps()
    local rt, ft = globals.RealTime(), globals.AbsoluteFrameTime()

    if ft > 0 then
        table.insert(frametimes, 1, ft)
    end

    local count = #frametimes
    if count == 0 then
        return 0
    end

    local accum = 0
    local i = 0
    while accum < 0.5 do
        i = i + 1
        accum = accum + frametimes[i]
        if i >= count then
            break
        end
    end

    accum = accum / i

    while i < count do
        i = i + 1
        table.remove(frametimes)
    end

    local fps = 1 / accum
    local time_since_update = rt - last_update_time
    if math.abs(fps - fps_prev) > 4 or time_since_update > 1 then
        fps_prev = fps
        last_update_time = rt
    else
        fps = fps_prev
    end

    return math.floor(fps + 0.5)
end
--end region

--region renderer
local renderer = {}
renderer.rectangle = function(x, y, w, h, clr, fill, radius)
    local alpha = 255
    if clr[4] then
        alpha = clr[4]
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    if fill then
        draw.FilledRect(x, y, x + w, y + h)
    else
        draw.OutlinedRect(x, y, x + w, y + h)
    end
    if fill == "s" then
        draw.ShadowRect(x, y, x + w, y + h, radius)
    end
end

renderer.gradient = function(x, y, w, h, clr, clr1, vertical)
    local r, g, b, a = clr1[1], clr1[2], clr1[3], clr1[4]
    local r1, g1, b1, a1 = clr[1], clr[2], clr[3], clr[4]

    if a and a1 == nil then
        a, a1 = 255, 255
    end

    if vertical then
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x, y + w - i, w, 1, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, h do
                renderer.rectangle(x, y + i, w, 1, {r, g, b, i / h * a}, true)
            end
        end
    else
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x + w - i, y, 1, h, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, w do
                renderer.rectangle(x + i, y, 1, h, {r, g, b, i / w * a}, true)
            end
        end
    end
end
--end region

--region draw
--@On draw
local font = draw.CreateFont("Verdana", 12)
local font2 = draw.CreateFont("Verdana", 10)
local function on_draw()
    local lp = entities.GetLocalPlayer()
    if not lp then
        return
    end
    if not lp:IsAlive() then
        return
    end

    local screen_w, screen_h = draw.GetScreenSize()
    local screen_w = math.floor(screen_w * 0.5 + 0.5)
    local screen_h = screen_h - 20

    renderer.gradient(screen_w - 300, screen_h, 189, 20, {30, 30, 30, 0}, {30, 30, 30, 220}, nil)
    draw.Color(30, 30, 30, 220)
    draw.FilledRect(screen_w - 110, screen_h, screen_w + 110, screen_h + 20)
    renderer.gradient(screen_w + 110, screen_h, 190, 20, {30, 30, 30, 220}, {30, 30, 30, 0}, nil)
    renderer.gradient(screen_w - 200, screen_h, 199, 1, {0, 0, 0, 0}, {0, 0, 0, 100}, nil)
    renderer.gradient(screen_w, screen_h, 200, 1, {0, 0, 0, 100}, {0, 0, 0, 0}, nil)

    local fps = accumulate_fps()
    local ping = entities.GetPlayerResources():GetPropInt("m_iPing", lp:GetIndex())
    local velocity_x = lp:GetPropFloat("localdata", "m_vecVelocity[0]")
    local velocity_y = lp:GetPropFloat("localdata", "m_vecVelocity[1]")
    local velocity = math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
    local final_velocity = math.min(9999, velocity) + 0.2

    local r, g, b
    if ping < 40 then
        r, g, b = 159, 202, 43
    elseif ping < 80 then
        r, g, b = 255, 222, 0
    else
        r, g, b = 255, 0, 60
    end
    draw.SetFont(font)
    draw.Color(r, g, b, 255)
    local ping_w = draw.GetTextSize(ping)
    draw.Text(screen_w - 86 - ping_w, screen_h + 5, ping)

    local tickrate = 1 / globals.TickInterval()
    if fps < tickrate then
        r, g, b = 255, 0, 60
    else
        r, g, b = 159, 202, 43
    end
    draw.Color(r, g, b, 255)
    local fps_w = draw.GetTextSize(fps)
    draw.Text(screen_w - fps_w, screen_h + 5, fps)

    draw.Color(255, 255, 255, 255)
    local speed_w = draw.GetTextSize(math.floor(final_velocity))
    draw.Text(screen_w + 77 - speed_w, screen_h + 5, math.floor(final_velocity))

    draw.SetFont(font2)
    draw.Color(255, 255, 255, 150)
    draw.Text(screen_w - 84, screen_h + 8, "PING")
    draw.Text(screen_w + 2, screen_h + 8, "FPS")
    draw.Text(screen_w + 80, screen_h + 8, "SPEED")
end
callbacks.Register("Draw", on_draw)



--敌人弹药显示
callbacks.Register("DrawESP", function(esp)

    local e = esp:GetEntity();
    if (e:IsPlayer() ~= true or entities.GetLocalPlayer():GetTeamNumber() == e:GetTeamNumber()) or not e:IsAlive() then return end
    esp:Color(249,255,0)
    ActiveWeapon = e:GetPropEntity("m_hActiveWeapon")
    esp:AddTextBottom("" .. ActiveWeapon:GetProp("m_iClip1") .. "/" .. ActiveWeapon:GetProp("m_iPrimaryReserveAmmoCount") )

end)



--敌方击杀显示
local killArray = {}
local guiref = gui.Reference("Visuals","Overlay","Enemy")
local recentkillcheck = gui.Checkbox(guiref, "🐺敌人最近击杀", "🐺敌人最近击杀", 0)
local recentkilltime = gui.Slider(guiref, "🐺敌人最近击杀保留时间", "🐺敌人最近击杀保留时间", 5, 1, 30)
local iconcolor = gui.ColorPicker( guiref, "iconcolor", "     颜色", 240, 60, 30, 255)
local killTexture = draw.CreateTexture(common.RasterizeSVG('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 32 32"><g><path fill-rule="evenodd" clip-rule="evenodd" fill="#FFF" d="M15.5-4.2l0.75-1.05l1-3.1l3.9-2.65v-0.05 c0.067-0.1,0.1-0.233,0.1-0.4c0-0.2-0.05-0.383-0.15-0.55c-0.167-0.233-0.383-0.35-0.65-0.35l-4.3,1.8l-1.2,1.65l-1.5-3.95 l2.25-5.05l-3.25-6.9c-0.267-0.2-0.633-0.3-1.1-0.3c-0.3,0-0.55,0.15-0.75,0.45c-0.1,0.133-0.15,0.25-0.15,0.35 c0,0.067,0.017,0.15,0.05,0.25c0.033,0.1,0.067,0.184,0.1,0.25l2.55,5.6L10.7-14l-3.05-4.9L0.8-18.7 c-0.367,0.033-0.6,0.184-0.7,0.45c-0.067,0.3-0.1,0.467-0.1,0.5c0,0.5,0.2,0.767,0.6,0.8l5.7,0.15l2.15,5.4l3.1,5.65L9.4-5.6 c-1.367-2-2.1-3.033-2.2-3.1C7.1-8.8,6.95-8.85,6.75-8.85C6.35-8.85,6.1-8.667,6-8.3C5.9-8,5.9-7.8,6-7.7H5.95l2.5,4.4l3.7,0.3 L14-3.5L15.5-4.2z M14.55-2.9c-0.333,0.4-0.45,0.85-0.35,1.35c0.033,0.5,0.25,0.9,0.65,1.2S15.7,0.066,16.2,0 c0.5-0.067,0.9-0.3,1.2-0.7c0.333-0.4,0.467-0.85,0.4-1.35c-0.066-0.5-0.3-0.9-0.7-1.2c-0.4-0.333-0.85-0.45-1.35-0.35 C15.25-3.533,14.85-3.3,14.55-2.9z"/><path fill-rule="evenodd" clip-rule="evenodd" fill="#FFF" d="M28.443,16.724c0.02-1.733-0.59-1.772-0.629-2.835 c-0.021-0.532,0.044-2.025,0-3.464c-0.045-1.434-0.198-2.817-0.315-3.15c-0.236-0.669-0.504-1.773-2.52-3.465 c-2.206-1.851-6.459-3.426-8.82-3.465c-2.363-0.04-5.119,1.142-7.246,2.52c-2.126,1.378-2.638,1.969-3.464,3.15 c-0.828,1.181-1.143,2.008-0.946,4.095c0.197,2.087,0.244,1.537,0.315,3.465c0.06,1.595-0.665,2.088-0.63,3.15 c0.052,1.587,0.648,1.916,0.63,2.52c-0.013,0.396-0.709,0.893-0.63,2.205c0.08,1.336,0.354,1.693,2.835,3.15 c1.61,0.945,3.504,1.299,3.465,1.89c-0.058,0.865-0.275,2.284-0.314,3.15c-0.039,0.866,0.354,0.945,1.259,1.26 c0.907,0.315,3.032,0.984,5.356,0.945c2.323-0.04,3.308-0.512,4.41-0.945c1.102-0.433,1.26-0.827,1.26-1.575 c0-0.748-0.63-2.283-0.63-2.835c0-0.551,1.89-1.142,4.095-2.205c2.206-1.063,2.18-2.125,2.206-2.835 c0.047-1.338-0.631-1.653-0.631-2.205C27.499,18.168,28.431,17.984,28.443,16.724z M9.858,19.874 c-1.103,0.04-3.465,0.04-3.465-3.15c0-4.419,2.362-4.922,4.095-5.04c1.733-0.118,1.969-0.315,2.836,0.315 c1.556,1.132,1.456,3.137,0.944,4.725c-0.375,1.163-0.788,1.614-1.575,2.205S10.961,19.834,9.858,19.874z M17.104,24.914 l-0.434-1.608L16,23.313l-0.472,1.602c-1.812-0.492-2.54-1.22-2.52-2.205c0.02-0.984,0.571-2.008,1.574-2.835 c1.005-0.827,1.167-0.955,1.891-0.945c0.691,0.01,0.752,0.144,1.26,0.63c1.097,1.051,1.807,1.751,1.891,3.15 C19.706,24.086,18.107,24.855,17.104,24.914z M22.773,19.874c-1.103-0.04-2.047-0.354-2.835-0.945 c-0.787-0.591-1.252-1.027-1.575-2.205c-0.407-1.483-0.61-3.593,0.946-4.725c0.866-0.63,1.102-0.433,2.835-0.315 c1.731,0.118,4.095,0.621,4.095,5.04C26.239,19.914,23.876,19.914,22.773,19.874z"/></g></svg>'))

recentkillcheck:SetDescription("")
recentkilltime:SetDescription("")
iconcolor:SetPosY(1197)
iconcolor:SetPosX(-10)

local function round(n, d)
    local p = 10^d
    return math.floor(n*p)/p
end

local function death_event(event)
	lPlayer = entities.GetLocalPlayer()
	if lPlayer == nil then return end
	lPlayerTeam = lPlayer:GetTeamNumber()
	
	if event:GetName() == "player_death" then 
		local attacker = event:GetInt("attacker") 
		local victim = event:GetInt("userid")
		local attackerIndex = client.GetPlayerIndexByUserID(attacker)
		local victimIndex = client.GetPlayerIndexByUserID(victim)
		local attackerEntID = entities.GetByUserID(attacker)
		local victimEntID = entities.GetByUserID(victim)
		local attackerTeam = attackerEntID:GetTeamNumber()
		local victimTeam = victimEntID:GetTeamNumber()
		local attackerPlayerInfo = client.GetPlayerInfo(attackerIndex)
		local victimPlayerInfo = client.GetPlayerInfo(victimIndex)
		local attackerSteamID = attackerPlayerInfo["SteamID"]
		local victimSteamID = victimPlayerInfo["SteamID"]
		local CurTime = globals.CurTime()

		if attackerTeam ~= lPlayerTeam and attackerTeam ~= victimTeam then
			if killArray[attackerSteamID] == nil then
				killArray[attackerSteamID] = {CurTime, attackerSteamID}
			else
				killArray[attackerSteamID][1] = CurTime
			end
		end
	end
	if event:GetName() == "cs_win_panel_match" then
		killArray = {}
	end
end
callbacks.Register("FireGameEvent", "death_event", death_event)
client.AllowListener("player_death")
client.AllowListener("cs_win_panel_match")

local function killDraw(builder)
	local CurTime = globals.CurTime()

	local entID = builder:GetEntity()
	if entID == nil then return end
	builder:Color(iconcolor:GetValue())

	if entID:GetClass() == "CCSPlayer" and recentkillcheck:GetValue() == true then
		local entIndex = entID:GetIndex()
		local entPlayerInfo = client.GetPlayerInfo(entIndex)
		local entSteamID = entPlayerInfo["SteamID"]
		for i, v in pairs(killArray) do
			if v[2] == entSteamID then
				local lastKillTime =  round(CurTime - v[1], 3)
				if lastKillTime <= recentkilltime:GetValue() then
					builder:AddIconTop(killTexture)
				end
			end
		end
	end
end
callbacks.Register("DrawESP", "killDraw", killDraw)



--Tab装备显示
local console_handlers = {}
function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c)
		fields[#fields + 1] = c
	end)
	return fields
end
local weapon_type_int = {
	1,
	1,
	1,
	1,
	[7] = 3,
	[8] = 3,
	[9] = 5,
	[10] = 3,
	[11] = 5,
	[13] = 3,
	[14] = 6,
	[16] = 3,
	[17] = 2,
	[19] = 2,
	[20] = 19,
	[23] = 2,
	[24] = 2,
	[25] = 4,
	[26] = 2,
	[27] = 4,
	[28] = 6,
	[29] = 4,
	[30] = 1,
	[31] = 0,
	[32] = 1,
	[33] = 2,
	[34] = 2,
	[35] = 4,
	[36] = 1,
	[37] = 19,
	[38] = 5,
	[39] = 3,
	[40] = 5,
	[41] = 0,
	[42] = 0,
	[43] = 9,
	[44] = 9,
	[45] = 9,
	[46] = 9,
	[47] = 9,
	[48] = 9,
	[49] = 7,
	[50] = 19,
	[51] = 19,
	[52] = 19,
	[55] = 19,
	[56] = 19,
	[57] = 11,
	[59] = 0,
	[60] = 3,
	[61] = 1,
	[63] = 1,
	[64] = 1,
	[68] = 9,
	[69] = 12,
	[70] = 13,
	[72] = 15,
	[74] = 16,
	[75] = 16,
	[76] = 16,
	[78] = 16,
	[80] = 0,
	[81] = 9,
	[82] = 9,
	[83] = 9,
	[84] = 9,
	[85] = 14,
	[500] = 0,
	[503] = 0,
	[505] = 0,
	[506] = 0,
	[507] = 0,
	[508] = 0,
	[509] = 0,
	[512] = 0,
	[514] = 0,
	[515] = 0,
	[516] = 0,
	[517] = 0,
	[518] = 0,
	[519] = 0,
	[520] = 0,
	[521] = 0,
	[522] = 0,
	[523] = 0,
	[525] = 0
}
local wep_type = {taser = 0, knife = 0, pistol = 1, smg = 2, rifle = 3, shotgun = 4, sniperrifle = 5, machinegun = 6, c4 = 7, grenade = 9, stackableitem = 11, fists = 12, breachcharge = 13, bumpmine = 14, tablet = 15, melee = 16, equipment = 19}
local function getWeaponType(wepIdx)
	local typeInt = weapon_type_int[tonumber(wepIdx)]
	for index, value in pairs(wep_type) do
		if value == typeInt then
			return index ~= 0 and index or (tonumber(wepIdx) == 31 and "taser" or "knife")
		end
	end
end

local function register_console_handler(command, handler, force)
	if console_handlers[command] and not force then
		return false
	end
	console_handlers[command] = handler
	return true
end
-- Console input
callbacks.Register("SendStringCmd", "lib_console_input", function(c)
	local raw_console_input = c:Get() -- Maximum 255 chars
	local parsed_console_input = raw_console_input:split(" ")
	local command = table.remove(parsed_console_input, 1)
	local str = ""
	for index, value in ipairs(parsed_console_input) do
		str = str .. value .. " "
	end
	if console_handlers[command] and console_handlers[command](str:sub(1, -2)) then
		c:Set("\0")
	end
end)
local main = [====[
	if (typeof(SClient) == 'undefined' && $.GetContextPanel().id == "CSGOHud") {
        SClient = (function () {
            $.Msg("Scoreboard Weapon injected successfully! Welcome : " + MyPersonaAPI.GetName())
            var handlers = {}
            let registerHandler = function (type, callback) {
                handlers[type] = callback
            }
            let receivedHandler = function (message) {
                if (handlers[message.type]) {
                    handlers[message.type](message)
                }
            }
            return {
                register_handler: registerHandler,
                receive: receivedHandler
            }
        })()
    }
    if ($.GetContextPanel().id == "CSGOHud") { $.Schedule(1, ()=>{GameInterfaceAPI.ConsoleCommand("!panoCall e_PanelWeaponLoaded")}) }
    if (typeof(SImageManager) == 'undefined' && $.GetContextPanel().id == "CSGOHud") {
        SImageManager = (function () {
            var HashMap = function HashMap() {
                var length = 0;
                var obj = new Object();
                this.isEmpty = function () {
                    return length == 0;
                };
                this.containsKey = function (key) {
                    return (key in obj);
                };
                this.containsValue = function (value) {
                    for (var key in obj) {
                        if (obj[key] == value) {
                            return true;
                        }
                    }
                    return false;
                };
                this.put = function (key, value) {
                    if (!this.containsKey(key)) {
                        length++;
                    }
                    obj[key] = value;
                };
                this.get = function (key) {
                    return this.containsKey(key) ? obj[key] : null;
                };
                this.remove = function (key) {
                    if (this.containsKey(key) && (delete obj[key])) {
                        length--;
                    }
                };
                this.values = function () {
                    var _values = new Array();
                    for (var key in obj) {
                        _values.push(obj[key]);
                    }
                    return _values;
                };
                this.keySet = function () {
                    var _keys = new Array();
                    for (var key in obj) {
                        _keys.push(key);
                    }
                    return _keys;
                };
                this.size = function () {
                    return length;
                };
                this.clear = function () {
                    length = 0;
                    obj = new Object();
                };
            }
            var ImagePool = new HashMap()
            class ImageCell {
                constructor(xuid) {
                    var updating = false
                    var lastUpdateWep = ""
                    var lastUpdateHL = ""
                    var lastColor = ""
                    let primaryLut = ['smg', 'rifle', 'heavy']
                    let partInit = "<root><styles><include src='file://{resources}/styles/csgostyles.css'/><include src='file://{resources}/styles/scoreboard.css'/><include src='file://{resources}/styles/hud/hudweaponselection.css' /></styles><Panel style='margin-right:0px;flow-children:right;horizontal-align:right;'></Panel></root>"
                    this.getTargetXUID = () => {
                        return xuid
                    }
                    this.getTargetPanel = () => {
                        var panel
                        var par = $.GetContextPanel().FindChildTraverse("player-" + xuid)
                        if (!par)
                            return
                        var parent = par.FindChildTraverse("name")
                        if (!parent)
                            return
                        panel = parent.FindChildTraverse("CustomImagePanel")
                        if (!panel) {
                            panel = $.CreatePanel("Panel", parent, "CustomImagePanel")
                        }
                        return panel
                    }
                    this.getState = () => {
                        return updating
                    }
                    this.update = (color, equipments, alpha, hl) => {
                        let colorRGBtoHex = (color) => {
                            var rgb = color.split(',')
                            var r = parseInt(rgb[0])
                            var g = parseInt(rgb[1])
                            var b = parseInt(rgb[2])
                            var hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)
                            return hex
                        }
                        let targetColor = colorRGBtoHex(color)
                        let panel = this.getTargetPanel()
                        if (!panel) {return}
                        if (GameStateAPI.GetPlayerStatus(xuid) == 1) {
                            panel.RemoveAndDeleteChildren()
                            return
                        }
                        if (lastUpdateHL != hl || lastUpdateWep != equipments.toString() || lastColor != color) {
                            updating = true
                            panel.RemoveAndDeleteChildren()
                            panel.BLoadLayoutFromString(partInit, false, false)
                            let sortedEQ = []
                            let nades = []
                            let others = []
                            equipments.forEach((item)=>{
                                let curType = InventoryAPI.GetSlot(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(parseInt(item), 0))
                                if(curType == 'grenade'){
                                    nades.push(item)
                                } else if (curType == 'secondary') {
                                    nades.unshift(item)
                                } else if(primaryLut.includes(curType)) {
                                    sortedEQ.push(item)
                                } else {
                                    others.push(item)
                                }
                            })
                            sortedEQ.concat(nades).concat(others).forEach((item) => {
                                let cellPanel = $.CreatePanel("Panel", panel, "CustomPanelCell", {
                                    style: 'margin-right:3px; height:18px;'
                                })
                                let nameUnClipped = InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(parseInt(item), 0))
                                if (!nameUnClipped)
                                    return
                                $.CreatePanel("Image", cellPanel, "CustomImageCell", {
                                    scaling: 'stretch-to-fit-y-preserve-aspect',
                                    src: 'file://{images}/icons/equipment/' + nameUnClipped.replace( 'weapon_', '' ).replace('item_defuser', 'defuser') + '.svg',
                                    style: hl == item ? ('wash-color-fast: white;opacity:' + alpha + ';-s2-mix-blend-mode: normal;img-shadow: ' + targetColor + ' 1px 1px 1.5px 0.5;') : ('wash-color-fast: hsv-transform(#e8e8e8, 0, 0.96, 0.18);opacity:' + (alpha-0.02) + ';-s2-mix-blend-mode: normal;')
                                })
                            })
                        }
                        lastUpdateHL = hl
                        lastUpdateWep = equipments.toString()
                        lastColor = color
                        updating = false
                    }
                }
            }
            return {
                get_cache: (xuid) => {
                    if (ImagePool.containsKey(xuid)) {
                        return ImagePool.get(xuid)
                    } else {
                        return false
                    }
                },
                dispatch: (entid, color, alpha, weapons, hl) => {
                    let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entid)
                    if (ImagePool.containsKey(xuid)) {
                        var targetCell = ImagePool.get(xuid)
                        var waitForUpdate = () => {
                            if (targetCell.getState()){
                                $.Schedule(0.05, waitForUpdate)
                            } else {
                                targetCell.update(color, weapons, alpha, hl)
                            }
                        }
                        waitForUpdate()
                        return true
                    } else {
                        ImagePool.put(xuid, new ImageCell(xuid))
                        return false
                    }
                },
                destroy: () => {
                    ImagePool.clear()
                }
            }
        })()
        $.RegisterForUnhandledEvent("Scoreboard_OnEndOfMatch", SImageManager.destroy)
        $.RegisterForUnhandledEvent('CSGOShowMainMenu', SImageManager.destroy)
        $.RegisterForUnhandledEvent('OpenPlayMenu', SImageManager.destroy)
        $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ReadyUpForMatch', SImageManager.destroy)
        SClient.register_handler("updateWeapons", (message) => {
            if (!SImageManager.dispatch(message.content.xuid, message.content.colorSet, message.content.alpha, message.content.weapons, message.content.highLightWep)) {
                $.Schedule(0.5, () => {
                    SImageManager.dispatch(message.content.xuid, message.content.colorSet, message.content.alpha, message.content.weapons, message.content.highLightWep)
                })
            }
        }) 
    }
]====]
-- Client
local handlers = {}
local pending = {}
local Client = {
	updateWeapons = loadstring([=[
        return function(entid, color, alpha, weapons, highLight)
            if not weapons or #weapons == 0 then
                return
            end
            alpha = string.format("%1.3f", alpha / 255)
            local colorStr = "" .. tostring(color[1]) .. "," .. tostring(color[2]) .. "," .. tostring(color[3])
            local weaponsStr = ""
            for index, value in ipairs(weapons) do
                weaponsStr = weaponsStr .. "\"" .. value .. "\"" .. ","
            end
            weaponsStr = weaponsStr:sub(1, -2)
            local panoStr = string.format("if(typeof (SClient) != 'undefined') { SClient.receive(%s) }", string.format([[{type: "%s", content: %s}]], "updateWeapons", string.format([[{xuid: %s, colorSet: "%s", alpha: %s , weapons: [%s], highLightWep:"%s" }]], entid, colorStr, alpha, weaponsStr, highLight)))
            panorama.RunScript(panoStr)
        end
    ]=])(),
	receive = function(message)
		for index, value in ipairs(handlers) do
			if value(message) then
				return
			end
		end
	end,
	register_handler = function(callback)
		table.insert(handlers, callback)
	end
}
register_console_handler("!panoCall", function(args)
	Client.receive(args)
	return true
end, true)
local last_check_sec = 0
local loaded = false
callbacks.Register("Draw", "AWStrangePanoramaFixer", function()
	if loaded then
		return
	end
	local cur = string.format("%1.0f", tostring(globals.RealTime()))
	if last_check_sec ~= cur then
		panorama.RunScript(main)
		last_check_sec = cur
	end
end)
Client.register_handler(function(msg)
	if msg == "e_PanelWeaponLoaded" then
		loaded = true
		callbacks.Unregister("Draw", "AWStrangePanoramaFixer") -- Credit: squid for api correction
		return true
	end
end)
local enhancement = gui.Reference("Misc", "Enhancement", "Fakelatency")
local hudweapon_enable = gui.Checkbox(enhancement, "hudweapon.enabled", "🐺计分板显示持有武器", false)
local menu = {filter = gui.Multibox(enhancement, "显示筛选")}
local itemList = {"主武器", "副武器", "刀/电击枪", "投掷物", "C4炸弹", "拆弹器", "护甲", "其他"}
for index, value in ipairs(itemList) do
	menu["item_" .. index] = gui.Checkbox(menu.filter, "hudweapon.item_" .. index, value, false)
end
local hudweapon_color = gui.ColorPicker(enhancement, "hudweapon.color", "图标发光颜色", 136, 71, 255, 255)
local player_weapons = {}
for i = 0, 64 do
	player_weapons[i] = {}
end
gui.Button(enhancement, "手动清除缓存记录", function()
	for i = 0, 64 do
		player_weapons[i] = {}
	end
end)
local function filter_weapon(wepList)
	for index, value in ipairs(wepList) do
		local wepType = getWeaponType(value)
		if wepType == "smg" or wepType == "rifle" or wepType == "shotgun" or wepType == "sniperrifle" or wepType == "machinegun" then
			if not menu.item_1:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "pistol" then
			if not menu.item_2:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "taser" then
			if not menu.item_3:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "grenade" then
			if not menu.item_4:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "c4" then
			if not menu.item_5:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "defuser" then
			if not menu.item_6:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "armor" then
			if not menu.item_7:GetValue() then
				table.remove(wepList, index)
			end
		else
			if not menu.item_8:GetValue() then
				table.remove(wepList, index)
			end
		end
	end
	return wepList
end

local hl = {}
local function add_weapon(idx, weapon)
	if player_weapons and player_weapons[idx] and #player_weapons[idx] > 0 then
		for i = 1, #player_weapons[idx] do
			if player_weapons[idx][i] == weapon then
				return
			end
		end
	end
	table.insert(player_weapons[idx], weapon)
end

local function remove_weapon(idx, weapon)
	if #player_weapons[idx] > 0 then
		for i = 1, #player_weapons[idx] do
			if player_weapons[idx][i] == weapon then
				table.remove(player_weapons[idx], i)
			end
		end
	end
end

local function deep_compare(tbl1, tbl2)
	for key1, value1 in pairs(tbl1) do
		local value2 = tbl2[key1]
		if value2 == nil then
			return false
		elseif value1 ~= value2 then
			if type(value1) == "table" and type(value2) == "table" then
				if not deep_compare(value1, value2) then
					return false
				end
			else
				return false
			end
		end
	end
	for key2, _ in pairs(tbl2) do
		if tbl1[key2] == nil then
			return false
		end
	end
	return true
end

local lastUpdate = 0
callbacks.Register("Draw", "hud_weapon_render", function()
	if hudweapon_enable:GetValue() and entities.GetLocalPlayer() then
		local player_resource = entities.GetPlayerResources()
		local currentUpdatePlayer = globals.FrameCount() % 16
		if currentUpdatePlayer ~= lastUpdate then
			local function updateIdx(currentUpdatePlayer)
				local r, g, b, a = hudweapon_color:GetValue()
				local forced_index = math.floor(currentUpdatePlayer)
				local playerInfo = client.GetPlayerInfo(forced_index)
				if playerInfo and not playerInfo.IsGOTV then
					local player_ent = entities.GetByIndex(forced_index)
					if player_ent and not player_ent:IsDormant() then
						local current_player_data = {}
						local active_weapon = player_ent:GetWeaponID()
						if active_weapon ~= nil then
							if player_ent:GetPropInt("m_bHasDefuser") == 1 then
								table.insert(current_player_data, "55")
							end
							for slot = 0, 63 do
								local weapon_ent = player_ent:GetPropEntity("m_hMyWeapons", string.format("%0.3d", slot))
								if weapon_ent ~= nil then
									local wep_id = weapon_ent:GetWeaponID()
									if wep_id then
										table.insert(current_player_data, tostring(wep_id))
									end
								end
							end
						end
						if player_resource:GetPropInt("m_iArmor", player_ent:GetIndex()) > 0 then
							if player_resource:GetPropInt("m_bHasHelmet", player_ent:GetIndex()) == 1 then
								table.insert(current_player_data, "51")
							else
								table.insert(current_player_data, "50")
							end
						end
						Client.updateWeapons(forced_index, {r, g, b}, a, filter_weapon(current_player_data), tostring(active_weapon))
						return
					elseif player_weapons[forced_index] and #player_weapons[forced_index] > 0 then
						Client.updateWeapons(forced_index, {r, g, b}, a, filter_weapon(player_weapons[forced_index]), hl[forced_index])
						return
					elseif player_weapons[forced_index] and #player_weapons[forced_index] == 0 then
						Client.updateWeapons(player_ent:GetIndex(), {r, g, b}, a, {"dead"}, "dead")
					end
					if not player_ent:IsAlive() then
						Client.updateWeapons(player_ent:GetIndex(), {r, g, b}, a, {"dead"}, "dead")
					end
				end
			end
			updateIdx(currentUpdatePlayer)
			updateIdx(currentUpdatePlayer * 2)
			updateIdx(currentUpdatePlayer * 4)
		end
		lastUpdate = currentUpdatePlayer
	end
end)
client.AllowListener("item_equip")
client.AllowListener("item_pickup")
client.AllowListener("item_remove")
client.AllowListener("grenade_thrown")
client.AllowListener("player_death")
client.AllowListener("cs_game_disconnected")
client.AllowListener("cs_match_end_restart")
client.AllowListener("start_halftime")
client.AllowListener("game_newmap")
client.AllowListener("round_end")
client.AllowListener("bomb_dropped")
callbacks.Register("FireGameEvent", "hud_weapon_events", function(event)
	local eventName = event:GetName()
	if eventName then
		if eventName == "item_equip" then
			local entid = entities.GetByUserID(event:GetInt("userid")):GetIndex()
			local wepName = event:GetString("defindex")
			hl[entid] = wepName
		elseif eventName == "item_pickup" then
			add_weapon(entities.GetByUserID(event:GetInt("userid")):GetIndex(), event:GetString("defindex"))
		elseif eventName == "item_remove" then
			remove_weapon(entities.GetByUserID(event:GetInt("userid")):GetIndex(), event:GetString("defindex"))
		elseif eventName == "player_death" then
			if player_weapons then
				player_weapons[entities.GetByUserID(event:GetInt("userid")):GetIndex()] = {}
				Client.updateWeapons(entities.GetByUserID(event:GetInt("userid")):GetIndex(), {0, 0, 0}, 0, {"dead"}, "dead")
			end
		elseif eventName == "round_end" or eventName == "bomb_dropped" then
			for k, v in pairs(player_weapons) do
				remove_weapon(k, "49")
			end
		end
	end
end)



---esp圆环指示器



local OOV_always = gui.Checkbox(gui.Reference("Visuals", "Local", "Helper"),"OOV.always", "Consider FOV", false);
local OOV_color = gui.ColorPicker(gui.Reference("Visuals", "Local", "Helper"), "OOV.clr", "Out Of Viev Color", 255, 255, 255, 255)

local function bad_argument(expression, name, expected)
    assert(type(expression) == expected, " bad argument #1 to '%s' (%s expected, got %s)", 4, name, expected, tostring(type(expression)))
end

function circle_outline(x, y, r, g, b, a, radius, start_degrees, percentage, thickness, radian)
    bad_argument(x and y and radius and start_degrees and percentage and thickness, "circle_outline", "number")

    local thickness = radius - thickness
    local percentage = math.abs(percentage * 360)
    local radian = radian or 1

    draw.Color(r, g, b, a)

    for i = start_degrees + radian, start_degrees + percentage, radian do
        local cos_1 = math.cos(i * math.pi / 180)
        local sin_1 = math.sin(i * math.pi / 180)
        local cos_2 = math.cos((i + radian) * math.pi / 180)
        local sin_2 = math.sin((i + radian) * math.pi / 180)

        local x0 = x + cos_2 * thickness
        local y0 = y + sin_2 * thickness
        local x1 = x + cos_1 * radius
        local y1 = y + sin_1 * radius
        local x2 = x + cos_2 * radius
        local y2 = y + sin_2 * radius
        local x3 = x + cos_1 * thickness
        local y3 = y + sin_1 * thickness

        draw.Triangle(x1, y1, x2, y2, x3, y3)
        draw.Triangle(x3, y3, x2, y2, x0, y + sin_2 * thickness)
    end
end
local function clamp(val, min, max)
    if val > max then
        return max
    elseif val < min then
        return min
    else
        return val
    end
end

local alpha = {}
local players = {activity = {}}

local function Draw()
    local lp = entities.GetLocalPlayer()
    if not lp then return end

    local fade = ((1.0 / 0.15) * globals.FrameTime()) * 80
    local r, g, b, a = OOV_color:GetValue()

    local screen_size = {draw.GetScreenSize()}
    local screen_size_x = screen_size[1] * 0.5
    local screen_size_y = screen_size[2] * 0.5

    local out_of_view_scale = 15

    local temp = {}
    local lp_abs = lp:GetAbsOrigin()
    local view_angles = engine.GetViewAngles()

    local CCSPlayer = entities.FindByClass("CCSPlayer")
    for k, v in pairs(CCSPlayer) do
        local index = v:GetIndex()

        local v_abs = v:GetAbsOrigin()
        local dist = vector.Distance({v_abs.x, v_abs.y, v_abs.z}, {lp_abs.x, lp_abs.y, lp_abs.z})

        alpha[index] = alpha[index] or 0
        if players.activity[index] then
            alpha[index] = players[index] and lp:IsAlive() and clamp(alpha[index] + fade, 0, a) or clamp(alpha[index] - fade, 0, a)
        else
            alpha[index] =
                v:IsPlayer() and v:GetTeamNumber() ~= lp:GetTeamNumber() and v:IsAlive() and lp:IsAlive() and dist <= 1500 and
                clamp(alpha[index] + fade, 0, a) or
                clamp(alpha[index] - fade, 0, a)
        end

        if alpha[index] ~= 0 then
            table.insert(temp, CCSPlayer[k])
        end
        players[index] = nil
        players.activity[index] = nil
    end

    for k, v in pairs(temp) do
        local index = v:GetIndex()
        local v_abs = v:GetAbsOrigin()
		local psx,psy = client.WorldToScreen(v_abs);
        angle = (v_abs - lp_abs):Angles()
        angle.y = angle.y - view_angles.y
        for i = 1, 2, 0.2 do
            local alpha = i / 5 * alpha[index]
			
			if psx == nil and psy == nil or psx < 100 or psy < 100 or psx > screen_size_x+500 or psy > screen_size_y+100 or not OOV_always:GetValue() then					
            circle_outline(
                screen_size_x,
                screen_size_y,
                r,
                g,
                b,
                alpha,
                (125 + i),
                (270 - 0.13 * 170) - angle.y + (i * 0.2),
                0.075 + (i * 0.00005),
                (i * 2)
            )
			circle_outline(
                screen_size_x,
                screen_size_y,
                r,
                g,
                b,
                alpha,
                (130 + i),
                (270 - 0.13 * 170) - angle.y + (i * 0.2),
                0.075 + (i * 0.00005),
                (i * 0.5)
            )		
			end
        end
    end
end

callbacks.Register("Draw", Draw)
--baim击杀指示器
local damageTable = {
	[1] = { 38, 0.9320 }, -- deagle
	[2] = { 15, 0.5750 }, -- elites
	[3] = { 20, 0.9115 }, -- five seven
	[4] = { 11, 0.4700 }, -- glock
	[7] = { 27, 0.7750 }, -- ak47
	[8] = { 24, 0.9000 }, -- aug
	[9] = { 110, 0.9750 }, -- awp
	[10] = { 19, 0.7000 }, -- famas
	[11] = { 63, 0.8250 }, -- g3sg1
	[13] = { 22, 0.7750 }, -- galil
	[14] = { 24, 0.8000 }, -- m249
	[16] = { 22, 0.7000 }, -- m4a4
	[17] = { 14, 0.5750 }, -- mac10
	[19] = { 14, 0.6900 }, -- p90
	[23] = { 13, 0.6250 }, -- mp5
	[24] = { 14, 0.6500 }, -- ump
	[25] = { 110, 0.8000 }, -- xm1014
	[26] = { 12, 0.6000 }, -- bizon
	[27] = { 200, 0.7500 }, -- mag7
	[28] = { 23, 0.7100 }, -- negev
	[29] = { 200, 0.7500 }, -- sawed off
	[30] = { 20, 0.9015 }, -- tec9
	[31] = { 500, 1.0000 }, -- taser
	[32] = { 15, 0.5050 }, -- hkp2000
	[33] = { 13, 0.6250 }, -- mp7
	[34] = { 12, 0.6000 }, -- mp9
	[35] = { 200, 0.5000 }, -- nova
	[36] = { 20, 0.6400 }, -- p250
	[38] = { 63, 0.8250 }, -- scar20
	[39] = { 29, 1.0000 }, -- sg556
	[40] = { 72, 0.8500 }, -- ssg08
	[59] = { 26, 0.7000 }, -- m4a1-s
	[60] = { 15, 0.5050 }, -- usp-s
	[63] = { 18, 0.7765 }, -- cz75
	[64] = { 72, 0.9320 } -- revolver
}

local lethalEnemies = { }

callbacks.Register("CreateMove", function(UserCmd)
	lethalEnemies = { }
	
	local localPlayer = entities.GetLocalPlayer()
	local localPlayerTeam = localPlayer:GetTeamNumber()
	local localPlayerHealth = localPlayer:GetHealth()
	local localPlayerHasArmor = localPlayer:GetProp("m_ArmorValue") > 0
	local localPlayerDamageTable = damageTable[localPlayer:GetWeaponID()]
	for i = 1, globals.MaxClients() do
		local currentEntity = entities.GetByIndex(i)
		if currentEntity ~= nil then
			if currentEntity:IsPlayer() and currentEntity:IsAlive() and currentEntity:GetTeamNumber() ~= localPlayerTeam then
				-- 0 = not lethal
				-- 1 = enemy lethal to us
				-- 2 = we're lethal to enemy
				-- 3 = both
				local lethalMode = 0
				local weaponDamageTable = damageTable[currentEntity:GetWeaponID()]
				if weaponDamageTable ~= nil then
					if ((weaponDamageTable[1] * 1.25) * (localPlayerHasArmor and weaponDamageTable[2] or 1)) >= localPlayerHealth then
						lethalMode = 1
					end					
				end
				
				if localPlayerDamageTable ~= nil then
					if ((localPlayerDamageTable[1] * 1.25) * ((currentEntity:GetProp("m_ArmorValue") > 0) and localPlayerDamageTable[2] or 1)) >= currentEntity:GetHealth() then
						lethalMode = lethalMode + 2
					end
				end
				
				if lethalMode ~= 0 then
					lethalEnemies[#lethalEnemies + 1] = { currentEntity, lethalMode }
				end
			end
		end
	end
end)

callbacks.Register("DrawESP", function(EspBuilder)
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end

	for i = 1, #lethalEnemies do
		local currentLethalEnemy = lethalEnemies[i]
		if currentLethalEnemy[1]:GetIndex() == EspBuilder:GetEntity():GetIndex() then
			local lethalMode = currentLethalEnemy[2]
			local currentColor = { 0, 0, 0, 255 }
			if lethalMode == 1 then
				currentColor[1] = 255
			elseif lethalMode == 2 then
				currentColor[2] = 255
			elseif lethalMode == 3 then
				currentColor[1] = 255
				currentColor[2] = 255
			end
			
			EspBuilder:Color(currentColor[1], currentColor[2], currentColor[3], currentColor[4])
			EspBuilder:AddTextRight("Baim")
		end
	end
end)



--FPS指示器
--region fps
local frametimes = {}
local fps_prev = 0
local last_update_time = 0
local function accumulate_fps()
    local rt, ft = globals.RealTime(), globals.AbsoluteFrameTime()

    if ft > 0 then
        table.insert(frametimes, 1, ft)
    end

    local count = #frametimes
    if count == 0 then
        return 0
    end

    local accum = 0
    local i = 0
    while accum < 0.5 do
        i = i + 1
        accum = accum + frametimes[i]
        if i >= count then
            break
        end
    end

    accum = accum / i

    while i < count do
        i = i + 1
        table.remove(frametimes)
    end

    local fps = 1 / accum
    local time_since_update = rt - last_update_time
    if math.abs(fps - fps_prev) > 4 or time_since_update > 1 then
        fps_prev = fps
        last_update_time = rt
    else
        fps = fps_prev
    end

    return math.floor(fps + 0.5)
end
--end region

--region renderer
local renderer = {}
renderer.rectangle = function(x, y, w, h, clr, fill, radius)
    local alpha = 255
    if clr[4] then
        alpha = clr[4]
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    if fill then
        draw.FilledRect(x, y, x + w, y + h)
    else
        draw.OutlinedRect(x, y, x + w, y + h)
    end
    if fill == "s" then
        draw.ShadowRect(x, y, x + w, y + h, radius)
    end
end

renderer.gradient = function(x, y, w, h, clr, clr1, vertical)
    local r, g, b, a = clr1[1], clr1[2], clr1[3], clr1[4]
    local r1, g1, b1, a1 = clr[1], clr[2], clr[3], clr[4]

    if a and a1 == nil then
        a, a1 = 255, 255
    end

    if vertical then
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x, y + w - i, w, 1, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, h do
                renderer.rectangle(x, y + i, w, 1, {r, g, b, i / h * a}, true)
            end
        end
    else
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x + w - i, y, 1, h, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, w do
                renderer.rectangle(x + i, y, 1, h, {r, g, b, i / w * a}, true)
            end
        end
    end
end
--end region

--region draw
--@On draw
local font = draw.CreateFont("Verdana", 12)
local font2 = draw.CreateFont("Verdana", 10)
local function on_draw()
    local lp = entities.GetLocalPlayer()
    if not lp then
        return
    end
    if not lp:IsAlive() then
        return
    end

    local screen_w, screen_h = draw.GetScreenSize()
    local screen_w = math.floor(screen_w * 0.5 + 0.5)
    local screen_h = screen_h - 20

    renderer.gradient(screen_w - 300, screen_h, 189, 20, {30, 30, 30, 0}, {30, 30, 30, 220}, nil)
    draw.Color(30, 30, 30, 220)
    draw.FilledRect(screen_w - 110, screen_h, screen_w + 110, screen_h + 20)
    renderer.gradient(screen_w + 110, screen_h, 190, 20, {30, 30, 30, 220}, {30, 30, 30, 0}, nil)
    renderer.gradient(screen_w - 200, screen_h, 199, 1, {0, 0, 0, 0}, {0, 0, 0, 100}, nil)
    renderer.gradient(screen_w, screen_h, 200, 1, {0, 0, 0, 100}, {0, 0, 0, 0}, nil)

    local fps = accumulate_fps()
    local ping = entities.GetPlayerResources():GetPropInt("m_iPing", lp:GetIndex())
    local velocity_x = lp:GetPropFloat("localdata", "m_vecVelocity[0]")
    local velocity_y = lp:GetPropFloat("localdata", "m_vecVelocity[1]")
    local velocity = math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
    local final_velocity = math.min(9999, velocity) + 0.2

    local r, g, b
    if ping < 40 then
        r, g, b = 159, 202, 43
    elseif ping < 80 then
        r, g, b = 255, 222, 0
    else
        r, g, b = 255, 0, 60
    end
    draw.SetFont(font)
    draw.Color(r, g, b, 255)
    local ping_w = draw.GetTextSize(ping)
    draw.Text(screen_w - 86 - ping_w, screen_h + 5, ping)

    local tickrate = 1 / globals.TickInterval()
    if fps < tickrate then
        r, g, b = 255, 0, 60
    else
        r, g, b = 159, 202, 43
    end
    draw.Color(r, g, b, 255)
    local fps_w = draw.GetTextSize(fps)
    draw.Text(screen_w - fps_w, screen_h + 5, fps)

    draw.Color(255, 255, 255, 255)
    local speed_w = draw.GetTextSize(math.floor(final_velocity))
    draw.Text(screen_w + 77 - speed_w, screen_h + 5, math.floor(final_velocity))

    draw.SetFont(font2)
    draw.Color(255, 255, 255, 150)
    draw.Text(screen_w - 84, screen_h + 8, "PING")
    draw.Text(screen_w + 2, screen_h + 8, "FPS")
    draw.Text(screen_w + 80, screen_h + 8, "SPEED")
end
callbacks.Register("Draw", on_draw)



--敌人弹药显示
callbacks.Register("DrawESP", function(esp)

    local e = esp:GetEntity();
    if (e:IsPlayer() ~= true or entities.GetLocalPlayer():GetTeamNumber() == e:GetTeamNumber()) or not e:IsAlive() then return end
    esp:Color(249,255,0)
    ActiveWeapon = e:GetPropEntity("m_hActiveWeapon")
    esp:AddTextBottom("" .. ActiveWeapon:GetProp("m_iClip1") .. "/" .. ActiveWeapon:GetProp("m_iPrimaryReserveAmmoCount") )

end)



--敌方击杀显示
local killArray = {}
local guiref = gui.Reference("Visuals","Overlay","Enemy")
local recentkillcheck = gui.Checkbox(guiref, "🐺敌人最近击杀", "🐺敌人最近击杀", 0)
local recentkilltime = gui.Slider(guiref, "🐺敌人最近击杀保留时间", "🐺敌人最近击杀保留时间", 5, 1, 30)
local iconcolor = gui.ColorPicker( guiref, "iconcolor", "     颜色", 240, 60, 30, 255)
local killTexture = draw.CreateTexture(common.RasterizeSVG('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 32 32"><g><path fill-rule="evenodd" clip-rule="evenodd" fill="#FFF" d="M15.5-4.2l0.75-1.05l1-3.1l3.9-2.65v-0.05 c0.067-0.1,0.1-0.233,0.1-0.4c0-0.2-0.05-0.383-0.15-0.55c-0.167-0.233-0.383-0.35-0.65-0.35l-4.3,1.8l-1.2,1.65l-1.5-3.95 l2.25-5.05l-3.25-6.9c-0.267-0.2-0.633-0.3-1.1-0.3c-0.3,0-0.55,0.15-0.75,0.45c-0.1,0.133-0.15,0.25-0.15,0.35 c0,0.067,0.017,0.15,0.05,0.25c0.033,0.1,0.067,0.184,0.1,0.25l2.55,5.6L10.7-14l-3.05-4.9L0.8-18.7 c-0.367,0.033-0.6,0.184-0.7,0.45c-0.067,0.3-0.1,0.467-0.1,0.5c0,0.5,0.2,0.767,0.6,0.8l5.7,0.15l2.15,5.4l3.1,5.65L9.4-5.6 c-1.367-2-2.1-3.033-2.2-3.1C7.1-8.8,6.95-8.85,6.75-8.85C6.35-8.85,6.1-8.667,6-8.3C5.9-8,5.9-7.8,6-7.7H5.95l2.5,4.4l3.7,0.3 L14-3.5L15.5-4.2z M14.55-2.9c-0.333,0.4-0.45,0.85-0.35,1.35c0.033,0.5,0.25,0.9,0.65,1.2S15.7,0.066,16.2,0 c0.5-0.067,0.9-0.3,1.2-0.7c0.333-0.4,0.467-0.85,0.4-1.35c-0.066-0.5-0.3-0.9-0.7-1.2c-0.4-0.333-0.85-0.45-1.35-0.35 C15.25-3.533,14.85-3.3,14.55-2.9z"/><path fill-rule="evenodd" clip-rule="evenodd" fill="#FFF" d="M28.443,16.724c0.02-1.733-0.59-1.772-0.629-2.835 c-0.021-0.532,0.044-2.025,0-3.464c-0.045-1.434-0.198-2.817-0.315-3.15c-0.236-0.669-0.504-1.773-2.52-3.465 c-2.206-1.851-6.459-3.426-8.82-3.465c-2.363-0.04-5.119,1.142-7.246,2.52c-2.126,1.378-2.638,1.969-3.464,3.15 c-0.828,1.181-1.143,2.008-0.946,4.095c0.197,2.087,0.244,1.537,0.315,3.465c0.06,1.595-0.665,2.088-0.63,3.15 c0.052,1.587,0.648,1.916,0.63,2.52c-0.013,0.396-0.709,0.893-0.63,2.205c0.08,1.336,0.354,1.693,2.835,3.15 c1.61,0.945,3.504,1.299,3.465,1.89c-0.058,0.865-0.275,2.284-0.314,3.15c-0.039,0.866,0.354,0.945,1.259,1.26 c0.907,0.315,3.032,0.984,5.356,0.945c2.323-0.04,3.308-0.512,4.41-0.945c1.102-0.433,1.26-0.827,1.26-1.575 c0-0.748-0.63-2.283-0.63-2.835c0-0.551,1.89-1.142,4.095-2.205c2.206-1.063,2.18-2.125,2.206-2.835 c0.047-1.338-0.631-1.653-0.631-2.205C27.499,18.168,28.431,17.984,28.443,16.724z M9.858,19.874 c-1.103,0.04-3.465,0.04-3.465-3.15c0-4.419,2.362-4.922,4.095-5.04c1.733-0.118,1.969-0.315,2.836,0.315 c1.556,1.132,1.456,3.137,0.944,4.725c-0.375,1.163-0.788,1.614-1.575,2.205S10.961,19.834,9.858,19.874z M17.104,24.914 l-0.434-1.608L16,23.313l-0.472,1.602c-1.812-0.492-2.54-1.22-2.52-2.205c0.02-0.984,0.571-2.008,1.574-2.835 c1.005-0.827,1.167-0.955,1.891-0.945c0.691,0.01,0.752,0.144,1.26,0.63c1.097,1.051,1.807,1.751,1.891,3.15 C19.706,24.086,18.107,24.855,17.104,24.914z M22.773,19.874c-1.103-0.04-2.047-0.354-2.835-0.945 c-0.787-0.591-1.252-1.027-1.575-2.205c-0.407-1.483-0.61-3.593,0.946-4.725c0.866-0.63,1.102-0.433,2.835-0.315 c1.731,0.118,4.095,0.621,4.095,5.04C26.239,19.914,23.876,19.914,22.773,19.874z"/></g></svg>'))

recentkillcheck:SetDescription("")
recentkilltime:SetDescription("")
iconcolor:SetPosY(1197)
iconcolor:SetPosX(-10)

local function round(n, d)
    local p = 10^d
    return math.floor(n*p)/p
end

local function death_event(event)
	lPlayer = entities.GetLocalPlayer()
	if lPlayer == nil then return end
	lPlayerTeam = lPlayer:GetTeamNumber()
	
	if event:GetName() == "player_death" then 
		local attacker = event:GetInt("attacker") 
		local victim = event:GetInt("userid")
		local attackerIndex = client.GetPlayerIndexByUserID(attacker)
		local victimIndex = client.GetPlayerIndexByUserID(victim)
		local attackerEntID = entities.GetByUserID(attacker)
		local victimEntID = entities.GetByUserID(victim)
		local attackerTeam = attackerEntID:GetTeamNumber()
		local victimTeam = victimEntID:GetTeamNumber()
		local attackerPlayerInfo = client.GetPlayerInfo(attackerIndex)
		local victimPlayerInfo = client.GetPlayerInfo(victimIndex)
		local attackerSteamID = attackerPlayerInfo["SteamID"]
		local victimSteamID = victimPlayerInfo["SteamID"]
		local CurTime = globals.CurTime()

		if attackerTeam ~= lPlayerTeam and attackerTeam ~= victimTeam then
			if killArray[attackerSteamID] == nil then
				killArray[attackerSteamID] = {CurTime, attackerSteamID}
			else
				killArray[attackerSteamID][1] = CurTime
			end
		end
	end
	if event:GetName() == "cs_win_panel_match" then
		killArray = {}
	end
end
callbacks.Register("FireGameEvent", "death_event", death_event)
client.AllowListener("player_death")
client.AllowListener("cs_win_panel_match")

local function killDraw(builder)
	local CurTime = globals.CurTime()

	local entID = builder:GetEntity()
	if entID == nil then return end
	builder:Color(iconcolor:GetValue())

	if entID:GetClass() == "CCSPlayer" and recentkillcheck:GetValue() == true then
		local entIndex = entID:GetIndex()
		local entPlayerInfo = client.GetPlayerInfo(entIndex)
		local entSteamID = entPlayerInfo["SteamID"]
		for i, v in pairs(killArray) do
			if v[2] == entSteamID then
				local lastKillTime =  round(CurTime - v[1], 3)
				if lastKillTime <= recentkilltime:GetValue() then
					builder:AddIconTop(killTexture)
				end
			end
		end
	end
end
callbacks.Register("DrawESP", "killDraw", killDraw)



--Tab装备显示
local console_handlers = {}
function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c)
		fields[#fields + 1] = c
	end)
	return fields
end
local weapon_type_int = {
	1,
	1,
	1,
	1,
	[7] = 3,
	[8] = 3,
	[9] = 5,
	[10] = 3,
	[11] = 5,
	[13] = 3,
	[14] = 6,
	[16] = 3,
	[17] = 2,
	[19] = 2,
	[20] = 19,
	[23] = 2,
	[24] = 2,
	[25] = 4,
	[26] = 2,
	[27] = 4,
	[28] = 6,
	[29] = 4,
	[30] = 1,
	[31] = 0,
	[32] = 1,
	[33] = 2,
	[34] = 2,
	[35] = 4,
	[36] = 1,
	[37] = 19,
	[38] = 5,
	[39] = 3,
	[40] = 5,
	[41] = 0,
	[42] = 0,
	[43] = 9,
	[44] = 9,
	[45] = 9,
	[46] = 9,
	[47] = 9,
	[48] = 9,
	[49] = 7,
	[50] = 19,
	[51] = 19,
	[52] = 19,
	[55] = 19,
	[56] = 19,
	[57] = 11,
	[59] = 0,
	[60] = 3,
	[61] = 1,
	[63] = 1,
	[64] = 1,
	[68] = 9,
	[69] = 12,
	[70] = 13,
	[72] = 15,
	[74] = 16,
	[75] = 16,
	[76] = 16,
	[78] = 16,
	[80] = 0,
	[81] = 9,
	[82] = 9,
	[83] = 9,
	[84] = 9,
	[85] = 14,
	[500] = 0,
	[503] = 0,
	[505] = 0,
	[506] = 0,
	[507] = 0,
	[508] = 0,
	[509] = 0,
	[512] = 0,
	[514] = 0,
	[515] = 0,
	[516] = 0,
	[517] = 0,
	[518] = 0,
	[519] = 0,
	[520] = 0,
	[521] = 0,
	[522] = 0,
	[523] = 0,
	[525] = 0
}
local wep_type = {taser = 0, knife = 0, pistol = 1, smg = 2, rifle = 3, shotgun = 4, sniperrifle = 5, machinegun = 6, c4 = 7, grenade = 9, stackableitem = 11, fists = 12, breachcharge = 13, bumpmine = 14, tablet = 15, melee = 16, equipment = 19}
local function getWeaponType(wepIdx)
	local typeInt = weapon_type_int[tonumber(wepIdx)]
	for index, value in pairs(wep_type) do
		if value == typeInt then
			return index ~= 0 and index or (tonumber(wepIdx) == 31 and "taser" or "knife")
		end
	end
end

local function register_console_handler(command, handler, force)
	if console_handlers[command] and not force then
		return false
	end
	console_handlers[command] = handler
	return true
end
-- Console input
callbacks.Register("SendStringCmd", "lib_console_input", function(c)
	local raw_console_input = c:Get() -- Maximum 255 chars
	local parsed_console_input = raw_console_input:split(" ")
	local command = table.remove(parsed_console_input, 1)
	local str = ""
	for index, value in ipairs(parsed_console_input) do
		str = str .. value .. " "
	end
	if console_handlers[command] and console_handlers[command](str:sub(1, -2)) then
		c:Set("\0")
	end
end)
local main = [====[
	if (typeof(SClient) == 'undefined' && $.GetContextPanel().id == "CSGOHud") {
        SClient = (function () {
            $.Msg("Scoreboard Weapon injected successfully! Welcome : " + MyPersonaAPI.GetName())
            var handlers = {}
            let registerHandler = function (type, callback) {
                handlers[type] = callback
            }
            let receivedHandler = function (message) {
                if (handlers[message.type]) {
                    handlers[message.type](message)
                }
            }
            return {
                register_handler: registerHandler,
                receive: receivedHandler
            }
        })()
    }
    if ($.GetContextPanel().id == "CSGOHud") { $.Schedule(1, ()=>{GameInterfaceAPI.ConsoleCommand("!panoCall e_PanelWeaponLoaded")}) }
    if (typeof(SImageManager) == 'undefined' && $.GetContextPanel().id == "CSGOHud") {
        SImageManager = (function () {
            var HashMap = function HashMap() {
                var length = 0;
                var obj = new Object();
                this.isEmpty = function () {
                    return length == 0;
                };
                this.containsKey = function (key) {
                    return (key in obj);
                };
                this.containsValue = function (value) {
                    for (var key in obj) {
                        if (obj[key] == value) {
                            return true;
                        }
                    }
                    return false;
                };
                this.put = function (key, value) {
                    if (!this.containsKey(key)) {
                        length++;
                    }
                    obj[key] = value;
                };
                this.get = function (key) {
                    return this.containsKey(key) ? obj[key] : null;
                };
                this.remove = function (key) {
                    if (this.containsKey(key) && (delete obj[key])) {
                        length--;
                    }
                };
                this.values = function () {
                    var _values = new Array();
                    for (var key in obj) {
                        _values.push(obj[key]);
                    }
                    return _values;
                };
                this.keySet = function () {
                    var _keys = new Array();
                    for (var key in obj) {
                        _keys.push(key);
                    }
                    return _keys;
                };
                this.size = function () {
                    return length;
                };
                this.clear = function () {
                    length = 0;
                    obj = new Object();
                };
            }
            var ImagePool = new HashMap()
            class ImageCell {
                constructor(xuid) {
                    var updating = false
                    var lastUpdateWep = ""
                    var lastUpdateHL = ""
                    var lastColor = ""
                    let primaryLut = ['smg', 'rifle', 'heavy']
                    let partInit = "<root><styles><include src='file://{resources}/styles/csgostyles.css'/><include src='file://{resources}/styles/scoreboard.css'/><include src='file://{resources}/styles/hud/hudweaponselection.css' /></styles><Panel style='margin-right:0px;flow-children:right;horizontal-align:right;'></Panel></root>"
                    this.getTargetXUID = () => {
                        return xuid
                    }
                    this.getTargetPanel = () => {
                        var panel
                        var par = $.GetContextPanel().FindChildTraverse("player-" + xuid)
                        if (!par)
                            return
                        var parent = par.FindChildTraverse("name")
                        if (!parent)
                            return
                        panel = parent.FindChildTraverse("CustomImagePanel")
                        if (!panel) {
                            panel = $.CreatePanel("Panel", parent, "CustomImagePanel")
                        }
                        return panel
                    }
                    this.getState = () => {
                        return updating
                    }
                    this.update = (color, equipments, alpha, hl) => {
                        let colorRGBtoHex = (color) => {
                            var rgb = color.split(',')
                            var r = parseInt(rgb[0])
                            var g = parseInt(rgb[1])
                            var b = parseInt(rgb[2])
                            var hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)
                            return hex
                        }
                        let targetColor = colorRGBtoHex(color)
                        let panel = this.getTargetPanel()
                        if (!panel) {return}
                        if (GameStateAPI.GetPlayerStatus(xuid) == 1) {
                            panel.RemoveAndDeleteChildren()
                            return
                        }
                        if (lastUpdateHL != hl || lastUpdateWep != equipments.toString() || lastColor != color) {
                            updating = true
                            panel.RemoveAndDeleteChildren()
                            panel.BLoadLayoutFromString(partInit, false, false)
                            let sortedEQ = []
                            let nades = []
                            let others = []
                            equipments.forEach((item)=>{
                                let curType = InventoryAPI.GetSlot(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(parseInt(item), 0))
                                if(curType == 'grenade'){
                                    nades.push(item)
                                } else if (curType == 'secondary') {
                                    nades.unshift(item)
                                } else if(primaryLut.includes(curType)) {
                                    sortedEQ.push(item)
                                } else {
                                    others.push(item)
                                }
                            })
                            sortedEQ.concat(nades).concat(others).forEach((item) => {
                                let cellPanel = $.CreatePanel("Panel", panel, "CustomPanelCell", {
                                    style: 'margin-right:3px; height:18px;'
                                })
                                let nameUnClipped = InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(parseInt(item), 0))
                                if (!nameUnClipped)
                                    return
                                $.CreatePanel("Image", cellPanel, "CustomImageCell", {
                                    scaling: 'stretch-to-fit-y-preserve-aspect',
                                    src: 'file://{images}/icons/equipment/' + nameUnClipped.replace( 'weapon_', '' ).replace('item_defuser', 'defuser') + '.svg',
                                    style: hl == item ? ('wash-color-fast: white;opacity:' + alpha + ';-s2-mix-blend-mode: normal;img-shadow: ' + targetColor + ' 1px 1px 1.5px 0.5;') : ('wash-color-fast: hsv-transform(#e8e8e8, 0, 0.96, 0.18);opacity:' + (alpha-0.02) + ';-s2-mix-blend-mode: normal;')
                                })
                            })
                        }
                        lastUpdateHL = hl
                        lastUpdateWep = equipments.toString()
                        lastColor = color
                        updating = false
                    }
                }
            }
            return {
                get_cache: (xuid) => {
                    if (ImagePool.containsKey(xuid)) {
                        return ImagePool.get(xuid)
                    } else {
                        return false
                    }
                },
                dispatch: (entid, color, alpha, weapons, hl) => {
                    let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entid)
                    if (ImagePool.containsKey(xuid)) {
                        var targetCell = ImagePool.get(xuid)
                        var waitForUpdate = () => {
                            if (targetCell.getState()){
                                $.Schedule(0.05, waitForUpdate)
                            } else {
                                targetCell.update(color, weapons, alpha, hl)
                            }
                        }
                        waitForUpdate()
                        return true
                    } else {
                        ImagePool.put(xuid, new ImageCell(xuid))
                        return false
                    }
                },
                destroy: () => {
                    ImagePool.clear()
                }
            }
        })()
        $.RegisterForUnhandledEvent("Scoreboard_OnEndOfMatch", SImageManager.destroy)
        $.RegisterForUnhandledEvent('CSGOShowMainMenu', SImageManager.destroy)
        $.RegisterForUnhandledEvent('OpenPlayMenu', SImageManager.destroy)
        $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ReadyUpForMatch', SImageManager.destroy)
        SClient.register_handler("updateWeapons", (message) => {
            if (!SImageManager.dispatch(message.content.xuid, message.content.colorSet, message.content.alpha, message.content.weapons, message.content.highLightWep)) {
                $.Schedule(0.5, () => {
                    SImageManager.dispatch(message.content.xuid, message.content.colorSet, message.content.alpha, message.content.weapons, message.content.highLightWep)
                })
            }
        }) 
    }
]====]
-- Client
local handlers = {}
local pending = {}
local Client = {
	updateWeapons = loadstring([=[
        return function(entid, color, alpha, weapons, highLight)
            if not weapons or #weapons == 0 then
                return
            end
            alpha = string.format("%1.3f", alpha / 255)
            local colorStr = "" .. tostring(color[1]) .. "," .. tostring(color[2]) .. "," .. tostring(color[3])
            local weaponsStr = ""
            for index, value in ipairs(weapons) do
                weaponsStr = weaponsStr .. "\"" .. value .. "\"" .. ","
            end
            weaponsStr = weaponsStr:sub(1, -2)
            local panoStr = string.format("if(typeof (SClient) != 'undefined') { SClient.receive(%s) }", string.format([[{type: "%s", content: %s}]], "updateWeapons", string.format([[{xuid: %s, colorSet: "%s", alpha: %s , weapons: [%s], highLightWep:"%s" }]], entid, colorStr, alpha, weaponsStr, highLight)))
            panorama.RunScript(panoStr)
        end
    ]=])(),
	receive = function(message)
		for index, value in ipairs(handlers) do
			if value(message) then
				return
			end
		end
	end,
	register_handler = function(callback)
		table.insert(handlers, callback)
	end
}
register_console_handler("!panoCall", function(args)
	Client.receive(args)
	return true
end, true)
local last_check_sec = 0
local loaded = false
callbacks.Register("Draw", "AWStrangePanoramaFixer", function()
	if loaded then
		return
	end
	local cur = string.format("%1.0f", tostring(globals.RealTime()))
	if last_check_sec ~= cur then
		panorama.RunScript(main)
		last_check_sec = cur
	end
end)
Client.register_handler(function(msg)
	if msg == "e_PanelWeaponLoaded" then
		loaded = true
		callbacks.Unregister("Draw", "AWStrangePanoramaFixer") -- Credit: squid for api correction
		return true
	end
end)
local enhancement = gui.Reference("Misc", "Enhancement", "Fakelatency")
local hudweapon_enable = gui.Checkbox(enhancement, "hudweapon.enabled", "🐺计分板显示持有武器", false)
local menu = {filter = gui.Multibox(enhancement, "显示筛选")}
local itemList = {"主武器", "副武器", "刀/电击枪", "投掷物", "C4炸弹", "拆弹器", "护甲", "其他"}
for index, value in ipairs(itemList) do
	menu["item_" .. index] = gui.Checkbox(menu.filter, "hudweapon.item_" .. index, value, false)
end
local hudweapon_color = gui.ColorPicker(enhancement, "hudweapon.color", "图标发光颜色", 136, 71, 255, 255)
local player_weapons = {}
for i = 0, 64 do
	player_weapons[i] = {}
end
gui.Button(enhancement, "手动清除缓存记录", function()
	for i = 0, 64 do
		player_weapons[i] = {}
	end
end)
local function filter_weapon(wepList)
	for index, value in ipairs(wepList) do
		local wepType = getWeaponType(value)
		if wepType == "smg" or wepType == "rifle" or wepType == "shotgun" or wepType == "sniperrifle" or wepType == "machinegun" then
			if not menu.item_1:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "pistol" then
			if not menu.item_2:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "taser" then
			if not menu.item_3:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "grenade" then
			if not menu.item_4:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "c4" then
			if not menu.item_5:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "defuser" then
			if not menu.item_6:GetValue() then
				table.remove(wepList, index)
			end
		elseif wepType == "armor" then
			if not menu.item_7:GetValue() then
				table.remove(wepList, index)
			end
		else
			if not menu.item_8:GetValue() then
				table.remove(wepList, index)
			end
		end
	end
	return wepList
end

local hl = {}
local function add_weapon(idx, weapon)
	if player_weapons and player_weapons[idx] and #player_weapons[idx] > 0 then
		for i = 1, #player_weapons[idx] do
			if player_weapons[idx][i] == weapon then
				return
			end
		end
	end
	table.insert(player_weapons[idx], weapon)
end

local function remove_weapon(idx, weapon)
	if #player_weapons[idx] > 0 then
		for i = 1, #player_weapons[idx] do
			if player_weapons[idx][i] == weapon then
				table.remove(player_weapons[idx], i)
			end
		end
	end
end

local function deep_compare(tbl1, tbl2)
	for key1, value1 in pairs(tbl1) do
		local value2 = tbl2[key1]
		if value2 == nil then
			return false
		elseif value1 ~= value2 then
			if type(value1) == "table" and type(value2) == "table" then
				if not deep_compare(value1, value2) then
					return false
				end
			else
				return false
			end
		end
	end
	for key2, _ in pairs(tbl2) do
		if tbl1[key2] == nil then
			return false
		end
	end
	return true
end

local lastUpdate = 0
callbacks.Register("Draw", "hud_weapon_render", function()
	if hudweapon_enable:GetValue() and entities.GetLocalPlayer() then
		local player_resource = entities.GetPlayerResources()
		local currentUpdatePlayer = globals.FrameCount() % 16
		if currentUpdatePlayer ~= lastUpdate then
			local function updateIdx(currentUpdatePlayer)
				local r, g, b, a = hudweapon_color:GetValue()
				local forced_index = math.floor(currentUpdatePlayer)
				local playerInfo = client.GetPlayerInfo(forced_index)
				if playerInfo and not playerInfo.IsGOTV then
					local player_ent = entities.GetByIndex(forced_index)
					if player_ent and not player_ent:IsDormant() then
						local current_player_data = {}
						local active_weapon = player_ent:GetWeaponID()
						if active_weapon ~= nil then
							if player_ent:GetPropInt("m_bHasDefuser") == 1 then
								table.insert(current_player_data, "55")
							end
							for slot = 0, 63 do
								local weapon_ent = player_ent:GetPropEntity("m_hMyWeapons", string.format("%0.3d", slot))
								if weapon_ent ~= nil then
									local wep_id = weapon_ent:GetWeaponID()
									if wep_id then
										table.insert(current_player_data, tostring(wep_id))
									end
								end
							end
						end
						if player_resource:GetPropInt("m_iArmor", player_ent:GetIndex()) > 0 then
							if player_resource:GetPropInt("m_bHasHelmet", player_ent:GetIndex()) == 1 then
								table.insert(current_player_data, "51")
							else
								table.insert(current_player_data, "50")
							end
						end
						Client.updateWeapons(forced_index, {r, g, b}, a, filter_weapon(current_player_data), tostring(active_weapon))
						return
					elseif player_weapons[forced_index] and #player_weapons[forced_index] > 0 then
						Client.updateWeapons(forced_index, {r, g, b}, a, filter_weapon(player_weapons[forced_index]), hl[forced_index])
						return
					elseif player_weapons[forced_index] and #player_weapons[forced_index] == 0 then
						Client.updateWeapons(player_ent:GetIndex(), {r, g, b}, a, {"dead"}, "dead")
					end
					if not player_ent:IsAlive() then
						Client.updateWeapons(player_ent:GetIndex(), {r, g, b}, a, {"dead"}, "dead")
					end
				end
			end
			updateIdx(currentUpdatePlayer)
			updateIdx(currentUpdatePlayer * 2)
			updateIdx(currentUpdatePlayer * 4)
		end
		lastUpdate = currentUpdatePlayer
	end
end)
client.AllowListener("item_equip")
client.AllowListener("item_pickup")
client.AllowListener("item_remove")
client.AllowListener("grenade_thrown")
client.AllowListener("player_death")
client.AllowListener("cs_game_disconnected")
client.AllowListener("cs_match_end_restart")
client.AllowListener("start_halftime")
client.AllowListener("game_newmap")
client.AllowListener("round_end")
client.AllowListener("bomb_dropped")
callbacks.Register("FireGameEvent", "hud_weapon_events", function(event)
	local eventName = event:GetName()
	if eventName then
		if eventName == "item_equip" then
			local entid = entities.GetByUserID(event:GetInt("userid")):GetIndex()
			local wepName = event:GetString("defindex")
			hl[entid] = wepName
		elseif eventName == "item_pickup" then
			add_weapon(entities.GetByUserID(event:GetInt("userid")):GetIndex(), event:GetString("defindex"))
		elseif eventName == "item_remove" then
			remove_weapon(entities.GetByUserID(event:GetInt("userid")):GetIndex(), event:GetString("defindex"))
		elseif eventName == "player_death" then
			if player_weapons then
				player_weapons[entities.GetByUserID(event:GetInt("userid")):GetIndex()] = {}
				Client.updateWeapons(entities.GetByUserID(event:GetInt("userid")):GetIndex(), {0, 0, 0}, 0, {"dead"}, "dead")
			end
		elseif eventName == "round_end" or eventName == "bomb_dropped" then
			for k, v in pairs(player_weapons) do
				remove_weapon(k, "49")
			end
		end
	end
end)




















