_G["CLCDK"] = CLCDK
CLCDK_CONFIG_Ver = "1.0c"

-----Create Main Frame-----
local CLCDK = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
CLCDK:SetWidth(94)
CLCDK:SetHeight(68)
CLCDK:SetFrameStrata("BACKGROUND")
CLCDK:SetBackdrop{bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = false, tileSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0},}
CLCDK:SetBackdropColor(0, 0, 0, 0.5)
-----End Create Main Frame-----

-----Locals-----
local spec, GoD, FS
--local SPEC_UNKNOWN, SPEC_BLOOD, SPEC_FROST, SPEC_UNHOLY = 0, 1, 2, 3
local updatetimer = 0
local runes_colour = {{1, 0, 0},{0, 1, 1},{0, 0.95, 0},{0.8, 0.1, 1}} --Blood,  Unholy,  Frost,  Death
local spells = {
	["Frost Fever"] = GetSpellInfo(55095),
	["Blood Plague"] = GetSpellInfo(55078),
	
	["Icy Touch"] = GetSpellInfo(45477),
	["Plague Strike"] = GetSpellInfo(45462),
	["Blood Strike"] = GetSpellInfo(45902),
	["Death Strike"] = GetSpellInfo(66188),
	["Obliterate"] = GetSpellInfo(66198),
	["Death Coil"] = GetSpellInfo(49895),
	["Pestilence"] = GetSpellInfo(50842),	
	["Horn of Winter"] = GetSpellInfo(57330),
	["Anti-Magic Shell"] = GetSpellInfo(48707),
	["Icebound Fortitude"] = GetSpellInfo(48792),
	["Death Grip"] = GetSpellInfo(49576),	
	["Strangulate"] = GetSpellInfo(47476),
	["Dark Command"] = GetSpellInfo(56222),
	["Death Pact"] = GetSpellInfo(48743),
	["Mind Freeze"] = GetSpellInfo(47528),
	["Death and Decay"] = GetSpellInfo(49938),
	["Raise Ally"] = GetSpellInfo(61999),
	["Raise Dead"] = GetSpellInfo(46584),
	["Army of the Dead"] = GetSpellInfo(42650),
	["Blood Tap"] = GetSpellInfo(45529),
	["Empower Rune Weapon"] = GetSpellInfo(47568),		
	
	
	["Heart Strike"] = GetSpellInfo(55258),
	["Hysteria"] = GetSpellInfo(49016),
	
	["Frost Strike"] = GetSpellInfo(51416),
	["Howling Blast"] = GetSpellInfo(51409),
	["Killing Machine"] = GetSpellInfo(51124),
	["Freezing Fog"] = GetSpellInfo(59052),
	["Unbreakable Armor"] = GetSpellInfo(51271),
	
	["Desolation"] = GetSpellInfo(63583),
	["Scourge Strike"] = GetSpellInfo(55265),
	["Bone Shield"] = GetSpellInfo(49222),
	["Summon Gargoyle"] = GetSpellInfo(49206),
	["Ghoul Frenzy"] = GetSpellInfo(63560),	
	
}
------End Locals------

function CLCDKUpdatePosition()
	CLCDK:ClearAllPoints()
	CLCDK:SetPoint(CLCDK_Settings.Point, "UIParent", CLCDK_Settings.X, CLCDK_Settings.Y)
	CLCDK:SetScale(CLCDK_Settings.Scale)
	CLCDK:SetBackdropColor(0, 0, 0, CLCDK_Settings.Trans)
end

function formatTime(timeleft)
	if timeleft > 3600 then
		return format("%dh:%dm", timeleft/3600, ((timeleft%3600)/60))
	elseif timeleft > 600 then 
		return format("%dm", timeleft/60)
	elseif timeleft > 60 then 
		return format("%d:%2.2d", timeleft/60, timeleft%60)
	end	
	return timeleft
end	

CLCDK:SetScript("OnClick", function(self, button)
	if button == "RightButton" and CLCDK:GetAlpha() ~= 0 then
        ToggleDropDownMenu(1, nil, CLCDK_Menu, "cursor", 0, 0)
    end
end)

CLCDK:SetScript("OnMouseDown", function(self, button)
	if not CLCDK_Settings.Locked then
		CloseDropDownMenus()
		CLCDK:StartMoving()		
	end
end)

CLCDK:SetScript("OnMouseUp", function(self, button)
	CLCDK:StopMovingOrSizing()
	_, _, CLCDK_Settings.Point, CLCDK_Settings.X, CLCDK_Settings.Y = CLCDK:GetPoint()
end)
-----End Menu-----	
	
-----Create Frames------
function CLCDK:CreateIcon(spellname, size)
	frame = CreateFrame("Frame", nil, CLCDK, "BackdropTemplate")
	frame:SetWidth(size)
	frame:SetHeight(size)
	frame:SetFrameStrata("BACKGROUND")
	icon = GetSpellTexture(spellname)
	frame.Spell = spellname
	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetHeight(size-2)
	frame.Icon:SetWidth(size-2)
	frame.Icon:SetPoint("Center", frame, 0, 0)
	frame.Icon:SetTexture(icon)
	frame.Time = frame:CreateFontString(nil, 'OVERLAY')
	frame.Time:SetPoint("CENTER",frame, 0, 0)
	frame.Time:SetJustifyH("CENTER")
	frame.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 13, "OUTLINE")
	return frame
end

CLCDK.CD1 = CreateFrame("Button", nil, CLCDK, "BackdropTemplate")
CLCDK.CD1:SetWidth(33)
CLCDK.CD1:SetHeight(68)
CLCDK.CD1:SetFrameStrata("BACKGROUND")
CLCDK.CD1:SetBackdrop{bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = false, tileSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0},}
CLCDK.CD1:SetBackdropColor(0, 0, 0, 0.5)
CLCDK.CD1:SetPoint("TOPRIGHT", CLCDK, "TOPLEFT", 0, 0)
CLCDK.CD1.One = CLCDK:CreateIcon(spells["Horn of Winter"], 33)
CLCDK.CD1.One:SetPoint("TOPLEFT", CLCDK.CD1, "TOPLEFT", 0, -1)
CLCDK.CD1.One.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 11, "OUTLINE")
CLCDK.CD1.Two = CLCDK:CreateIcon(spells["Horn of Winter"], 33)
CLCDK.CD1.Two:SetPoint("TOPLEFT", CLCDK.CD1.One, "BOTTOMLEFT", 0, 0)
CLCDK.CD1.Two.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 11, "OUTLINE")

CLCDK.CD2 = CreateFrame("Button", nil, CLCDK, "BackdropTemplate")
CLCDK.CD2:SetWidth(33)
CLCDK.CD2:SetHeight(68)
CLCDK.CD2:SetFrameStrata("BACKGROUND")
CLCDK.CD2:SetBackdrop{bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = false, tileSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0},}
CLCDK.CD2:SetBackdropColor(0, 0, 0, 0.5)
CLCDK.CD2:SetPoint("TOPLEFT", CLCDK, "TOPRIGHT", 0, 0)
CLCDK.CD2.One = CLCDK:CreateIcon(spells["Horn of Winter"], 33)
CLCDK.CD2.One:SetPoint("TOPLEFT", CLCDK.CD2, "TOPLEFT", 0, -1)
CLCDK.CD2.One.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 11, "OUTLINE")
CLCDK.CD2.Two = CLCDK:CreateIcon(spells["Horn of Winter"], 33)
CLCDK.CD2.Two:SetPoint("TOPLEFT", CLCDK.CD2.One, "BOTTOMLEFT", 0, 0)
CLCDK.CD2.Two.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 11, "OUTLINE")

CLCDK.Icon = CLCDK:CreateTexture(nil, "ARTWORK")
CLCDK.Icon:SetHeight(46)
CLCDK.Icon:SetWidth(46)
CLCDK.Icon:SetPoint("BOTTOMLEFT", CLCDK, "BOTTOMLEFT", 0, 1)

CLCDK.GCD = CreateFrame('StatusBar', nil, CLCDK, "BackdropTemplate")
CLCDK.GCD:SetWidth(94)
CLCDK.GCD:SetHeight(2)
CLCDK.GCD:SetFrameStrata("BACKGROUND")
CLCDK.GCD:SetPoint("TOPRIGHT", CLCDK, "TOPRIGHT", 0, -1)
CLCDK.GCD:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
CLCDK.GCD:SetStatusBarColor(255/255, 198/255, 0); 
CLCDK.GCD:GetStatusBarTexture():SetHorizTile(false) 
CLCDK.GCD:GetStatusBarTexture():SetVertTile(false)

CLCDK.RuneBar = CLCDK:CreateFontString(nil, 'OVERLAY')
CLCDK.RuneBar:SetPoint("TOPRIGHT", CLCDK, "TOPRIGHT", -10, -2)
CLCDK.RuneBar:SetJustifyH("CENTER")
CLCDK.RuneBar:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 18, "OUTLINE")	

CLCDK.RunicPower = CLCDK:CreateFontString(nil, 'OVERLAY')
CLCDK.RunicPower:SetPoint("TOPLEFT", CLCDK.Icon, "TOPRIGHT", 4, 0)
CLCDK.RunicPower:SetJustifyH("CENTER")
CLCDK.RunicPower:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 18, "OUTLINE")	

CLCDK.TargetCast = CreateFrame('StatusBar', nil, CLCDK, "BackdropTemplate")
CLCDK.TargetCast:SetWidth(94)
CLCDK.TargetCast:SetHeight(12)
CLCDK.TargetCast:SetFrameStrata("HIGH")
CLCDK.TargetCast:SetPoint("BOTTOM", CLCDK, "TOP", 0, 1.5)
CLCDK.TargetCast:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
CLCDK.TargetCast:SetStatusBarColor(255/255, 198/255, 0); 
CLCDK.TargetCast:GetStatusBarTexture():SetHorizTile(false) 
CLCDK.TargetCast:GetStatusBarTexture():SetVertTile(false)
CLCDK.TargetCast:SetBackdrop{bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = false, tileSize = 1,insets = {left = -1, right = -1, top = -1, bottom = -1},}
CLCDK.TargetCast:SetBackdropColor(0,0,0,0.5)
CLCDK.TargetCast.Name = CLCDK.TargetCast:CreateFontString(nil, 'OVERLAY')
CLCDK.TargetCast.Name:SetPoint("Left",CLCDK.TargetCast, 1, 0.5)
CLCDK.TargetCast.Name:SetJustifyH("LEFT")
CLCDK.TargetCast.Name:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 6, "OUTLINE")	
CLCDK.TargetCast.Time = CLCDK.TargetCast:CreateFontString(nil, 'OVERLAY')
CLCDK.TargetCast.Time:SetPoint("RIGHT",CLCDK.TargetCast, -1, 0.5)
CLCDK.TargetCast.Time:SetJustifyH("RIGHT")
CLCDK.TargetCast.Time:SetFont('Interface\\AddOns\\CLC_DK\\verdanab.ttf', 6, "OUTLINE")
-----End Create Frames-------

------Update Frames------
function CLCDK:UpdateUI()	
	CLCDK:SetAlpha(1)
	CLCDK.FF.Icon:SetVertexColor(1, 1, 1, 1)
	CLCDK.BP.Icon:SetVertexColor(1, 1, 1, 1)		
	CLCDK.FF.Time:SetText("")
	CLCDK.BP.Time:SetText("")	
	
	--When Targeting an enemy
	if UnitCanAttack("player", "target") and (not UnitIsDead("target")) then
		if CLCDK_Settings.Priority then
			CLCDK.Icon:SetAlpha(1)	
			CLCDK.Icon:SetTexture(CLCDK:GetNextMove())
		else
			CLCDK.Icon:SetAlpha(0)	
		end
		
		--Diseases	
		if CLCDK_Settings.Disease then 
			CLCDK.BP:SetAlpha(1)	
			CLCDK.FF:SetAlpha(1)	
			for i = 1, 10 do
				local name, _, _, _, dur, expires, _, _, _, id = UnitDebuff("target", i, "PLAYER");
				if id == (55095) then
					CLCDK.FF.Icon:SetVertexColor(.5, .5, .5, 1);
					CLCDK.FF.Time:SetText(math.floor(expires - GetTime()));				
				elseif id == (55078) then
					CLCDK.BP.Icon:SetVertexColor(.5, .5, .5, 1);
					CLCDK.BP.Time:SetText(math.floor(expires - GetTime()));	
				end		
			end	
		else
			CLCDK.BP:SetAlpha(0);	
			CLCDK.FF:SetAlpha(0);	
		end
		
		--Castbar
		if CLCDK_Settings.CastBar then					
			spell, _, displayName, _, startTime, endTime, _, _, _ = UnitCastingInfo("target")	
			if spell == nil then spell, _, displayName, _, startTime, endTime, _, _, _ = UnitChannelInfo("target") end		
			if spell ~= nil then
				startTime = (startTime / 1000);
				endTime = (endTime / 1000);
				local castTime = (endTime - startTime);	 
				CLCDK.TargetCast:SetAlpha(1)
				CLCDK.TargetCast:SetMinMaxValues(0, castTime)
				CLCDK.TargetCast:SetValue(min(GetTime() - startTime, castTime))
				CLCDK.TargetCast.Name:SetText(string.format("%.12s", string.len(displayName) > 12 and string.gsub(displayName, '%s?(.)%S+%s', '%1. ') or displayName))
				CLCDK.TargetCast.Time:SetText(string.format("%.1f",castTime-min(GetTime() - startTime, castTime)))							
			else	
				CLCDK.TargetCast:SetAlpha(0)
			end		
		end		
	else	
		CLCDK.Icon:SetAlpha(0)
		CLCDK.TargetCast:SetAlpha(0)
	end	
	
	--CD1
	if CLCDK_Settings.CD["1"] then
		CLCDK.CD1:SetAlpha(1)
		--CD.One
		if CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_One"] ~= CLCDK_None then			
			CLCDK.CD1.One:SetAlpha(1)		
			icon = GetSpellTexture(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_One"])
			CLCDK.CD1.One.Icon:SetTexture(icon)
			if icon ~= nil then
				start, duration, enable =  GetSpellCooldown(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_One"])
				t = ceil(start + duration - GetTime())
				if t < 0 then
					CLCDK.CD1.One.Icon:SetVertexColor(1, 1, 1, 1);
					CLCDK.CD1.One.Time:SetText("")
				elseif enable == 1 and not(t < 5 and CLCDK.CD1.One.Time:GetText() == nil) then
					CLCDK.CD1.One.Icon:SetVertexColor(0.5, 0.5, 0.5, 1);
					CLCDK.CD1.One.Time:SetText(formatTime(t))
				end			
			end
		else
			CLCDK.CD1.One:SetAlpha(0)	
		end
		--CD.Two
		if CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_Two"] ~= CLCDK_None then
			CLCDK.CD1.Two:SetAlpha(1)
			icon = GetSpellTexture(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_Two"])
			CLCDK.CD1.Two.Icon:SetTexture(icon)
			if icon ~= nil then
				start, duration, _ =  GetSpellCooldown(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_Two"])
				t = ceil(start + duration - GetTime())
				if t < 0 then
					CLCDK.CD1.Two.Icon:SetVertexColor(1, 1, 1, 1);
					CLCDK.CD1.Two.Time:SetText("")
				elseif enable == 1 and not(t < 5 and CLCDK.CD1.Two.Time:GetText() == nil) then
					CLCDK.CD1.Two.Icon:SetVertexColor(0.5, 0.5, 0.5, 1);
					CLCDK.CD1.Two.Time:SetText(formatTime(t))
				end
			end
		else
			CLCDK.CD1.Two:SetAlpha(0)
		end	
	else	
		CLCDK.CD1:SetAlpha(0)
		CLCDK.CD1.One:SetAlpha(0)	
		CLCDK.CD1.Two:SetAlpha(0)	
	end
	
	--CD2
	if CLCDK_Settings.CD["2"] then
		CLCDK.CD2:SetAlpha(1)	
		--CD.One
		if CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_One"] ~= CLCDK_None then
			CLCDK.CD2.One:SetAlpha(1)	
			icon = GetSpellTexture(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_One"])
			CLCDK.CD2.One.Icon:SetTexture(icon)
			if icon ~= nil then
				start, duration, enable =  GetSpellCooldown(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_One"])
				t = ceil(start + duration - GetTime())
				if t < 0 then
					CLCDK.CD2.One.Icon:SetVertexColor(1, 1, 1, 1);
					CLCDK.CD2.One.Time:SetText("")
				elseif enable == 1 and not(t < 5 and CLCDK.CD2.One.Time:GetText() == nil) then
					CLCDK.CD2.One.Icon:SetVertexColor(0.5, 0.5, 0.5, 1);
					CLCDK.CD2.One.Time:SetText(formatTime(t))
				end
			end
		else
			CLCDK.CD2.One:SetAlpha(0)	
		end
		--CD.Two
		if CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_Two"] ~= CLCDK_None then
			CLCDK.CD2.Two:SetAlpha(1)
			icon = GetSpellTexture(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_Two"])
			CLCDK.CD2.Two.Icon:SetTexture(icon)
			if icon ~= nil then
				start, duration, _ =  GetSpellCooldown(CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_Two"])
				t = ceil(start + duration - GetTime())
				if t < 0 then
					CLCDK.CD2.Two.Icon:SetVertexColor(1, 1, 1, 1);
					CLCDK.CD2.Two.Time:SetText("")
				elseif enable == 1 and not(t < 5 and CLCDK.CD2.Two.Time:GetText() == nil) then
					CLCDK.CD2.Two.Icon:SetVertexColor(0.5, 0.5, 0.5, 1);
					CLCDK.CD2.Two.Time:SetText(formatTime(t))
				end
			end
		else
			CLCDK.CD2.Two:SetAlpha(0)
		end
	else	
		CLCDK.CD2:SetAlpha(0)
		CLCDK.CD2.One:SetAlpha(0)	
		CLCDK.CD2.Two:SetAlpha(0)	
	end	
	
	--Runes
	if CLCDK_Settings.Rune then
		CLCDK.RuneBar:SetAlpha(1)	
		local RuneBar = ""
		for i = 1, 6 do     
			local start,cooldown,_ = GetRuneCooldown(i)
			local r, g, b = unpack(runes_colour[GetRuneType(i)])
			local cdtime = (math.ceil(cooldown-(GetTime()-start)))		
			if cdtime == 10 then
				cdtime = "9"
			elseif cdtime <= 0 then				
				cdtime = "*"
			end       
			RuneBar = RuneBar..string.format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, cdtime)
		end   		
		CLCDK.RuneBar:SetText(RuneBar) 	
	else
		CLCDK.RuneBar:SetAlpha(0)	
	end
	
	--RunicPower
	if CLCDK_Settings.RP then
		CLCDK.RunicPower:SetAlpha(1)	
		r, g, b = unpack(runes_colour[2])	
		CLCDK.RunicPower:SetText(string.format("|cff%02x%02x%02x%.3d|r",r*255, g*255, b*255, UnitPower("player")))	
	else
		CLCDK.RunicPower:SetAlpha(0)	
	end	
		
	--GCD	
	if CLCDK_Settings.GCD then
		CLCDK.GCD:SetAlpha(1)	
		local start, dur = GetSpellCooldown(spells["Death Coil"])
		CLCDK.GCD:SetMinMaxValues(0, 1)		
		if not start or start == 0 or not dur or dur == 0 or dur > 1.5 then		
			CLCDK.GCD:Hide()
		else	
			local position = (GetTime() - start) / dur	
			if position < 1 then
				CLCDK.GCD:SetValue(position)
				CLCDK.GCD:Show()
			end		
		end	
	else
		CLCDK.GCD:SetAlpha(0)	
	end
end
-----End Update Frame

-----Priority System-----
local function getGCD ()
	local GCD
	local curtime = GetTime()
	local start, dur = GetSpellCooldown(spells["Death Coil"])
	if dur ~= 0 and start ~= nil then GCD =  dur - (start - curtime)
	else GCD = 0 end
	return GCD
end

local function runeCD(a, b)
	local curtime = GetTime()
	local GCD = getGCD()
			
	local start, dur, cool = GetRuneCooldown(a)		
	if (GetRuneType(a) == (a/2)+0.5) and (cool or (dur - (start - curtime)) < GCD) then
		return true
	end	

	local start, dur, cool = GetRuneCooldown(b)
	if (GetRuneType(b) == (b/2)) and (cool or (dur - (start - curtime)) < GCD) then
		return true
	end	
end		

--Returns the total number of Death runes off CD
local function availableDeathRunesCount()	
	local count = 0
	for i = 1, 6 do
		local _, _, cool = GetRuneCooldown(i)
		if GetRuneType(i) == 4 and cool then
				count = count + 1	
		end
	end
	return count
end

-- Returns the number of depleted runes (runes on CD)
local function DepletedRunes()
    local count = 6
    for i = 1, 6 do
		local start, dur, cool = GetRuneCooldown(i)
        if cool or isOffCD(start, dur) then
			count = count - 1
        end
    end
    return count
end

function CLCDK:GetRangeandIcon(move)
	if IsSpellInRange(move, "target") == 0 then
		CLCDK.Icon:SetVertexColor(0.8, 0.05, 0.05, 1);
	end
	icon = GetSpellTexture(move)
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
	local GCD = getGCD ()
	local curtime = GetTime()
	for i = 1, 40 do
		local name, _, _, _, dur, expires, _, _, _, id = UnitDebuff("target", i, "PLAYER");
		if name == "Frost Fever" then
			FFexpires = expires - curtime;
		elseif name == "Blood Plague" then
			BPexpires = expires - curtime;
		end			
		if FFexpires and BPexpires then
			break -- only cycle as many times as required and no more
		end
	end
	
	--Pestilence if less then 2 sec
	if GoD then
		for i = 1, 2 do
		local start, dur = GetSpellCooldown(spells["Death Coil"])
			if dur ~= 0 and start ~= nil then 
				GCD =  dur - (curtime - start)	
			else GCD = 0
			end
		end	
	end
	
	if (FFexpires ~= nil and BPexpires ~= nil) and (FFexpires  > GCD and BPexpires > GCD) and (FFexpires < (2 + GCD) or BPexpires < (2 + GCD)) and (runeCD(1,2) or availableDeathRunesCount() >= 1) then		
		return  true, CLCDK:GetRangeandIcon(spells["Pestilence"])
	end	
	
	--Icy Touch if no Frost Fever	
	if FFexpires == nil or FFexpires <= (2 + GCD) then
		return true, CLCDK:GetRangeandIcon(spells["Icy Touch"])
	end
	
	--Plague Strike if no Blood Plague	
	if BPexpires == nil or BPexpires <= (2 + GCD) then
		return true, CLCDK:GetRangeandIcon(spells["Plague Strike"])
	end
	
end

 function CLCDK:UnholyMove()
	CLCDK.Icon:SetVertexColor(1, 1, 1, 1);
	
	-- Bone Shield
	for i = 1, 3 do
		local start, duration, enable, _ = GetSpellCooldown(spells["Bone Shield"])
		if name == "Bone Shield" and (runeCD(3,4) or availableDeathRunesCount() > 1) and ((not enable) or (start + duration - GetTime()) < getGCD()) then	
			icon = GetSpellTexture(spells["Bone Shield"])
			return icon
		end
	end		
	
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	return move	end		
	
	-- Blood Strike if no Deso
	for i = 1, 10 do
	local name, _, _, _, dur, expires, _, _, _, id = UnitBuff("player", i)
		if name == "Desolation" and expires == nil and (runeCD(1,2) or availableDeathRunesCount() > 1) then	
			return CLCDK:GetRangeandIcon(spells["Blood Strike"])
		end	
	end
	--Scourge Strike
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount()>=2 then
		return CLCDK:GetRangeandIcon(spells["Scourge Strike"])
	end	
	
	-- Death Coil
	if UnitPower("player") >= (UnitPowerMax("player")-20) then
		return CLCDK:GetRangeandIcon(spells["Death Coil"])
	end	
	
	-- Blood Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon(spells["Blood Strike"])
	end	
		
	-- Death Coil
	if UnitPower("player") >= 40 then
		return CLCDK:GetRangeandIcon(spells["Death Coil"])
	end	
	
	if CLCDK_Settings.Horn then
		start, duration, enable, _ =  GetSpellCooldown(spells["Horn of Winter"])
		if (not enable) or(start + duration - GetTime()) < getGCD() then
			return CLCDK:GetRangeandIcon (spells["Horn of Winter"])
		end		
	end
	
	-- If nothing else can be done
	return nil		
end

function CLCDK:FrostMove()
	CLCDK.Icon:SetVertexColor(1, 1, 1, 1)
	
	-- If Killing Machine and Rime
	--for i = 1, 10 do
	--	local name, _, _, _, duration, expires, _, _, _, spellID = UnitBuff("player", i, spells["Killing Machine"])
	--	if expires ~= nil then
	--		for i = 1, 10 do
	--			local name, _, _, _, duration, expires, _, _, _, spellID = UnitBuff("player", i)
	--			if name == (spells["Freezing Fog"]) then
	--				return CLCDK:GetRangeandIcon(spells["Howling Blast"])
	--			end
	--		end
	--	end		
	--end
	
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	return move	end
	
	-- Frost Strike if RP capped
	if UnitPower("player") >= 106 then
		return CLCDK:GetRangeandIcon(spells["Frost Strike"])
	end	
	
	--Obliterate
	if IsUsableSpell(spells["Death Strike"]) then
		return CLCDK:GetRangeandIcon(spells["Death Strike"])
    end
		
	-- Blood Strike if blood runes
	if (runeCD(1,2)) then		
		return CLCDK:GetRangeandIcon(spells["Blood Strike"])
	end
	
	-- Frost Strike
	if UnitPower("player") >= (40 - FS) then
		return CLCDK:GetRangeandIcon(spells["Frost Strike"])
	end	
	
	-- Plague Strike if unholy runes
	--if (runeCD(3,4)) then		
	--	return CLCDK:GetRangeandIcon(spells["Plague Strike"])
	--end
	
	-- Icy Touch if frost runes
	--if (runeCD(5,6)) then		
	--	return CLCDK:GetRangeandIcon(spells["Icy Touch"])
	--end
	
	-- If Freezeing, Howling Blast
	for i = 1, 10 do
		local name, _, _, _, _, _, expires, _, _, _, _ = UnitBuff("player",i)
		if name == "Freezing Fog" and expires ~= nil then			
			return CLCDK:GetRangeandIcon(spells["Howling Blast"])
		end	
	end
	-- If nothing else can be done
	return nil
end

function CLCDK:BloodMove()
	CLCDK.Icon:SetVertexColor(1, 1, 1, 1); 
		
	--Disease Stuff
	local disease, move = CLCDK:GetDisease()	
	if disease then	return move	end		
		
	-- Heart Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon(spells["Heart Strike"])
	end	
	
	--Death Strike
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount() >= 2 then
		return CLCDK:GetRangeandIcon(spells["Death Strike"])
	end	
			
	-- Death Coil
	if UnitPower("player") >= 40 then
		return CLCDK:GetRangeandIcon(spells["Death Coil"])
	end	
	
	-- If nothing else can be done
	return nil				
end	

function CLCDK:BlankMove()
	CLCDK.Icon:SetVertexColor(1, 1, 1, 1);
		
	--Disease Stuff
	CLCDK:GetDisease()

	-- Blood Strike
	if runeCD(1,2) then		
		return CLCDK:GetRangeandIcon(spells["Blood Strike"])
	end	
	
	--Death Strike
	if (runeCD(5,6) and runeCD(3,4)) or (availableDeathRunesCount()==1 and (runeCD(5,6) or runeCD(3,4))) or availableDeathRunesCount()>=2 then
		return CLCDK:GetRangeandIcon(spells["Death Strike"])
	end	
			
	-- Death Coil
	if UnitPower("player") >= 40 then
		return CLCDK:GetRangeandIcon(spells["Death Coil"])
	end	
	
	-- If nothing else can be done
	return nil				
end	
-----End Priority System------

------Check Spec------
function CLCDK:CheckSpec()
	if (IsSpellKnown(55090) or IsSpellKnown(55265) or IsSpellKnown(55270) or IsSpellKnown(55271)) then --Scourge Strike
		spec = "unholy"
	elseif (IsSpellKnown(55050) or IsSpellKnown(55258) or IsSpellKnown(55259) or IsSpellKnown(55260) or IsSpellKnown(55261) or IsSpellKnown(55262)) then --Heart Strike
		spec = "blood"
	elseif (IsSpellKnown(49143) or IsSpellKnown(51416) or IsSpellKnown(51417) or IsSpellKnown(51418) or IsSpellKnown(51419) or IsSpellKnown(55268)) then --Frost Strike
		spec = "frost"
	else
		spec = ""
	end
	GoD = false
	FS = 0
	for i = 1, GetNumGlyphSockets() do
		local _, _, glyphID, _ = GetGlyphSocketInfo(i);		
		if ( glyphID ~= nil ) then	
			--name= GetSpellInfo(glyphID)
			--print(name..":"..glyphID)
		
			if ( glyphID == 63334 ) then --Glyph of Disease
				GoD = true
			end	
			if ( glyphID == 58647 ) then --Glyph of Frost Strike
				FS = 8
			end	
		end
	end	
	CLCDK_OptionsRefresh()
end
------End Check Spec------

-----Events-----
CLCDK:RegisterEvent("PLAYER_LOGIN")
CLCDK:RegisterEvent("PLAYER_ENTERING_WORLD")
CLCDK:RegisterEvent("PLAYER_TALENT_UPDATE")
CLCDK:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
CLCDK:RegisterEvent("GLYPH_ADDED")

CLCDK:SetScript("OnEvent", function(self, e) 
	CLCDK:CheckSpec()
	if(e == "PLAYER_LOGIN") then CLCDK:Login() end	
end)

function CLCDK:Login()
	_, englishClass = UnitClass("player");	
	if englishClass == "DEATHKNIGHT" then
		RuneFrame:Hide()	
		
		if CLCDK_Settings == nil or CLCDK_Settings.Version == nil or CLCDK_Settings.Version < CLCDK_CONFIG_Ver then
			CLCDK_SetDefaults()
		end
				
		CLCDK.BP = CLCDK:CreateIcon(spells["Blood Plague"], 24)
		CLCDK.BP:SetPoint("BOTTOMRIGHT", CLCDK, "BOTTOMRIGHT", 0, 0)
		CLCDK.FF = CLCDK:CreateIcon(spells["Frost Fever"], 24)
		CLCDK.FF:SetPoint("RIGHT", CLCDK.BP, "LEFT", 0, 0)
				
		UIDropDownMenu_Initialize(CLCDK_OptionsPanel_CD1_One, CLCDK_OptionsPanel_OnLoad);
		UIDropDownMenu_Initialize(CLCDK_OptionsPanel_CD1_Two, CLCDK_OptionsPanel_OnLoad);
		UIDropDownMenu_Initialize(CLCDK_OptionsPanel_CD2_One, CLCDK_OptionsPanel_OnLoad);
		UIDropDownMenu_Initialize(CLCDK_OptionsPanel_CD2_Two, CLCDK_OptionsPanel_OnLoad);		
		UIDropDownMenu_Initialize(CLCDK_OptionsPanel_ViewDD, CLCDK_OptionsPanel_ViewDD_OnLoad);						
							
		CLCDKUpdatePosition()				
		CLCDK:UpdateUI()		
		InterfaceOptions_AddCategory(CLCDK_OptionsPanel);
		CLCDK_OptionsRefresh()	
	else
		CLCDK.Show = dummy	
		CLCDK:UnregisterAllEvents()	
		CLCDK:Hide()	
		CLCDK = nil
		CLCDK_OptionsPanel:UnregisterAllEvents()	
		CLCDK_OptionsPanel:Hide()
	end		
end

CLCDK:SetScript("OnUpdate", function() 
	local timer = GetTime()    	
	if (timer - updatetimer >= 0.05) then		
		updatetimer = timer		
		--Update Frame
		
		if (InCombatLockdown() or CLCDK_Settings.VScheme == "show" or (not CLCDK_Settings.Locked) or (UnitCanAttack("player", "target") and (not UnitIsDead("target")) and CLCDK_Settings.VScheme == "norm" )) and (not UnitInVehicle("player")) then	
			CLCDK:UpdateUI()	
		else	
			if CLCDK_Settings.VScheme == "norm" or CLCDK_Settings.VScheme == "hide" then
				CLCDK:SetAlpha(0)
			else
				CLCDK:SetAlpha(1)
			end
		end		
	end	
end)
-----End Events-----

-----Options-----
SLASH_CLCDK1 = "/clcdk"
SlashCmdList["CLCDK"] = function()
	InterfaceOptionsFrame_OpenToCategory(CLCDK_OptionsPanel)
	InterfaceOptionsFrame_OpenToCategory(CLCDK_OptionsPanel)
end

function CLCDK_SetDefaults()
	CLCDK_Settings = {}
	
	CLCDK_Settings.Version = CLCDK_CONFIG_Ver
	CLCDK_Settings.Locked = true
	
	CLCDK_Settings.Point = "Center"
	CLCDK_Settings.X = 0
	CLCDK_Settings.Y = -175
	CLCDK_Settings.Scale = 1.0
	CLCDK_Settings.Trans = 0.5
	CLCDK_Settings.VScheme = "norm"	
	
	CLCDK_Settings.CastBar = false
	CLCDK_Settings.Priority = true
	CLCDK_Settings.Horn = false
	CLCDK_Settings.GCD = true
	CLCDK_Settings.Rune = true
	CLCDK_Settings.RP = true
	CLCDK_Settings.Disease = true
	
	CLCDK_Settings.CD = {
		["1"] = true,
		["CLCDK_OptionsPanel_CD1_One"] = spells["Horn of Winter"],
		["CLCDK_OptionsPanel_CD1_Two"] = spells["Blood Tap"],
		
		["2"] = true,
		["CLCDK_OptionsPanel_CD2_One"] = spells["Raise Dead"],
		["CLCDK_OptionsPanel_CD2_Two"] = spells["Army of the Dead"],
	}
	
	CLCDK_OptionsRefresh()
	CLCDKUpdatePosition()	
end

function CLCDK_OptionsRefresh()
	if CLCDK_Settings ~= nil and (CLCDK_Settings.Version ~= nil and CLCDK_Settings.Version == CLCDK_CONFIG_Ver) then
		if (spec == "unholy") then
			CLCDK_OptionsPanel_Title_Spec:SetText(CLCDK_Spec_Unholy)
		elseif (spec == "frost") then
			CLCDK_OptionsPanel_Title_Spec:SetText(CLCDK_Spec_Frost)
		elseif (spec == "blood") then
			CLCDK_OptionsPanel_Title_Spec:SetText(CLCDK_Spec_Blood)
		else
			CLCDK_OptionsPanel_Title_Spec:SetText(CLCDK_Spec_None)
		end
				
		if CLCDK_Settings.Locked then
			CLCDK:EnableMouse(false)
		else
			CLCDK:EnableMouse(true)
		end		
				
		CLCDK_OptionsPanel_Castbar:SetChecked(CLCDK_Settings.CastBar);
		CLCDK_OptionsPanel_Priority:SetChecked(CLCDK_Settings.Priority);	
		CLCDK_OptionsPanel_GCD:SetChecked(CLCDK_Settings.GCD);
		CLCDK_OptionsPanel_Rune:SetChecked(CLCDK_Settings.Rune);
		CLCDK_OptionsPanel_RP:SetChecked(CLCDK_Settings.RP);
		CLCDK_OptionsPanel_Disease:SetChecked(CLCDK_Settings.Disease);
		
		CLCDK_OptionsPanel_Horn:SetChecked(CLCDK_Settings.Horn);
		
		CLCDK_OptionsPanel_CD1:SetChecked(CLCDK_Settings.CD["1"]);	
		UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_CD1_One, CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_One"])
		UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_CD1_Two, CLCDK_Settings.CD["CLCDK_OptionsPanel_CD1_Two"])
			
		CLCDK_OptionsPanel_CD2:SetChecked(CLCDK_Settings.CD["2"]);	
		UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_CD2_One, CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_One"])
		UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_CD2_Two, CLCDK_Settings.CD["CLCDK_OptionsPanel_CD2_Two"])
				
				
		CLCDK_OptionsPanel_Locked:SetChecked(CLCDK_Settings.Locked);
		UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_ViewDD, CLCDK_Settings.VScheme)	
		CLCDK_OptionsPanel_Scale:SetNumber(CLCDK_Settings.Scale)
		CLCDK_OptionsPanel_Scale:SetCursorPosition(0)	
		CLCDK_OptionsPanel_Trans:SetNumber(CLCDK_Settings.Trans)
		CLCDK_OptionsPanel_Trans:SetCursorPosition(0)				
	end
end

function CLCDK_OptionsOkay()
	if CLCDK_Settings ~= nil and (CLCDK_Settings.Version ~= nil and CLCDK_Settings.Version == CLCDK_CONFIG_Ver) then
		CLCDK_Settings.Locked = (CLCDK_OptionsPanel_Locked:GetChecked());	
		
		if CLCDK_OptionsPanel_Scale:GetNumber() >= 0.5 and CLCDK_OptionsPanel_Scale:GetNumber() <= 5 then
			CLCDK_Settings.Scale = CLCDK_OptionsPanel_Scale:GetNumber()
		else
			CLCDK_OptionsPanel_Scale:SetNumber(CLCDK_Settings.Scale)
		end
		
		if CLCDK_OptionsPanel_Trans:GetNumber() >= 0 and CLCDK_OptionsPanel_Trans:GetNumber() <= 1 then
			CLCDK_Settings.Trans = CLCDK_OptionsPanel_Trans:GetNumber()
		else
			CLCDK_OptionsPanel_Trans:SetNumber(CLCDK_Settings.Trans)
		end
		
		CLCDK_OptionsRefresh()
		CLCDKUpdatePosition()
	end
end

function CLCDK_OptionsPanel_ViewDD_OnLoad()
	info            = {}	
	info.text       = CLCDK_Norm	
	info.value      = "norm"
	info.func       = function() CLCDK_Settings.VScheme = "norm";UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_ViewDD, CLCDK_Settings.VScheme); end
	UIDropDownMenu_AddButton(info)
	
	info            = {}	
	info.text       = CLCDK_Show
	info.value      = "show"
	info.func       = function() CLCDK_Settings.VScheme = "show";UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_ViewDD, CLCDK_Settings.VScheme); end
	UIDropDownMenu_AddButton(info)
	
	info            = {}	
	info.text       = CLCDK_Hide
	info.value      = "hide"
	info.func       = function() CLCDK_Settings.VScheme = "hide";UIDropDownMenu_SetSelectedValue(CLCDK_OptionsPanel_ViewDD, CLCDK_Settings.VScheme); end
	UIDropDownMenu_AddButton(info)	
end

local NormCDs = {
	spells["Anti-Magic Shell"],
	spells["Army of the Dead"],			
	spells["Blood Tap"],
	spells["Dark Command"],
	spells["Death and Decay"],
	spells["Death Grip"],
	spells["Death Pact"],
	spells["Empower Rune Weapon"],
	spells["Horn of Winter"],
	spells["Icebound Fortitude"],
	spells["Mind Freeze"],
	spells["Raise Ally"],
	spells["Raise Dead"],
	spells["Strangulate"],
}
local UnholyCDs = {
	spells["Bone Shield"],
	spells["Summon Gargoyle"],
}
local FrostCDs = {
	spells["Unbreakable Armor"],
}
local BloodCDs = {
	spells["Hysteria"],
}

function CLCDK_OptionsPanel_OnLoad(self)	
	--None Option
	UIDropDownMenu_AddButton(CLCDK_OptionsPanel_Item(CLCDK_None, self))
			
	--Spec Specific CDs		
	if (spec == "unholy") then
		for i = 1, #UnholyCDs do
			UIDropDownMenu_AddButton(CLCDK_OptionsPanel_Item(UnholyCDs[i], self))
		end			
	elseif (spec == "frost") then
		for i = 1, #FrostCDs do
			UIDropDownMenu_AddButton(CLCDK_OptionsPanel_Item(FrostCDs[i], self))
		end	
	elseif (spec == "blood") then
		for i = 1, #BloodCDs do
			UIDropDownMenu_AddButton(CLCDK_OptionsPanel_Item(BloodCDs[i], self))
		end	
	end	
	
	--Seperator
	info.text = "---------------------------------------"
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)
	
	--Regular DK CDs
	for i = 1, #NormCDs do
		UIDropDownMenu_AddButton(CLCDK_OptionsPanel_Item(NormCDs[i], self))
	end	
end

function CLCDK_OptionsPanel_Item (spell, panel)	
	info			= {}
	info.text       = spell
	info.value      = spell
	info.func       = function() CLCDK_Settings.CD[panel:GetName()] = spell; UIDropDownMenu_SetSelectedValue(panel, CLCDK_Settings.CD[panel:GetName()]); end
	return info
end
-----End Options-----
