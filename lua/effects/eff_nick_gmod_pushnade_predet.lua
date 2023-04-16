function EFFECT:Init(data)
	local Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(Pos)

	for i = 0, 10 do
		local particle = Emitter:Add("sprites/mat_jack_shockwave", Pos)
		particle:SetVelocity(VectorRand() / 2000)
		particle:SetAirResistance(100)
		particle:SetGravity(Vector(0, 0, 0))
		particle:SetDieTime(.175)
		particle:SetStartAlpha(5)
		particle:SetEndAlpha(0)
		local Siz = 300
		particle:SetStartSize(Siz)
		particle:SetEndSize(Siz / Siz - 1)
		particle:SetRoll(math.Rand(-3, 3))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetLighting(false)
		local darg = math.Rand(10, 150)
		particle:SetColor(darg, darg, darg)
		particle:SetCollide(true)
	end

		timer.Simple(0.175, function()
			for i = 0, 150 do
				local Emitter = ParticleEmitter(Pos)
				local particle2 = Emitter:Add("sprites/heatwave", Pos)
				particle2:SetVelocity(VectorRand() * 20000)
				particle2:SetAirResistance(5700)
				particle2:SetGravity(Vector(0, 0, 0))
				particle2:SetDieTime(0.5)
				particle2:SetStartAlpha(10)
				particle2:SetEndAlpha(0)
				local Siz = 5
				particle2:SetStartSize(Siz)
				particle2:SetEndSize(Siz * 25)
				particle2:SetRoll(math.Rand(-5, 5))
				particle2:SetRollDelta(math.Rand(-2.5, 2.5))
				particle2:SetLighting(true)
				local darg = math.random(200, 255)
				particle2:SetColor(darg, darg, darg)
				particle2:SetCollide(true)
			end
		end)

		timer.Simple(0.175, function()
			for i = 0, 1 do
				local Emitter = ParticleEmitter(Pos)
				local particle2 = Emitter:Add("sprites/mat_jack_shockwave", Pos)
				particle2:SetVelocity(VectorRand() * 20000)
				particle2:SetAirResistance(5700)
				particle2:SetGravity(Vector(0, 0, 0))
				particle2:SetDieTime(0.5)
				particle2:SetStartAlpha(100)
				particle2:SetEndAlpha(0)
				local Siz = 5
				particle2:SetStartSize(Siz)
				particle2:SetEndSize(Siz * 25)
				particle2:SetRoll(math.Rand(-5, 5))
				particle2:SetRollDelta(math.Rand(-2.5, 2.5))
				particle2:SetLighting(true)
				local darg = math.random(200, 255)
				particle2:SetColor(darg, darg, darg)
				particle2:SetCollide(true)
			end
		end)

	Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	return false
end
