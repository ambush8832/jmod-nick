function EFFECT:Init(data)
	local Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(Pos)

	for i = 0, 100 do
		local particle = Emitter:Add("sprites/mat_jack_shockwave", Pos)
		particle:SetVelocity(VectorRand() * 2000)
		particle:SetAirResistance(1000)
		particle:SetGravity(Vector(0, 0, 0))
		particle:SetDieTime(.125)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		local Siz = math.random(100, 200)
		particle:SetStartSize(Siz)
		particle:SetEndSize(Siz * Siz / 10 + 25 * math.random(1, 3))
		particle:SetRoll(math.Rand(-3, 3))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetLighting(false)
		local darg = math.Rand(10, 150)
		particle:SetColor(darg, darg, darg)
		particle:SetCollide(true)
	end

	for i = 0, 100 do
		local Emitter = ParticleEmitter(Pos)
		local particle = Emitter:Add("particle/smokestack", Pos)
		particle:SetVelocity(VectorRand() * 2000)
		particle:SetAirResistance(500)
		particle:SetGravity(Vector(5, 5, 5))
		particle:SetDieTime(2)
		particle:SetStartAlpha(math.Rand(10, 30))
		particle:SetEndAlpha(0)
		local Siz = math.Rand(50, 70)
		particle:SetStartSize(Siz)
		particle:SetEndSize(Siz * math.random(1, 3))
		particle:SetRoll(math.Rand(-3, 3))
		particle:SetRollDelta(math.random(-3, 3))
		particle:SetLighting(false)
		local darg = math.random(175,200)
		particle:SetColor(darg, darg, darg)
		particle:SetCollide(true)
	end

	Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	return false
end
