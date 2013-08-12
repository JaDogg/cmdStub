
''----------------------------------------------------------------
''
'' This is the shellFunctions.bas
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

#include once "windows.bi"
#include "win/shellapi.bi"
#include "util.bas"

sub advance_shell_execute(cmd as string,foldername as string="",show as integer = SW_SHOW,do_wait as integer =-1,appname as string = "-",byref iexitcode as integer = 0)

	dim startinfo  as   STARTUPINFO
	dim pinfo      as   PROCESS_INFORMATION
	dim szAppName  as   string   = appname
	dim bytesRead  as   dword
	dim ExitCode   as   dword

	if cmd = "" then exit sub
	ExitCode  = 0


	startinfo.cb             = sizeof(STARTUPINFO)
	getstartupinfo(@startinfo)
	startinfo.dwFlags        = STARTF_USESHOWWINDOW
	startinfo.wShowWindow    = show

	dim as string tcmd  =  "/C " + cmd
	dim as string cmdex = add_slash(get_system_dir()) + "cmd.exe"

	if createprocess(strptr(cmdex),strptr(tcmd),null,null,true,null,null,null,@startinfo,@pinfo)=0 then
		messagebox(null,strptr("CreateProcess failed"),strptr(szAppName),MB_OK or MB_ICONERROR)
		iexitcode = -1
		exit sub
	endif

	if (do_wait) then
		waitforsingleobject(pinfo.hProcess,INFINITE)
		getexitcodeprocess(pinfo.hProcess,@ExitCode)
	endif

	iexitcode = ExitCode

end sub

sub advance_shell_open(cmd as string,show as integer = SW_SHOW)

	if cmd = "" then exit sub
	shellexecute(null,"Open",strptr(cmd),"","",show)

end sub