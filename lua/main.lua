package.path=package.path..';./lua/?.lua'

local resources = "../thirdparty/resources/resources_data/"

local items = require(resources.."items")
local item_descs = require(resources.."item_descriptions")

local gears = require("gears")
local util = require("util")

util.printTable(gears.rows(items, item_descs).toReadables())
