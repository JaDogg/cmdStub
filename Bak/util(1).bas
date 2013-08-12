
''----------------------------------------------------------------
''
'' This is the util.bas
''
'' This product is licensed under
'' The MIT License (MIT)
''
'' Copyright (c) 2013 B. A. Bhathiya N. H. Perera
''
'' Permission is hereby granted, free of charge, to any person obtaining a copy of
'' this software and associated documentation files (the "Software"), to deal in
'' the Software without restriction, including without limitation the rights to
'' use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
'' the Software, and to permit persons to whom the Software is furnished to do so,
'' subject to the following conditions:
''
'' The above copyright notice and this permission notice shall be included in all
'' copies or substantial portions of the Software.
''
'' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
'' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
'' FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
'' COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
'' IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
'' CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
''
''----------------------------------------------------------------

#include "windows.bi"

#define INIT_CONSOLE 0
#define WAIT_FOR_BAT 1
#define ADD_API 2
#define CHECK_BIT(v,p) (((v) and (1 shl (p)))<>0)

#define newl !"\r\n"

function get_temp_dir()as string
	dim as zstring ptr buffer = allocate(2000)
	gettemppath(1999,buffer)
	return *buffer
end function
function add_slash(path as string) as  string
	if (right(path,1) <> "\") then
		return path + "\"
	endif
	return path
end function
function get_temp_cmd_filename()as string
	dim as string path = "BHA"
	for i as integer = 1 to 17
		path+= hex(10+cint((rnd*5)))
	next
	return path + ".cmd"
end function
sub get_options(options as integer,byref is_con as integer,byref is_wait as integer,byref is_api as integer)
	is_con = CHECK_BIT(options,INIT_CONSOLE)
	is_wait = CHECK_BIT(options,WAIT_FOR_BAT)
	is_api = CHECK_BIT(options,ADD_API)
end sub
function get_system_dir() as string
	dim as zstring ptr buff = allocate(max_path+1)
	getsystemdirectory(buff, max_path)
	return *buff
end function
function get_command_line_without_exe() as string
	dim as string cmdl = *getcommandline()
	dim as integer poz
	if(left(cmdl,1)="""") then
		'have a starting quote then find next quote
		poz = instr(2,cmdl,"""")
		return mid(cmdl,poz+2)
	else	
		poz = instr(cmdl," ")
		if(poz<>0)then
			return mid(cmdl,poz+1)
		endif
		
	endif
	return ""
end function
function get_exename() as string
	dim as string ex
	ex = command(0)
	return mid(ex,instrrev(ex,"\")+1)
end function
function strip_extension(filename as string) as string
	dim as string ex
	ex = filename
	dim as integer poz = instrrev(ex,".")
	if (poz<>0) then
		return left(filename,poz)
	endif
	return filename
end function
function add_dquote(whatever as string) as string
	if(instr(whatever," ")=0) then
		return whatever
	else
		return """" + whatever + """"
	endif
	
end function
