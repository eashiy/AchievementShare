-- Various variables used
local ASwindow = AchievementShareWindow
local control_header = AchievementShareWindowHeader
local control_dungeons = AchievementListDungeons
local control_trials = AchievementListTrials
local control_arenas = AchievementListArenas
local control_night_market = AchievementListNightMarket
local control_anniversary = AchievementListAnniversary

-- Namespace
AchievementShare = { }
AchievementShare.name = "AchievementShare"

-- General Initialize catch all function. Called in OnAddOnLoaded.
function AchievementShare.Initialize()
  AchievementShare:SelectionDropDown() 
  AchievementShare:EH1Test()
end
 
-- Initalizes the add-on based on the name. 
function AchievementShare.OnAddOnLoaded(event, addonName)
  if addonName == AchievementShare.name then
    AchievementShare.Initialize()
    EVENT_MANAGER:UnregisterForEvent(AchievementShare.name, EVENT_ADD_ON_LOADED)
    
  end
end

-- this shows/hides the window. 
function AchievementShare.toggleASwindow()
  ASwindow:SetHidden(not ASwindow:IsHidden())
end

SLASH_COMMANDS["/achievementshare"] = AchievementShare.toggleASwindow
SLASH_COMMANDS["/achishare"] = AchievementShare.toggleASwindow


--ACHIEVEMENT CATEGORIES for Filter Drop
local AchievementLabelsTable = {"Dungeons" , "Trials" , "Arenas" , "Night Market" , "Anniversary" }
local AchievementTypeDrop = control_header:GetNamedChild("FilterDrop")

function AchievementShare:SelDropShowSelected(DungonVal, TrialVal, ArenaVal, NMVal, AnniVal)
  -- accepts 5 bool values
  control_dungeons:SetHidden(DungonVal)
  control_trials:SetHidden(TrialVal)
  control_arenas:SetHidden(ArenaVal)
  control_night_market:SetHidden(NMVal)
  control_anniversary:SetHidden(AnniVal)
end

function AchievementShare:SelectionDropDown()
-- dropdown for selecting Achievment types
  local comboBox = AchievementTypeDrop.drodownObject
  comboBox:SetSortsItems(false)
  for i, stringName in pairs(AchievementLabelsTable) do
    local entry = comboBox:CreateItemEntry(stringName, function(_, newItem)
      -- do stuff when selected, blah, blah, blah
      if newItem == "Dungeons" then
        AchievementShare:SelDropShowSelected(false, true, true, true, true)
      elseif newItem == "Trials" then
        AchievementShare:SelDropShowSelected(true, false, true, true, true)
      elseif newItem == "Arenas" then
        AchievementShare:SelDropShowSelected(true, true, false, true, true)
      elseif newItem == "Night Market" then
        AchievementShare:SelDropShowSelected(true, true, true, false, true)
      elseif newItem == "Anniversary" then
        AchievementShare:SelDropShowSelected(true, true, true, true, false)
      end
    end, true)
    comboBox:AddItem(entry, ZO_COMBOBOX_SUPPRESS_UPDATE)
    if stringName == "Dungeons" then 
        comboBox:ItemSelectedClickHelper(entry)
    end
  end
end


--Elden Hollow I put in this file for testing.
EH1 = {
  11, -- Van (norm)
  1573, -- Con (Vet)
  1578, -- HM
  1576, -- Speed
  1577, -- ND
  -- Slayers
  1575, -- Slayer (Alit)
  1574, -- Slayer (Orc)
  -- Side
    -- None
}
-- maybe this wont work now that I think about it 

-- local function AchiIdToUsableThing ()
--   for i, ID in pairs(EH1) do 
--     IsCompleted = GetAchievementProgress(ID)
--   end
-- end
-- local function SetFieldText( control, name, field, data )
--   local element = control:GetNamedChild(name)
--   local value = data[field] 
-- end

-- Color coding
local Complete_Color = { 0,255,0 }
local Incomplete_Color = { 255, 0, 0 }
local In_Progress_Color = { 255, 234, 0 }
local Not_Applicable_Color = { 186, 186, 186 }

-- NOT_APPLICABLE means not able to get it yet, like not owning dlc?

function AchievementShare.EH1Test()
  local IsComplete = ZO_GetAchievementStatus(11)
  -- this returns NOT_APPLICABLE = 1 INCOMPLETE = 2 IN_PROGRESS = 3 COMPLETE = 4
  local control = TabDungeonChallenger:GetNamedChild("NormClear")
  if IsComplete == 4 then
    control:SetText("Norm")
    control:SetColor(unpack(Complete_Color)) 
  end
  if IsComplete == 2 then 
    control:SetText("Norm")
    control:SetColor(unpack(Incomplete_Color))
  end
  if IsComplete == 3 then 
    control:SetText("Norm")
    control:SetColor(unpack(In_Progress_Color))
  end
  if IsComplete == 1 then 
    control:SetText("Not eligible")
    control:SetColor(unpack(Not_Applicable_Color))
  end
end


-- local function PopulateChallenger(control, data)
--   SetFieldText(control, "Name", "name", data)
--   SetFieldText(control, "NormClear", "normclear", data)
--   SetFieldText(control, "VetClear", "vetclear", data)
--   SetFieldText(control, "HardMode", "hardmode", data)
--   SetFieldText(control, "Speed", "speed", data)
--   SetFieldText(control, "NoDeath", "nodeath", data)
--   SetFieldText(control, "Tri", "tri", data)
-- end

-- Trials and Dungeons can be done with the API calls GetString("SI_GUILDACTIVITYATTRIBUTEVALUE", GUILD_ACTIVITY_ATTRIBUTE_VALUE_DUNGEONS) and GetString("SI_GUILDACTIVITYATTRIBUTEVALUE", GUILD_ACTIVITY_ATTRIBUTE_VALUE_TRIALS) respectively. This is just a cool way of getting the translated text based on the client language.  

-- ACHIEVEMENT CATEGORIES
-- Idk if this will work but I'll keep it for now. 
-- local AchiCat = {
--  DUNGEON = 1,
--  TRIAL = 2,
--  ARENA = 3, 
--  NIGHT_MARKET = 4,
--  ANNIVERSARY = 5
-- }

-- local DungTrialSubCat = {
-- NORM = 1,
-- CHALLENGER = 2,
-- SLAYER = 3,
-- SIDE = 4
-- }

-- VANQUISHER = 1 -- Nromal
-- CONQURER = 2 -- Vet
-- SPEED = 3 
-- ND = 4 
-- HM = 5
-- CHALLENGER = 6
-- TRI = 7
-- SLAYER1 = 8
-- SLAYER2 = 9


--CHALLENGER ACHIEVEMENTS
  -- Hard Mode(s)


-- SLAYERS

-- EHS1 = 859 -- elden hollow lurcher slayer
-- EHV = 11 --vanquisher (norm)


-- local function getAchievementInfo()
--   SetText("NormClear", GetAchievementProgress(11))

-- end




 
-- Actually loads the addon
EVENT_MANAGER:RegisterForEvent(AchievementShare.name, EVENT_ADD_ON_LOADED, AchievementShare.OnAddOnLoaded) 



-- Notes: I will likely need to add libCustomMenu, libGroupBroadcast, libAddonMenu 2.0?


-- from m0r, potentially a way to use libgroupbroadcast to package the achievement data.
-- protocol = handler:DeclareProtocol(255, "ASSENDPROGRESS")
-- protocol:AddField(LGB.CreateNumericField("id"))
-- protocol:AddField(LGB.CreateNumericField("progress"))
-- protocol:OnData(handlers.onTempMarker)
-- protocol:Finalize({replaceQueuedMessages = true})

--Send the stuff
-- protocol:Send({
  -- id = achievementId,
  -- progress = achievementProgress
--})

-- local function handler(unitTag, data)
--     if AreUnitsEqual('player', unitTag) then return end -- dont care about yourself sending data
--     local achievementId = data.id
--     local achievementProgress = data.progress
--     -- do stuff
-- end