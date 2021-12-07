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