-- LDB-Broker
-------------
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigReg = LibStub("AceConfigRegistry-3.0")

-- local L = LibStub("AceLocale-3.0"):GetLocate("LDBBroker")

local UPDATEPERIOD, elapsed = 0.5, 0

local dataojb = ldb:NewDataObject("Revive Battle Pets", { type = "data source", text = "Revive Battle Pets" })
local f = CreateFrame("frame")

RBPBroker = LibStub("AceAddon-3.0"):NewAddon("RDB-Broker", "AceConsole-3.0")
