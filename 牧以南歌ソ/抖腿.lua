--gui
local legshaking = gui.Checkbox(gui.Reference("Misc","Movement","Other"),"legfucker","🐺抖腿", false)
local legshakingtime = gui.Slider(gui.Reference("Misc","Movement","Other"), "legshaking.time", "抖腿间隔", 0.00, 0.00, 0.2, 0.01)

--var
local time = globals.CurTime()
local state = true

--function

local function Onlegshaking()
    if globals.CurTime() > time then
        state = not state
        time = globals.CurTime() + legshakingtime:GetValue()
        entities.GetLocalPlayer():SetPropInt(0, "m_flPoseParameter")
    end
    gui.SetValue("misc.slidewalk", state)
end

--callbacks
callbacks.Register("Draw", function()

    if entities.GetLocalPlayer() and legshaking:GetValue() then 
        entities.GetLocalPlayer():SetPropInt(1, "m_flPoseParameter")
        Onlegshaking()
    end
end)
--end