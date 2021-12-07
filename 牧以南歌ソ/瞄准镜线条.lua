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
