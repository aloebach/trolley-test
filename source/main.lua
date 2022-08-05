--[[
	Trolley test

	Author: Andrew Loebach

	animation demo for 3D trolley
]]

import 'CoreLibs/sprites'
import 'CoreLibs/ui' -- for crank indicator
import 'CoreLibs/crank'

local gfx <const> = playdate.graphics


-- initialize animation
local image_table = gfx.imagetable.new("images/godzilla")
local my_sprite = gfx.sprite.new(image_table)
my_sprite.total_frames = image_table:getLength()
my_sprite.frame_num = 1
--my_sprite.frame_num = math.floor( crank_angle / (360.1/my_sprite.total_frames) ) + 1
my_sprite:setImage(image_table:getImage(my_sprite.frame_num))
my_sprite:moveTo(200,120)
my_sprite:add()

--> Initialize sound effects
local click_noise = playdate.sound.sampleplayer.new('sounds/click')
local play_sound= true

-- logic for setting frame rate
local FPS = 40
local FPS_options = {20, 30, 40, 50}
playdate.display.setRefreshRate(FPS)

-- Initialize crank indicator
playdate.ui.crankIndicator:start()
show_crank_indicator = true


-- main update function called every frame:
function playdate.update()

	-- update sprite animations
	gfx.sprite.update() -- updates all sprites
	
	-- update crank indicator animation
	playdate.timer.updateTimers() 
	if show_crank_indicator then playdate.ui.crankIndicator:update() end
	
	-- display current FPS
	playdate.drawFPS()

end


-- callback function which is called crank is moved
function playdate.cranked(change, acceleratedChange)

	-- Once crank is turned, turn off crank indicator
	show_crank_indicator = nil

	-- When crank is turned, play clicking noise
	--click_noise:play(1)
	if play_sound then click_noise:play(1) end

	-- update sprite's frame when crank is turned
	local crank_angle = playdate.getCrankPosition() -- Returns the absolute position of the crank (in degrees). Zero is pointing straight up parallel to the device
	my_sprite.frame_num = math.floor( crank_angle / (360.1/my_sprite.total_frames) ) + 1 -- adding .1 to fix bug that occurs if crank_position ~= 360
	my_sprite:setImage(image_table:getImage(my_sprite.frame_num))

end


-- Defining system menu options
local sysMenu = playdate.getSystemMenu()

-- add menu option to change frame rate
sysMenu:addOptionsMenuItem("FPS", FPS_options, tostring(FPS), 
	function(selectedFPS)
		-- set FPS selected in menu by user
		FPS = selectedFPS
		playdate.display.setRefreshRate(FPS)		
	end
)

-- add menu option for toggling sound
sysMenu:addCheckmarkMenuItem("sound", true, 
	function(value)
		play_sound = value
	end
)

