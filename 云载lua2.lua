--绑定按键显示
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



--第三人称开镜透明
local REF = gui.Reference( "Settings" )
local TAB = gui.Tab(REF, "lua_transparent_on_scope_tab", "🐺第三人称开镜透明")
local BOX = gui.Groupbox(TAB, "🐺第三人称开镜透明", 15, 15, 605, 500)
local SLIDER = gui.Slider(BOX, "lua_transparent_on_scope_slider", "透明程度", 5, 0, 255)
local localchams = gui.Combobox(BOX, "lua_transparent_on_scope_set_localchams", "选择开镜后上色材质", "使用默认", "平面", "模型上色", "金属质感", "边缘发光", "纹理", "透明")
local switchghost = gui.Checkbox(BOX, "lua_transparent_on_scope_switchghost", "开镜后关闭假身上色", false)
local switchoc = gui.Checkbox(BOX, "lua_transparent_on_scope_switchoc", "开镜后关闭不可见部位色", false)
local switchol = gui.Checkbox(BOX, "lua_transparent_on_scope_switchol", "开镜后关闭附加效果", false)

local stored = 0
local set = 0
local change = 0
local slidervalue
local localvisiblecustom
local cb1 = switchghost:GetValue()
local cb2 = switchoc:GetValue()
local cb3 = switchol:GetValue()
local localchamscheck = localchams:GetValue()

local ghostoccluded, ghostoverlay, ghostvisible
local localoccluded, localoverlay, localvisible

local ghostoccludedclr_r, ghostoccludedclr_g, ghostoccludedclr_b, ghostoccludedclr_a
local ghostoverlayclr_r, ghostoverlayclr_g, ghostoverlayclr_b, ghostoverlayclr_a
local ghostvisibleclr_r, ghostvisibleclr_g, ghostvisibleclr_b, ghostvisibleclr_a

local localoccludedclr_r, localoccludedclr_g, localoccludedclr_b, localoccludedclr_a
local localoverlayclr_r, localoverlayclr_g, localoverlayclr_b, localoverlayclr_a 
local localvisibleclr_r, localvisibleclr_g, localvisibleclr_b, localvisibleclr_a 

callbacks.Register( "Draw", function()
local player_local = entities.GetLocalPlayer();
local scoped = player_local:GetProp("m_bIsScoped")
draw.Text(100 , 100,"Scoped: " .. tostring(scoped))
if scoped ~= 0 then

    if slidervalue ~= SLIDER:GetValue() then
        change = 1
    end

    if cb1 ~= switchghost:GetValue() then
        change = 1
        cb1 = switchghost:GetValue()
    end

    if cb2 ~= switchoc:GetValue() then
        change = 1
        cb2 = switchoc:GetValue()
    end

    if cb3 ~= switchol:GetValue() then
        change = 1
        cb3 = switchol:GetValue()
    end

    if localchamscheck ~= localchams:GetValue() then
        change = 1
        localchamscheck = localchams:GetValue()
    end

    if stored == 0 then
        ghostoccluded = gui.GetValue( "esp.chams.ghost.occluded" )
        ghostoverlay = gui.GetValue( "esp.chams.ghost.overlay" )
        ghostvisible = gui.GetValue( "esp.chams.ghost.visible" )

        localoccluded = gui.GetValue( "esp.chams.local.occluded" )
        localoverlay = gui.GetValue( "esp.chams.local.overlay" )
        localvisible = gui.GetValue( "esp.chams.local.visible" )
        ghostoccludedclr_r, ghostoccludedclr_g, ghostoccludedclr_b, ghostoccludedclr_a = gui.GetValue( "esp.chams.ghost.occluded.clr" )
        ghostoverlayclr_r, ghostoverlayclr_g, ghostoverlayclr_b, ghostoverlayclr_a = gui.GetValue( "esp.chams.ghost.overlay.clr" )
        ghostvisibleclr_r, ghostvisibleclr_g, ghostvisibleclr_b, ghostvisibleclr_a = gui.GetValue( "esp.chams.ghost.visible.clr" )

        localoccludedclr_r, localoccludedclr_g, localoccludedclr_b, localoccludedclr_a = gui.GetValue( "esp.chams.local.occluded.clr" )
        localoverlayclr_r, localoverlayclr_g, localoverlayclr_b, localoverlayclr_a = gui.GetValue( "esp.chams.local.overlay.clr" )
        localvisibleclr_r, localvisibleclr_g, localvisibleclr_b, localvisibleclr_a = gui.GetValue( "esp.chams.local.visible.clr" )

        stored = 1
    else 
        if set == 0 or change == 1 then
            slidervalue = SLIDER:GetValue()

            if switchghost:GetValue() then
                gui.SetValue( "esp.chams.ghost.occluded", 0 )
                gui.SetValue( "esp.chams.ghost.overlay", 0 )
                gui.SetValue( "esp.chams.ghost.visible", 0 )
            else 
                gui.SetValue( "esp.chams.ghost.occluded", ghostoccluded )
                gui.SetValue( "esp.chams.ghost.overlay", ghostoverlay )
                gui.SetValue( "esp.chams.ghost.visible", ghostvisible ) 
            end

            if localchams:GetValue() ~= 0 then 
                localvisiblecustom = localchams:GetValue()
            else
                localvisiblecustom = localvisible
            end

            if switchoc:GetValue() == true then
                gui.SetValue( "esp.chams.ghost.occluded" , 0)
                gui.SetValue( "esp.chams.local.occluded" , 0)
            else
                if switchghost:GetValue() == 1 then
                gui.SetValue( "esp.chams.ghost.occluded" , ghostoccluded)
                end
                gui.SetValue( "esp.chams.local.occluded" , localoccluded)
                if ghostoccluded ~= 0 then
                    gui.SetValue("esp.chams.ghost.occluded.clr", ghostoccludedclr_r, ghostoccludedclr_g, ghostoccludedclr_b, slidervalue)
                end
                if localoccluded ~= 0 then
                    gui.SetValue( "esp.chams.local.occluded.clr", localoccludedclr_r, localoccludedclr_g, localoccludedclr_b, slidervalue)
                end
            end

            if switchol:GetValue() == true then
                gui.SetValue( "esp.chams.ghost.overlay" , 0)
                gui.SetValue( "esp.chams.local.overlay" , 0)
            else
                if switchghost:GetValue() == 1 then
                gui.SetValue( "esp.chams.ghost.overlay" , ghostoverlay)
                end
                gui.SetValue( "esp.chams.local.overlay" , localoverlay)
                if ghostoverlay ~= 0 then
                    gui.SetValue("esp.chams.ghost.overlay.clr", ghostoverlayclr_r, ghostoverlayclr_g, ghostoverlayclr_b, slidervalue)
                end
                if localoverlay ~= 0 then
                    gui.SetValue("esp.chams.local.overlay.clr", localoverlayclr_r, localoverlayclr_g, localoverlayclr_b, slidervalue)
                end
            end

            if ghostvisible ~= 0 then
                gui.SetValue("esp.chams.ghost.visible.clr", ghostvisibleclr_r, ghostvisibleclr_g, ghostvisibleclr_b, slidervalue)
            end
        
            if localvisiblecustom ~= 0 then
                gui.SetValue("esp.chams.local.visible", localvisiblecustom)
            end
            gui.SetValue("esp.chams.local.visible.clr", localvisibleclr_r, localvisibleclr_g, localvisibleclr_b, slidervalue)

        change = 0
        set = 1
        end
    end
else
    if set == 1 then

        gui.SetValue( "esp.chams.ghost.occluded", ghostoccluded )
        gui.SetValue( "esp.chams.ghost.overlay", ghostoverlay )
        gui.SetValue( "esp.chams.ghost.visible", ghostvisible )

        gui.SetValue( "esp.chams.local.occluded", localoccluded )
        gui.SetValue( "esp.chams.local.overlay", localoverlay )
        gui.SetValue( "esp.chams.local.visible", localvisible )
        
        gui.SetValue( "esp.chams.ghost.occluded.clr", ghostoccludedclr_r, ghostoccludedclr_g, ghostoccludedclr_b, ghostoccludedclr_a )
        gui.SetValue( "esp.chams.ghost.overlay.clr", ghostoverlayclr_r, ghostoverlayclr_g, ghostoverlayclr_b, ghostoverlayclr_a)
        gui.SetValue( "esp.chams.ghost.visible.clr", ghostvisibleclr_r, ghostvisibleclr_g, ghostvisibleclr_b, ghostvisibleclr_a)

        gui.SetValue( "esp.chams.local.occluded.clr", localoccludedclr_r, localoccludedclr_g, localoccludedclr_b, localoccludedclr_a)
        gui.SetValue( "esp.chams.local.overlay.clr" , localoverlayclr_r, localoverlayclr_g, localoverlayclr_b, localoverlayclr_a)
        gui.SetValue( "esp.chams.local.visible.clr" ,localvisibleclr_r, localvisibleclr_g, localvisibleclr_b, localvisibleclr_a)

        set = 0
        stored = 0
    end
end
end)



--假卡指示器
--gui
local X, Y = draw.GetScreenSize()
local fakelag_indicator_Reference = gui.Reference("Misc", "Enhancement", "Fakelag")
local fakelag_indicator_Enable = gui.Checkbox(fakelag_indicator_Reference, "indicator", "🐺假卡指示器", 0)
local fakelag_indicator_Clr = gui.ColorPicker(fakelag_indicator_Enable, "clr", "clr", 255, 255, 255, 255)
local fakelag_indicator_Clr2 = gui.ColorPicker(fakelag_indicator_Enable, "clr2", "clr2", 88, 197, 255, 255)
local fakelag_indicator_Clr3 = gui.ColorPicker(fakelag_indicator_Enable, "clr3", "clr3", 163, 118, 255, 255)
local fakelag_indicator_X = gui.Slider(fakelag_indicator_Enable, "x", "X", 25, 0, X)
local fakelag_indicator_Y = gui.Slider(fakelag_indicator_Enable, "y", "Y", 530, 0, Y)

fakelag_indicator_Enable:SetDescription("左侧显示条形假卡指示器")
fakelag_indicator_X:SetInvisible(true)
fakelag_indicator_Y:SetInvisible(true)

--var
local font = draw.CreateFont("Verdana", 12)
local MENU = gui.Reference("MENU")


--function

--Mouse drag
local function is_inside(a, b, x, y, w, h) 
    return 
    a >= x and a <= w and b >= y and b <= h 
end
local function drag_menu(x, y, w, h)
    if not MENU:IsActive() then
        return tX, tY
    end
    local mouse_down = input.IsButtonDown(1)
    if mouse_down then
        local X, Y = input.GetMousePos()
        if not _drag then
            local w, h = x + w, y + h
            if is_inside(X, Y, x, y, w, h) then
                offsetX, offsetY = X - x, Y - y
                _drag = true
            end
        else
            tX, tY = X - offsetX, Y - offsetY
            fakelag_indicator_X:SetValue(tX)
            fakelag_indicator_Y:SetValue(tY)
        end
    else
        _drag = false
    end
    return tX, tY
end
--Let drag position save
local function PositionSave()
    if tX ~= fakelag_indicator_X:GetValue() or tY ~= fakelag_indicator_Y:GetValue() then
        tX, tY = fakelag_indicator_X:GetValue(), fakelag_indicator_Y:GetValue()
    end
end

--Gradient rectangle 
local function drawFilledRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.FilledRect(x, y, x + width, y + height)
end
local function drawGradient(color1, color2, x, y, w, h, vertical)
	local r2, g2, b2 = color1[1], color1[2], color1[3]
	local r, g, b = color2[1], color2[2], color2[3]
    drawFilledRect(r2, g2, b2, 255, x, y, w, h)
    if vertical then
        for i = 1, h do
            local a = i / h * 255
            drawFilledRect(r, g, b, a, x, y + i, w, 1)
        end
    else
        for i = 1, w do
            local a = i / w * 255
            drawFilledRect(r, g, b, a, x + i, y, 1, h)
        end
    end
end

--Calculate false lag
local function time_to_ticks(a)
    return 
    math.floor(1 + a / globals.TickInterval())
end

--On draw
local function Ondraw()

    local x, y = drag_menu(tX, tY, 100, 41)
    local y = y + 15
    if entities.GetLocalPlayer():IsAlive() then

        local r, g, b, a = fakelag_indicator_Clr:GetValue()
        local r2, g2, b2, a2 = fakelag_indicator_Clr2:GetValue()
        local r3, g3, b3, a3 = fakelag_indicator_Clr3:GetValue()
        local FakeLag = time_to_ticks(globals.CurTime() - entities.GetLocalPlayer():GetPropFloat( "m_flSimulationTime")) + 2

        draw.Color(4, 4, 4, 150)
        draw.FilledRect(x, y, x + 103, y + 26)
        drawGradient({r2, g2, b2, a2}, {r3, g3, b3, a3}, x + 3, y + 3,  FakeLag * 5.883,  20)
        draw.SetFont(font)
        draw.Color(r, g, b, a)
        draw.TextShadow(x + 33, y - 15, "🐺FL")
        
    end

end

callbacks.Register("Draw", function()
    local lp = entities.GetLocalPlayer()
    if lp ~= nil then
        if gui.GetValue("misc.master") and gui.GetValue("misc.fakelag.enable") and fakelag_indicator_Enable:GetValue() then
            PositionSave()
            Ondraw() 
        end
    end
end)



--瞄准镜线条
gui.Reference("visuals", "other", "effects", "effects removal", "no scope overlay"):SetValue(true)

local menu = gui.Reference("menu")

local master_switch = gui.Checkbox(gui.Reference("visuals", "other", "effects"), "scopeline", "🐺自定义开镜瞄准线", 0)

local overlay_position = gui.Slider(master_switch, "scopeline.initialpos", "瞄准线外直径", 250, 0, 500)
local _a = gui.Text(master_switch, " ")

local overlay_offset = gui.Slider(master_switch, "scopeline.offset", "瞄准线内直径", 0, 15, 500)
local _b = gui.Text(master_switch, " ")

local fade_time = gui.Slider(master_switch, "scopeline.fadespeed", "淡入动画速度", 12, 4, 20)
local _c = gui.Text(master_switch, " ")

local color_picker = gui.ColorPicker(master_switch, "clr", "clr", 255, 255, 255, 255)


local function clamp(val, min, max)
    return val > max and max or val < min and min or val
end

local alpha = 0
callbacks.Register(
    "Draw",
    function()
        local lp = entities.GetLocalPlayer()
        local switch = master_switch:GetValue()
        if menu:IsActive() then
            _a:SetInvisible(not switch)
            _b:SetInvisible(not switch)
            _c:SetInvisible(not switch)
            overlay_position:SetInvisible(not switch)
            overlay_offset:SetInvisible(not switch)
            fade_time:SetInvisible(not switch)
            color_picker:SetInvisible(not switch)
        end
        if not (switch and lp and lp:IsAlive()) then
            return
        end

        local wid = lp:GetWeaponID()

        local offset, initial_position, fade_time, r, g, b, a =
            overlay_offset:GetValue(),
            overlay_position:GetValue(),
            fade_time:GetValue(),
            color_picker:GetValue()

        local ft = fade_time > 4 and (globals.FrameTime() * fade_time) or 1
        local x, y = draw.get_screen_size()
        local x, y = x * 0.5, y * 0.5

        local wpn = lp:GetPropEntity("m_hActiveWeapon")

        local wen = wpn and wpn:GetName()

        local scope_level =
            (wen == "weapon_awp" or wen == "weapon_ssg08" or wen == "weapon_aug" or wen == "weapon_scar20" or wen == "weapon_sg556" or
            wen == "weapon_g3sg1") and
            wpn:GetProp("m_zoomLevel") or
            0

        local scoped = lp:GetProp("m_bIsScoped")
        local scoped = scoped == 1 or scoped == 257
        local resume_zoom = lp:GetProp("m_bResumeZoom") == 1

        local is_valid = lp:IsAlive() and wpn and scope_level

        if is_valid and scope_level > 0 and scoped and not resume_zoom then
            alpha = clamp(alpha + ft, 0, 1)
            lp:SetPropBool(false, "m_bIsScoped")
        else
            alpha = clamp(alpha - ft, 0, 1)
        end

        if alpha ~= 0 then
            draw.gradient(
                x - initial_position,
                y,
                x - offset,
                y + 1,
                {
                    r,
                    g,
                    b,
                    0
                },
                {
                    r,
                    g,
                    b,
                    alpha * a
                },
                true
            )
            draw.gradient(
                x + offset,
                y,
                x + initial_position,
                y + 1,
                {
                    r,
                    g,
                    b,
                    alpha * a
                },
                {
                    r,
                    g,
                    b,
                    0
                },
                true
            )
            draw.gradient(
                x,
                y - initial_position,
                x + 1,
                y - offset,
                {
                    r,
                    g,
                    b,
                    0
                },
                {
                    r,
                    g,
                    b,
                    alpha * a
                },
                false
            )
            draw.gradient(
                x,
                y + offset,
                x + 1,
                y + initial_position,
                {
                    r,
                    g,
                    b,
                    alpha * a
                },
                {
                    r,
                    g,
                    b,
                    0
                },
                false
            )
        end
    end
)

--第三人称平滑
local rb_ref = gui.Reference("VISUALS")
local tab = gui.Tab(rb_ref, "thirdperson", "🐺第三人称平滑")
local gb_r = gui.Groupbox(tab, "🐺第三人称平滑", 15, 15, 250, 400)
local thirdperson_slider = gui.Slider(gb_r, "thirdperson_slider", "第三人称距离", 150, 0, 500)
local thirdperson = gui.GetValue("esp.local.thirdperson")
local thirdperson_dist = gui.GetValue("esp.local.thirdpersondist")
local distance = 0

function on_paint()
    local screen_width, screen_height = draw.GetScreenSize()
    local scx, scy = screen_width * 0.5, screen_height * 0.5
 
    local_player = entities.GetLocalPlayer()

    if local_player == nil then 
        return
    end
     
    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    local multiplier = (1.0 / 0.2) * globals.FrameTime()

    if gui.GetValue("esp.local.thirdperson") then
        if distance < 1.0 then
            distance = ( distance + ( multiplier * ( 1 - distance ) ) )
        end
    else
        distance = 0
    end

    if distance >= 1.0 then
        distance = 1
    end

    if gui.GetValue("esp.local.thirdperson") then
        gui.SetValue("esp.local.thirdpersondist", (gui.GetValue("esp.thirdperson.thirdperson_slider") * distance))
    end
end

callbacks.Register("Draw", on_paint)






--快速落地
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



--投票显示
local c_hud_chat =
    ffi.cast("unsigned long(__thiscall*)(void*, const char*)", mem.FindPattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))(
    ffi.cast("unsigned long**", ffi.cast("uintptr_t", mem.FindPattern("client.dll", "B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 8B 5D 08")) + 1)[0],
    "CHudChat"
)

local ffi_print_chat = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", c_hud_chat)[0][27])

function client.PrintChat(msg)
    ffi_print_chat(c_hud_chat, 0, 0, " " .. msg)
end

local vote_print_chat =
    (function()
    local on = gui.Checkbox(gui.Reference("misc", "enhancement", "appearance"), "showvote", "🐺投票信息", 0)
    on:SetDescription("在本地客户端聊天中显示投票信息。")

    callbacks.Register(
        "DispatchUserMessage",
        function(um)
            local lp = entities.GetLocalPlayer()
            if not (gui.GetValue("misc.master") and on:GetValue() and lp) then
                return
            end

            local team = lp:GetTeamNumber()
            local clr = team == 2 and "\09" or team == 3 and "\10" or "\01"
            if um:GetID() == 46 then
                local type = um:GetInt(3)
                local type_name =
                    type == 0 and "\07踢出玩家 " or type == 1 and " 更改地图 " or type == 6 and "\04发起投降" or
                    type == 13 and "\07发起暂停"

                client.PrintChat(
                    "[" .. clr .. "投票启动\01] " .. client.GetPlayerNameByIndex(um:GetInt(2)) .. " 想要 " .. type_name .. um:GetString(5)
                )
            end

            local results = um:GetID() == 47 and "\06通过" or um:GetID() == 48 and "\02失败"
            local _ = results and client.PrintChat("[" .. clr .. "投票结果\01] " .. results)
        end
    )

    client.AllowListener("vote_cast")

    callbacks.Register(
        "FireGameEvent",
        function(e)
            local lp = entities.GetLocalPlayer()
            if not (gui.GetValue("misc.master") and on:GetValue() and lp) then
                return
            end

            if e:GetName() and e:GetName() == "vote_cast" then
                local team = lp:GetTeamNumber()
                local option = e:GetInt("vote_option")
                local results = option == 0 and "\06同意" or option == 1 and "\07拒绝" or "未知"

                client.PrintChat(
                    "[" ..
                        (team == 2 and "\09" or team == 3 and "\10" or "\01") ..
                            "投票进程\01] " .. client.GetPlayerNameByIndex(e:GetInt("entityid")) .. " " .. results
                )
            end
        end
    )
end)()



