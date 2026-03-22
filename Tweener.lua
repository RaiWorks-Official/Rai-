local Module = {
    TweenService = game:GetService("TweenService")
}

function Module:TweenTo(obj, prop, speed, ...)
    local Root = obj:WaitForChild("HumanoidRootPart")

    local Dist = (Root.Position - prop.Position).Magnitude
    speed = math.max(speed, 0.01)
    local Overall = Dist / speed

    local info = TweenInfo.new(Overall, ...)

    local goal = {
        CFrame = prop.CFrame
    }

    local Tween = self.TweenService:Create(Root, info, goal)

    local Ins = {
        Tween = Tween
    }

    function Ins:Stop()
        if self.Tween then
            self.Tween:Cancel()
            self.Tween = nil
        end
    end

    Tween:Play()

    return Ins, Tween
end

return Module
