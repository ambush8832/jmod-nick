-- Jackarunda 2021
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="Nick, AdventureBoots"
ENT.Category="JMod Extras - EZ Explosives"
ENT.PrintName="EZ Magnesium Grenade"
ENT.Spawnable=true

ENT.Model="models/jmodels/explosives/grenades/firenade/incendiary_grenade.mdl"
--ENT.ModelScale=1.5
ENT.SpoonModel="models/jmodels/explosives/grenades/firenade/incendiary_grenade_spoon.mdl"

local STATE_BURNING, ThinkRate = 6, 1

if(SERVER)then

	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("weapons/pinpull.wav", 60, 100)
		self:SetBodygroup(3, 1)
	end

	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)
		timer.Simple(2,function()
			if(IsValid(self))then self:Detonate() end
		end)
		self:SpoonEffect()
	end

	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded = true
		local SelfPos, Owner, Time = self:LocalToWorld(self:OBBCenter()), self.Owner or self, CurTime()
		JMod.Sploom(Owner, SelfPos, 10)
		self.NextSound = Time + 1
		self.NextEffect = Time + 0.5
		self.DieTime = Time + 120
		self.Range = 200
		self.Power = 2
		self.Size = 2
		self:SetState(STATE_BURNING)
	end

	function ENT:CustomThink(State, Time)
		if(self:GetState() == STATE_BURNING)then
			local Pos, Dir = self:GetPos(), self:GetForward()
			--print(self:WaterLevel())
			self:Extinguish()

			if (self.NextSound < Time) then
				self.NextSound=Time+1
				JMod.EmitAIsound(self:GetPos(),300,.5,8)
			end

			if (self.NextEffect < Time) then
				self.NextEffect=Time+0.3
				local Att, Infl = self.Owner or self, self or game.GetWorld()

				for k, v in pairs(ents.FindInSphere(Pos, 200)) do
					local blacklist={
						["vfire_ball"]=true,
						["ent_jack_gmod_ezfirehazard"]=true,
						["ent_jack_gmod_eznapalm"]=true
					}

					local Tr = util.QuickTrace(self:GetPos(), v:GetPos()-self:GetPos(), self)
					if not(blacklist[v:GetClass()]) and (IsValid(v:GetPhysicsObject())) and (Tr.Entity == v) then
						local Dam=DamageInfo()
						Dam:SetDamage(self.Power*math.Rand(.75, 1.25))
						Dam:SetDamageType(DMG_BURN)
						Dam:SetDamagePosition(Pos)
						Dam:SetAttacker(Att)
						Dam:SetInflictor(Infl)
						v:TakeDamageInfo(Dam)
						print("We dealt damage to: "..v:GetClass())

						if vFireInstalled then
							CreateVFireEntFires(v, math.random(1, 3))
						elseif (math.random() <= 0.15) then
							v:Ignite(10)
						end
					end
				end

				if vFireInstalled and math.random() <= 0.01 then
					CreateVFireBall(math.random(20, 30), math.random(10, 20), self:GetPos(), VectorRand()*math.random(200, 400), self:GetOwner())
				end

				if (math.random(1, 5) == 1) then
					local Tr=util.QuickTrace(Pos, VectorRand()*self.Range, {self})
					if (Tr.Hit) then
						util.Decal("Scorch", Tr.HitPos+Tr.HitNormal, Tr.HitPos-Tr.HitNormal)
					end
				end
			end
		
			if (IsValid(self)) then
				if (self.DieTime < Time) then
					self:Remove()
					return
				end
				--self:NextThink(Time+(1/ThinkRate))
			end
		end

		return true
	end
	
elseif(CLIENT)then
	function ENT:Initialize()
		local HighVisuals=true
		self.Ptype=1
		self.TypeInfo={"Napalm", {Sound("snds_jack_gmod/fire1.wav"), Sound("snds_jack_gmod/fire2.wav")}, "eff_nick_gmod_mgburn_smoky", 15, 14, 100}
		self.CastLight=(self.HighVisuals and math.random(1, 2) == 1) or (math.random(1, 10) == 1)
		self.Size=self.TypeInfo[6]
		--self.FlameSprite=Material("mats_jack_halo_sprites/flamelet"..math.random(1,5))
	end

	local GlowSprite=Material("mat_jack_gmod_glowsprite")

	function ENT:Draw()
		local Time, Pos=CurTime(), self:GetPos()
		self:DrawModel()
		if(self:GetState() == STATE_BURNING)then
			render.SetMaterial(GlowSprite)
			render.DrawSprite(Pos+VectorRand()*self.Size*math.Rand(0, .05), self.Size*math.Rand(.75, 1.25), self.Size*math.Rand(.50, 1), Color(255, 255, 255, 255))

			if (self.CastLight and not GAMEMODE.Lagging) then
				local dlight=DynamicLight(self:EntIndex())

				if (dlight) then
					dlight.pos=Pos
					dlight.r=255
					dlight.g=255
					dlight.b=175
					dlight.brightness=3
					dlight.Decay=200
					dlight.Size=400
					dlight.DieTime=CurTime()+.5
				end
			end
		end
	end
	language.Add("ent_jack_gmod_ezfirenade", "EZ Magnesium Grenade")
end