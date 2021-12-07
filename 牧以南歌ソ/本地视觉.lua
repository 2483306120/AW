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