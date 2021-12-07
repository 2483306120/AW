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
