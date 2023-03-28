AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Nick, AdventureBoots"
ENT.Category = "JMod Extras - EZ Explosives"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Sodium"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
---
ENT.JModEZstorable = true
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)
---
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 2
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self.Entity:SetModel("models/props_pipes/pipe02_connector01.mdl") -- We need to replace this model
		--self.Entity:SetMaterial("models/jacky_camouflage/digi2") -- We need to replace this material
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(true)
		---
		timer.Simple(.01, function()
			self:GetPhysicsObject():SetMass(10)
			self:GetPhysicsObject():Wake()
		end)
	end

	function ENT:Use(activator)
		activator:PickupObject(self)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos = self:LocalToWorld(self:OBBCenter())
		JMod.Sploom(self.EZowner, SelfPos, math.random(10, 20))
		self:Remove()
	end

	function ENT:Think()
		--Here's where we will check for if we are underwater or not
	end
elseif CLIENT then
	language.Add("ent_nick_gmod_ezsodium", "EZ Sodium")
end
