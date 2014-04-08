local L = LibStub('AceLocale-3.0'):NewLocale('RBPBroker', 'enUS', true)

-- LibDataBroker data object title
L['Revive Battle Pets'] = true

-- Configuration dialog
L['Main'] = true
L['Show Cooldown'] = true
L['Show cooldown time for Revive Battle Pets spell in bar'] = true
L['Notify Availability'] = true
L['Notify the player when cooldown time finishes'] = true
L['None'] = true
L['With Level Up Sound'] = true
L['In Chat'] = true
L['Both'] = true
L['Report Current Status'] = true
L['At Battle Start'] = true
L['Notify current status in chat after battle start animation finishes'] = true
L['At Battle End'] = true
L['Notify current status in chat on returning to normal game'] = true

-- Notifications
-- Cooldown finished, RBP is ready; %s will be replaced by icon and name
L['%s is ready'] = true

-- Current status, not yet ready. First %s is RBP icon and name, second
-- is time in long form (as per SecondsToTime API call)
L['%s ready in %s'] = true

-- Display
-- Shortest possible way to say it is ready
L['Ready'] = true

-- Tooltip
L['Click for options'] = true
