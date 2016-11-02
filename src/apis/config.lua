function write(file,config,value)
	local data = {}
	if fs.isDir(file) then
		return false
	end
	if fs.exists(file) then
		local f = fs.open(file,"r")
		local con = f.readAll()
		f.close()
		con = textutils.unserialize(con)
		if not con then
			return false
		end
		data = con
	end
	
	data[config] = value
	local f = fs.open(file,"w")
	f.write(textutils.serialize(data))
	f.close()
	return true
end

function read(file,config)
	local data = {}
	if fs.isDir(file) then
		return nil
	end
	if fs.exists(file) then
		local f = fs.open(file,"r")
		local con = f.readAll()
		f.close()
		con = textutils.unserialize(con)
		if not con then
			return nil
		end
		data = con
	end
	return data[config]
end

function list(file)
	local data = {}
	if fs.isDir(file) then
		return nil
	end
	if fs.exists(file) then
		local f = fs.open(file,"r")
		local con = f.readAll()
		f.close()
		con = textutils.unserialize(con)
		if not con then
			return nil
		end
		data = con
	end
	return data
end
