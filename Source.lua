--// OOP

local module = {}
module.__index = module

local ListOfSubs = {}

--// Services

local DataStoreService = require(script:FindFirstChild("Datastore2"))
local RunService = game:GetService("RunService")

function module:new(Time : int, Scope : string)
	setmetatable({[1] = Time}, module)
	
	self[Scope] = Time
end

function module:Activate(Player : player, Scope : string)
	local TimeValue = os.clock()
	
	local data = DataStoreService(Scope, Player)
	data:Set(TimeValue)
	data:Save()
end

function module.ResetData(Player : player, Scope : string)
	local data = DataStoreService(Scope, Player)
	data:Set(0)
	data:Save()
end

function module:ManualCheck(Player : player, Scope : string)
	local TimeValue = os.clock()
	local data = DataStoreService(Scope, Player)
	local get = data:Get()
	local Time = self[Scope]
	
	if TimeValue - get >= Time or get == 0 then
		return false
	else
		return true
	end
end

function module:AutoCheck(toggle : any, Scope : string, Player : player, Callback : any)
	if toggle == true then
		
		local data = DataStoreService(Scope, Player)
		local get = data:Get()
		local connection = nil
		
		connection = RunService.Stepped:Connect(function()
			local TimeValue = os.clock()
			
			local Time = self[Scope]
			
			if TimeValue - get >= Time or get == 0 then
				Callback()
				
				connection:Disconnect()
			end
		end)
	end
end

return module
