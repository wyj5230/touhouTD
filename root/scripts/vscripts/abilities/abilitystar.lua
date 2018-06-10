function OnStar01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_star/ability_star_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
	ParticleManager:DestroyParticleSystem(effectIndex,false)

	caster:SetContextThink(DoUniqueString("ability_star_01_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
			for k,v in pairs(targets) do
				local DamageTable = {
		   			ability = keys.ability,
		            victim = v, 
		            attacker = caster, 
		            damage = caster:THTD_GetStar() * caster:THTD_GetPower(), 
		            damage_type = keys.ability:GetAbilityDamageType(), 
		            damage_flags = DOTA_DAMAGE_FLAG_NONE
			   	}
			   	UnitDamageTarget(DamageTable)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_star_01_slow", {Duration = 3.5})
			end
			return nil
		end,
	0.5)
end

function OnStar02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]

	local damage = caster:THTD_GetStar() * caster:THTD_GetPower() * 0.5

	local count = 0
	caster:SetContextThink(DoUniqueString("ability_star_02_delay"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end

			if count > 20 then
				return nil
			end

		   	local effectIndex = ParticleManager:CreateParticle("particles/heroes/thtd_star/ability_star_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex, 0, targetPoint)
			ParticleManager:DestroyParticleSystem(effectIndex,false)

			caster:SetContextThink(DoUniqueString("ability_star_02_delay"), 
				function()
					local targets = THTD_FindUnitsInRadius(caster,targetPoint,300)
					for k,v in pairs(targets) do
						local DamageTable = {
				   			ability = keys.ability,
				            victim = v, 
				            attacker = caster, 
				            damage = damage * 1.05, 
				            damage_type = keys.ability:GetAbilityDamageType(), 
				            damage_flags = DOTA_DAMAGE_FLAG_NONE
					   	}
					   	UnitDamageTarget(DamageTable)
					end
					return nil
				end,
			0.5)

			count = count + 1
			return 0.2
		end,
	0)
end