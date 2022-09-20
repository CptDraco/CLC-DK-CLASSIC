_G["CLCDK"] = CLCDK
local CLCDK = CreateFrame("Frame", nil, UIParent)
CLCDK:SetWidth(96)
CLCDK:SetHeight(68)
CLCDK:SetFrameStrata("BACKGROUND")
--CLCDK:SetBackdrop{bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = false, tileSize = 1,insets = {left = 0, right = 0, top = 0, bottom = 0},}
--CLCDK:SetBackdropColor(0, 0, 0, 0.5)

---Options---
CLCDK:SetPoint("CENTER", 0, -175) --Location
CLCDK:SetScale(1) --Scale
if showcastbar == nil then showcastbar = true; end --Show the castbar?
---End of Options---

local spec = ""
local GoD = false
local updatetimer = 0
local spectimer = 0
local runes_colour = {{1, 0, 0},{0, 0.95, 0},{0, 1, 1},{ 0.8, 0.1, 1 }}

function CLCDK:CreateIcon(spellname)
	frame = CreateFrame("Frame", nil, CLCDK)
	frame:SetWidth(24)
	frame:SetHeight(24)
	frame:SetFrameStrata("BACKGROUND")
	_, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellname)
	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetHeight(22)
	frame.Icon:SetWidth(22)
	frame.Icon:SetPoint("Center", frame, 0, 0)
	frame.Icon:SetTexture(icon)
	frame.Time = frame:CreateFontString(nil, 'OVERLAY')
	frame.Time:SetPoint("CENTER",frame, 0, 0)
	frame.Time:SetJustifyH("CENTER")
	frame.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 13, "OUTLINE")
	return frame
end

CLCDK.Move = CreateFrame("Frame", nil, CLCDK)
CLCDK.Move:SetWidth(48)
CLCDK.Move:SetHeight(48)
CLCDK.Move:SetFrameStrata("BACKGROUND")
CLCDK.Move:SetPoint("BOTTOMLEFT", CLCDK, "BOTTOMLEFT", 0, 0)
CLCDK.Move.Icon = CLCDK.Move:CreateTexture(nil, "ARTWORK")
CLCDK.Move.Icon:SetHeight(46)
CLCDK.Move.Icon:SetWidth(46)
CLCDK.Move.Icon:SetPoint("Center", CLCDK.Move, 0, 0)

CLCDK.tDK = CreateFrame("Frame", nil, CLCDK)
CLCDK.tDK:SetWidth(96)
CLCDK.tDK:SetHeight(22)
CLCDK.tDK:SetFrameStrata("BACKGROUND")
CLCDK.tDK:SetPoint("TOP", CLCDK, "TOP", 0, 0)
CLCDK.tDK.GCD = CreateFrame('StatusBar', nil, CLCDK)
CLCDK.tDK.GCD:SetWidth(94)
CLCDK.tDK.GCD:SetHeight(2)
CLCDK.tDK.GCD:SetFrameStrata("BACKGROUND")
CLCDK.tDK.GCD:SetPoint("TOP", CLCDK.tDK, 0, -1)
CLCDK.tDK.GCD:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
CLCDK.tDK.GCD:SetStatusBarColor(255/255, 198/255, 0); 
CLCDK.tDK.GCD:GetStatusBarTexture():SetHorizTile(false) 
CLCDK.tDK.GCD:GetStatusBarTexture():SetVertTile(false)
CLCDK.tDK.runebar = CLCDK:CreateFontString(nil, 'OVERLAY')
CLCDK.tDK.runebar:SetPoint("TOP", CLCDK.tDK.GCD, "BOTTOM", 0, -1)
CLCDK.tDK.runebar:SetJustifyH("CENTER")
CLCDK.tDK.runebar:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 18, "OUTLINE")	
CLCDK.tDK.power = CLCDK:CreateFontString(nil, 'OVERLAY')
CLCDK.tDK.power:SetPoint("CENTER", CLCDK, 25, 1)
CLCDK.tDK.power:SetJustifyH("CENTER")
CLCDK.tDK.power:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 18, "OUTLINE")	

CLCDK.TargetCast = CreateFrame('StatusBar', nil, CLCDK)
CLCDK.TargetCast:SetWidth(94)
CLCDK.TargetCast:SetHeight(12)
CLCDK.TargetCast:SetFrameStrata("HIGH")
CLCDK.TargetCast:SetPoint("BOTTOM", CLCDK.tDK, "TOP", 0, 1.5)
CLCDK.TargetCast:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
CLCDK.TargetCast:SetStatusBarColor(255/255, 198/255, 0); 
--CLCDK.TargetCast:SetBackdrop{bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = false, tileSize = 1,insets = {left = -1, right = -1, top = -1, bottom = -1},}
--CLCDK.TargetCast:SetBackdropColor(0,0,0,0.5)
CLCDK.TargetCast:Hide()
CLCDK.TargetCast.Name = CLCDK.TargetCast:CreateFontString(nil, 'OVERLAY')
CLCDK.TargetCast.Name:SetPoint("Left",CLCDK.TargetCast, 1, 0.5)
CLCDK.TargetCast.Name:SetJustifyH("LEFT")
CLCDK.TargetCast.Name:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 6, "OUTLINE")	
CLCDK.TargetCast.Time = CLCDK.TargetCast:CreateFontString(nil, 'OVERLAY')
CLCDK.TargetCast.Time:SetPoint("RIGHT",CLCDK.TargetCast, -1, 0.5)
CLCDK.TargetCast.Time:SetJustifyH("RIGHT")
CLCDK.TargetCast.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 6, "OUTLINE")
CLCDK.TargetCast:GetStatusBarTexture():SetHorizTile(false) 
CLCDK.TargetCast:GetStatusBarTexture():SetVertTile(false)

function CLCDK:UpdateDKUI()	
	if (InCombatLockdown() or ((UnitCanAttack("player", "target") and (not UnitIsDead("target"))))) and (not UnitInVehicle("player")) then
		CLCDK:SetAlpha(1)				
		CLCDK.FF.Icon:SetVertexColor(1, 1, 1, 1)
		CLCDK.BP.Icon:SetVertexColor(1, 1, 1, 1)
		CLCDK.FF.Time:SetText("")
		CLCDK.BP.Time:SetText("")
		
		--When Targeting an enemy
		if UnitCanAttack("player", "target") and (not UnitIsDead("target")) then	
			CLCDK.Move.Icon:Show()		
			CLCDK.Move.Icon:SetTexture(CLCDK:GetNextMove())
			
			--Diseases
			local ff = ""
			local bp = ""		
			for i = 1, 10 do
				name, _, _, _, _, _, expires, _, _, _, _ = UnitDebuff("target", i, "PLAYER")
				if name == "Frost Fever" then
					CLCDK.FF.Icon:SetVertexColor(.5, .5, .5, 1);
					ff = string.format("|cffffffff%.2d|r", expires - GetTime())				
				elseif name == "Blood Plague" then
					CLCDK.BP.Icon:SetVertexColor(.5, .5, .5, 1);
					bp = string.format("|cffffffff%.2d|r", expires - GetTime())			
				end		
			end		
			CLCDK.FF.Time:SetText(ff)
			CLCDK.BP.Time:SetText(bp)

			if showcastbar then
				--Cast	
				spell, _, displayName, _, startTime, endTime, _, _, _ = UnitCastingInfo("target")	
				if spell == nil then spell, _, displayName, _, startTime, endTime, _, _, _ = UnitChannelInfo("target") end		
				if spell ~= nil then
					startTime = (startTime / 1000);
					endTime = (endTime / 1000);
					local castTime = (endTime - startTime);	 
					CLCDK.TargetCast:Show()
					CLCDK.TargetCast:SetMinMaxValues(0, castTime)
					CLCDK.TargetCast:SetValue(min(GetTime() - startTime, castTime))
					CLCDK.TargetCast.Name:SetText(string.format("%.12s", string.len(displayName) > 12 and string.gsub(displayName, '%s?(.)%S+%s', '%1. ') or displayName))
					CLCDK.TargetCast.Time:SetText(string.format("%.1f",castTime-min(GetTime() - startTime, castTime)))							
				else	
					CLCDK.TargetCast:Hide()	
				end		
			end
		else
			CLCDK.Move.Icon:Hide()
			CLCDK.TargetCast:Hide()
		end	
									
		--Runes
		local runebar = ""
		for i = 1, 6 do     
			local start,cooldown,_ = GetRuneCooldown(i)
			local r, g, b = unpack(runes_colour[GetRuneType(i)])
			local cdtime = (cooldown-math.floor(GetTime()-start))		
			if cdtime == 10 then
				rune = string.format("|cff%02x%02x%02x9|r", r*255, g*255, b*255)
			elseif cdtime > 0 then
				rune = string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, cdtime)
			else
				rune = string.format("|cff%02x%02x%02x*|r", r*255, g*255, b*255)
			end       
			runebar = runebar..rune
		end   		
		CLCDK.tDK.runebar:SetText(runebar) 	
		
		--Power
		local p = UnitPower("player")	
		r, g, b = unpack(runes_colour[3])	
		CLCDK.tDK.power:SetText(string.format("|cff%02x%02x%02x%.3d|r",r*255, g*255, b*255, p))	
			
		--GCD	
		local start, dur = GetSpellCooldown("Death Coil")
		CLCDK.tDK.GCD:SetMinMaxValues(0, 1)
		CLCDK.tDK.GCD:Hide()
		if not start or start == 0 or not dur or dur == 0 or dur > 1.5 then		
			return
		end		
		local position = (GetTime() - start) / dur	
		if position < 1 then
			CLCDK.tDK.GCD:SetValue(position)
			CLCDK.tDK.GCD:Show()
		end		
	else
		CLCDK:SetAlpha(0)
	end	
end

---Priority System
local function runeCD (a, b)
	local _,_,cool_first = GetRuneCooldown(a)
	local _,_,cool_second = GetRuneCooldown(b)
	return (GetRuneType(a)== (a/2)+0.5 and cool_first == true) or (GetRuneType(b)== b/2 and cool_second == true)
end	

local function availableDeathRunesCount()	
	local count = 0
	for i = 1, 6 do	
		local _,_,cool = GetRuneCooldown(i)
		if GetRuneType(i)==4 and cool then
			count = count + 1
		end
	end
	return count
end

function CLCDK:GetRangeandIcon (move)
	if IsSpellInRange(move, "target") == 0 then
		CLCDK.Move.Icon:SetVertexColor(0.75, 0, 0, 1);
	end
	_, _, icon, _, _, _, _, _, _ = GetSpellInfo(move)
	return icon
end

function CLCDK:GetNextMove()
	if (spec == "unholy") then
		return CLCDK:UnholyMove()
	elseif (spec == "frost") then
		return CLCDK:FrostMove()
	elseif (spec == "blood") then
		return CLCDK:BloodMove()
	else
		return CLCDK:BlankMove()
	end
end

function CLCDK:GetDisease()
	local FFexpires, BPexpires
	for i = 1, 10 do
		name, _, _, _, _, _, expires, _, _, _, _ = UnitDebuff("target", i, "PLAYER")
		if name == "Frost Fever" then
			FFexpires = expires
		elseif name == "Blood Plague" then
			BPexpires = expires
		end		
	end
	
	if (GoD) then
		--Pestilence if less then 2 sec
		if (((FFexpires ~= nil) and (FFexpires - GetTime()) < 2) or ((BPexpires ~= nil) and ((BPexpires - GetTime()) < 2))) and (runeCD(1,2) or availableDeathRunesCount() > 1) then			
			return  true, CLCDK:GetRangeandIcon ("Pestilence")
		end
	end
	
	-- Icy Touch if no Frost Fever		
	if (FFexpires == nil or (FFexpires - GetTime()) < 2) and (runeCD(5,6) or availableDeathRunesCount() > 1) then			
		return true, CLCDK:GetRangeandIcon ("Icy Touch")
	end

	--Plague Strike if no Blood Plague
	if (BPexpires == nil or (BPexpires - GetTime()) < 2) and (runeCD(3,4) or availableDeathRunesCount() > 1) then
		return true, CLCDK:GetRangeandIcon ("Plague Strike")
	end	
	
	return false
end

 function CLCDK:UnholyMove()
	CLCDK.Move.Icon:SetVertexColor(1, 1, 1, 1); 
	-- Bone Shield
	_, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("player", "Bone Shield")
	start, duration, enable =  GetSpellCooldown("Bone Shield")
	if expires == nil and (runeCD(3,4) or availableDeathRunesCount() > 1) and ((not enable) or (start + duration - GetTime()) < 1) then	
		_, _, icon, _, _, _, _, _, _ = GetSpellInfo("Bone Shield")
		return icon
	end		
	
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	
		return move
	end	
	
	-- Blood Strike if no Deso
	_, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("player", "Desolation")
	if expires == nil and (runeCD(1,2) or availableDeathRunesCount() > 1) then	
		return CLCDK:GetRangeandIcon ("Blood Strike")
	end	
	
	--Scourge Strike
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount()>=2 then
		return CLCDK:GetRangeandIcon ("Scourge Strike")
	end	
	
	-- Death Coil
	if UnitPower("player") > 79 then
		return CLCDK:GetRangeandIcon ("Death Coil")
	end	
	
	-- Blood Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon ("Blood Strike")
	end	
		
	-- Death Coil
	if UnitPower("player") > 39 then
		return CLCDK:GetRangeandIcon ("Death Coil")
	end	
	
	-- If nothing else can be done
	return nil				
end

function CLCDK:FrostMove()
	CLCDK.Move.Icon:SetVertexColor(1, 1, 1, 1); 
		
	-- If Killing Machine
	_, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("player", "Killing Machine")
	if expires ~= nil then
		-- If Rime, Howling Blast
		_, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("player", "Freezing Fog")
		if expires ~= nil then			
			return CLCDK:GetRangeandIcon ("Howling Blast")
		end
		
		-- Frost Strike
		if UnitPower("player") > 32 then	
			return CLCDK:GetRangeandIcon ("Frost Strike")
		end
	end		
	
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	
		return move
	end	
	
	--Obliterate
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount()>=2 then
		return CLCDK:GetRangeandIcon ("Obliterate")
	end	
	
	-- Blood Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon ("Blood Strike")
	end	
		
	-- Frost Strike
	if UnitPower("player") > 31 then
		return CLCDK:GetRangeandIcon ("Frost Strike")
	end	
	
	-- If Rime, Howling Blast
	_, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("player", "Freezing Fog")
	if expires ~= nil then	
		CLCDK:GetRangeandIcon ("Howling Blast")
	end		
	
	-- If nothing else can be done
	return nil				
end

function CLCDK:BloodMove()
	CLCDK.Move.Icon:SetVertexColor(1, 1, 1, 1); 
		
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	
		return move
	end	
	
	-- Heart Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon ("Heart Strike")
	end	
	
	--Death Strike
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount()>=2 then
		return CLCDK:GetRangeandIcon ("Death Strike")
	end	
			
	-- Death Coil
	if UnitPower("player") > 39 then
		return CLCDK:GetRangeandIcon ("Death Coil")
	end	
	
	-- If nothing else can be done
	return nil				
end	

function CLCDK:BlankMove()
	CLCDK.Move.Icon:SetVertexColor(1, 1, 1, 1); 
		
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	
		return move
	end	
	
	-- Blood Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon ("Blood Strike")
	end	
	
	--Death Strike
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount()>=2 then
		return CLCDK:GetRangeandIcon ("Death Strike")
	end	
			
	-- Death Coil
	if UnitPower("player") > 39 then
		return CLCDK:GetRangeandIcon ("Death Coil")
	end	
	
	-- If nothing else can be done
	return nil				
end	

function CLCDK:CheckSpec()
	if (IsSpellKnown(55090) or IsSpellKnown(55265) or IsSpellKnown(55270) or IsSpellKnown(55271)) then --Scourge Strike
		spec = "unholy"
	end
	if (IsSpellKnown(55050) or IsSpellKnown(55258) or IsSpellKnown(55259) or IsSpellKnown(55260) or IsSpellKnown(55261) or IsSpellKnown(55262)) then --Heart Strike
		spec = "blood"
	end
	if (IsSpellKnown(49143) or IsSpellKnown(51416) or IsSpellKnown(51417) or IsSpellKnown(51418) or IsSpellKnown(51419) or IsSpellKnown(55268)) then --Frost Strike
		spec = "frost"
	end
	
	for i = 1, 6 do
		local _, _, glyphID, _ = GetGlyphSocketInfo(i);
		if ( glyphID ~= nil ) then	
			if ( glyphID == 63334 ) then --Glyph of Disease
				GoD = true
			end	
		end
	end	
end

CLCDK:SetScript("OnEvent", function(self, e) if(CLCDK[e]) then CLCDK[e]() end end)

CLCDK:RegisterEvent("PLAYER_LOGIN")
function CLCDK:PLAYER_LOGIN()
	_, englishClass = UnitClass("player");	
	if englishClass == "DEATHKNIGHT" then	
		CLCDK.BP = CLCDK:CreateIcon("Blood Plague")
		CLCDK.BP:SetPoint("BOTTOMRIGHT", CLCDK, "BOTTOMRIGHT", 0, 0)
		CLCDK.FF = CLCDK:CreateIcon("Frost Fever")
		CLCDK.FF:SetPoint("RIGHT", CLCDK.BP, "LEFT", 0, 0)					
		RuneFrame:Hide()
	else
		CLCDK.Show = dummy	
		CLCDK:UnregisterAllEvents()	
		CLCDK:Hide()				
	end		
end

CLCDK:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
function CLCDK:ACTIVE_TALENT_GROUP_CHANGED()
	CLCDK:CheckSpec()
end

CLCDK:RegisterEvent("PLAYER_ENTERING_WORLD")
function CLCDK:PLAYER_ENTERING_WORLD()	
	CLCDK:CheckSpec()	
end

CLCDK:SetScript("OnUpdate", function() 
	local timer = GetTime()    	
	if (timer - updatetimer >= 0.04) then		
		updatetimer = timer
		CLCDK:UpdateDKUI()
	end	
	if (timer - spectimer >= 300) then
		spectimer = timer
		CLCDK:CheckSpec()
	end	
end)
