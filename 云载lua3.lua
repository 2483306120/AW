--指示器

local function require(name, url)
    package = package or {}

    package.loaded = package.loaded or {}

    package.loaded[name] =
        package.loaded[name] or RunScript(name .. ".lua") or
        http.Get(
            url,
            function(body)
                file.Write(name .. ".lua", body)
            end
        )

    return package.loaded[name] or error("unable to load module " .. name .. " ( try to reload )", 2)
end

local function menu_weapon(var)
    local w = var:match("%a+"):lower()
    local w = w:find("heavy") and "hpistol" or w:find("auto") and "asniper" or w:find("submachine") and "smg" or w:find("light") and "lmg" or w
    return w
end

local ui = {}
ui.ref = gui.Reference("visuals", "other", "extra")
ui.multi_box = gui.Multibox(ui.ref, "🐺指示器")
ui.multi_box:SetDescription("在左侧显示指示器")

ui.option = {
    gui.Checkbox(ui.multi_box, "indicators.ct", "指示器文本", 1),
    gui.Checkbox(ui.multi_box, "indicators.lr", "合法/ 暴力", 1),
    gui.Checkbox(ui.multi_box, "indicators.af", "自动开火", 1),
    gui.Checkbox(ui.multi_box, "indicators.fov", "自瞄范围", 1),
    gui.Checkbox(ui.multi_box, "indicators.hc", "最小命中率", 1),
    gui.Checkbox(ui.multi_box, "indicators.dmg", "最小伤害", 1),
    gui.Checkbox(ui.multi_box, "indicators.aw", "自动穿墙", 1),
    gui.Checkbox(ui.multi_box, "indicators.fl", "假卡", 1),
    gui.Checkbox(ui.multi_box, "indicators.fd", "假蹲", 1),
    gui.Checkbox(ui.multi_box, "indicators.dt", "DT", 1),
    gui.Checkbox(ui.multi_box, "indicators.lc", "滞后补偿", 1)
}

ui.edit_box = gui.Editbox(ui.ref, "indicators.custom.text", "🐺指示器文本")
ui.edit_box:SetDescription("自定义指示器文本")
ui.edit_box:SetValue("🐺Aimware")
ui.edit_box:SetHeight(45)
ui.option.clr = {}
for i = 1, #ui.option do
    ui.option.clr[i] = gui.ColorPicker(ui.option[i], "clr", "clr", 255, 255, 255, 255)
end

local origin_records = {}
local globals_CurTime, globals_TickInterval = globals.CurTime, globals.TickInterval
local math_floor = math.floor

local function time_to_ticks(a)
    return math_floor(1 + a / globals_TickInterval())
end

local function on_create_move(cmd)
    local lp = entities.GetLocalPlayer()
    if not (lp and lp:IsAlive()) then
        return
    end
    if ui.option[11]:GetValue() then
        if cmd.sendpacket then
            origin_records[#origin_records + 1] = lp:GetAbsOrigin()
        end
    end
end

local function on_draw()
    local lp = entities.GetLocalPlayer()

    if not (lp and lp:IsAlive()) then
        return
    end

    local lbot = gui.GetValue("lbot.master")
    local rbot = gui.GetValue("rbot.master")

    if ui.option[11]:GetValue() and origin_records[1] and origin_records[2] then
        local r, g, b, a = ui.option.clr[11]:GetValue()
        local delta =
            Vector3(origin_records[2].x - origin_records[1].x, origin_records[2].y - origin_records[1].y, origin_records[2].z - origin_records[1].z)
        if delta:Length2D() ^ 2 > 4096 then
            draw.indicator(r, g, b, a, "🐺LC")
        end
        if origin_records[3] then
            table.remove(origin_records, 1)
        end
    end

    if ui.option[10]:GetValue() then
        local weapon = menu_weapon(gui.GetValue("rbot.accuracy.weapon"))
        local dt_pcall = pcall(gui.GetValue, "rbot.accuracy.weapon." .. weapon .. ".doublefire")

        if dt_pcall and gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".doublefire") > 1 then
            local m_flNextSecondaryAttack = lp:GetPropEntity("m_hActiveWeapon"):GetPropFloat("LocalActiveWeaponData", "m_flNextSecondaryAttack")
            local r, g, b, a = ui.option.clr[10]:GetValue()
            if m_flNextSecondaryAttack > globals_CurTime() + 0.03 then
                r, g, b, a = 255, 0, 0, 255
            end
            draw.indicator(r, g, b, a, "🐺DT")
        end
    end

    if ui.option[9]:GetValue() then
        local fakecrouchkey = gui.GetValue("rbot.antiaim.extra.fakecrouchkey")
        if fakecrouchkey ~= 0 and input.IsButtonDown(fakecrouchkey) then
            local r, g, b, a = ui.option.clr[9]:GetValue()
            draw.indicator(r, g, b, a, "🐺FD")
        end
    end

    if ui.option[8]:GetValue() then
        local r, g, b, a = ui.option.clr[8]:GetValue()

        local fl = time_to_ticks(globals_CurTime() - lp:GetPropFloat("m_flSimulationTime")) + 2
        draw.indicator(r, g, b, a, "🐺FL " .. fl)
    end

    if ui.option[7]:GetValue() and gui.GetValue("rbot.hitscan.mode." .. menu_weapon(gui.GetValue("rbot.hitscan.mode")) .. ".autowall") then
        local r, g, b, a = ui.option.clr[7]:GetValue()
        draw.indicator(r, g, b, a, "🐺AW")
    end

    if ui.option[6]:GetValue() then
        local r, g, b, a = ui.option.clr[6]:GetValue()
        local weapon = menu_weapon(gui.GetValue("rbot.accuracy.weapon"))
        local text = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".mindmg")
        draw.indicator(r, g, b, a, "🐺DMG: " .. ((text > 100) and ("HP+" .. (text - 100)) or text))
    end

    if ui.option[5]:GetValue() then
        local r, g, b, a = ui.option.clr[5]:GetValue()
        local weapon = menu_weapon(gui.GetValue("rbot.accuracy.weapon"))
        local text = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".hitchance")
        draw.indicator(r, g, b, a, "🐺HC: " .. text)
    end

    if ui.option[4]:GetValue() then
        local r, g, b, a = ui.option.clr[4]:GetValue()
        local weapon = menu_weapon(gui.GetValue("lbot.weapon.target"))
        local text =
            lbot and ("🐺%.1f"):format(gui.GetValue("lbot.weapon.target." .. weapon .. ".maxfov")) or rbot and gui.GetValue("rbot.aim.target.fov")
        draw.indicator(r, g, b, a, text .. "°")
    end

    if ui.option[3]:GetValue() and ((lbot and gui.GetValue("lbot.aim.autofire")) or (rbot and gui.GetValue("rbot.aim.enable"))) then
        local r, g, b, a = ui.option.clr[3]:GetValue()
        draw.indicator(r, g, b, a, "🐺AF")
    end

    if ui.option[2]:GetValue() then
        local r, g, b, a = ui.option.clr[2]:GetValue()
        local text = lbot and "🐺Legit" or rbot and "🐺Rage"
        draw.indicator(r, g, b, a, text)
    end

    ui.edit_box:SetInvisible(not ui.option[1]:GetValue())
    if ui.option[1]:GetValue() then
        local r, g, b, a = ui.option.clr[1]:GetValue()
        local text = ui.edit_box:GetValue()
        draw.indicator(r, g, b, a, text)
    end
end

callbacks.Register("CreateMove", on_create_move)
callbacks.Register("Draw", on_draw)



--屏幕比例
local aspect_ratio_table = {};   
local REF = gui.Reference("MISC", "Enhancement", "Appearance")
local aspect_misc = gui.Groupbox(REF, "🐺屏幕比例", 16, 310, 230)
local aspect_ratio_check = gui.Checkbox(aspect_misc, "aspect_ratio_check", "屏幕比例", false); 
local aspect_ratio_reference = gui.Slider(aspect_misc, "aspect_ratio_reference", "比例：", 100, 1, 199)
local function gcd(m, n)    while m ~= 0 do   m, n = math.fmod(n, m), m; 
end   
return n
end

local function set_aspect_ratio(aspect_ratio_multiplier)
local screen_width, screen_height = draw.GetScreenSize();   local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height; 
    if aspect_ratio_multiplier == 1 or not aspect_ratio_check:GetValue() then  aspectratio_value = 0;   end
        client.SetConVar( "r_aspectratio", tonumber(aspectratio_value), true);   end

local function on_aspect_ratio_changed()
local screen_width, screen_height = draw.GetScreenSize();
for i=1, 200 do   local i2=i*0.01;    i2 = 2 - i2;   local divisor = gcd(screen_width*i2, screen_height);    if screen_width*i2/divisor < 100 or i2 == 1 then   aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor;  end  end
local aspect_ratio = aspect_ratio_reference:GetValue()*0.01;  aspect_ratio = 2 - aspect_ratio;   set_aspect_ratio(aspect_ratio);   end
callbacks.Register('Draw', "Aspect Ratio" ,on_aspect_ratio_changed)

--十字后坐力准心

--Recoil Crosshair by Cheeseot
local ButtonPosition = gui.Reference( "VISUALS", "Other", "Extra" );
local PunchCheckbox = gui.Checkbox( ButtonPosition, "lua_recoilcrosshair", "🐺后坐力准心", 1 );
local recoilcolor = gui.ColorPicker(PunchCheckbox, "recoilcolor", "Recoil Crosshair Color", 255,255,255,255)
local IdleCheckbox = gui.Checkbox( ButtonPosition, "lua_recoilidle", "🐺空闲时自动隐藏准心", 1 );

local function punch()

local rifle = 0;
local me = entities.GetLocalPlayer();
if me ~= nil and not gui.GetValue("rbot.master") then
    if me:IsAlive() then
    local scoped = me:GetProp("m_bIsScoped");
    if scoped == 256 then scoped = 0 end
    if scoped == 257 then scoped = 1 end
    local my_weapon = me:GetPropEntity("m_hActiveWeapon");
    if my_weapon ~=nil then
        local weapon_name = my_weapon:GetClass();
        local canDraw = 0;
        local snipercrosshair = 0;
        weapon_name = string.gsub(weapon_name, "CWeapon", "");
        if weapon_name == "Aug" or weapon_name == "SG556" then
            rifle = 1;
            else
            rifle = 0;
            end

        if scoped == 0 or (scoped == 1 and rifle == 1) then
            canDraw = 1;
            else
            canDraw = 0;
            end

        if weapon_name == "Taser" or weapon_name == "CKnife" then
            canDraw = 0;
            end

        if weapon_name == "AWP" or weapon_name == "SCAR20" or weapon_name == "G3SG1"  or weapon_name == "SSG08" then
            snipercrosshair = 1;
            end

    --Recoil Crosshair by Cheeseot

        if PunchCheckbox:GetValue() and canDraw == 1 then
            local punchAngleVec = me:GetPropVector("localdata", "m_Local", "m_aimPunchAngle");
            local punchAngleX, punchAngleY = punchAngleVec.x, punchAngleVec.y
            local w, h = draw.GetScreenSize();
            local x = w / 2;
            local y = h / 2;
            local fov = 90 --gui.GetValue("vis_view_fov");      polak pls add this back

            if fov == 0 then
                fov = 90;
                end
            if scoped == 1 and rifle == 1 then
                fov = 45;
                end
            
            local dx = w / fov;
            local dy = h / fov;
			
			local px = 0
			local py = 0
			
            if gui.GetValue("esp.other.norecoil") then
				px = x - (dx * punchAngleY)*1.2;
				py = y + (dy * punchAngleX)*2;
            else
				px = x - (dx * punchAngleY)*0.6;
				py = y + (dy * punchAngleX);
			end
            
            if px > x-0.5 and px < x then px = x end
            if px < x+0.5 and px > x then px = x end
            if py > y-0.5 and py < y then py = y end
            if py < y+0.5 and py > y then py = y end

			if IdleCheckbox:GetValue() then
            if px == x and py == y and snipercrosshair ~=1 then return; end
			end
				
            draw.Color(recoilcolor:GetValue());
            draw.FilledRect(px-3, py-1, px+3, py+1);
            draw.FilledRect(px-1, py-3, px+1, py+3);
            end
        end
    end
    end
end
callbacks.Register("Draw", "punch", punch);
--Recoil Crosshair by Cheeseot



--AA指示器
local math_cos, math_pi, math_max, math_floor, math_abs, math_min, math_sin = math.cos, math.pi, math.max, math.floor, math.abs, math.min, math.sin

local draw_Line,
    draw_OutlinedRect,
    draw_RoundedRectFill,
    draw_ShadowRect,
    draw_GetScreenSize,
    draw_SetFont,
    draw_GetTextSize,
    draw_FilledCircle,
    draw_OutlinedCircle,
    draw_SetScissorRect,
    draw_FilledRect,
    draw_SetTexture,
    draw_UpdateTexture,
    draw_TextShadow,
    draw_CreateTexture,
    draw_Triangle,
    draw_AddFontResource,
    draw_Color,
    draw_RoundedRect,
    draw_CreateFont,
    draw_Text =
    draw.Line,
    draw.OutlinedRect,
    draw.RoundedRectFill,
    draw.ShadowRect,
    draw.GetScreenSize,
    draw.SetFont,
    draw.GetTextSize,
    draw.FilledCircle,
    draw.OutlinedCircle,
    draw.SetScissorRect,
    draw.FilledRect,
    draw.SetTexture,
    draw.UpdateTexture,
    draw.TextShadow,
    draw.CreateTexture,
    draw.Triangle,
    draw.AddFontResource,
    draw.Color,
    draw.RoundedRect,
    draw.CreateFont,
    draw.Text

local input_IsButtonDown, input_GetMousePos = input.IsButtonDown, input.GetMousePos

local globals_FrameCount = globals.FrameCount

local gui_Slider, gui_Reference = gui.Slider, gui.Reference

local http_Get = http.Get

local file_Write = file.Write

local function _color(r, g, b, a)
    local r = math_min(255, math_max(0, r))
    local g = math_min(255, math_max(0, g or r))
    local b = math_min(255, math_max(0, b or g or r))
    local a = math_min(255, math_max(0, a or 255))
    return r, g, b, a
end

local function _round(number, precision)
    local mult = 10 ^ (precision or 0)
    return math_floor(number * mult + 0.5) / mult
end

function draw.color(r, g, b, a)
    draw_Color(_color(r, g, b, a))
end

draw.line = draw_Line

function draw.rect(xa, ya, xb, yb, flags, radius)
    local a = flags:find("s") and draw_ShadowRect(xa, ya, xb, yb, radius) or flags:find("scissor") and draw_SetScissorRect(xa, ya, xb, yb)
    local b = flags:find("o") and draw_OutlinedRect(xa, ya, xb, yb) or flags:find("f") and draw_FilledRect(xa, ya, xb, yb)
end

function draw.rect_round(xa, ya, xb, yb, flags, radius, tl, tr, bl, br)
    local a =
        flags:find("o") and draw_RoundedRect(x1, y1, x2, y2, radius, tl, tr, bl, br) or
        flags:find("f") and draw_RoundedRectFill(xa, ya, xb, yb, radius, tl, tr, bl, br)
end

function draw.triangle(xa, ya, xb, yb, xc, yc, flags)
    local a =
        flags:find("o") and draw_Line(xa, ya, xb, yb),
        draw_Line(xb, yb, xc, yc),
        draw_Line(xc, yc, xa, ya) or flags:find("f") and draw_Triangle(xa, ya, xb, yb, xc, yc)
end

function draw.circle(x, y, radius, flags)
    local a = flags:find("o") and draw_OutlinedCircle(x, y, radius) or flags:find("f") and draw_FilledCircle(x, y, radius)
end

draw.get_text_size = draw_GetTextSize

draw.get_screen_size = draw_GetScreenSize

function draw.text(x, y, flags, string)
    local w = draw_GetTextSize(string)
    local x = flags:find("c") and x - _round(w * 0.5) or flags:find("l") and x - w or x
    local a = flags:find("s") and draw_TextShadow(x, y, string) or draw_Text(x, y, string)
end

function draw.new_font(name, height, weight)
    return draw_CreateFont(name or "verdana", height or 13, weight or 0)
end

draw.add_font = draw_AddFontResource

draw.set_font = draw_SetFont

draw.new_texture = draw_CreateTexture

draw.update_texture = draw_UpdateTexture

draw.set_texture = draw_SetTexture

local common_DecodePNG, common_DecodeJPEG, common_RasterizeSVG = common.DecodePNG, common.DecodeJPEG, common.RasterizeSVG

local textures = {}

function draw.load_png(data)
    textures[data] = not textures[data] and draw_CreateTexture(common_DecodePNG(data)) or textures[data]

    return textures[data]
end

function draw.load_jpg(data)
    textures[data] = not textures[data] and draw_CreateTexture(common_DecodeJPEG(data)) or textures[data]

    return textures[data]
end

function draw.load_svg(data, scale)
    local scale = scale or 1
    local data = data .. scale

    textures[data] = not textures[data] and draw_CreateTexture(common_RasterizeSVG(data, scale)) or textures[data]

    return textures[data]
end

function draw.texture(texture, xa, ya, xb, yb)
    draw_SetTexture(texture)
    draw_FilledRect(xa, ya, xb, yb)
    draw_SetTexture(nil)
end

local gradient_texture_a =
    draw_CreateTexture(
    common_RasterizeSVG(
        [[<defs><linearGradient id="a" x1="100%" y1="0%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#a)" /></svg>]]
    )
)

local gradient_texture_b =
    draw_CreateTexture(
    common_RasterizeSVG(
        [[<defs><linearGradient id="c" x1="0%" y1="100%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#c)" /></svg>]]
    )
)

function draw.gradient(xa, ya, xb, yb, ca, cb, ltr)
    local r, g, b, a = _color(ca[1], ca[2], ca[3], ca[4])
    local r2, g2, b2, a2 = _color(cb[1], cb[2], cb[3], cb[4])

    local texture = ltr and gradient_texture_a or gradient_texture_b

    local t = (a ~= 255 or a2 ~= 255)
    draw_Color(r, g, b, a)
    draw_SetTexture(t and texture or nil)
    draw_FilledRect(xa, ya, xb, yb)

    draw_Color(r2, g2, b2, a2)
    local set_texture = not t and draw_SetTexture(texture)
    draw_FilledRect(xb, yb, xa, ya)
    draw_SetTexture(nil)
end

function draw.circle_outline(x, y, radius, start_degrees, percentage, thickness, radian)
    local thickness = radius - thickness
    local percentage = math_abs(percentage * 360)
    local radian = radian or 1

    for i = start_degrees, start_degrees + percentage - radian, radian do
        local cos_1 = math_cos(i * math_pi / 180)
        local sin_1 = math_sin(i * math_pi / 180)
        local cos_2 = math_cos((i + radian) * math_pi / 180)
        local sin_2 = math_sin((i + radian) * math_pi / 180)

        local xa = x + cos_1 * radius
        local ya = y + sin_1 * radius
        local xb = x + cos_2 * radius
        local yb = y + sin_2 * radius
        local xc = x + cos_1 * thickness
        local yc = y + sin_1 * thickness
        local xd = x + cos_2 * thickness
        local yd = y + sin_2 * thickness

        draw_Triangle(xa, ya, xb, yb, xc, yc)
        draw_Triangle(xc, yc, xb, yb, xd, yd)
    end
end

local menu = gui_Reference("menu")

function draw.drag(parent, varname, base_x, base_y)
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
                    local j, k = draw_GetScreenSize()
                    self.parent_x:SetValue(q / j * self.res)
                    self.parent_y:SetValue(r / k * self.res)
                end,
                get = function(self)
                    local j, k = draw_GetScreenSize()
                    return _round(self.parent_x:GetValue() / self.res * j), _round(self.parent_y:GetValue() / self.res * k)
                end
            }
        }
        function a.new(r, u, v, w, x)
            local x = x or 10000
            local j, k = draw_GetScreenSize()
            local y = gui_Slider(r, u .. "x", " position x", v / j * x, 0, x)
            local z = gui_Slider(r, u .. "y", " position y", w / k * x, 0, x)
            y:SetInvisible(true)
            z:SetInvisible(true)
            return setmetatable({parent = r, varname = u, parent_x = y, parent_y = z, res = x}, p)
        end
        function a.drag(q, r, A, B)
            if globals_FrameCount() ~= b then
                c = menu:IsActive()
                f, g = d, e
                d, e = input_GetMousePos()
                i = h
                h = input_IsButtonDown(1) == true
                m = l
                l = {}
                o = n
                n = false
                j, k = draw_GetScreenSize()
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
            l[#l + 1] = {q, r, A, B}
            return q, r, A, B
        end
        return a
    end)().new(parent, varname, base_x, base_y)
end

local indicator = {{}}

function draw.indicator(r, g, b, a, string)
    local new = {}
    local add = indicator[1]
    local x, y = draw_GetScreenSize()

    new.y = y / 1.4105 - #add * 35

    local i = #add + 1
    add[i] = {}

    setmetatable(add[i], new)
    new.__index = new
    new.r, new.g, new.b, new.a = _color(r, g, b, a)
    new.string = string or ""

    return new.y
end

local font = draw_CreateFont("segoe ui", 30, 600)

local draw_gradient = draw.gradient

callbacks.Register(
    "Draw",
    function()
        local temp = {}
        local add = indicator[1]
        local _x, y = draw_GetScreenSize()
        local x = 12
        local c = 0

        draw_SetFont(font)

        add.y = _round(y / 1.4105 - #temp * 35)

        for i = 1, #add do
            temp[#temp + 1] = add[i]
        end

        for i = 1, #temp do
            local _i = temp[i]

            local w, h = draw_GetTextSize(_i.string)
            local xa = _round(x + w * 0.45)
            local ya = add.y - 6
            local xb = add.y + 25

            draw_gradient(x, ya, xa, xb, {c, c, c, c}, {c, c, c, _i.a * 0.2}, true)
            draw_gradient(xa, ya, x + w * 0.9, xb, {c, c, c, _i.a * 0.2}, {c, c, c, c}, true)

            draw_Color(_i.r, _i.g, _i.b, _i.a)
            draw_Text(x + 1, add.y, _i.string)

            add.y = add.y - 35
        end

        indicator[1] = {}
    end
)

local ref = gui.Reference("ragebot", "anti-aim", "extra")
local ui_base_on = gui.Checkbox(ref, "baseind", "🐺假身指示器", 0)
local ui_base_clr = gui.ColorPicker(ui_base_on, "clr", "clr", 255, 255, 255, 255)
local ui_base_radius = gui.Slider(ref, "baseind.radius", "半径", 25, 10, 50)
local ui_base_percentage = gui.Slider(ref, "baseind.percentage", "弧度", 0.15, 0.01, 0.3, 0.005)

local ui_rev_on = gui.Checkbox(ref, "revind", "🐺AA指示器", 0)
local ui_rev_clr = gui.ColorPicker(ui_rev_on, "clr", "clr", 255, 255, 255, 255)
local ui_rev_clr2 = gui.ColorPicker(ui_rev_on, "clr2", "clr2", 255, 0, 0, 255)
local ui_rev_opt = gui.Combobox(ref, "revind.type", "式样", "a", "b", "c", "d", "e")
local ui_rev_interval = gui.Slider(ref, "revind.interval", "间距", 25, 10, 100)

local function base_ui(obj)
    ui_base_clr:SetInvisible(not obj)
    ui_base_radius:SetInvisible(not obj)
    ui_base_percentage:SetInvisible(not obj)
end

local function rev_ui(obj)
    ui_rev_clr:SetInvisible(not obj)
    ui_rev_clr2:SetInvisible(not obj)
    ui_rev_opt:SetInvisible(not obj)
    ui_rev_interval:SetInvisible(not obj)
end

local function base_ind(on, ent, x, y)
    if not (on and ent and ent:IsAlive()) then
        return
    end
    local head_pos = ent:GetHitboxPosition(0)
    local abs = ent:GetAbsOrigin()

    local angle = (head_pos - abs):Angles()
    local view_angle = engine.GetViewAngles()
    local diff = view_angle.y - angle.y

    local x, y = x * 0.5, y * 0.5
    local radius = ui_base_radius:GetValue()
    local percentage = ui_base_percentage:GetValue()
    local r, g, b, a = ui_base_clr:GetValue()

    draw.color(r, g, b, a)
    draw.circle_outline(x, y, radius, 270 + diff - 360 * percentage / 2, percentage, 5, 8)
end

local font = draw.new_font("name", 20, 1000)
local font2 = draw.new_font("name", 25, 400)

local function aa_reversal_ind(on, ent, x, y)
    if not (on and ent and ent:IsAlive()) then
        return
    end

    local x, y = x * 0.5, y * 0.5
    local int = ui_rev_interval:GetValue()
    local r, g, b, a = ui_rev_clr:GetValue()
    local r2, g2, b2, a2 = ui_rev_clr2:GetValue()
    local rot = gui.GetValue("rbot.antiaim.base.rotation")

    if ui_rev_opt:GetValue() == 0 then
        draw.color(r, g, b, a + 200)
        draw.triangle(x - 30 - int, y, x - 10 - int, y - 10, x - 10 - int, y + 10, "o")
        draw.color(r, g, b, a + 200)
        draw.triangle(x + 30 + int, y, x + 10 + int, y - 10, x + 10 + int, y + 10, "o")

        if rot < 0 then
            draw.color(r, g, b, a)
            draw.triangle(x - 30 - int, y, x - 10 - int, y - 10, x - 10 - int, y + 10, "f")
        else
            draw.color(r, g, b, a)
            draw.triangle(x + 30 + int, y, x + 10 + int, y - 10, x + 10 + int, y + 10, "f")
        end
    elseif ui_rev_opt:GetValue() == 1 then
        draw.set_font(font)
        if rot < 0 then
            draw.color(r, g, b, a)
            draw.text(x + 21 + int, y - 7, "", "🐺")
            draw.text(x + 20 + int, y - 7, "", "🐺")
            draw.color(r2, g2, b2, a2)
            draw.text(x - 21 - int, y - 7, "l", "🐺")
            draw.text(x - 20 - int, y - 7, "l", "🐺")
        else
            draw.color(r2, g2, b2, a2)
            draw.text(x + 21 + int, y - 7, "", "🐺")
            draw.text(x + 20 + int, y - 7, "", "🐺")
            draw.color(r, g, b, a)
            draw.text(x - 21 - int, y - 7, "l", "🐺")
            draw.text(x - 20 - int, y - 7, "l", "🐺")
        end
    elseif ui_rev_opt:GetValue() == 2 then
        draw.set_font(font)
        if rot < 0 then
            draw.color(r, g, b, a)
            draw.text(x + 21 + int, y - 7, "", ">>")
            draw.text(x + 20 + int, y - 7, "", ">>")
            draw.color(r2, g2, b2, a2)
            draw.text(x - 21 - int, y - 7, "l", "<<")
            draw.text(x - 20 - int, y - 7, "l", "<<")
        else
            draw.color(r2, g2, b2, a2)
            draw.text(x + 21 + int, y - 7, "", ">>")
            draw.text(x + 20 + int, y - 7, "", ">>")
            draw.color(r, g, b, a)
            draw.text(x - 21 - int, y - 7, "l", "<<")
            draw.text(x - 20 - int, y - 7, "l", "<<")
        end
    elseif ui_rev_opt:GetValue() == 3 then
        draw.set_font(font2)
        if rot < 0 then
            draw.color(r, g, b, a)
            draw.text(x + 21 + int, y - 7, "", "☠")
            draw.text(x + 20 + int, y - 7, "", "☠")
            draw.color(r2, g2, b2, a2)
            draw.text(x - 21 - int, y - 7, "l", "☠")
            draw.text(x - 20 - int, y - 7, "l", "☠")
        else
            draw.color(r2, g2, b2, a2)
            draw.text(x + 21 + int, y - 7, "", "☠")
            draw.text(x + 20 + int, y - 7, "", "☠")
            draw.color(r, g, b, a)
            draw.text(x - 21 - int, y - 7, "l", "☠")
            draw.text(x - 20 - int, y - 7, "l", "☠")
        end
    elseif ui_rev_opt:GetValue() == 4 then
        if rot < 0 then
            draw.color(r, g, b, a)
            draw.circle_outline(x, y, 20 + int, 290 + 72 * 0.5, 0.2, 5, 8)
            draw.color(r2, g2, b2, a2)
            draw.circle_outline(x, y, 20 + int, 105 + 72 * 0.5, 0.2, 5, 8)
        else
            draw.color(r2, g2, b2, a2)
            draw.circle_outline(x, y, 20 + int, 290 + 72 * 0.5, 0.2, 5, 8)
            draw.color(r, g, b, a)
            draw.circle_outline(x, y, 20 + int, 105 + 72 * 0.5, 0.2, 5, 8)
        end
    end
end

callbacks.Register(
    "Draw",
    function()
        local lp = entities.GetLocalPlayer()
        local x, y = draw.GetScreenSize()

        local on = ui_base_on:GetValue()
        base_ui(on)
        base_ind(on, lp, x, y)

        local on = ui_rev_on:GetValue()
        rev_ui(on)
        aa_reversal_ind(on, lp, x, y)
    end
)




--投掷物第一人称

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


--本地视觉
local TAB = gui.Tab( gui.Reference( "Visuals" ), "viewmodel.tab", "🐺本地视觉" )
local HG = gui.Groupbox( TAB, "🐺手臂", 15, 15, (640-45)/2, 640 )
local WG = gui.Groupbox( TAB, "🐺武器", 30 + (640-45)/2, 15, (640-45)/2, 640 )

local HC = gui.Checkbox( HG, "viewmodel.hand", "开启手臂视觉", false )
local WC = gui.Checkbox( WG, "viewmodel.weapon", "开启武器视觉", false )

local H_CLR = gui.ColorPicker( HC, "viewmodel.hand.clr", "手臂颜色", 255, 255, 255, 255 )
local W_CLR = gui.ColorPicker( WC, "viewmodel.weapon.clr", "武器颜色", 255, 255, 255, 255 )

local HT = gui.Combobox( HG, "viewmodel.hand.type", "手臂材料", "自定义","平面","金属","发光","反光" )
local WT = gui.Combobox( WG, "viewmodel.weapon.type", "武器材料", "自定义","平面","金属","发光","反光" )

local HT_CLR = gui.ColorPicker( HT, "viewmodel.hand.type.clr", "自定义手臂颜色", 255, 255, 255, 255 )
local WT_CLR = gui.ColorPicker( WT, "viewmodel.weapon.type.clr", "自定义武器颜色", 255, 255, 255, 255 )

local HA = gui.Checkbox( HG, "viewmodel.hand.additive", "附加效果", false )
local WA = gui.Checkbox( WG, "viewmodel.weapon.additive", "附加效果", false )

local HCOLOR = gui.Combobox( HG, "viewmodel.hand.colorbase", "附加效果式样", "静态","彩虹色","混合色" )
local H_CLR_L_1 = gui.ColorPicker( HG, "viewmodel.hand.lerp.clr1", "混合色（1）", 255, 255, 255, 255 )
local H_CLR_L_2 = gui.ColorPicker( HG, "viewmodel.hand.lerp.clr2", "混合色（2）", 255, 255, 255, 255 )
local HSPEED = gui.Slider( HG, "viewmodel.hand.speed", "混合色/彩虹色变换速度", 10, 1, 100 )
local HRG = gui.Slider( HG, "viewmodel.hand.rainbow.gamma", "彩虹色系数", 100, 1, 100 )

local WCOLOR = gui.Combobox( WG, "viewmodel.weapon.colorbase", "附加效果式样", "静态","彩虹色","混合色" )
local W_CLR_L_1 = gui.ColorPicker( WG, "viewmodel.weapon.lerp.clr1", "混合色（1）", 255, 255, 255, 255 )
local W_CLR_L_2 = gui.ColorPicker( WG, "viewmodel.weapon.lerp.clr2", "混合色（2）", 255, 255, 255, 255 )
local WSPEED = gui.Slider( WG, "viewmodel.weapon.speed", "混合色/Rainbow Speed", 10, 1, 100 )
local WRG = gui.Slider( WG, "viewmodel.weapon.rainbow.gamma", "彩虹色系数", 100, 1, 100 )

local HPHONG = gui.Slider( HG, "viewmodel.hand.phong", "材质", 0, 0, 100 )
local HPEARL = gui.Slider( HG, "viewmodel.hand.pearl","珠光", 0, 0, 100 )
local HREFLECTIVITY = gui.Slider(HG,"viewmodel.hand.reflectivity","反射强度",0,0,100)
local HGLOW = gui.Slider( HG, "viewmodel.hand.glowint", "发光强度", 2, 2, 50 )

local WPHONG = gui.Slider( WG, "viewmodel.weapon.phong", "材质", 0, 0, 100 )
local WPEARL = gui.Slider( WG, "viewmodel.weapon.pearl","珠光", 0, 0, 100 )
local WREFLECTIVITY = gui.Slider(WG,"viewmodel.weapon.reflectivity","反射强度",0,0,100)
local WGLOW = gui.Slider( WG, "viewmodel.weapon.glowint", "发光强度", 2, 2, 50 )



local hr,hg,hb,ha = 255
local wr,wg,wb,wa = 255

local old_hr,old_hg,old_hb,old_ha = 255
local old_wr,old_wg,old_wb,old_wa = 255

local h_old_type,w_old_type = 0

local h_old_phong, h_old_pearl , h_old_reflectivity , h_old_glow , w_old_phong , w_old_pearl , w_old_reflectivity , w_old_glow = 0

local hmat,wmat = nil

function lerp(a,b,t) return a * (1-math.abs(t)) + b * math.abs(t) end

local function HOnDraw()
    hr,hg,hb,ha = HT_CLR:GetValue()
    local type = HT:GetValue()
    local pearl = HPEARL:GetValue() / 100 * 10
    local phong = HPHONG:GetValue() / 100 * 20
    local reflectivity = HREFLECTIVITY:GetValue()/100
    local glow = HGLOW:GetValue()
    
    if h_old_type ~= type or hmat == nil or old_hr ~= hr or old_hg ~= hg or old_hb ~= hb or old_ha ~= ha or h_old_pearl ~= pearl or h_old_phong ~= phong or h_old_reflectivity ~= reflectivity or h_old_glow ~= glow then
        if type == 0 then
            hmat = materials.Create("aw_vm_hands",
            [[
                VertexLitGeneric
                {
                    $basetexture vgui/white_additive
                    $envmap env_cubemap
                    $envmaptint "[]] .. hr/255 * reflectivity .. " " .. hg/255 * reflectivity .. " " .. hb/255 * reflectivity .. [[]"
                    $phong 1
                    $phongboost ]] .. phong .. [[
                    $basemapalphaphongmask 1
                    $pearlescent ]] .. pearl.. [[ 
                }
            ]])
        elseif type == 1 then
            hmat = materials.Create("aw_vm_hands",
            [[
                UnlitGeneric
                {
                    $model 1
                }
            ]])
        elseif type == 2 then
            hmat = materials.Create("aw_vm_hands",
            [[
                VertexLitGeneric
                {
                    $basetexture vgui/white_additve
                    $envmap env_cubemap
                    $envmaptint "[]] .. hr/255 .. " " .. hg/255 .. " " .. hb/255 .. [[]"
                }
            ]])
        elseif type == 3 then
            hmat = materials.Create("aw_vm_hands",
            [[
                VertexLitGeneric
                {
                    $basetexture vgui/white_additive
                    $envmap models/effects/cube_white
                    $envmaptint "[]] .. hr/255 .. " " .. hg/255 .. " " .. hb/255 .. [[]"
                    $envmapfresnel 1
                    $envmapfresnelminmaxexp "[0 1 ]] ..  glow .. [[]"
                }
            ]])
        elseif type == 4 then
            hmat = materials.Create( "aw_vm_hands", 
            [[
                VertexLitGeneric
                {
	                $baseTexture			black
	                $bumpmap				effects\flat_normal
	                $translucent 1
	                $alpha 0.4
	                $envmap		models\effects\crystal_cube_vertigo_hdr
	                $envmaptint "[]] .. hr/255 .. " " .. hg/255 .. " " .. hb/255 ..[[]"
	                //$envmaptint "[0.8 1.2 1.5]"
	                //$envmapcontrast 1.2
	                $envmapsaturation 0.1
	                $envmapfresnel 0
	                $phong 1
	                $phongexponent 16
	                $phongtint "[]].. hr/255 .. " " .. hg/255 .. " " .. hb/255 ..[[]"
	                $phongboost 2
	                //$nocull 1
                }
            ]])
        end
    end
    old_hr,old_hg,old_hb,old_ha = HT_CLR:GetValue()
    h_old_type = type
    h_old_pearl = pearl
    h_old_phong = phong
    h_old_reflectivity = reflectivity
    h_old_glow = glow
end

local function HModel(Context)
    if Context:GetEntity() ~= nil and HC:GetValue() then
        if Context:GetEntity():GetClass() == "CBaseAnimating" then
            local r,g,b,a = H_CLR:GetValue()
            if HCOLOR:GetValue() == 0 then
                hmat:ColorModulate(r/255,g/255,b/255)
            elseif HCOLOR:GetValue() == 1 then
                r = (math.sin(globals.RealTime() * HSPEED:GetValue() / 10) * 127 + 128) * HRG:GetValue() / 100
                g = (math.sin(globals.RealTime() * HSPEED:GetValue() / 10 + 2) * 127 + 128) * HRG:GetValue() / 100
                b = (math.sin(globals.RealTime() * HSPEED:GetValue() / 10 + 4) * 127 + 128) * HRG:GetValue() / 100
                hmat:ColorModulate(r/255,g/255,b/255)
            elseif HCOLOR:GetValue() == 2 then
                local r1,g1,b1,a1 = H_CLR_L_1:GetValue()
                local r2,g2,b2,a2 = H_CLR_L_2:GetValue()
                r = lerp(r1,r2,math.sin(globals.RealTime() * HSPEED:GetValue() / 10))
                g = lerp(g1,g2,math.sin(globals.RealTime() * HSPEED:GetValue() / 10))
                b = lerp(b1,b2,math.sin(globals.RealTime() * HSPEED:GetValue() / 10))
                
                hmat:ColorModulate(r/255,g/255,b/255)
            end
            hmat:AlphaModulate(a/255)
            hmat:SetMaterialVarFlag(128,HA:GetValue())
            Context:ForcedMaterialOverride(hmat)
        end
    end
end

callbacks.Register( "Draw", HOnDraw )
callbacks.Register( "DrawModel", HModel)


local function WOnDraw()
    wr,wg,wb,wa = WT_CLR:GetValue()
    local type = WT:GetValue()
    local pearl = WPEARL:GetValue() / 100 * 10
    local phong = WPHONG:GetValue() / 100 * 20
    local reflectivity = WREFLECTIVITY:GetValue()/100
    local glow = WGLOW:GetValue()
    if w_old_type ~= type or wmat == nil or old_wr ~= wr or old_wg ~= wg or old_wb ~= wb or old_wa ~= wa or w_old_pearl ~= pearl or w_old_phong ~= phong or w_old_reflectivity ~= reflectivity or w_old_glow ~= glow then
        if type == 0 then
            wmat = materials.Create("aw_vm_weapon",
            [[
                VertexLitGeneric
                {
                    $basetexture vgui/white_additive
                    $envmap env_cubemap
                    $envmaptint "[]] .. wr/255 * reflectivity .. " " .. wg/255 * reflectivity .. " " .. wb/255 * reflectivity .. [[]"
                    $phong 1
                    $phongboost ]] .. phong .. [[
                    $basemapalphaphongmask 1
                    $pearlescent ]] .. pearl.. [[ 
                }
            ]])
        elseif type == 1 then
            wmat = materials.Create("aw_vm_weapon",
            [[
                UnlitGeneric
                {
                    $model 1
                }
            ]])
        elseif type == 2 then
            wmat = materials.Create("aw_vm_weapon",
            [[
                VertexLitGeneric
                {
                    $basetexture vgui/white_additve
                    $envmap env_cubemap
                    $envmaptint "[]] .. wr/255 .. " " .. wg/255 .. " " .. wb/255 .. [[]"
                }
            ]])
        elseif type == 3 then
            wmat = materials.Create("aw_vm_weapon",
            [[
                VertexLitGeneric
                {
                    $basetexture vgui/white_additive
                    $envmap models/effects/cube_white
                    $envmaptint "[]] .. wr/255 .. " " .. wg/255 .. " " .. wb/255 .. [[]"
                    $envmapfresnel 1
                    $envmapfresnelminmaxexp "[0 1 ]] ..  glow .. [[]"
                }
            ]])
        elseif type == 4 then
            wmat = materials.Create( "aw_vm_hands", 
            [[
                VertexLitGeneric
                {
	                $baseTexture			black
	                $bumpmap				effects\flat_normal
	                $translucent 1
	                $alpha 0.4
	                $envmap		models\effects\crystal_cube_vertigo_hdr
	                $envmaptint "[]] .. wr/255 .. " " .. wg/255 .. " " .. wb/255 ..[[]"
	                //$envmaptint "[0.8 1.2 1.5]"
	                //$envmapcontrast 1.2
	                $envmapsaturation 0.1
	                $envmapfresnel 0
	                $phong 1
	                $phongexponent 16
	                $phongtint "[]].. wr/255 .. " " .. wg/255 .. " " .. wb/255 ..[[]"
	                $phongboost 2
	                //$nocull 1
                }
            ]])
        end
    end
    old_wr,old_wg,old_wb,old_wa = WT_CLR:GetValue()
    w_old_type = type
    w_old_pearl = pearl
    w_old_phong = phong
    w_old_reflectivity = reflectivity
    w_old_glow = glow
end

local function WModel(Context)
    if Context:GetEntity() ~= nil and WC:GetValue() then
        if Context:GetEntity():GetClass() == "CPredictedViewModel" then
            local r,g,b,a = W_CLR:GetValue()
            if WCOLOR:GetValue() == 0 then
                wmat:ColorModulate(r/255,g/255,b/255)
            elseif WCOLOR:GetValue() == 1 then
                r = (math.sin(globals.RealTime() * WSPEED:GetValue() / 10) * 127 + 128) * WRG:GetValue() / 100
                g = (math.sin(globals.RealTime() * WSPEED:GetValue() / 10 + 2) * 127 + 128) * WRG:GetValue() / 100
                b = (math.sin(globals.RealTime() * WSPEED:GetValue() / 10 + 4) * 127 + 128) * WRG:GetValue() / 100
                wmat:ColorModulate(r/255,g/255,b/255)
            elseif WCOLOR:GetValue() == 2 then
                local r1,g1,b1,a1 = W_CLR_L_1:GetValue()
                local r2,g2,b2,a2 = W_CLR_L_2:GetValue()
                r = lerp(r1,r2,math.sin(globals.RealTime() * WSPEED:GetValue() / 10))
                g = lerp(g1,g2,math.sin(globals.RealTime() * WSPEED:GetValue() / 10))
                b = lerp(b1,b2,math.sin(globals.RealTime() * WSPEED:GetValue() / 10))
                wmat:ColorModulate(r/255,g/255,b/255)
            end
            wmat:AlphaModulate(a/255)
            wmat:SetMaterialVarFlag(128,WA:GetValue())
            Context:ForcedMaterialOverride(wmat)
        end
    end
end

callbacks.Register( "Draw", WOnDraw )
callbacks.Register( "DrawModel", WModel)






















local function HGUIWork()
    if HCOLOR:GetValue() == 0 then
        H_CLR_L_1:SetDisabled(true)
        H_CLR_L_2:SetDisabled(true)
        HSPEED:SetDisabled(true)
        HRG:SetDisabled(true)
    elseif HCOLOR:GetValue() == 1 then
        H_CLR_L_1:SetDisabled(true)
        H_CLR_L_2:SetDisabled(true)
        HSPEED:SetDisabled(false)
        HRG:SetDisabled(false)
    elseif HCOLOR:GetValue() == 2 then
        H_CLR_L_1:SetDisabled(false)
        H_CLR_L_2:SetDisabled(false)
        HSPEED:SetDisabled(false)
        HRG:SetDisabled(true)
    end
    if HT:GetValue() == 0 then
        HPHONG:SetDisabled(false)
        HREFLECTIVITY:SetDisabled(false)
        HPEARL:SetDisabled(false)
    else
        HPHONG:SetDisabled(true)
        HREFLECTIVITY:SetDisabled(true)
        HPEARL:SetDisabled(true)
    end
    if HT:GetValue() == 3 then
        HGLOW:SetDisabled(false)
    else
        HGLOW:SetDisabled(true)
    end
end


local function WGUIWork()
    if WCOLOR:GetValue() == 0 then
        W_CLR_L_1:SetDisabled(true)
        W_CLR_L_2:SetDisabled(true)
        WSPEED:SetDisabled(true)
        WRG:SetDisabled(true)
    elseif WCOLOR:GetValue() == 1 then
        W_CLR_L_1:SetDisabled(true)
        W_CLR_L_2:SetDisabled(true)
        WSPEED:SetDisabled(false)
        WRG:SetDisabled(false)
    elseif WCOLOR:GetValue() == 2 then
        W_CLR_L_1:SetDisabled(false)
        W_CLR_L_2:SetDisabled(false)
        WSPEED:SetDisabled(false)
        WRG:SetDisabled(true)
    end
    if WT:GetValue() == 0 then
        WPHONG:SetDisabled(false)
        WREFLECTIVITY:SetDisabled(false)
        WPEARL:SetDisabled(false)
    else
        WPHONG:SetDisabled(true)
        WREFLECTIVITY:SetDisabled(true)
        WPEARL:SetDisabled(true)
    end
    if WT:GetValue() == 3 then
        WGLOW:SetDisabled(false)
    else
        WGLOW:SetDisabled(true)
    end
end

callbacks.Register( "Draw", HGUIWork )
callbacks.Register( "Draw", WGUIWork )

--点位助手
local WALK_SPEED = 100;
local DRAW_MARKER_DISTANCE = 100;
local WH_ACTION_COOLDOWN = 30;
local GAME_COMMAND_COOLDOWN = 40;
local Wall_SAVE_FILE_NAME = "🐺点位数据.dat";
local WLB = gui.Tab(gui.Reference("VISUALS"), "Wall_helper_settings", "🐺点位助手")
local W_ButtonPosition = gui.Reference("VISUALS", "🐺点位助手");

local W_MULTIBOX = gui.Groupbox(W_ButtonPosition, "🐺视觉设置", 20, 20, 265, 400);
local W_keybind = gui.Groupbox(W_ButtonPosition, "🐺按键设置", 320, 20, 265, 400);

local WH_ENABLED = gui.Checkbox( W_MULTIBOX, "WH_enabled", "启用点位助手", 1 );
local W_RECT_SIZE = gui.Slider(W_MULTIBOX, "WH_W_RECT_SIZE", "瞄准点大小", 10, 0, 25);
local WH_CHECKBOX_THROWRECT = gui.Checkbox( W_MULTIBOX, "WH_ch_throw", "瞄准点颜色", 1 );
local WH_CHECKBOX_HELPERLINE = gui.Checkbox( W_MULTIBOX, "WH_ch_throwline", "引导线颜色", 1 );
local WH_CHECKBOX_BOXSTAND = gui.Checkbox( W_MULTIBOX, "WH_ch_standbox", "站立点颜色(已激活)", 1 );
local WH_CHECKBOX_OOD = gui.Checkbox( W_MULTIBOX, "WH_ch_standbox_ood", "站立点颜色(未激活)", 1 );
local WH_CHECKBOX_TEXT = gui.Checkbox( W_MULTIBOX, "WH_ch_text", "文本颜色", 1 );
local WH_VISUALS_DISTANCE_SL = gui.Slider(W_MULTIBOX, "WH_max_distance", "点位显示距离", 3000, 0, 5000);
local W_THROW_RADIUS = gui.Slider(W_MULTIBOX, "WH_box_radius", "点位大小", 20, 0, 50);

local WH_CHECKBOX_W_keybindS = gui.Checkbox( W_keybind, "WH_ch_W_keybinds", "启用按键绑定", 0 );
local WH_ADD = gui.Keybox(W_keybind, "WH_kb_add", "添加点位按钮", 0);
local WH_REMOVE = gui.Keybox(W_keybind, "WH_kb_rem", "删除点位按钮", 0);
local W_CLR_THROW = gui.ColorPicker(WH_CHECKBOX_THROWRECT, "WH_W_CLR_THROW", "Wall Helper Throw Point", 255, 0, 0, 255);
local W_CLR_HELPER_LINE = gui.ColorPicker(WH_CHECKBOX_HELPERLINE, "WH_CLR_helper", "Wall Helper Line Color", 233, 212, 96, 255);
local W_CLR_STAND_BOX = gui.ColorPicker(WH_CHECKBOX_BOXSTAND, "WH_CLR_standbox", "Wall Helper Location", 0, 230, 64, 255);
local W_CLR_STAND_BOX_OOD = gui.ColorPicker(WH_CHECKBOX_OOD, "WH_CLR_standbox_oop", "Wall Helper Location (Out)", 22, 160, 133, 255);
local W_CLR_TEXT = gui.ColorPicker(WH_CHECKBOX_TEXT, "WH_CLR_text", "Wall Helper Text Color", 255, 255, 255, 255);

local maps = {}

local WH_WINDOW_ACTIVE = false;

local window_show = false;
local window_cb_pressed = true;
local should_load_data = true;
local last_action = globals.TickCount();
local throw_to_add;
local chat_add_step = 1;
local message_to_say;
local my_last_message = globals.TickCount();
local screen_w, screen_h = 0,0;
local should_load_data = true;

local nade_type_mapping = {
    "auto",
    "knife",
    "knife",
    "knife",
    "knife";
    "knife";
}

local throw_type_mapping = {
    "单穿点",
    "假蹲点",
    "ESP点",
    " ",
}

local chat_add_messages = {
    "[HVH] 欢迎来到HVH点位助手，请输入你添加的点位名称，或者输入空格跳过，比如：蛤蟆点",
    "[HVH] 请输入HVH点位说明：单穿点/假蹲点/ESP点/或者输入空格跳过",
}

-- Just open up the file in append mode, should create the file if it doesn't exist and won't override anything if it does
local my_file = file.Open(Wall_SAVE_FILE_NAME, "a");
my_file:Close();

local current_map_name;

function gameEventHandlerw(event)
	if (WH_ENABLED:GetValue() == false) then
		return
	end

	local event_name = event:GetName();
	
    if (event_name == "player_say" and throw_to_add ~= nil) then
        local self_pid = client.GetLocalPlayerIndex();
        print(self_pid);
        local chat_uid = event:GetInt('userid');
        local chat_pid = client.GetPlayerIndexByUserID(chat_uid);
        print(chat_pid);

        if (self_pid ~= chat_pid) then
            return;
        end

        my_last_message = globals.TickCount();

        local say_text = event:GetString('text');

        if (say_text == "cancel") then
            message_to_say = "[HVH] Throw cancelled";
            throw_to_add = nil;
            chat_add_step = 0;
            return;
        end

        -- Don't use the bot's messages
        if (string.sub(say_text, 1, 5) == "[HVH]") then
            return;
        end

        -- Enter name
        if (chat_add_step == 1) then
            throw_to_add.name = say_text;
        elseif (chat_add_step == 2) then
            if (hasValuew(throw_type_mapping, say_text) == false) then
                message_to_say = "[HVH] 您输入的 '" .. say_text .. "' 不正确，请输入: 单穿点/假蹲点/ESP点/空格";
                return;
            end

            throw_to_add.type = say_text;
            message_to_say = "[HVH] 你的点位 '" .. throw_to_add.name .. "' - " .. throw_to_add.type .. " 已经成功添加.";
            table.insert(maps[current_map_name], throw_to_add);
            throw_to_add = nil;
            local value = convertTableToDataStringw(maps);
            local data_file = file.Open(Wall_SAVE_FILE_NAME, "w");
            if (data_file ~= nil) then
                data_file:Write(value);
                data_file:Close();
            end

            chat_add_step = 0;
            return;
        else
            chat_add_step = 0;
            return;
        end

        chat_add_step = chat_add_step + 1;
        message_to_say = chat_add_messages[chat_add_step];

        return;
    end
end

function doAddw(cmd)
	local me = entities.GetLocalPlayer();
    if (current_map_name == nil or maps[current_map_name] == nil or me == nil or not me:IsAlive()) then
        return;
    end
	
	local myPos = me:GetAbsOrigin();
	local angles = cmd:GetViewAngles();
	local nade_type = getWeaponNamew(me);
    if (nade_type ~= nil and nade_type ~= "knife" and nade_type ~= "knife" and nade_type ~= "knife" and nade_type ~= "knife" and nade_type ~= "knife") then
        return;
    end
	
	local new_throw = {
        name = "",
        type = "not_set",
        nade = nade_type,
        pos = {
            x = myPos.x,
            y = myPos.y,
            z = myPos.z
        },
        ax = angles.x,
        ay = angles.y
    };
	
	throw_to_add = new_throw;
    chat_add_step = 1;
    message_to_say = chat_add_messages[chat_add_step];
end

function removeFirstThroww(throw)
    for i, v in ipairs(maps[current_map_name]) do
        if (v.name == throw.name and v.pos.x == throw.pos.x and v.pos.y == throw.pos.y and v.pos.z == throw.pos.z) then
            return table.remove(maps[current_map_name], i);
        end
    end
end

function doDel(throw)
	if (current_map_name == nil or maps[current_map_name] == nil) then
        return;
    end

    removeFirstThroww(throw);

    local value = convertTableToDataStringw(maps);
    local data_file = file.Open(Wall_SAVE_FILE_NAME, "w");
    if (data_file ~= nil) then
        data_file:Write(value);
        data_file:Close();
    end
end

function moveEventHandlerw(cmd)

	if (WH_ENABLED:GetValue() == false) then
		return
	end

	local me = entities.GetLocalPlayer();
	

    if (current_map_name == nil or maps == nil or maps[current_map_name] == nil or me == nil or not me:IsAlive()) then
        throw_to_add = nil;
        chat_add_step = 1;
        message_to_say = nil;
        return;
    end
	
	if (throw_to_add ~= nil) then
        return;
    end
	
	local add_W_keybind = WH_ADD:GetValue();
    local del_W_keybind = WH_REMOVE:GetValue();
	
	if (WH_CHECKBOX_W_keybindS:GetValue() == false or (add_W_keybind == 0 and del_W_keybind == 0)) then
        return;
    end
	
	if (last_action ~= nil and last_action > globals.TickCount()) then
        last_action = globals.TickCount();
    end

    if (add_W_keybind ~= 0 and input.IsButtonDown(add_W_keybind) and globals.TickCount() - last_action > WH_ACTION_COOLDOWN) then
        last_action = globals.TickCount();
        return doAddw(cmd);
    end

    local closest_throw, distance = getClosestThroww(maps[current_map_name], me, cmd);
    if (closest_throw == nil or distance > W_THROW_RADIUS:GetValue()) then
        return;
    end

    if (del_W_keybind ~= 0 and input.IsButtonDown(del_W_keybind) and globals.TickCount() - last_action > WH_ACTION_COOLDOWN) then
        last_action = globals.TickCount();
        return doDel(closest_throw);
    end
end

function drawEventHandlerw()
	if (WH_ENABLED:GetValue() == false) then
		return
	end

    if (should_load_data) then
        loadDataw();
        should_load_data = false;
    end

    screen_w, screen_h = draw.GetScreenSize();

    local active_map_name = engine.GetMapName();

    -- If we don't have an active map, stop
    if (active_map_name == nil or maps == nil) then
        return;
    end

    if (maps[active_map_name] == nil) then
        maps[active_map_name] = {};
    end

    if (current_map_name ~= active_map_name) then
        current_map_name = active_map_name;
    end

    if (maps[current_map_name] == nil) then
        return;
    end

    if (my_last_message ~= nil and my_last_message > globals.TickCount()) then
        my_last_message = globals.TickCount();
    end

    if (message_to_say ~= nil and globals.TickCount() - my_last_message > 100) then
        client.ChatTeamSay(message_to_say);
        message_to_say = nil;
    end

    showNadeThrowsw();
end


function loadDataw()
    local data_file = file.Open(Wall_SAVE_FILE_NAME, "r");
    if (data_file == nil) then
        return;
    end
    local throw_data = data_file:Read();
    data_file:Close();
    if (throw_data ~= nil and throw_data ~= "") then
       maps = parseStringifiedTablew(throw_data);
    end
end

function showNadeThrowsw()
    local me = entities:GetLocalPlayer();
	if (me == nil) then
        return;
    end

	local myPos = me:GetAbsOrigin();
    local weapon_name = getWeaponNamew(me);

    if (weapon_name ~= nil and weapon_name ~= "knife" and weapon_name ~= "knife" and weapon_name ~= "knife" and weapon_name ~= "knife" and weapon_name ~= "knife") then
        return;
    end


    local throws_to_show, within_distance = getActiveThrowsw(maps[current_map_name], me, weapon_name);
	
    for i=1, #throws_to_show do
        local throw = throws_to_show[i];
				
		local throwVector = Vector3(throw.pos.x, throw.pos.y, throw.pos.z);
        local cx, cy = client.WorldToScreen(throwVector);

        if (within_distance) then
            local z_offset = 64;
            if (throw.type == "crouch") then
                z_offset = 46;
            end

            local t_x, t_y, t_z = getThrowPositionw(throw.pos.x, throw.pos.y, throw.pos.z, throw.ax, throw.ay, z_offset);
			local drawVector = Vector3(t_x, t_y, t_z);
            local draw_x, draw_y = client.WorldToScreen(drawVector);
            if (draw_x ~= nil and draw_y ~= nil) then
				-- Draw rectangle for throw point
				if WH_CHECKBOX_THROWRECT:GetValue() then
					draw.Color(W_CLR_THROW:GetValue());
					local rSize = W_RECT_SIZE:GetValue();
					draw.RoundedRect(draw_x - rSize, draw_y - rSize, draw_x + rSize, draw_y + rSize);
				end
				
                -- Draw a line from the center of our screen to the throw position
				if WH_CHECKBOX_HELPERLINE:GetValue() then
					draw.Color(W_CLR_HELPER_LINE:GetValue());
					draw.Line(draw_x, draw_y, screen_w / 2, screen_h / 2);				
				end
				              
				-- Draw throw type
				if WH_CHECKBOX_TEXT:GetValue() then
					draw.Color(W_CLR_TEXT:GetValue());
					local text_size_w, text_size_h = draw.GetTextSize(throw.name);
					draw.Text(draw_x - text_size_w / 2, draw_y - 30 - text_size_h / 2, throw.name);
					text_size_w, text_size_h = draw.GetTextSize(throw.type);
					draw.Text(draw_x - text_size_w / 2, draw_y - 20 - text_size_h / 2, throw.type);
				end
            end
        end
		
    	local ulVector = Vector3(throw.pos.x - W_THROW_RADIUS:GetValue() / 2, throw.pos.y - W_THROW_RADIUS:GetValue() / 2, throw.pos.z);
        local ulx, uly = client.WorldToScreen(ulVector);
		local blVector = Vector3(throw.pos.x - W_THROW_RADIUS:GetValue() / 2, throw.pos.y + W_THROW_RADIUS:GetValue() / 2, throw.pos.z);
        local blx, bly = client.WorldToScreen(blVector);
		local urVector = Vector3(throw.pos.x + W_THROW_RADIUS:GetValue() / 2, throw.pos.y - W_THROW_RADIUS:GetValue() / 2, throw.pos.z);
        local urx, ury = client.WorldToScreen(urVector);
		local brVector = Vector3(throw.pos.x + W_THROW_RADIUS:GetValue() / 2, throw.pos.y + W_THROW_RADIUS:GetValue() / 2, throw.pos.z);
        local brx, bry = client.WorldToScreen(brVector);
	

		if (cx ~= nil and cy ~= nil and ulx ~= nil and uly ~= nil and blx ~= nil and bly ~= nil and urx ~= nil and ury ~= nil and brx ~= nil and bry ~= nil) then

			if(throw.distance < WH_VISUALS_DISTANCE_SL:GetValue()) then


				-- Draw name
				if (throw.name ~= nil) then
					if WH_CHECKBOX_TEXT:GetValue() then
						local text_size_w, text_size_h = draw.GetTextSize(throw.name);
						draw.Color(W_CLR_TEXT:GetValue());
						draw.Text(cx - text_size_w / 2, cy - 20 - text_size_h / 2, throw.name);
					end
				end

				-- Show radius as green when in distance, blue otherwise
				if (within_distance) then
					if WH_CHECKBOX_BOXSTAND:GetValue() then
						draw.Color(W_CLR_STAND_BOX:GetValue());
					else
						draw.Color(255, 255, 255, 0);
					end
				else
					if WH_CHECKBOX_OOD:GetValue() then
						draw.Color(W_CLR_STAND_BOX_OOD:GetValue());
					end
				end
				
				
		
				-- Top left to rest
				draw.Line(ulx, uly, blx, bly);
		
				draw.Line(ulx, uly, urx, ury);
				draw.Line(ulx, uly, brx, bry);

				-- Bottom right to rest
				draw.Line(brx, bry, blx, bly);
				draw.Line(brx, bry, urx, ury);

				-- Diagonal
				draw.Line(blx, bly, urx, ury);
			end
		end
    end
end


function getThrowPositionw(pos_x, pos_y, pos_z, ax, ay, z_offset)
    return pos_x - DRAW_MARKER_DISTANCE * math.cos(math.rad(ay + 180)), pos_y - DRAW_MARKER_DISTANCE * math.sin(math.rad(ay + 180)), pos_z - DRAW_MARKER_DISTANCE * math.tan(math.rad(ax)) + z_offset;
end

function getWeaponNamew(me)
    local my_weapon = me:GetPropEntity("m_hActiveWeapon");
    if (my_weapon == nil) then
        return nil;
    end

    local weapon_name = my_weapon:GetClass();
    weapon_name = weapon_name:gsub("CWeapon", "");
    weapon_name = weapon_name:lower();

    if (weapon_name:sub(1, 1) == "c") then
        weapon_name = weapon_name:sub(2)
    end

    if (weapon_name == "scar20") then
        weapon_name = "knife";
    end

    if (weapon_name == "awp") then
        weapon_name = "knife";
    end

    if (weapon_name == "g3sg1") then
        weapon_name = "knife";
    end

     if (weapon_name == "ssg08") then
        weapon_name = "knife";
     end     

     if (weapon_name == "revolver") then
        weapon_name = "knife";
     end

     if (weapon_name == "deagle") then
        weapon_name = "knife";
     end
    return weapon_name;
end

function getDistanceToTargetw(my_x, my_y, my_z, t_x, t_y, t_z)
    local dx = my_x - t_x;
    local dy = my_y - t_y;
    local dz = my_z - t_z;
    return math.sqrt(dx*dx + dy*dy + dz*dz);
end

function dumpw(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dumpw(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function getActiveThrowsw(map, me, nade_name)
    local throws = {};
    local throws_in_distance = {};
    -- Determine if any are within range, we should only show those if that's the case
    for i=1, #map do

        local throw = map[i];
		
        if (throw ~= nil and throw.nade == nade_name) then
            local myPos = me:GetAbsOrigin();

            local distance = getDistanceToTargetw(myPos.x, myPos.y, throw.pos.z, throw.pos.x, throw.pos.y, throw.pos.z);
            throw.distance = distance;
	
            if (distance < W_THROW_RADIUS:GetValue()) then
                table.insert(throws_in_distance, throw);
            else
                table.insert(throws, throw);
            end
        end
    end

    if (#throws_in_distance > 0) then
        return throws_in_distance, true;
    end

    return throws, false;
end

function getClosestThrow(map, me, cmd)
    local closest_throw;
    local closest_distance;
    local closest_distance_from_center;
    local myPos = me:GetAbsOrigin();
    for i = 1, #map do
        local throw = map[i];
        local distance = getDistanceToTargetw(myPos.x, myPos.y, throw.pos.z, throw.pos.x, throw.pos.y, throw.pos.z);
        local z_offset = 64;
        if (throw.type == "crouch") then
            z_offset = 46;
        end
        local pos_x, pos_y, pos_z = getThrowPositionw(throw.pos.x, throw.pos.y, throw.pos.z, throw.ax, throw.ay, z_offset);
		local drawVector = Vector3(pos_x, pos_y, pos_z);
        local draw_x, draw_y = client.WorldToScreen(drawVector);
        local distance_from_center;

        if (draw_x ~= nil and draw_y ~= nil) then
            distance_from_center = math.abs(screen_w / 2 - draw_x + screen_h / 2 - draw_y);
        end

        if (
        closest_distance == nil
                or (
        distance <= W_THROW_RADIUS:GetValue()
                and (
        closest_distance_from_center == nil
                or (closest_distance_from_center ~= nil and distance_from_center ~= nil and distance_from_center < closest_distance_from_center)
        )
        )
                or (
        (closest_distance_from_center == nil and distance < closest_distance)
        )
        ) then
            closest_throw = throw;
            closest_distance = distance;
            closest_distance_from_center = distance_from_center;
        end
    end

    return closest_throw, closest_distance;
end

function parseStringifiedTablew(stringified_table)
    local new_map = {};

    local strings_to_parse = {};
    for i in string.gmatch(stringified_table, "([^\n]*)\n") do
        table.insert(strings_to_parse, i);
    end

    for i=1, #strings_to_parse do
        local matches = {};

        for word in string.gmatch(strings_to_parse[i], "([^,]*)") do
            table.insert(matches, word);
        end

        local map_name = matches[1];
        if new_map[map_name] == nil then
            new_map[map_name] = {};
        end

        table.insert(new_map[map_name], {
            name = matches[3],
            type = matches[5],
            nade = matches[7],
            pos = {
                x = tonumber(matches[9]),
                y = tonumber(matches[11]),
                z = tonumber(matches[13])
            },
            ax = tonumber(matches[15]),
            ay = tonumber(matches[17]);
        });
    end

    return new_map;
end

function convertTableToDataStringw(object)
    local converted = "";
    for map_name, map in pairs(object) do
        for i, throw in ipairs(map) do
            if (throw ~= nil) then
                converted = converted..map_name.. ','..throw.name..','..throw.type..','..throw.nade..','..throw.pos.x..','..throw.pos.y..','..throw.pos.z..','..throw.ax..','..throw.ay..'\n';
            end
        end
    end

    return converted;
end

function hasValuew(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end



client.AllowListener("player_say");
callbacks.Register("FireGameEvent", "WH_EVENT", gameEventHandlerw);
callbacks.Register("CreateMove", "WH_MOVE", moveEventHandlerw);
callbacks.Register("Draw", "WH_DRAW", drawEventHandlerw);
