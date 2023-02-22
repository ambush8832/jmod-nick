-- Nick 2022, Jackarunda 2021
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="Nick"
ENT.PrintName="EZ BB Grenade"
ENT.Category="JMod Extras - EZ Misc."
ENT.Spawnable=true
ENT.JModPreferredCarryAngles=Angle(0,100,0)
ENT.Model="models/jmod/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material="models/mats_nick_nades/airsoft"
ENT.HardThrowStr=700
ENT.SoftThrowStr=500
ENT.SpoonScale=1.5
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
		timer.Simple(3, function()
			if(IsValid(self))then self:Detonate() end
		end)
	end
	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded=true
		local SelfPos=self:GetPos()
		self:EmitSound("snd_jack_fragsplodeclose.wav",90,100)
		local plooie=EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(0.75)
		util.Effect("eff_jack_bombletdetonate",plooie,true,true)
		util.ScreenShake(SelfPos,99999,99999,1,750*0.25)
		JMod.FragSplosion(self,SelfPos+Vector(0,0,20),50,-1,512,self.EZowner or game.GetWorld())
		local Spred=Vector(0,0,0)		
		self:Remove()
	end
elseif(CLIENT)then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("ent_nick_gmod_ezbbnade","EZ Airsoft Grenade")
end