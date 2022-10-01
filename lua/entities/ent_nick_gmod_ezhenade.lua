-- Nick 2022, Jackarunda 2021
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="Nick"
ENT.PrintName="EZ HE Grenade"
ENT.Category="JMod Extras - EZ Explosives"
ENT.Spawnable=true
ENT.JModPreferredCarryAngles=Angle(0,100,0)
ENT.Model="models/jmodels/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material="models/mats_nick_nades/highexplosive_alt"
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
			if(IsValid(self))then self:Detonate() end
		end)
	end
	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded=true
		local SelfPos=self:GetPos()
		local PowerMult=0.69
		JMod.Sploom(self.Owner,self:GetPos(),150,400)
		JMod.BlastDoors(self.Owner, self:GetPos(), 100, 445, false)
		self:EmitSound("snd_jack_fragsplodeclose.wav",90,100)
		local plooie=EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(0.5)
		util.Effect("eff_jack_plastisplosion",plooie,true,true)
		util.ScreenShake(SelfPos,99999,99999,1,750*1.75)
		local OnGround=util.QuickTrace(SelfPos+Vector(0,0,5),Vector(0,0,-15),{self}).Hit
		local Spred=Vector(0,0,0)		
		self:Remove()
	end
elseif(CLIENT)then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("ent_jack_gmod_ezhenade","EZ High Explosive Grenade")
end