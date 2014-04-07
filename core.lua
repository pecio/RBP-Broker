-- LDB-Broker
-------------
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigReg = LibStub("AceConfigRegistry-3.0")

-- local L = LibStub("AceLocale-3.0"):GetLocate("LDBBroker")

local UPDATEPERIOD, elapsed = 0.5, 0
local RBPSPELL = 125439

local dataojb = ldb:NewDataObject("Revive Battle Pets", { type = "data source", text = "Revive Battle Pets" })
local f = CreateFrame("frame")

RBPBroker = LibStub("AceAddon-3.0"):NewAddon("RDB-Broker", "AceConsole-3.0")

local options = {
  name = "RBP-Broker",
  handler = RBPBroker,
  type = 'group',
  args = {
    main = {
      type = 'group',
      name = 'Main',
      args = {
        cooldown = {
          type = 'toggle',
          name = 'Show Cooldown',
          desc = 'Show cooldown time for Revive Battle Pets spell in bar',
          set = function(info, val) RBPBroker.config.profile.cooldown = val end,
          get = function(info) return RBPBroker.config.profile.cooldown end
        },
        notifyEnd = {
          type ='select',
          name = 'Notify Availability',
          desc = 'Notify the player when cooldown time finishes',
          values = {
            n0 = 'None',
            n1 = 'With Level Up Sound',
            n2 = 'In Chat',
            n3 = 'Both'
          },
          set = function(info, val) RBPBroker.config.profile.notifyEnd = val end,
          get = function(info) return RBPBroker.config.profile.notifyEnd end
        }
      }
    }
  }
}

local defaultOptions = {
  profile = {
    cooldown = true,
    notifyEnd = 'n0'
  }
}

function RBPBroker:OnEnable()
  local brokerOptions = AceConfigReg:GetOptionsTable("Broker", "Dialog", "LibDataBroekr-1.1")
  if not brokerOptions then
    brokerOptions = {
      type = 'group',
      name = 'Broker',
      args = {}
    }
    AceConfigReg:RegisterOptionsTable('Broker', brokerOptions)
  end

  -- Get and store Revive Battle Pets icon and name
  local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(RBPSPELL)
  PetHealthBroker.RBPicon = icon
  PetHealthBroker.RBPname = name

  options.args.main.args.rbp.name = name
  options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.config)

  AceConfigReg:RegisterOptionsTable(RBPBroker.name, options)
  RBPBroker.menu = LibStub("AceConfigDialog-3.0")AddToBlizOptions("RBP-Broker", "Revive Battle Pets", "Broker")
end

function RBPBroker:OnInitialize()
  self.config = LibStub("AceDB-3.0"):New("RBPBrokerConfig", defaultOptions, true)
end
f:SetScript('OnUpdate', function(self, elap)
  elapsed = elapsed + elap
  if elapsed < UPDATEPERIOD then return end

  elapsed = 0

  local text = string.format('|T%s:16|t', RBPBroker.RBPicon)

  local start, duration, enabled = GetSpellCooldown(RBPSPELL)
  local cooldown = start + duration - GetTime()

  if RBPBroker.config.profile.cooldown then
    text = text .. RBPBroker:GetShortTime(cooldown)
  end

  if cooldown > 0 then
    RBPBroker.inCooldown = true
    local min = math.floor(cooldown / 60)
    local seg = cooldown % 60
    text = text .. string.format(" |cFFFFFFFF%d:%02d|r", min, seg)
  else
    if RBPBroker.inCooldown then -- finished
      RBPBroker.inCooldown = false

      if not RBPBroker.config.profile.notifyEnd == 'n0' then
        RBPBroker:NotifyEnd()
      end
    end
  end

  dataobj.text = text
end)

function RBPBroker:NotifyEnd()
  if RBPBroker.config.profile.notifyEnd == 'n1' or RBPBroker.config.profile.notifyEnd == 'n3' then -- sound or both
    PlaySound("LEVELUP")
  end
  if RBPBroker.config.profile.notifyEnd == 'n2' or RBPBroker.config.profile.notifyEnd == 'n3' then -- chat or both
    RBPBroker:Printf('%s is ready', string.format('|T%s:16|t %s', RBPBroker.RBPicon, RBPBroker.RBPname))
  end
end

function RBPBroker:GetSortTime(seconds)
  if seconds > 0 then
    local min = math.floor(seconds / 60)
    local sec = seconds % 60
    return string.format('|cFFFFFFFF%d:%02d|r', min, sec)
  else
    return string.format('|cFF00FF00%s|r', 'Ready')
  end
end
