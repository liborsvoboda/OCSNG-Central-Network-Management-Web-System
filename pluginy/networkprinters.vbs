' This scripts read the network printer from the registry per user
' it was tested with Windows7/32bit and Windows XP
' Author: Christian Davies
' Email: christian.davies@gmx.at
' Date: 12. June 2012
' Version: 1.0

Const HKEY_CLASSES_ROOT   = &H80000000
Const HKEY_CURRENT_USER   = &H80000001
Const HKEY_LOCAL_MACHINE  = &H80000002
Const HKEY_USERS          = &H80000003
Const REG_SZ        = 1
Const REG_EXPAND_SZ = 2
Const REG_BINARY    = 3
Const REG_DWORD     = 4
Const REG_MULTI_SZ  = 7
Dim Profils(255)
Dim Username(255)
i = 1
DefaultPrinterFlag = "No"
 
' First get all users from registry including all systemusers
strProfilImagePath = "ProfileImagePath"
strComputer = "." ' Use . for current machine
hDefKey = HKEY_LOCAL_MACHINE
strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
oReg.EnumKey hDefKey, strKeyPath, arrSubKeys
' Store all Profil UID in an array
For Each strSubkey In arrSubKeys
	Profils(i) = strSubkey
	i = i + 1	
Next
 
' Get the Username from the Profil
For count = 1 to ( i - 1 )
	strKeyPathProfil = strKeyPath & "\" & Profils(count)
	oReg.GetStringValue hDefKey,strKeyPathProfil, strProfilImagePath, strValue
	Position = InStrRev(strValue, "\")
    Username(count) = Right(strValue, Len(StrValue)-Position)
	' Extract the Username from the Profil Path. Normally something like C:\Users\Username
Next
 
' Read the printer connections of each user
For count = 1 to ( i - 1 )
	On Error Resume Next
	strKeyPath = Profils(count)&"\Printers\Connections"
	oReg.EnumKey HKEY_USERS,strKeyPath, arrValues
 
 
	' If no error found network printer exists
	if Err.Number  = 0 Then
		' Read Default Printer from Registry
		strDefaultPrinter = Profils(count)&"\Software\Microsoft\Windows NT\CurrentVersion\Windows"
		strDevice = "Device"
		oReg.GetStringValue HKEY_USERS, strDefaultPrinter, strDevice, strValuePrinter
		Position = InStr(strValuePrinter, ",")
		Defaultprinter = lcase(Left(strValuePrinter, (Position-1)))
 
		For Each strValue_Printer In arrValues
		' Check if a network printer exists
			if len(strValue_Printer) > 0 then 
				a = split(strValue_Printer,",")
				b = replace(strValue_Printer, ",", "\")
 
				'check if printer is the default printer
				if lcase(b) = Defaultprinter then
					DefaultPrinterFlag = "Yes"
				else 
					DefaultPrinterFlag = "No"
				end if
                                ' Please see also the remark
				Wscript.echo "<NETWORK_PRINTERS>"
				Wscript.echo "<USERNAME>" & lcase(Username(count)) & "</USERNAME>"
				Wscript.echo "<SHARENAME>" &  ucase(a(3)) & "</SHARENAME>"
				Wscript.echo "<SHAREPATH>" &  lcase(b)  & "</SHAREPATH>"
				Wscript.echo "<DEFAULTPRINTER>" & DefaultPrinterFlag & "</DEFAULTPRINTER>"
				Wscript.echo "<SHARETYPE>Network-Printer</SHARETYPE>"
				Wscript.echo "<SHAREDESC> </SHAREDESC>"
				Wscript.echo "<SHARECOMMENT> </SHARECOMMENT>"
				Wscript.echo "</NETWORK_PRINTERS>"
			end if
		Next
	End If
Next
'--- end of script
