--[[GUI API BY MHIEKURU
	functions available

	OBJECTS
	gui.background()
	gui.progressBar()
	gui.toggleButton()
	gui.pulseButton()

	RENDER
	gui.render()
]]
--CORE FUNCTION--

local function convertArea( vertex )
	local xMax, yMax = term.getSize()
	--if vertex consist of two numbers, convert given as length and height, then set starting vertex to the current cursor position
	if type(vertex[1]) == 'number' and type(vertex[2]) == 'number' and vertex[3] == nil and vertex[4] == nil then
		local x, y = term.getCursorPos()
		if vertex[1] < 0 then
			vertex[3] = xMax+vertex[1]+1
		else
			vertex[3] = x-1+vertex[1]
		end
		if vertex[2] < 0 then
			vertex[4] = yMax+vertex[2]+1
		else
			vertex[4] = y-1+vertex[2]
		end
		vertex[1] = x
		vertex[2] = y
	--if vertex consist of four numbers, convert each number to its [maxAxis plus the negative vertex plus one] if the vertex is a negative value
	elseif type(vertex[1]) == 'number' and type(vertex[2]) == 'number' and type(vertex[3]) == 'number' and type(vertex[4]) == 'number' then
		if vertex[1] < 0 then
			vertex[1] = xMax+vertex[1]+1
		end
		if vertex[2] < 0 then
			vertex[2] = yMax+vertex[2]+1
		end
		if vertex[3] < 0 then
			vertex[3] = xMax+vertex[3]+1
		end
		if vertex[4] < 0 then
			vertex[4] = yMax+vertex[4]+1
		end
	end
	--switch vertex[1] and vertex[3] if vertex[1] is greater
	local placeHolderX, placeHolderY
	if vertex[3] < vertex[1] then
		placeHolderX = vertex[1]
		vertex[1] = vertex[3]
		vertex[3] = placeHolderX
	end
	--switch vertex[1] and vertex[3] if vertex[1] is greater
	if vertex[4] < vertex[2] then
		placeHolderY = vertex[2]
		vertex[2] = vertex[4]
		vertex[4] = placeHolderY
	end
	return vertex
end

local function fill( vertex, color )
	term.setBackgroundColor( color )
	for i = vertex[2], vertex[4] do
		term.setCursorPos( vertex[1], i )
		write( string.rep( ' ', vertex[3] - vertex[1] + 1 ) )
	end
end

function setCursorPos( vertex, string, position )
	if position == 'c' then
		term.setCursorPos( math.ceil( ( ( vertex[3] - vertex[1] + 1 - #string ) / 2 ) + vertex[1] ),
			math.ceil( ( math.floor(vertex[4]) + math.floor(vertex[2]) ) / 2 ) )
	elseif position == 'l' then
		term.setCursorPos( vertex[1], math.ceil( ( math.floor(vertex[4]) + math.floor(vertex[2]) ) / 2 ) )
	end
end

--GUI LIBRARY--

background = function( color )
	return
		{
		type = 'background',
		color = color
		}
end

progressBar = function( vertex, color, string )
	return
		{
		type = 'bar_percent',
		vertex = vertex,
		color = color,
		string = string,
		}
end

toggleButton = function( vertex, color, string, guifunction )
	return
		{
		type = 'button_toggle',
		vertex = vertex,
		color = color,
		string = string,
		guifunction = guifunction,
		state = 1
		}
end

pulseButton = function( vertex, color, string, guifunction )
	return
		{
		type = 'button_pulse',
		vertex = vertex,
		color = color,
		string = string,
		guifunction = guifunction,
		}
end

render = function(gui)
	local counter = 0
	local counterEvent
	local refreshrate = 0
	os.startTimer(0)
	while true do
		if counter == 3 then
			if gui[counterEvent].guifunction then
				local startTime = os.clock()
				gui[counterEvent].guifunction()
				if os.clock() > startTime+refreshrate then
					os.startTimer(refreshrate)
				end
			end
			counter = 0
		elseif counter > 0 then
			counter = counter+1
		end
		--wait event
		local event, mbttn, crsrX, crsrY = os.pullEvent()
		--check and run functions
		if event == 'mouse_click' or event == 'monitor_touch' or event == 'mouse_drag' then
			local startTime = os.clock()
			for i = 1, #gui do
				if gui[i].type == 'button_toggle' or gui[i].type == 'button_pulse' then
					if crsrX >= gui[i].vertex[1] and crsrX <= gui[i].vertex[3] and crsrY >= gui[i].vertex[2] and crsrY <= gui[i].vertex[4] then
						if gui[i].type == 'button_toggle' then
							if gui[i].guifunction then
								gui[i].guifunction[gui[i].state]()
							end
							if mbttn == 1 then -- [+]
								if gui[i].state == #gui[i].color then --only when func activated
									gui[i].state = 1
								else
									gui[i].state = gui[i].state + 1
								end
							else -- [-]
								if gui[i].state == 1 then --only when func activated
									gui[i].state = #gui[i].color
								else
									gui[i].state = gui[i].state - 1
								end
							end
						elseif gui[i].type == 'button_pulse' then
							counter = 1
							counterEvent = i
						end
					end
				end
			end
			if os.clock() > startTime+refreshrate then
				os.startTimer(refreshrate)
			end
		elseif event == 'timer' then
			--render
			for i, v in ipairs(gui) do
				if gui[i].type == 'button_toggle' then
					gui[i].vertex = convertArea( gui[i].vertex )
					--renders button's background
					fill( gui[i].vertex, gui[i].color[gui[i].state] )
					--renders button's text
					setCursorPos( gui[i].vertex, gui[i].string[gui[i].state], 'c' )
					term.setTextColor( colors.white )
					write( gui[i].string[gui[i].state] )
					term.setCursorPos( gui[i].vertex[1], gui[i].vertex[4] + 2 )
				elseif gui[i].type == 'button_pulse' then
					gui[i].vertex = convertArea( gui[i].vertex )
					--renders button's background
					if counter == 0 then
						fill( gui[i].vertex, gui[i].color[1] )
					else
						fill( gui[i].vertex, gui[i].color[2] )
					end
					--renders button's text
					setCursorPos( gui[i].vertex, gui[i].string, 'c' )
					term.setTextColor( colors.white )
					write( gui[i].string )
					term.setCursorPos( gui[i].vertex[1], gui[i].vertex[4] + 2 )
				elseif gui[i].type == 'bar_percent' then
					if gui[i].string then
						local percent = gui[i].string()
						gui[i].vertex = convertArea( gui[i].vertex )
						if percent > 100 then percent = 100 end --limit percent to 100%
						--renders progress bar's background
						fill( {math.floor(((gui[i].vertex[3]-gui[i].vertex[1]+1)*percent/100)+gui[i].vertex[1]), gui[i].vertex[2], gui[i].vertex[3], gui[i].vertex[4]}, gui[i].color[1] )
						--renders progress bar's foreground
						fill( {gui[i].vertex[1], gui[i].vertex[2], math.floor(((gui[i].vertex[3]-gui[i].vertex[1]+1)*percent/100)+gui[i].vertex[1]-1), gui[i].vertex[4]}, gui[i].color[2] )
						--renders data to be displayed
						local perTab = {}
						for j = 1, #tostring( percent .. '%' ) do
 						   perTab[ j ] = tostring( percent .. '%' ):sub( j, j )
						end
						setCursorPos( gui[i].vertex, perTab, 'c' )
						for j = 1, #perTab do
							local perX, perY = term.getCursorPos()
							if perX <= math.floor(((gui[i].vertex[3]-gui[i].vertex[1]+1)*percent/100)+gui[i].vertex[1]-1) and perX >= gui[i].vertex[1] then
								term.setBackgroundColor(gui[i].color[2])
								term.setTextColor(gui[i].color[1])
							else
								term.setBackgroundColor(gui[i].color[1])
								term.setTextColor(gui[i].color[2])
							end
							write(perTab[j])
						end
						term.setCursorPos( gui[i].vertex[1], gui[i].vertex[4] + 2 )
					end
				elseif gui[i].type == 'background' then
					local x, y = term.getCursorPos()
					term.setBackgroundColor( gui[ i ].color )
					term.clear()
					term.setCursorPos( x, y )
				end
			end
			os.startTimer(refreshrate)
		end
	end
end
