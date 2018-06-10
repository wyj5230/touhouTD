function OnLuna01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local targetPoint = target:GetOrigin()
	
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_luna/ability_luna_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 2, target:GetOrigin())
	ParticleManager:SetParticleControl(effectIndex, 5, target:GetOrigin())
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
		local effectIndex_next = ParticleManager:CreateParticle("particles/heroes/thtd_luna/ability_luna_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex_next, 0, targets[1]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex_next, 1, targets[1]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex_next, 2, targets[1]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex_next, 5, targets[1]:GetOrigin())
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
		local effectIndex_next = ParticleManager:CreateParticle("particles/heroes/thtd_luna/ability_luna_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(effectIndex_next, 0, targets[2]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex_next, 1, targets[2]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex_next, 2, targets[2]:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex_next, 5, targets[2]:GetOrigin())
		ParticleManager:DestroyParticleSystem(effectIndex_next,false)

		local DamageTable = {
			ability = keys.ability,
	        victim = targets[2], 
	        attacker = caster, 
	        damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 2.0, 
	        damage_type = keys.ability:GetAbilityDamageType(), 
	        damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end
end

local thtd_luna_02_bonus_table = 
{
	[3] = 100,
	[4] = 250,
	[5] = 500,
}

function OnLuna02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	local foward = (targetPoint - caster:GetAbsOrigin()):Normalized()

	local targets = 
		FindUnitsInLine(
			caster:GetTeamNumber(), 
			caster:GetOrigin(), 
			caster:GetOrigin() + foward*1000, 
			nil, 
			200,
			keys.ability:GetAbilityTargetTeam(), 
			keys.ability:GetAbilityTargetType(), 
			keys.ability:GetAbilityTargetFlags()
		)

	local bonus = thtd_luna_02_bonus_table[caster:THTD_GetStar()] * (#targets)

	if caster.thtd_luna_02_bonus == nil then
		caster.thtd_luna_02_bonus = false
	end

	if caster:THTD_IsTower() and caster.thtd_luna_02_bonus == false then
		caster:THTD_AddPower(bonus)
		caster:THTD_AddAttack(bonus)
		caster.thtd_luna_02_bonus = true

		caster:SetContextThink(DoUniqueString("thtd_luna_02_buff_remove"), 
			function()
				if GameRules:IsGamePaused() then return 0.03 end
				caster:THTD_AddPower(-bonus)
				caster:THTD_AddAttack(-bonus)
				caster.thtd_luna_02_bonus = false
			end,
		7.0)
	end

	local damage = caster:THTD_GetPower() * caster:THTD_GetStar() * 5

	for k,v in pairs(targets) do
		local DamageTable = {
   			ability = keys.ability,
            victim = v, 
            attacker = caster, 
            damage = damage, 
            damage_type = keys.ability:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
	   	}
	   	UnitDamageTarget(DamageTable)
	end

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_luna/ability_luna_02_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 1, caster:GetOrigin() + foward*1000 + Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 3, caster:GetOrigin() + foward*1000 + Vector(0,0,128))
	ParticleManager:SetParticleControl(effectIndex, 9, caster:GetOrigin() + Vector(0,0,128))
	ParticleManager:DestroyParticleSystemTime(effectIndex,2.0)
	
end