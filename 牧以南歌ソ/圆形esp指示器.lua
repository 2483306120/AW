--making enemy circle warning for aw
--by qi https://aimware.net/forum/user/366789

--ui
local reference = gui.Reference("visuals", "local", "helper")
local ui_circle_esp_rgb = gui.Checkbox(reference, "circle_esp.rgb", "Circle Outline Rgb", 0)
local ui_circle_esp_clr = gui.ColorPicker(reference, "circle_esp.clr", "Circle Esp Clr", 255, 56, 56, 64)
local ui_circle_esp_interval = gui.Slider(reference, "circle_esp.interval", "Interval", 5, 0, 30)
local ui_circle_esp_percentage = gui.Slider(reference, "circle_esp.percentage", "percentage", 0.2, 0, 0.5, 0.01)

--require
local function require(filename, url)
    local filename = filename .. ".lua"

    local function http_write(body)
        file.Write(filename, body)
    end

    local module = RunScript(filename) or http.Get(url, http_write)

    return module or error("unable to load module " .. filename, 2)
end

local renderer = require("libraries/renderer", "https://raw.githubusercontent.com/287871/aimware/renderer/renderer.lua")

--clamp
local function clamp(val, min, max)
    if val > max then
        return max
    elseif val < min then
        return min
    else
        return val
    end
end

--color rgb
local function hsv_to_rgb(h, s, v, a)
    local r, g, b

    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end

--local global var
local alpha = {}
local players = {activity = {}}

--esp information
local function esp_info(builder)
    local lp = entities.GetLocalPlayer()

    local builder_ent = builder:GetEntity()

    if builder_ent:IsPlayer() and builder_ent:GetTeamNumber() ~= lp:GetTeamNumber() then
        if builder_ent:IsAlive() then
            players[builder_ent:GetIndex()] = true
            players.activity[builder_ent:GetIndex()] = true
        else
            players[builder_ent:GetIndex()] = nil
        end
    end
end

--draw circle
local function esp_draw_circle()
    local lp = entities.GetLocalPlayer()

    if not lp then
        return
    end

    local fade = ((1.0 / 0.15) * globals.FrameTime()) * 80
    local r, g, b, a = ui_circle_esp_clr:GetValue()

    if ui_circle_esp_rgb:GetValue() then
        r, g, b = hsv_to_rgb(globals.RealTime() * 0.1, 1, 1, 0.5)
    end

    local screen_size = {draw.GetScreenSize()}
    local screen_size_x = screen_size[1] * 0.5
    local screen_size_y = screen_size[2] * 0.5

    local out_of_view_scale = gui.GetValue("esp.local.outofviewscale")
    local interval = ui_circle_esp_interval:GetValue() + 30
    local percentage = ui_circle_esp_percentage:GetValue()

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
        angle = (v_abs - lp_abs):Angles()
        angle.y = angle.y - view_angles.y
        for i = 1, 2, 0.2 do
            local alpha = i / 5 * alpha[index]

            renderer.circle_outline(
                screen_size_x,
                screen_size_y,
                r,
                g,
                b,
                alpha,
                (50 + out_of_view_scale + (interval * k)) + i,
                (270 - percentage * 170) - angle.y + (i * 0.2),
                percentage + (i * 0.00005),
                25 + (i * 2)
            )
        end
    end
end

--callbacks
callbacks.Register("DrawESP", esp_info)
callbacks.Register("Draw", esp_draw_circle)
--end