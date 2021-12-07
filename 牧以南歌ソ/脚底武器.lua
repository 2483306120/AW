local widtext_reference= gui.Reference( "Visuals", "Overlay", "Weapon" )
local widtext_checkbox = gui.Checkbox( widtext_reference, "local.weapon.text", "🐺显示当前武器", 0 )
local widtext_clr = gui.ColorPicker( widtext_checkbox, "clr", "name", 255, 255, 255, 255 )
widtext_checkbox:SetDescription("第三人称时显示当前武器")

local font = draw.CreateFont('Segoe UI', 20, 1000)

local function predict_velocity(entity, prediction_amount)

    local absVelocity = {0, 0, 0}
    local pos_ = {entity:GetAbsOrigin()}
    local modifed_velocity = {vector.Multiply({0, 0, 0})}
    return {vector.Subtract({vector.Add(pos_, modifed_velocity)}, {0,0,0})}
end


local function PlayersFilter(fn) 
    local valid = {}
    for k, player in pairs(entities.FindByClass("CCSPlayer")) do
        if fn and fn(player) then
            table.insert(valid, player)
        end
    end
    return valid
end


callbacks.Register("Draw", function()

    local LocalPlayer = entities.GetLocalPlayer()
    local hp = LocalPlayer:GetHealth()
    if LocalPlayer  then
        if hp ~= 0 then
        if widtext_checkbox:GetValue() and gui.GetValue('esp.local.thirdperson')then
        local my_pos = LocalPlayer:GetAbsOrigin()
        local prediction = predict_velocity(LocalPlayer)
        local x,y,z = vector.Add(
            {my_pos.x, my_pos.y, my_pos.z},
            {prediction[1], prediction[2], prediction[3]}
        )
        
        local prediction = Vector3( x, y ,z)
        
        local players = PlayersFilter(function(player)
        local tr = engine.TraceLine(prediction,
        player:GetAbsOrigin() + Vector3(0,0,0)
        )
        return 
        tr and tr.entity and tr.entity:IsPlayer() and
            tr.entity:GetTeamNumber() ~= LocalPlayer:GetTeamNumber()
        end)

        local wid = LocalPlayer:GetWeaponID();  
        if wid == 1 then
            widtext = '🐺Desert Eagle'
        elseif wid == 2  then
            widtext = '🐺Dual Berettas'
        elseif wid == 3  then
        widtext = '🐺Five-SeveN'
        elseif wid == 4  then
        widtext = '🐺Glock-18'
        elseif wid == 7  then
        widtext = '🐺AK-47'
        elseif wid == 8  then
        widtext = '🐺AUG'
        elseif wid == 9  then
        widtext = '🐺AWP'
        elseif wid == 10  then
        widtext = 'FAMAS'
        elseif wid == 11  then
        widtext = '🐺G3SG1'
        elseif wid == 13  then
        widtext = '🐺Galil AR'
        elseif wid == 14  then
        widtext = '🐺M249'
        elseif wid == 16  then
        widtext = '🐺M4A4'
        elseif wid == 17  then
        widtext = '🐺MAC-10'
        elseif wid == 19  then
        widtext = '🐺P90'
        elseif wid == 23  then
        widtext = '🐺MP5-SD'
        elseif wid == 24  then
        widtext = '🐺UMP-45'
        elseif wid == 25  then
        widtext = '🐺XM1014'
        elseif wid == 26  then
        widtext = '🐺PP-Bizon'
        elseif wid == 27  then
        widtext = '🐺MAG-7'
        elseif wid == 28  then
        widtext = '🐺Negev'
        elseif wid == 29  then
        widtext = '🐺Sawed-Off'
        elseif wid == 30  then
        widtext = '🐺Tec-9'
        elseif wid == 31  then
        widtext = '🐺Zeus x27'
        elseif wid == 32  then
        widtext = '🐺P2000'
        elseif wid == 33  then
        widtext = '🐺MP7'
        elseif wid == 34  then
        widtext = '🐺MP9'
        elseif wid == 35  then
        widtext = '🐺Nova'
        elseif wid == 36  then
        widtext = '🐺P250'
        elseif wid == 37  then
        widtext = '🐺Ballistic Shield'
        elseif wid == 38  then
        widtext = '🐺SCAR-20'
        elseif wid == 39  then
        widtext = '🐺SG 553'
        elseif wid == 40  then
        widtext = '🐺SSG 08'
        elseif wid == 41  then
        widtext = '🐺Knife'
        elseif wid == 42  then
        widtext = '🐺Knife'
        elseif wid == 43  then
        widtext = '🐺Flashbang'
        elseif wid == 44  then
        widtext = '🐺Grenade'
        elseif wid == 45  then
        widtext = '🐺Smoke'
        elseif wid == 46  then
        widtext = '🐺Molotov'
        elseif wid == 47  then
        widtext = '🐺Decoy'
        elseif wid == 48  then
        widtext = '🐺Incendiary'
        elseif wid == 49  then
        widtext = '🐺C4'
        elseif wid == 57  then
        widtext = '🐺Medi-Shot'
        elseif wid == 59  then
        widtext = '🐺Knife'
        elseif wid == 60  then
        widtext = '🐺M4A1-S'
        elseif wid == 61  then
        widtext = '🐺USP-S'
        elseif wid == 62  then
        widtext = '🐺Trade Up Contract'
        elseif wid == 63  then
        widtext = '🐺CZ75'
        elseif wid == 64  then
        widtext = '🐺Revolver'
        elseif wid == 68  then
        widtext = '🐺Tactical Awareness'
        elseif wid == 69  then
        widtext = '🐺Bare Hands'
        elseif wid == 70  then
        widtext = '🐺Breach Charge'
        elseif wid == 72  then
        widtext = '🐺Tablet'
        elseif wid == 75  then
        widtext = '🐺Axe'
        elseif wid == 76  then
        widtext = '🐺Hammer'
        elseif wid == 78  then
        widtext = '🐺Wrench'
        elseif wid == 81  then
        widtext = '🐺Fire Bomb'
        elseif wid == 82  then
        widtext = '🐺Diversion Device'
        elseif wid == 83  then
        widtext = '🐺Frag Grenade'
        elseif wid == 85  then
        widtext = '🐺Bump Mine'
        elseif wid == 500  then
        widtext = '🐺Bayonet'
        elseif wid == 503  then
        widtext = '🐺Classic Knife'
        elseif wid == 505  then
        widtext = '🐺Flip Knife'
        elseif wid == 506  then
        widtext = '🐺Gut Knife'
        elseif wid == 507  then
        widtext = '🐺Karambit'
        elseif wid == 508  then
        widtext = '🐺M9 Bayonet'
        elseif wid == 509  then
        widtext = '🐺Huntsman Knife'
        elseif wid == 512  then
        widtext = '🐺Falchion Knife'
        elseif wid == 514  then
        widtext = '🐺Bowie Knife'
        elseif wid == 515  then
        widtext = '🐺Butterfly Knife'
        elseif wid == 516  then
        widtext = '🐺Shadow Daggers'
        elseif wid == 517  then
        widtext = '🐺Paracord Knife'
        elseif wid == 518  then
        widtext = '🐺Survival Knife'
        elseif wid == 519  then
        widtext = '🐺Ursus Knife'
        elseif wid == 520  then
        widtext = '🐺Navaja Knife'
        elseif wid == 521  then
        widtext = '🐺Nomad Knife'
        elseif wid == 522  then
        widtext = '🐺Stiletto Knife'
        elseif wid == 523  then
        widtext = '🐺Talon Knife'
        elseif wid == 525  then
        widtext = '🐺Skeleton Knife'
        end

        local x2,y2 = client.WorldToScreen(prediction)  
        local w, h = draw.GetTextSize(widtext);
        local x2_1 = x2-(w/2)
        local r, g, b, a = widtext_clr:GetValue()

        draw.SetFont( font )
        draw.Color( 14, 14, 14, a )
        draw.Text( x2_1+1, y2*1.06+1, widtext )
        draw.Color( r, g, b, a )
        draw.Text( x2_1, y2*1.06, widtext )
    end
    end
    end
end)