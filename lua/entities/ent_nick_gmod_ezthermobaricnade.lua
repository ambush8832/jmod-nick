-- Nick 2022, Jackarunda 2021
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezgrenade"
ENT.Author="Nick"
ENT.PrintName="EZ Fuel Air Grenade"
ENT.Category="JMod Extras - EZ Explosives"
ENT.Spawnable=true
ENT.JModPreferredCarryAngles=Angle(0, -240, 0)
ENT.Model="models/jmodels/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material="models/mats_nick_nades/thermobaric"
ENT.HardThrowStr=250
ENT.SoftThrowStr=100
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
		timer.Simple(math.random(3,7), function()
			if(IsValid(self))then self:Detonate() end
		end)
	end
	function ENT:Detonate()
if(self.Exploded)then return end
		self.Exploded=true
		local SelfPos,Att=self:GetPos()+Vector(0,0,60),self.Owner or game.GetWorld()
		JMod.Sploom(Att,SelfPos,100)
		---
		if(self:WaterLevel()>=3)then self:Remove();return end
		---
		local Sploom=EffectData()
		Sploom:SetOrigin(SelfPos)
		util.Effect("eff_jack_gmod_faebomb_predet",Sploom,true,true)
		---
		local Oof=.25
		for i=1,500 do
			local Tr=util.QuickTrace(SelfPos,VectorRand()*1000,self)
			if(Tr.Hit)then Oof=Oof*1.005 end
		end
		---
		timer.Simple(.3,function()
			util.ScreenShake(SelfPos,1000,3,2,2000*Oof)
			---
			util.BlastDamage(game.GetWorld(),Att,SelfPos,2000*Oof,200*Oof)
			---
			for i=1,2*Oof do
				sound.Play("ambient/explosions/explode_"..math.random(1,9)..".wav",SelfPos+VectorRand()*1000,160,math.random(80,110))
			end
			---
			JMod.WreckBuildings(self,SelfPos,10*Oof)
			JMod.BlastDoors(self,SelfPos,10*Oof)
			---
			timer.Simple(.2,function()
				JMod.WreckBuildings(self,SelfPos,10*Oof)
				JMod.BlastDoors(self,SelfPos,10*Oof)
			end)
			timer.Simple(.4,function()
				JMod.WreckBuildings(self,SelfPos,10*Oof)
				JMod.BlastDoors(self,SelfPos,10*Oof)
			end)
			---
			timer.Simple(.1,function()
				local Tr=util.QuickTrace(SelfPos+Vector(0,0,100),Vector(0,0,-400))
				if(Tr.Hit)then util.Decal("BigScorch",Tr.HitPos+Tr.HitNormal,Tr.HitPos-Tr.HitNormal) end
			end)
			---
			local Sploom=EffectData()
			Sploom:SetOrigin(SelfPos)
			Sploom:SetScale(Oof)
			util.Effect("eff_jack_gmod_faebomb_main",Sploom,true,true)
		end)
		self:Remove()
	end
elseif(CLIENT)then
	function ENT:Draw()
		self:DrawModel()
	end
	language.Add("ent_nick_gmod_ezthermobaricnade","EZ Thermobaric Grenade")
end