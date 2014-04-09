-- LDB-Broker
-------------
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigReg = LibStub("AceConfigRegistry-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("RBPBroker")

local UPDATEPERIOD, elapsed = 0.5, 0
local RBPSPELL = 125439

local dataobj = ldb:NewDataObject(L['Revive Battle Pets'], { type = "data source", text = L['Revive Battle Pets'] })
local f = CreateFrame("frame")

RBPBroker = LibStub("AceAddon-3.0"):NewAddon("RBP-Broker", "AceConsole-3.0")

local options = {
  name = "RBP-Broker",
  handler = RBPBroker,
  type = 'group',
  args = {
    main = {
      type = 'group',
      name = L['Main'],
      args = {
        cooldown = {
          type = 'toggle',
          name = L['Show Cooldown'],
          desc = L['Show cooldown time for Revive Battle Pets spell in bar'],
          set = function(info, val) RBPBroker.config.profile.cooldown = val end,
          get = function(info) return RBPBroker.config.profile.cooldown end
        },
        notifyEnd = {
          type ='select',
          name = L['Notify Availability'],
          desc = L['Notify the player when cooldown time finishes'],
          values = {
            n0 = L['None'],
            n1 = L['With Level Up Sound'],
            n2 = L['In Chat'],
            n3 = L['Both']
          },
          set = function(info, val) RBPBroker.config.profile.notifyEnd = val end,
          get = function(info) return RBPBroker.config.profile.notifyEnd end
        },
        currentStatus = {
          type = 'group',
          inline = true,
          name = L['Report Current Status'],
          args = {
            battleStart = {
              type = 'toggle',
              name = L['At Battle Start'],
              desc = L['Notify current status in chat after battle start animation finishes'],
              set = function(info, val) RBPBroker.config.profile.battleStart = val end,
              get = function(info) return RBPBroker.config.profile.battleStart end
            },
            battleEnd = {
              type = 'toggle',
              name = L['At Battle End'],
              desc = L['Notify current status in chat on returning to normal game'],
              set = function(info, val) RBPBroker.config.profile.battleEnd = val end,
              get = function(info) return RBPBroker.config.profile.battleEnd end
            }
          }
        }
      }
    }
  }
}

local defaultOptions = {
  profile = {
    cooldown = true,
    notifyEnd = 'n0',
    battleStart = false,
    battleEnd = false
  }
}

function RBPBroker:OnEnable()
  local brokerOptions = AceConfigReg:GetOptionsTable("Broker", "dialog", "LibDataBroker-1.1")
  if not brokerOptions then
    brokerOptions = {
      type = 'group',
      name = 'Broker',
      args = {}
    }
    AceConfigReg:RegisterOptionsTable('Broker', brokerOptions)
    LibStub('AceConfigDialog-3.0'):AddToBlizOptions('Broker', 'Broker')
  end

  -- Get and store Revive Battle Pets icon and name
  local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(RBPSPELL)
  RBPBroker.RBPicon = icon
  RBPBroker.RBPname = name
  RBPBroker.RBPfullName = string.format("|T%s:16|t %s", icon, name)

  options.name = name
  options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.config)

  AceConfigReg:RegisterOptionsTable(RBPBroker.name, options)
  RBPBroker.menu = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(RBPBroker.name, RBPBroker.RBPname, "Broker")

  -- Register event handlers and events
  f:SetScript('OnEvent', function(self, event, ...)
    RBPBroker[event](self, ...)
  end)
  f:RegisterEvent('PET_BATTLE_OPENING_DONE')
  f:RegisterEvent('PET_BATTLE_CLOSE')
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
  else
    if RBPBroker.inCooldown then -- finished
      RBPBroker.inCooldown = false

      if not (RBPBroker.config.profile.notifyEnd == 'n0') then
        RBPBroker:NotifyEnd()
      end
    end
  end

  dataobj.text = text
end)

function RBPBroker:NotifyEnd()
  if (RBPBroker.config.profile.notifyEnd == 'n1') or (RBPBroker.config.profile.notifyEnd == 'n3') then -- sound or both
    PlaySound("LEVELUP")
  end
  if (RBPBroker.config.profile.notifyEnd == 'n2') or (RBPBroker.config.profile.notifyEnd == 'n3') then -- chat or both
    RBPBroker:Printf(L['%s is ready'], RBPBroker.RBPfullName)
  end
end

function RBPBroker:GetShortTime(seconds)
  if seconds > 0 then
    local min = math.floor(seconds / 60)
    local sec = seconds % 60
    return string.format('|cFFFFFFFF%d:%02d|r', min, sec)
  else
    return string.format('|cFF00FF00%s|r', L['Ready'])
  end
end

function dataobj:OnTooltipShow()
  self:AddLine(RBPBroker.RBPname)
  self:AddLine(L['Click for options'])
end

function dataobj:OnClick(button)
  InterfaceOptionsFrame_OpenToCategory(RBPBroker.menu)
end

function dataobj:OnEnter()
  GameTooltip:SetOwner(self, "ANCHOR_NONE")
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
  GameTooltip:ClearLines()
  dataobj.OnTooltipShow(GameTooltip)
  GameTooltip:Show()
end

function dataobj:OnLeave()
  GameTooltip:Hide()
end

function RBPBroker.PET_BATTLE_OPENING_DONE(...)
  if RBPBroker.config.profile.battleStart then
    RBPBroker:NotifyCurrentStatus()
  end
end

function RBPBroker.PET_BATTLE_CLOSE(...)
  -- Event fires twice. The first time, [petbattle] macro conditional
  -- evalueates to true, the second to false
  local result, target = SecureCmdOptionParse("[petbattle] In;Out")
  if RBPBroker.config.profile.battleEnd and result == "Out" then
    RBPBroker:NotifyCurrentStatus()
  end
end

function RBPBroker:NotifyCurrentStatus()
  local start, duration, enabled = GetSpellCooldown(RBPSPELL)
  local cooldown = start + duration - GetTime()

  if cooldown >= 1 then
    RBPBroker:Printf(L['%s ready in %s'], RBPBroker.RBPfullName, SecondsToTime(cooldown))
  else
    RBPBroker:Printf(L['%s is ready'], RBPBroker.RBPfullName)
  end
end
