-- Nick 2022, Jackarunda 2021
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="Nick"
ENT.PrintName="EZ Repulsion Grenade"
ENT.Category="JMod Extras - EZ Explosives"
ENT.Spawnable=true
ENT.JModPreferredCarryAngles=Angle(0,100,0)
ENT.Model="models/jmod/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material="models/mats_nick_nades/thermobaric"
ENT.HardThrowStr=350
ENT.SoftThrowStr=250
ENT.SpoonScale=2

if(SERVER)then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("weapons/pinpull.wav", 60, 100)
		self:SetBodygroup(3, 1)
	end
	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()
		timer.Simple(2.5, function()
			if(IsValid(self))then 
			self:Detonate() 
			end
		end)
	end
	function ENT:Detonate()
		if(self.Exploded)then 
			return 
		end

		self.Exploded=true

		local SelfPos = self:GetPos()

		local blacklist = {
				["worldspawn"]=true
		}	

		local plooie = EffectData()
		plooie:SetOrigin(self:GetPos())
		local ChargeUpSound = CreateSound(self, "weapons/cguard/charging.wav", nil)
		ChargeUpSound:Play()
		util.ScreenShake(self:GetPos(), 48, 36, 1.55, 256)
		util.Effect("eff_nick_gmod_pushnade_predet", plooie, true, true)
		timer.Simple(0.55, function()
			ChargeUpSound:Stop()
			util.Effect("eff_nick_gmod_pushnade_main", plooie, true, true)
			self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
			self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
			util.ScreenShake(self:GetPos(), 32, 16, 0.75, 512)
			util.BlastDamage(self.EZowner or self, self.EZowner or game:GetWorld(), self:GetPos(), 384, 125)
			JMod.BlastDoors(self.EZowner, self:GetPos(), 100, 445, false)
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 512)) do
				if (v ~= self) then
					local tr = util.QuickTrace(self:GetPos(), v:GetPos()-self:GetPos(), self)
					if JMod.VisCheck(self:GetPos(), v:GetPos(), self) then
						if IsValid((tr.Entity)) and not (blacklist[v:GetClass()]) and (tr.Entity == v) then
							local PhysObject = v:GetPhysicsObject()
							if IsValid((PhysObject)) then	
								local Mass = PhysObject:GetMass()
								local PushMass = Mass / 10 + 0.5
								local pushvec = tr.Normal * 15000 * PushMass
								local pushpos = tr.HitPos

								PhysObject:ApplyForceOffset(pushvec, pushpos)
							end
						end
					end
				end
			end
			self:Remove()
		end)
	end
elseif(CLIENT)then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("ent_jack_gmod_ezpushnade","EZ Soundwave Repulsor Grenade")
end