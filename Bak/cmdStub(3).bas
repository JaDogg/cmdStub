
''----------------------------------------------------------------
''
'' This is the stub executable of CmdWrapperZen (cmdStub.bas)
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

#include "overlayhandler.bas"
#include "shellfunctions.bas"

sub start()
	
	dim as integer has_ovr,ovr_pos,ovr_len
	dim as string temp_cmd,temp_cmd_path,temp_cmd_justname
	dim as string api_data
	dim as string batdata
	dim as integer options,is_con,is_wait,is_api
	dim as string paras_to_use
	randomize timer,3
	
	get_overlay_information(has_ovr,ovr_pos,ovr_len)
	if not (has_ovr) then exit sub 
	
	'continue if there is an ovrlay
	
	batdata = read_overlay(ovr_pos,ovr_len)
	options = valint(left(batdata,1))
	batdata = mid(batdata,2) 'skip first character (its the options)
	
	get_options(op,is_con,is_wait,is_api)
	'show the console if its said

	temp_cmd_path = add_slash(get_temp_dir())
	temp_cmd_justname = get_temp_cmd_filename()
	temp_cmd = temp_cmd_path + temp_cmd_justname
	paras_to_use = get_command_line_without_exe()
	
	if (is_con) then
		allocconsole()
	endif
	
	if(is_api) then
		api_data = "@echo off" + newl
		api_data += "set CW_EXE_NAME=" + get_exename() + newl
		api_data += "set CW_EXE_PATH=" + add_slash(exepath()) + newl
		api_data += "set CW_EXE_FULL=" + command(0) + newl
		api_data += "set CW_EXE_NAME_NOEXT=" + strip_extension(get_exename()) + newl
		
		api_data += "set CW_CMD_NAME=" + temp_cmd_justname + newl
		api_data += "set CW_CMD_PATH=" + temp_cmd_path + newl		
		api_data += "set CW_CMD_FULL=" + temp_cmd + newl
		api_data += "set CW_CMD_NAME_NOEXT=" + strip_extension(temp_cmd_justname) + newl
				
		api_data += "set CW_CUR_DIR=" + add_slash(curdir()) + newl
		
		api_data += "set CW_RND_INT=" + str(cint(rnd*1000)) + newl
		
		api_data += "set CW_START_TIME=" + time() + newl
		api_data += "set CW_START_DATE=" + date() + newl
		
		api_data += "set CW_FULL_CMDL=" + *getcommandline() + newl
		api_data += "set CW_CMDL=" + paras_to_use + newl
		
		
		batdata = api_data + batdata
	endif
	
	'save the cmd file
	dim as integer ffile = freefile()
	open temp_cmd for binary as #ffile
	put #ffile,,batdata
	close #ffile
	
	'run it
	if (is_wait) then
		advance_shell_execute(add_dquote(temp_cmd) + " " + paras_to_use,curdir(),SW_HIDE)
	else
		advance_shell_execute(add_dquote(temp_cmd) + " " + paras_to_use,curdir(),SW_HIDE,0)
	endif
end sub

start() 'call start
