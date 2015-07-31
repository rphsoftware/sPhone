--rMenu made by trainerred2000

function createMenu(sx,sy,type)
	if(not sx or not sy or not type)then
		error("Argumets invalid - start x, starty, type - valid types are (mouse and key)")
	end

	menu = {
		mtype = type,
		x=sx,
		y=sy,
		selop = 1,

		options = {
		},

		addOption = function(self,name,textcolor,backcolor,selectedtextcolor,selectedbackcolor,mfunction)
		
			self.options[#self.options+1] = {name=name,textcolor=textcolor,backcolor=backcolor,selectedtextcolor=selectedtextcolor,selectedbackcolor=selectedbackcolor,func=mfunction}
		
		end,

		update = function(self)
			if(#self.options <= 0)then
				error("Menu empty! run <menu>:addOption(option) ")
			end

			if(self.mtype == "mouse")then
				for i = 1, #self.options do
						term.setCursorPos(sx,sy+i)
						term.setTextColor(self.options[i].textcolor)
						term.setBackgroundColor(self.options[i].backcolor)
						print("  "..self.options[i].name.."  ")
				end

			elseif(self.mtype == "key")then
				for i = 1, #self.options do
					if(self.selop == i)then
						term.setCursorPos(sx,sy+i)
						term.setTextColor(self.options[i].selectedtextcolor)
						term.setBackgroundColor(self.options[i].selectedbackcolor)
						print("> "..self.options[i].name.." <")
					else
						term.setCursorPos(sx,sy+i)
						term.setTextColor(self.options[i].textcolor)
						term.setBackgroundColor(self.options[i].backcolor)
						print("  "..self.options[i].name.."  ")
					end
				end
			end

			a = {os.pullEvent()}

			if(self.mtype == "mouse" and a[1] == "mouse_click" and a[2] == 1)then
				for i = 1, #self.options do
					if(a[3] >= self.x and a[3] <= self.x+(#self.options[i].name)+2 and a[4] == math.floor(self.y+i))then
						term.setCursorPos(sx,sy+i)
						term.setTextColor(self.options[i].selectedtextcolor)
						term.setBackgroundColor(self.options[i].selectedbackcolor)
						print("  "..self.options[i].name.."  ")
						sleep(0.3)
						self.options[i].func()
					--else
						--error(a[3].."|"..self.x.."| "..self.x+(#self.options[i].name+2).."|"..a[4].."|"..(self.y+i) )
					end
				end


			elseif(self.mtype == "key" and a[1] == "key")then
				if(a[2] == keys.up and self.selop > 1)then self.selop = self.selop - 1 end
				if(a[2] == keys.down and self.selop < (#self.options))then self.selop = self.selop + 1 end
				if(a[2] == keys.enter)then self.options[self.selop].func() end
			end

		end,

	}

	return menu

end
