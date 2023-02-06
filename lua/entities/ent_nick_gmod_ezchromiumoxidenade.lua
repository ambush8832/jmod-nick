AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="Nick"
ENT.PrintName="EZ Toxic Gas Grenade"
ENT.Category="JMod Extras - EZ Misc."
ENT.Spawnable=true
ENT.JModPreferredCarryAngles=Angle(0,100,0)
ENT.Model="models/jmod/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material="models/mats_nick_nades/oxide"
ENT.SpoonScale=2
if(SERVER)then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("weapons/pinpull.wav", 60, 100)
		self:SetBodygroup(3,1)
	end
	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()
		timer.Simple(0,function()
			if(IsValid(self))then self:Detonate() end
		end)
	end
	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded=true
		self.FuelLeft=60
		self:EmitSound("snd_jack_fragsplodeclose.wav", 70, 150)
	end
	function ENT:CustomThink()
		if(self.Exploded)then
			if(self.FuelLeft > 0)then
				local Gas=ents.Create("ent_nick_gmod_ezchromiumoxideparticle")
				Gas:SetPos(self:LocalToWorld(self:OBBCenter()))
				JMod.SetOwner(Gas,self.Owner or self)
				Gas:Spawn()
				Gas:Activate()
				Gas:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity()+self:GetUp()*math.random(10,100))
				self:EmitSound("snd_jack_sss.wav",55,80)
				self.FuelLeft=self.FuelLeft-1
				if(self.FuelLeft<=0)then SafeRemoveEntityDelayed(self,1) end
			end
		end
	end
elseif(CLIENT)then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("ent_jack_gmod_ezfumigatornade","EZ Fumigator Grenade")
end