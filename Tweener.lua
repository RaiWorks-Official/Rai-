local Module = {
	TweenService = game:GetService("TweenService"),
	RunService   = game:GetService("RunService"),
}

function Module:TweenTo(obj, target, speed, easingStyle, easingDir)
	local hum  = obj:FindFirstChildOfClass("Humanoid")
	local root = obj:WaitForChild("HumanoidRootPart")

	speed       = math.max(speed or 50, 0.01)
	easingStyle = easingStyle or Enum.EasingStyle.Sine
	easingDir   = easingDir   or Enum.EasingDirection.InOut

	local targetCF = typeof(target) == "CFrame" and target
		or (target:IsA("BasePart") and target.CFrame)
		or CFrame.new(target.Position)

	local dist     = (root.Position - targetCF.Position).Magnitude
	local duration = math.max(dist / speed, 0.01)
	local elapsed  = 0
	local startCF  = root.CFrame
	local conn

	local PState
	if hum then
		PState = hum:GetState()
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	end

	local ins = { _active = true }

	function ins:Stop()
		if not self._active then return end
		self._active = false
		if conn then conn:Disconnect() end
		if hum and PState then
			hum:ChangeState(PState)
		end
	end

	conn = Module.RunService.Heartbeat:Connect(function(dt)
		if not ins._active then
			conn:Disconnect()
			return
		end

		local cur = typeof(target) == "CFrame" and target
			or (target and target.Parent and target:IsA("BasePart") and target.CFrame)
			or targetCF

		elapsed = elapsed + dt
		local alpha = math.clamp(elapsed / duration, 0, 1)
		root.CFrame = startCF:Lerp(cur, Module.TweenService:GetValue(alpha, easingStyle, easingDir))

		if alpha >= 1 then ins:Stop() end
	end)

	return ins
end

return Module
