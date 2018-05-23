function OnHanadayousei01Attack(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local damage = caster:THTD_GetStar() * caster:THTD_GetPower()	
	local seed = RandomInt(1,100)

	if seed >= 40 then
		if target.thtd_is_lock_hourainingyou_01_stun ~= true then
			target.thtd_is_lock_hourainingyou_01_stun = true
			UnitStunTarget(caster,target,0.5)
			target:SetContextThink(DoUniqueString("ability_hourainingyou_01"), 
				function()
					if GameRules:IsGamePaused() then return 0.03 end
					target.thtd_is_lock_hourainingyou_01_stun = false
					return nil
				end,
			2.0)
		end
	end
	
	if caster.__hanadayousei_lock ~= true then 
		caster.__hanadayousei_lock = true
		local targets = THTD_FindUnitsInRadius(caster,caster:GetOrigin(),800)
		local attackcount = 0
		for i=1,#targets do
			local unit = targets[i]
			local multipoisoncount = 0
			if unit~=nil and unit:IsNull()==false and unit:IsAlive() then
				unit.thtd_poison_buff = unit.thtd_poison_buff + 1
				unit:SetContextThink(DoUniqueString("thtd_mugiyousei01_attack"), 
					function()
						if GameRules:IsGamePaused() then return 0.03 end
						if multipoisoncount > 5 then 
							unit.thtd_poison_buff = unit.thtd_poison_buff - 1
							return nil 
						end
						multipoisoncount = multipoisoncount + 1
						local DamageTable = {
								ability = keys.ability,
								victim = unit, 
								attacker = caster, 
								damage = damage, 
								damage_type = keys.ability:GetAbilityDamageType(), 
								damage_flags = DOTA_DAMAGE_FLAG_NONE
						}
						UnitDamageTarget(DamageTable)
						return 1.0
					end, 
				1.0)
			end
			
			if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
				caster:PerformAttack(unit,true,false,true,false,true,false,true)						
				
				if seed >= 40 then
					if unit.thtd_is_lock_hourainingyou_01_stun ~= true then
						unit.thtd_is_lock_hourainingyou_01_stun = true
						UnitStunTarget(caster,unit,0.5)
						unit:SetContextThink(DoUniqueString("ability_hourainingyou_01"), 
							function()
								if GameRules:IsGamePaused() then return 0.03 end
								unit.thtd_is_lock_hourainingyou_01_stun = false
								return nil
							end,
						2.0)
					end
				end
								
				attackcount = attackcount + 1
			end
			if attackcount > 8 then
				break
			end
		end
		caster.__hanadayousei_lock = false
	end
end