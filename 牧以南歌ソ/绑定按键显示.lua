local entities_GetPlayerResources, entities_FindByClass, entities_GetByIndex, entities_GetLocalPlayer, entities_GetByUserID =
    entities.GetPlayerResources,
    entities.FindByClass,
    entities.GetByIndex,
    entities.GetLocalPlayer,
    entities.GetByUserID
local client_GetLocalPlayerIndex,
    client_ChatSay,
    client_WorldToScreen,
    client_Command,
    client_GetPlayerIndexByUserID,
    client_SetConVar,
    client_GetPlayerInfo,
    client_GetConVar =
    client.GetLocalPlayerIndex,
    client.ChatSay,
    client.WorldToScreen,
    client.Command,
    client.GetPlayerIndexByUserID,
    client.SetConVar,
    client.GetPlayerInfo,
    client.GetConVar
local client_GetPlayerNameByIndex, client_GetPlayerNameByUserID, client_ChatTeamSay, client_AllowListener =
    client.GetPlayerNameByIndex,
    client.GetPlayerNameByUserID,
    client.ChatTeamSay,
    client.AllowListener
local globals_FrameTime,
    globals_AbsoluteFrameTime,
    globals_CurTime,
    globals_TickCount,
    globals_MaxClients,
    globals_RealTime,
    globals_FrameCount,
    globals_TickInterval =
    globals.FrameTime,
    globals.AbsoluteFrameTime,
    globals.CurTime,
    globals.TickCount,
    globals.MaxClients,
    globals.RealTime,
    globals.FrameCount,
    globals.TickInterval
local http_Get = http.Get
local math_ceil,
    math_tan,
    math_huge,
    math_log10,
    math_randomseed,
    math_cos,
    math_sinh,
    math_random,
    math_mod,
    math_pi,
    math_max,
    math_atan2,
    math_ldexp,
    math_floor,
    math_sqrt,
    math_deg,
    math_atan =
    math.ceil,
    math.tan,
    math.huge,
    math.log10,
    math.randomseed,
    math.cos,
    math.sinh,
    math.random,
    math.mod,
    math.pi,
    math.max,
    math.atan2,
    math.ldexp,
    math.floor,
    math.sqrt,
    math.deg,
    math.atan
local math_fmod,
    math_acos,
    math_pow,
    math_abs,
    math_min,
    math_log,
    math_frexp,
    math_sin,
    math_tanh,
    math_exp,
    math_modf,
    math_cosh,
    math_asin,
    math_rad =
    math.fmod,
    math.acos,
    math.pow,
    math.abs,
    math.min,
    math.log,
    math.frexp,
    math.sin,
    math.tanh,
    math.exp,
    math.modf,
    math.cosh,
    math.asin,
    math.rad
local table_foreach, table_sort, table_remove, table_foreachi, table_maxn, table_getn, table_concat, table_insert =
    table.foreach,
    table.sort,
    table.remove,
    table.foreachi,
    table.maxn,
    table.getn,
    table.concat,
    table.insert
local string_find,
    string_lower,
    string_format,
    string_rep,
    string_gsub,
    string_len,
    string_gmatch,
    string_dump,
    string_match,
    string_reverse,
    string_byte,
    string_char,
    string_upper,
    string_gfind,
    string_sub =
    string.find,
    string.lower,
    string.format,
    string.rep,
    string.gsub,
    string.len,
    string.gmatch,
    string.dump,
    string.match,
    string.reverse,
    string.byte,
    string.char,
    string.upper,
    string.gfind,
    string.sub
--endregion

--region data

local keybinds_data = {
    {
        varname = "rbot.accuracy.movement.autopeekkey",
        custom_name = "Peek",
        ui_offset = 2,
        alpha = 0
	},
    {
        varname = "rbot.antiaim.base.lby",
        custom_name = "Antiaim",
        ui_offset = 4,
        alpha = 0
    },
    {
        varname = "rbot.hitscan.mode.shared.autowall",
        custom_name = "AUTO",
        ui_offset = 0,
        alpha = 0
    },
    {
        varname = "rbot.antiaim.condition.shiftonshot",
        custom_name = "On Shot",
        ui_offset = 1,
        alpha = 0
    },
    {
        varname = "rbot.accuracy.weapon.shared.doublefire",
        custom_name = "DT",
        ui_offset = 3,
        alpha = 0
    },
    {
        varname = "rbot.accuracy.movement.slowkey",
        custom_name = "Slow Walk",
        ui_offset = 2,
        alpha = 0
    },
    {
        varname = "rbot.antiaim.extra.fakecrouchkey",
        custom_name = "Fake Duck",
        ui_offset = 2,
        alpha = 0
    },
    
    }

--endregion

--region gui dragging
local menu = gui.Reference("menu")

local dragging = function(reference, name, base_x, base_y)
    return (function()
        local a = {}
        local b, c, d, e, f, g, h, i, j, k, l, m, n, o
        local p = {
            __index = {
                drag = function(self, ...)
                    local q, r = self:get()
                    local s, t = a.drag(q, r, ...)
                    if q ~= s or r ~= t then
                        self:set(s, t)
                    end
                    return s, t
                end,
                set = function(self, q, r)
                    local j, k = draw.GetScreenSize()
                    self.x_reference:SetValue(q / j * self.res)
                    self.y_reference:SetValue(r / k * self.res)
                end,
                get = function(self)
                    local j, k = draw.GetScreenSize()
                    return self.x_reference:GetValue() / self.res * j, self.y_reference:GetValue() / self.res * k
                end
            }
        }
        function a.new(r, u, v, w, x)
            x = x or 10000
            local j, k = draw.GetScreenSize()
            local y = gui.Slider(r, "x", u .. " position x", v / j * x, 0, x)
            local z = gui.Slider(r, "y", u .. " position y", w / k * x, 0, x)
            y:SetInvisible(true)
            z:SetInvisible(true)
            return setmetatable({reference = r, name = u, x_reference = y, y_reference = z, res = x}, p)
        end
        function a.drag(q, r, A, B, C, D, E)
            if globals_FrameCount ~= b then
                c = menu:IsActive()
                f, g = d, e
                d, e = input.GetMousePos()
                i = h
                h = input.IsButtonDown(0x01) == true
                m = l
                l = {}
                o = n
                n = false
                j, k = draw.GetScreenSize()
            end
            if c and i ~= nil then
                if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                    n = true
                    q, r = q + d - f, r + e - g
                    if not D then
                        q = math_max(0, math_min(j - A, q))
                        r = math_max(0, math_min(k - B, r))
                    end
                end
            end
            table_insert(l, {q, r, A, B})
            return q, r, A, B
        end
        return a
    end)().new(reference, name, base_x, base_y)
end
--endregion

--region gui
local screen_size = {draw.GetScreenSize()}

local ragebot_accuracy_weapon = gui.Reference("ragebot", "accuracy", "weapon")

local reference = gui.Reference("misc", "general", "extra")
local ui_watermark = gui.Checkbox(reference, "水印", "🐺显示水印", 1)
local ui_watermark_clr = gui.ColorPicker(ui_watermark, "clr", "clr", 255, 64, 48, 255)
local ui_watermark_clr2 = gui.ColorPicker(ui_watermark, "clr2", "clr2", 17, 17, 17, 135)

local ui_keybinds = gui.Checkbox(reference, "按键", "🐺显示按键", 1)
local ui_keybinds_clr = gui.ColorPicker(ui_keybinds, "clr", "clr", 255, 64, 48, 255)
local ui_keybinds_clr2 = gui.ColorPicker(ui_keybinds, "clr2", "clr2", 0, 0, 0, 100)
local ui_keybinds_dragging = dragging(ui_keybinds, "keybinds", screen_size[1] * 0.25, screen_size[2] * 0.35)

local ui_spectators = gui.Checkbox(reference, "观察者", "🐺显示观察者", 1)
local ui_spectators_clr = gui.ColorPicker(ui_spectators, "clr", "clr", 255, 64, 48, 255)
local ui_spectators_clr2 = gui.ColorPicker(ui_spectators, "clr2", "clr2", 0, 0, 0, 100)
local ui_spectators_dragging = dragging(ui_spectators, "spectators", screen_size[1] * 0.15, screen_size[2] * 0.35)

ui_watermark:SetDescription("显示水印 Aimware.net.")
ui_keybinds:SetDescription("显示已触发的绑定按键")
ui_spectators:SetDescription("显示正在观看你的观察者")
--endregion

---region time
local time, time_b, time_s = {0, 0, 0}, 0, 0

local function split_string(inputstr, sep)
    local t = {}
    for str in string_gmatch(inputstr, "([^" .. sep .. "]+)") do
        table_insert(t, str)
    end
    return t
end

local function time_format(v)
    local time =
        string_format(
        "%s:%s:%s",
        v[1] < 10 and "0" .. math_floor(v[1]) or math_floor(v[1]),
        v[2] < 10 and "0" .. math_floor(v[2]) or math_floor(v[2]),
        v[3] < 10 and "0" .. math_floor(v[3]) or math_floor(v[3])
    )
    return time
end

local function get_time()
    local lp = entities_GetLocalPlayer()
    if time_s == 0 or ((time_s + 1200 < common.Time()) and (lp == nil or not lp:IsAlive())) then
        if not data then
            http_Get(
                "http://time.tianqi.com/beijing/",
                function(string)
                    data = string_match(string, [[<th colspan="2" id="clock">(.+)</th>]])
                end
            )
        end
        if data then
            for i, str in pairs(split_string(string_match(data, [[(%d+:%d+:%d+)]]), ":")) do
                time[i] = tonumber(str)
            end

            time_s = common.Time()
            time_b = common.Time()
        end
    end
    time[3] = time[3] + common.Time() - time_b
    time_b = common.Time()
    if time[3] >= 60 then
        time[2], time[3], time_b = time[2] + 1, 0, common.Time()
    end
    if time[2] >= 60 then
        time[1], time[2] = time[1] + 1, 0
    end
    if time[1] >= 24 then
        time[1] = 0
    end

    return time_format(time)
end
--endregion

--get menu weapon
local function menu_weapon(var)
    local wp = string.match(var, [["(.+)"]])
    local wp = string.lower(wp)
    if wp == "heavy pistol" then
        return "hpistol"
    elseif wp == "auto sniper" then
        return "asniper"
    elseif wp == "submachine gun" then
        return "smg"
    elseif wp == "light machine gun" then
        return "lmg"
    else
        return wp
    end
end

--get name
local function get_name(entity)
    if entity then
        local lp_index = client_GetLocalPlayerIndex()
        local n = client_GetPlayerNameByIndex(lp_index)
        return n
    else
        local n = client_GetConVar("name")
        return n
    end
end

--get spectators

local function get_spectators()
    local spectators_table = {}
    local lp = entities.GetLocalPlayer()
    if not lp then
        return
    end
    local CCSPlayer = entities.FindByClass("CCSPlayer")
    for i = 1, #CCSPlayer do
        local CCSPlayer = CCSPlayer[i]
        if CCSPlayer ~= lp and CCSPlayer:GetHealth() <= 0 then
            local m_hObserverTarget = CCSPlayer:GetPropEntity("m_hObserverTarget")
            if m_hObserverTarget then
                if CCSPlayer:GetName() ~= "GOTV" and CCSPlayer:GetIndex() ~= 1 then
                    if m_hObserverTarget:IsPlayer() then
                        if lp:IsAlive() then
                            if m_hObserverTarget:GetIndex() == client.GetLocalPlayerIndex() then
                                table.insert(spectators_table, CCSPlayer)
                            end
                        end
                    end
                end
            end
        end
    end
    return spectators_table
end

--clamp
local function clamp(val, min, max)
    if (val > max) then
        return max
    elseif (val < min) then
        return min
    else
        return val
    end
end

--region http api
local function http_api(renderer)
    local font = renderer.create_font(name, height, weight)

    --region watermark
    local prefix = "Aimware.net"
    local watermark_alpha = 0

    local function watermark()
        local fade_factor = ((1.0 / 0.15) * globals_FrameTime()) * 250

        if ui_watermark:GetValue() then
            watermark_alpha = clamp(watermark_alpha + fade_factor, 0, 255)
        else
            watermark_alpha = clamp(watermark_alpha - fade_factor, 0, 255)
        end

        if watermark_alpha == 0 then
            return
        end

        local lp = entities_GetLocalPlayer()

        local name = get_name(lp)
        local time = get_time()

        local text = string_format(" %s | %s | %s", prefix, name, time)

        if lp then
            local delay = entities_GetPlayerResources():GetPropInt("m_iPing", lp:GetIndex())
            local tick = 1 / globals_TickInterval()
            text = string_format(" %s | %s | delay: %dms | %dtick | %s", prefix, name, delay, tick, time)
        end

        local x, y = draw.GetScreenSize()
        local x, y = math_modf(x * 0.99), math_modf(y * 0.02)
        local h, w = 18, renderer.measure_text(text, font) + 8
        local x = x - w - 10

        local r, g, b, a = ui_watermark_clr:GetValue()
        local a = a * watermark_alpha / 255

        local r2, g2, b2, a2 = ui_watermark_clr2:GetValue()
        local a2 = a2 * watermark_alpha / 255

        local pulse = 8 + math_sin(math_abs(-math_pi + (globals_RealTime() * (0.6 / 1)) % (math_pi * 2))) * 12
        local pulse2 = -28 + math_sin(math_abs(-math_pi + (globals_RealTime() * (0.6 / 1)) % (math_pi * 2))) * 12

        renderer.gradient(x, y, pulse * (w / 30), 1, 0, 0, 0, 0, r, g, b, a, true)
        renderer.gradient(x, y + h, pulse * (w / 30), 1, 0, 0, 0, 0, r, g, b, a, true)

        renderer.gradient(x + w + 1, y, pulse2 * (w / 40), 1, r, g, b, a, 0, 0, 0, 0, true)
        renderer.gradient(x + w + 1, y + h, pulse2 * (w / 40), 1, r, g, b, a, 0, 0, 0, 0, true)

        renderer.rectangle(x, y + 1, w, h - 1, r2, g2, b2, a2, "f")
        renderer.rectangle(x, y + 1, 1, h, r, g, b, a, "f")
        renderer.rectangle(x + w, y + 1, 1, h, r, g, b, a, "f")

        renderer.set_font(font)
        renderer.text(x + 4, y + 5, 255, 255, 255, watermark_alpha, text, "s")
    end

    local keybinds_alpha = 0
    local function keybinds()
        local get = gui.GetValue
        local lp = entities_GetLocalPlayer()

        local x, y = ui_keybinds_dragging:get()
        local x, y = math_modf(x), math_modf(y)
        local w, h = 130, 20

        local string_dis = 0

        local fade_factor = ((1.0 / 0.15) * globals_FrameTime()) * 200

        --dt pcall
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        local weapon_pcall = pcall(get, "rbot.accuracy.weapon." .. weapon .. ".doublefire")

        --table pcall and add
        local temp = {}
        for index = 1, #keybinds_data do
            local k_index = keybinds_data[index]

            --pcall
            local varname = get(k_index.varname)

            if k_index.ui_offset == 2 then
                varname = varname and input.IsButtonDown(varname)
            elseif k_index.ui_offset == 3 then
                varname = weapon_pcall and get("rbot.accuracy.weapon." .. weapon .. ".doublefire") > 0
            elseif k_index.ui_offset == 4 then
                varname = varname < 0
            end

            if varname then
                k_index.alpha = clamp(k_index.alpha + fade_factor, 0, 255)
            else
                k_index.alpha = clamp(k_index.alpha - fade_factor, 0, 255)
            end

            --add
            if k_index.alpha ~= 0 then
                table_insert(temp, keybinds_data[index])

                if renderer.measure_text(k_index.custom_name, font) > 80 then
                    string_dis = 20
                end
            end
        end

        --paint
        if lp and (#temp ~= 0 or menu:IsActive()) and ui_keybinds:GetValue() then
            keybinds_alpha = clamp(keybinds_alpha + fade_factor, 0, 255)
        else
            keybinds_alpha = clamp(keybinds_alpha - fade_factor, 0, 255)
        end

        if keybinds_alpha == 0 then
            return
        end

        renderer.set_font(font)

        ui_keybinds_dragging:drag(w + string_dis, h + (#temp * 15))

        local r, g, b, a = ui_keybinds_clr:GetValue()
        local r2, g2, b2, a2 = ui_keybinds_clr2:GetValue()
        local a = keybinds_alpha * a / 255
        local a2 = keybinds_alpha * a2 / 255

        local pulse = 8 + math_sin(math_abs(-math_pi + (globals_RealTime() * (0.6 / 1)) % (math_pi * 2))) * 12
        local pulse2 = -28 + math_sin(math_abs(-math_pi + (globals_RealTime() * (0.6 / 1)) % (math_pi * 2))) * 12

        renderer.gradient(x, y, pulse * (w / 30), 1, 0, 0, 0, 0, r, g, b, a, true)
        renderer.gradient(x, y + h, pulse * (w / 30), 1, 0, 0, 0, 0, r, g, b, a, true)

        renderer.gradient(x + w + 1 + string_dis, y, pulse2 * (w / 40), 1, r, g, b, a, 0, 0, 0, 0, true)
        renderer.gradient(x + w + 1 + string_dis, y + h, pulse2 * (w / 40), 1, r, g, b, a, 0, 0, 0, 0, true)

        renderer.rectangle(x, y + 1, w + string_dis, h - 1, r2, g2, b2, a2, "f")
        renderer.rectangle(x, y + 1, 1, h, r, g, b, a, "f")
        renderer.rectangle(x + w + string_dis, y + 1, 1, h, r, g, b, a, "f")

        renderer.text(x + 45 + (string_dis * 0.5), y + 5, 255, 255, 255, keybinds_alpha, "  🐺key", "s")

        for index = 1, #temp do
            if temp[index].alpha ~= 0 then
                local activity_name = "[open]"
                if temp[index].ui_offset == 2 then
                    activity_name = "[hold]"
                end

                renderer.text(x + 4, y + 8 + (index * 15), 255, 255, 255, temp[index].alpha, temp[index].custom_name, "s")
                renderer.text(x + 80 + string_dis, y + 8 + (index * 15), 255, 255, 255, temp[index].alpha, activity_name, "s")
            end
        end
    end

    local spectators_alpha = 0

    local function spectators()
        local fade_factor = ((1.0 / 0.15) * globals_FrameTime()) * 200

        local lp = entities_GetLocalPlayer()
        local spectators = get_spectators()

        if lp and (#spectators ~= 0 or menu:IsActive()) and ui_spectators:GetValue() then
            spectators_alpha = clamp(spectators_alpha + fade_factor, 0, 255)
        else
            spectators_alpha = clamp(spectators_alpha - fade_factor, 0, 255)
        end

        if spectators_alpha == 0 then
            return
        end

        local x, y = ui_spectators_dragging:get()
        local x, y = math_modf(x), math_modf(y)

        local w, h = 120, 20
        local string_dis = 0

        renderer.set_font(font)
        if #spectators > 2 then
            string_dis = 20
        end

        for index, players in pairs(spectators) do
            local name = players:GetName()
            if string_len(name) > 16 then
                name = string_match(name, [[................]]) .. ".."
            end
            renderer.text(x + 4, y + 8 + (index * 15), 255, 255, 255, spectators_alpha, name, "s")
            renderer.rectangle(x + 101 + string_dis, y + 7 + (index * 15), 14, 14, 4, 4, 4, spectators_alpha, "f")
            renderer.rectangle(x + 102 + string_dis, y + 8 + (index * 15), 12, 12, 30, 30, 30, spectators_alpha, "f")
            renderer.text(x + 105 + string_dis, y + 9 + (index * 15), 255, 255, 255, spectators_alpha, "?", "s")
        end

        ui_spectators_dragging:drag(w + string_dis, h + (#spectators * 15))

        local r, g, b, a = ui_spectators_clr:GetValue()
        local r2, g2, b2, a2 = ui_spectators_clr2:GetValue()

        local a = spectators_alpha * a / 255
        local a2 = spectators_alpha * a2 / 255

        local pulse = 8 + math_sin(math_abs(-math_pi + (globals_RealTime() * (0.6 / 1)) % (math_pi * 2))) * 12
        local pulse2 = -28 + math_sin(math_abs(-math_pi + (globals_RealTime() * (0.6 / 1)) % (math_pi * 2))) * 12

        renderer.gradient(x, y, pulse * (w / 30), 1, 0, 0, 0, 0, r, g, b, a, true)
        renderer.gradient(x, y + h, pulse * (w / 30), 1, 0, 0, 0, 0, r, g, b, a, true)

        renderer.gradient(x + w + 1 + string_dis, y, pulse2 * (w / 40), 1, r, g, b, a, 0, 0, 0, 0, true)
        renderer.gradient(x + w + 1 + string_dis, y + h, pulse2 * (w / 40), 1, r, g, b, a, 0, 0, 0, 0, true)

        renderer.rectangle(x, y + 1, w + string_dis, h - 1, r2, g2, b2, a2, "f")
        renderer.rectangle(x, y + 1, 1, h, r, g, b, a, "f")
        renderer.rectangle(x + w + string_dis, y + 1, 1, h, r, g, b, a, "f")

        renderer.text(x + 37 + (string_dis * 0.5), y + 5, 255, 255, 255, spectators_alpha, "watch", "s")
    end

    callbacks.Register(
        "Draw",
        function()
            watermark()
            keybinds()
            spectators()
        end
    )
    --endregion
end
--endregion

--region http api request
local function http_request(string)
    local renderer = loadstring(string)()

    if type(renderer) == "table" then
        http_api(renderer)
    else
        callbacks.Register(
            "Draw",
            function()
                draw.TextShadow(5, 5, "无法连接到服务器，请检查网络")
            end
        )
    end
end

http_Get("https://aimware28.coding.net/p/coding-code-guide/d/aimware/git/raw/master/renderer.lua?download=false", http_request)
--endregion
