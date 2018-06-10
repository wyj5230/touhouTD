function OnSunny01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_01_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 9, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	local DamageTable = {
		ability = keys.ability,
        victim = target, 
        attacker = caster, 
        damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
        damage_type = keys.ability:GetAbilityDamageType(), 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
   	}
   	UnitDamageTarget(DamageTable)
	
	local targets = THTD_FindUnitsInRadius(caster,targetPoint,1000)

	if targets[1]~=nil then
		local effectIndex_next = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_01_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

		ParticleManager:SetParticleControlEnt(effectIndex_next , 0, targets[1], 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex_next , 1, target, 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex_next , 9, targets[1], 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystem(effectIndex_next,false)

		local DamageTable = {
			ability = keys.ability,
	        victim = targets[1], 
	        attacker = caster, 
	        damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 2.0, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end

	if targets[2]~=nil then
		local effectIndex_next = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_01_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)

		ParticleManager:SetParticleControlEnt(effectIndex_next , 0, targets[2], 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex_next , 1, targets[1], 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex_next , 9, targets[2], 5, "attach_hitloc", Vector(0,0,0), true)
		ParticleManager:DestroyParticleSystem(effectIndex_next,false)

		local DamageTable = {
			ability = keys.ability,
	        victim = targets[2], 
	        attacker = caster, 
	        damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 4.0, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end
end


function OnSunny02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/sunny/ability_sunny_02.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex , 0, targetPoint+Vector(0,0,32))
	ParticleManager:DestroyParticleSystemTime(effectIndex,10.0)

	local count = 0

	caster:SetContextThink(DoUniqueString("ability_sunny_02_debuff"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end

			if count > 25 then
				return nil
			end

			local targets = THTD_FindUnitsInRadius(caster,targetPoint,400)

			for k,v in pairs(targets) do
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_sunny_02_debuff", {Duration = 0.6})
			end

			count = count + 1

			return 0.4
		end,
	0.4)
end
