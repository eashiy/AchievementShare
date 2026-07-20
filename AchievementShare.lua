-- Namespace
AchievementShare = { }
AchievementShare.name = "AchievementShare"


-- Various variables used
local AS = AchievementShare
local ASwindow = AchievementShareWindow
local control_header = AchievementShareWindowHeader
local control_dungeons = AchievementListDungeons
local control_trials = AchievementListTrials
local control_arenas = AchievementListArenas
local control_night_market = AchievementListNightMarket
local control_anniversary = AchievementListAnniversary
local AS_Achievement_IDs = AS_ID

local libScroll = LibScroll

AS.DEFAULT_LIST_TEXT = ZO_ColorDef:New(0.4627, 0.737, 0.7647, 1) -- scroll list row text color

--local RCR_Classifier = Raidificator.RCR_AchievementClassifier


-- General Initialize catch all function. Called in OnAddOnLoaded.
function AchievementShare.Initialize()
  AchievementShare:SelectionDropDown()
  AS_AchievementList:New()

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
EH1CHAL = {
  11, -- Van (norm)
  1573, -- Con (Vet)
  1578, -- HM
  1576, -- Speed
  1577, -- ND
}
EH1SLAY = {
  -- Slayers
  1575, -- Slayer (Alit)
  1574, -- Slayer (Orc)
  -- Side
    -- None
}

-- Color coding for IsAchiComplete
local Complete_Color = { 0,255,0 }
local Incomplete_Color = { 255, 0, 0 }
local In_Progress_Color = { 255, 234, 0 }
local Not_Applicable_Color = { 186, 186, 186 }

-- Checks if an achievement is complete based on the ID then sets the control text color accordingly 
function AchievementShare.IsAchiComplete(ID, controlName, controlText)
  local IsComplete = ZO_GetAchievementStatus(ID)
  -- this returns NOT_APPLICABLE = 1 INCOMPLETE = 2 IN_PROGRESS = 3 COMPLETE = 4
  -- NOT_APPLICABLE means not able to get it yet, like not owning dlc?
  local control = TabDungeonChallenger:GetNamedChild(controlName)
  local text = controlText
  if IsComplete == 4 then
    control:SetText(text)
    control:SetColor(unpack(Complete_Color)) 
  end
  if IsComplete == 2 then 
    control:SetText(text)
    control:SetColor(unpack(Incomplete_Color))
  end
  if IsComplete == 3 then 
    control:SetText(text)
    control:SetColor(unpack(In_Progress_Color))
  end
  if IsComplete == 1 then 
    control:SetText(text)
    control:SetColor(unpack(Not_Applicable_Color))
  end
end

-- Calls IsAchiComplete for a set of challenger achievements. Tri is an optional value. 
function AchievementShare.challengers(Van, Con, HM, Sp, ND, Tri)
  AchievementShare.IsAchiComplete(Van, "NormClear", "Norm")
  AchievementShare.IsAchiComplete(Con, "VetClear", "Vet")
  AchievementShare.IsAchiComplete(HM, "HardMode", "HM")
  AchievementShare.IsAchiComplete(Sp, "Speed", "Speed")
  AchievementShare.IsAchiComplete(ND, "NoDeath", "ND")
  local tri = Tri
  if Tri == nil then
    tri = 0 
  end
  if tri > 0 then 
      AchievementShare.IsAchiComplete(Tri, "Tri", "Tri")
  end
end

-- Filter List
AS.AS_List = {
-- [Zone ID] = { release year, nomal clear, vet clear } 
    [144] = { release = 2014, van = "van", con = "con" }, -- Spindleclutch I
    [936] = { release = 2014, van = "van", con = "con" } , -- Spindleclutch II
    [380] = { release = 2014, van = "van", con = "con" }  , -- The Banished Cells I
    [935] = { release = 2014, van = "van", con = "con" }  , -- The Banished Cells II
    [283] = { release = 2014, van = "van", con = "con" }  , -- Fungal Grotto I
    [934] = { release = 2014, van = "van", con = "con" }  , -- Fungal Grotto II
    [146] = { release = 2014, van = "van", con = "con" }  , -- Wayrest Sewers I
    [933] = { release = 2014, van = "van", con = "con" }  , -- Wayrest Sewers II
    [126] = { release = 2014, van = "van", con = "con" }  , -- Elden Hollow I
    [931] = { release = 2014, van = "van", con = "con" }  , -- Elden Hollow II
 }


AS_AchievementList = ZO_SortFilterList:Subclass()
AS_AchievementList.defaults = { }

AS_AchievementList.SORT_KEYS = {
  ["Release"] = { },
  ["Name"] = {tiebreaker = "Release"},
  ["NormClear"] = {tiebreaker = "Release"},
  ["VetClear"] = {tiebreaker = "Release"},
  -- ["HardMode"] = {tiebreaker = "Release"},
  -- ["Seed"] = {tiebreaker = "Release"},
  -- ["NoDeath"] = {tiebreaker = "Release"},
  -- ["Tri"] = {tiebreaker = "Release"}
}

function AS_AchievementList:New()
  local list = ZO_SortFilterList.New(self, AchievementListDungeons)
  list:Initialize()
  return list
end

function AS_AchievementList:Initialize()
  self.List_Achievements = {}
  ZO_ScrollList_AddDataType(self.list, 1, "AchievementShareRow", 30, function(control, data) self:SetupUnitRow(control, data) end)
  ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
  self.sortFunction = function(listEntry1, listEntry2) return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, UnitList.SORT_KEYS, self.currentSortOrder) end
  self:RefreshData()
end

function AS_AchievementList:BuildMasterList()
  self.List_Achievements = {  }
  local list = AS.AS_List
  -- this loops through the table AS_List put each row into the scroll list I think.
  for idx, entry in pairs(lsit) do  
    table.insert(self.List_Achievements, data)
  end
end

function AS_AchievementList:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)

    for i = 1, #self.List_Achievements do
        local data = self.List_Achievements[i]
      table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end    
end

function AS_AchievementList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function AS_AchievementList:SetupUnitRow(control, data)
  control.data = data
  control.release = GetControl(control, "Release")
  control.name = GetControl(control, "Name")
  control.van = GetControl(control, "NormClear")
  control.con = GetControl(control, "VetClear")

  control.release:SetText(data.release)
  control.name:SetText(data.name)
  control.van:SetText(data.NormClear)
  control.con:SetText(data.VetClear)

  control.release.normalColor = AS.DEFAULT_LIST_TEXT
  control.name.normalColor = AS.DEFAULT_LIST_TEXT
  control.van.normalColor = AS.DEFAULT_LIST_TEXT
  control.con.normalColor = AS.DEFAULT_LIST_TEXT
  

  ZO_SortFilterList.SetupRow(self, control, data)
end

function AS_AchievementList:Refresh()
  self:RefreshData()
end


-- Actually loads the addon
EVENT_MANAGER:RegisterForEvent(AchievementShare.name, EVENT_ADD_ON_LOADED, AchievementShare.OnAddOnLoaded) 










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