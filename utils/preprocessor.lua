local _M = {};
local load = pcall(load, "") and load or function(chunk, chunkname, mode, env)
	local f, err = loadstring( chunk, chunkname );
	if not f then return f, err; end
	return setfenv(f, env or _G);
end

local function ParseTable( tbl )
	if type(tbl) == "table" then
		local res = {};
		res[#res+1] = "{";
		for k,v in pairs(tbl) do
			if tonumber(k) then
				res[#res+1] = ( "[%s]" ):format( k );
			else
				res[#res+1] = ( "[%q]" ):format( k );
			end
			res[#res+1] = "=";
			if type(v) == "table" then
				res[#res+1] = ( "%s" ):format( ParseTable(v) );
			else
				res[#res+1] = ( "%q" ):format( v );
			end
			res[#res+1] = ",";
		end
		res[#res+1] = "}";
		return table.concat(res, " ");
	else
		return tostring(tbl);
	end
end

local function parser( file, defines )
	local lines = {};
	if type(defines) == "table" then
		for k,v in pairs(defines) do
			lines[#lines+1] = ( "local %s = %s;" ):format( k, ParseTable(v) );
		end
	end
	for line in file:lines() do
		if line:find("^#") then
			lines[#lines+1] = line:sub( 2 );
		else
			local last = 1;
			for text,expr,index in line:gmatch("(.-)$(%b())()") do
				last = index;
				if text ~= "" then
					lines[#lines+1] = ( "io.write( %q )" ):format( text );
				end
				lines[#lines+1] = ( "io.write( %s )" ):format( expr );
			end
			lines[#lines+1] = ( "io.write( %q )" ):format( line:sub(last) .. "\n" );
		end
	end
	return table.concat(lines, "\n");
end

function _M.read( filename, defines )
	local file = io.input( filename );
	local chunk = parser( file, defines );
	io.close( file );
	return chunk;
end

function _M.write( filename, chunk )
	local file = io.output( filename );
	local f, err = load( chunk, filename );
	assert( f, debug.traceback(err) );
	f();
	io.close( file );
end

return _M;
