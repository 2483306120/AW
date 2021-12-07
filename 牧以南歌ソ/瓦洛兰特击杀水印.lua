--make valorant kill gif for aw
--by qi /https://aimware.net/forum/user/366789

local math_min = math.min
local math_max = math.max
local math_modf = math.modf
local math_floor = math.floor
local draw_CreateTexture, draw_GetScreenSize, draw_SetTexture, draw_FilledRect =
    draw.CreateTexture,
    draw.GetScreenSize,
    draw.SetTexture,
    draw.FilledRect
local globals_CurTime = globals.CurTime
local common_DecodePNG = common.DecodePNG
local file_Open, file_Write, file_Enumerate = file.Open, file.Write, file.Enumerate
local client_GetLocalPlayerIndex, client_GetPlayerIndexByUserID = client.GetLocalPlayerIndex, client.GetPlayerIndexByUserID

local event_kill
local counter = 0
local next_frame = 0
local gif = {}

local function file_inspect(name)
    local file_exists
    file_Enumerate(
        function(file)
            if file == name then
                file_exists = true
            end
        end
    )
    return file_exists
end

for i = 0, 78 do
    if file_inspect("picture/valorant/" .. i .. ".png") then
        local png_open = file_Open("picture/valorant/" .. i .. ".png", "r")
        local png_data = png_open:Read()
        png_open:Close()
        local texture = draw_CreateTexture(common_DecodePNG(png_data))
        gif[#gif + 1] = texture
    else
        http.Get(
            --ch "https://aimware28.coding.net/p/coding-code-guide/d/aimware/git/raw/master/picture/valorant/" .. i .. ".png?download=false",
            "https://raw.githubusercontent.com/287871/aimware/renderer/picture/valorant/" .. i .. ".png",
            function(body)
                file_Write("picture/valorant/" .. i .. ".png", body)
            end
        )
    end
end

if #gif ~= 79 then
    error("Downloading PNG image, wait for a moment and then reload")
end

local function on_fire_fame_event(event)
    local lp = entities.GetLocalPlayer()
    local lp_index = client_GetLocalPlayerIndex()
    local attacker = client_GetPlayerIndexByUserID(event:GetInt("attacker"))
    local userid = client_GetPlayerIndexByUserID(event:GetInt("userid"))

    if event:GetName() and lp and lp:IsAlive() and event:GetName() == "player_death" and userid ~= lp_index then
        if attacker == lp_index then
            event_kill = true
        end
    end
end

local function on_draw()
    local screen_size = {draw_GetScreenSize()}

    if event_kill then
        local time = math_floor(globals_CurTime() * 1000)

        if next_frame - time > 30 then
            next_frame = 0
        end

        if next_frame - time < 1 then
            counter = counter + 1

            next_frame = time + 30
        end

        local gif_texture = gif[(counter % #gif + 1)]

        local w, h = 350, 175
        local x, y = screen_size[1] * 0.5 - w * 0.5, screen_size[2] * 0.7

        draw_SetTexture(gif_texture)
        draw_FilledRect(x, y, x + w, y + h)
    end
    if counter % #gif + 1 == 79 then
        event_kill = nil
    end
end

callbacks.Register("Draw", on_draw)
client.AllowListener("player_death")
callbacks.Register("FireGameEvent", on_fire_fame_event)


