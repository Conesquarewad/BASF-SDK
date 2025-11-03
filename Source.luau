local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BASF = {}

do
	local Expected = 1413575372
	local Experience = game.GameId

	if Experience ~= Expected then
		warn("This experience isn't a BASF")
	end
end

BASF.Post = ReplicatedStorage:WaitForChild("Post")
BASF.Get = ReplicatedStorage:WaitForChild("Get")

local Current = Players.LocalPlayer
do
	local List = {}

	local Map = workspace:WaitForChild("Map")

	for Index, Child in pairs( Map:GetChildren() ) do
		local Name = Child.Name

		if Child:IsA("BasePart") then
			local Is = tonumber( Name )

			if Is then
				List[ Is ] = Child
			end

		end
	end

	BASF.Plots = List
end


function BASF.GetPlayerFromPlot( Base : PVInstance )
	local Container = ReplicatedStorage:WaitForChild("Plot")

	local Username do
		Username = nil

		for Index, Child in pairs( Container:GetChildren() ) do
			local Name = Child.Name

			if Child:IsA("StringValue") then
				local Value = Child.Value

				if Name == Base.Name then
					Username = Value

					break
				end

			end
		end
	end

	if Username then

		return Players:FindFirstChild( Username )
	end
end

function BASF.GetPlotFromPlayer( Player : Player )
	local Container = ReplicatedStorage:WaitForChild("Plot")

	local Target do
		Target = nil

		for Index, Child in pairs( Container:GetChildren() ) do

			if Child:IsA("StringValue") then
				local Value = Child.Value

				if Value == Player.Name then
					Target = Child
					
					break
				end
			end
		end
	end
	
	if Target then
		local Key = tonumber( Target.Name )
		
		if Key then
			return BASF.GetPlotFromNumber( Key )
		end
	end
	
end

function BASF.GetPlotFromNumber( Key : number )
	local Plot = BASF.Plots[ Key ]
	
	if Plot then
		return Plot
	end
end

function BASF.GetCurrentPlot()
	return BASF.GetPlotFromPlayer( Current )
end


function BASF.IsTrusted( A : Player, B : Player )
	local Friend = ReplicatedStorage:WaitForChild("Friend")

	local Container = Friend:FindFirstChild( A.Name )
	if Container then
		local Found = Container:FindFirstChild( B.Name )

		if Found then
			return true
		end
	end

	return false
end

function BASF.IsBlock( Object : Instance )

	if Object:IsA("PVInstance") then
		local Active = workspace:WaitForChild("Active")

		if Object:IsDescendantOf( Active ) then
			return true
		end
	end

	return false
end

function BASF.IsOwned( Plot : PVInstance | number )
	local Result do
		Result = nil

		if typeof( Plot ) == "number" then
			local Plot = BASF.GetPlotFromNumber( Plot )

			if Plot then
				Result = BASF.GetPlayerFromPlot( Plot )
			end
		elseif typeof( Plot ) == "Instance" then
			Result = BASF.GetPlayerFromPlot( Plot )
		end
	end

	if Result and Result == Current then
		return true
	end

	return false
end


function BASF.Pick( Target : Instance )
	local Stuff = require( ReplicatedStorage:WaitForChild("Stuff") )

	if Stuff then
		local Block = Stuff.Block

		if BASF.IsBlock( Target ) then
			local Model = Target:FindFirstAncestorOfClass("Model")

			if Model then
				return Block:Color( Model, nil, false )
			else
				return Block:Color( Target, nil, false )
			end
		else
			if Target:IsA("BasePart") then
				return Target.Color
			end
		end
	end

	return Color3.fromRGB( 255, 255, 255 )
end

function BASF.Paint( Target : Instance, Color : Color3? )
	Color = Color or Color3.fromRGB( 255, 255, 255 )

	if Color then
		local Post = BASF.Post

		Post:FireServer("Paint", Target, Color)
	end
end

function BASF.Place( Block : string, Coordinate : CFrame?, Anchored : boolean?, Collision : boolean? )
	Coordinate = Coordinate or CFrame.new( Vector3.new( 0, 15, 0 ) )

	local Get = BASF.Get

	Get:InvokeServer("Place", Block, Coordinate, nil, Collision, Anchored)
end

function BASF.Delete( Target : Instance )
	local Post = BASF.Post

	Post:FireServer("Destroy", Target)
end


function BASF.Execute( Input : string )
	local Post = BASF.Post

	Post:FireServer("Command", Input)
end

function BASF.Clear()
	local Post = BASF.Post

	Post:FireServer("Clear")
end

function BASF.Claim( Plot : number )
    local Template = "claim %d"

    BASF.Execute( Template:format( Plot ) )
end


function BASF.AddTrust( Player : Player )
	local Post = BASF.Post

	Post:FireServer("AddFriend", Player)
end

function BASF.RemoveTrust( Player : Player )
	local Post = BASF.Post

	Post:FireServer("RemoveFriend", Player)
end

function BASF.GetTrusted( Target : Player? )
	Target = Target or Current

	local Friend = ReplicatedStorage:WaitForChild("Friend")

	if Target then
		local Container = Friend:FindFirstChild( Target.Name )

		if Container then
			local List = {}

			for Index, Child in pairs( Container:GetChildren() ) do
				local Name = Child.Name

				if Child:IsA("StringValue") then
					if table.find( List, Name ) then continue end

					table.insert( List, Name )
				end
			end

			return List
		end
	end

	return {}
end


function BASF.GetPVP( Target : Player )
    local Character = Target.Character

    if Character then
        local Shield = Character:FindFirstChild("PVPShield")

        if Shield then
            return true
        end
    end

    return false
end

function BASF.SetPVP( Enable : boolean? )
	Enable = Enable or true

	if Enable then
		local Post = BASF.Post

		Post:FireServer("UpdatePVP", Enable)
	end
end


function BASF.SaveBuilding( Slot : number )
	local Get = BASF.Get

	Get:InvokeServer("Save", Slot)
end

function BASF.LoadBuilding( Slot : number )
	local Get = BASF.Get

	Get:InvokeServer("Load", Slot)
end

function BASF.RenameSlot( Slot : number, New : string? )
	New = New or "Untitled"

	if New then
		local Post = BASF.Post

		Post:FireServer("Slot", Slot, New)
	end
end


function BASF.GetData()
	local Get = BASF.Get

	return Get:InvokeServer("Data")
end


function BASF.GetFavorite()
	local Get = BASF.Get

	return Get:InvokeServer("GetFavorite")
end

function BASF.AddFavorite( Block : string )
	local Post = BASF.Post

	Post:FireServer("AddFavorite", Block)
end

function BASF.RemoveFavorite( Block : string )
	local Post = BASF.Post

	Post:FireServer("RemoveFavorite", Block)
end


function BASF.GetBlock()
	local Building = ReplicatedStorage:WaitForChild("Building")

	local Result = {}
	local Worker = {}

	local function Looking( Container : Instance )

		for Index, Child in pairs( Container:GetChildren() ) do
			local Name = Child.Name

			if Child:IsA("PVInstance") then
				if table.find( Result, Name ) then continue end

				table.insert( Result, Name )
			elseif Child:IsA("Folder") then
				local Thread = coroutine.create( function()
					Looking( Child )

					coroutine.yield()
				end)

				coroutine.resume( Thread )

				table.insert( Worker, Thread )
			end
		end
	end

	Looking( Building )

	do
		for Index, Item in pairs( Worker ) do

			if typeof( Item ) == "RBXScriptConnection" then
				Item:Disconnect()
			elseif typeof( Item ) == "Instance" then
				Item:Destroy()
			elseif typeof( Item ) == "thread" then

				if coroutine.status( Item ) == "suspended" then
					coroutine.close( Item )
				end
			end
		end

		table.clear( Worker )
	end

	return Result
end


return BASF
