
''----------------------------------------------------------------
''
'' This is the overlayHandler.bas
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
#define WIN_INCLUDE_ALL


/'
this gets the overlay information of the current executable(myself)

has_ovr is -1 if there is an overlay
ovr_pos is position of the overlay
ovr_len is the length of overlay
'/
sub get_overlay_information(byref has_ovr as integer,byref ovr_pos as integer,byref ovr_len as integer)

	dim exename as string
	dim ifile as integer
	dim dosheader as IMAGE_DOS_HEADER
	dim ntheader as IMAGE_NT_HEADERS
	redim sections(0) as IMAGE_SECTION_HEADER
	dim howmanysec as integer
	dim exeend as integer

	'set default return values
	has_ovr = 0
	ovr_pos = 0
	ovr_len = 0

	exename = command(0)

	ifile = freefile()
	open exename for binary as #ifile
	if err<>0 then exit sub

	get #ifile,,dosheader
	seek #ifile,dosheader.e_lfanew+1
	get #ifile,,ntheader
	howmanysec = ntheader.FileHeader.NumberOfSections
	redim sections(howmanysec-1) as IMAGE_SECTION_HEADER
	get #ifile,,sections()
	exeend = sections(howmanysec-1).PointerToRawData + sections(howmanysec-1).SizeOfRawData + 1
	if exeend < lof(ifile) then
		has_ovr = -1
		ovr_pos = exeend
		ovr_len = lof(ifile) - exeend + 1
	else
		exit sub
	endif

	close #ifile
end sub
function read_overlay(ovr_pos as integer,ovr_len as integer) as string
	dim as integer ifile
	dim as string exename = command(0)
	dim as string sbuff
	ifile = freefile()
	open exename for binary as #ifile
	if err<>0 then exit function
	
	seek #ifile,ovr_pos 
	sbuff = space(ovr_len)
	get #1,,sbuff
	close #ifile
	
	return sbuff
end function
