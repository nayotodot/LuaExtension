local _M = {};
local load = pcall(load, "") and load or function(chunk, chunkname, mode, env)
	local f, err = loadstring( chunk, chunkname );
	if not f then return f, err; end
	return setfenv(f, env or _G);
end

local function parser( file )
	local lines = {};
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

function _M.read( filename )
	local file = io.input( filename );
	local chunk = parser( file );
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
