-- Various functions used


-- Namespace
AchievementShare = { }
 
-- naming the namespace as a string
AchievementShare.name = "AchievementShare"

function AchievementShare.Initialize()

end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function AEx.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == AchievementExport then
    AEx.Initialize()
    --unregister the event again as our addon was loaded now and we do not need it anymore to be run for each other addon that will load
    EVENT_MANAGER:UnregisterForEvent(AEx.name, EVENT_ADD_ON_LOADED) --this is only explicitly nededed to unregister the event, after update47, if the optional boolean param "loadOnce" was not true as the RegisterForEvent was used!
  end
end
 
--CHALLENGER ACHIEVEMENTS
  -- Hard Mode(s)


-- SLAYERS

EHS1 = 859 -- elden hollow lurcher slayer


local function GetAchievementId(EHS1)

end



 
-- Finally, we'll register our event handler function to be called when the proper event occurs.
-->This event EVENT_ADD_ON_LOADED will be called for EACH of the addons/libraries enabled, this is why there needs to be a check against the addon name
-->within your callback function! Else the very first addon loaded would run your code + all following addons too.
EVENT_MANAGER:RegisterForEvent(AEx.name, EVENT_ADD_ON_LOADED, AEx.OnAddOnLoaded, true) --last optional param boolean "loadOnce" is added with update47!






