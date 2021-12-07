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