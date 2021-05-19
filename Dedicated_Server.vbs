'Change the file extension to .vbs if the format is not correct
'Move to folder Steam\steamapps\common\Don't Starve Together Dedicated Server\mods
'Run file DST_Dedicated_Server_Script.vbs
Option Explicit

Dim objFSO                  : Set objFSO = CreateObject("Scripting.FileSystemObject")
Dim objWS                   : Set objWS = CreateObject("wscript.shell")
Dim objApp 					: Set objApp = CreateObject("Shell.Application")
Dim objWMIService 			: Set objWMIService = GetObject("winmgmts:")

Dim ProcessList, process, prorun
Dim objFolder, colSubfolders, objSubfolder 
Dim oFile, File, folderTemp
Dim a(6), i, x, title, temp, str, strLeft, strRight, strNameOfFolder, cluster_token, cluster_path
Dim PATH_DOCUMENTS, PATH_STEAM_APP, PATH_DATA_DST, PATH_DATA_CLUSTER, TargetPath, tempPath

title = "DST Dedicated Server Script - by HoMinhTri"
PATH_DOCUMENTS = objWS.SpecialFolders("MyDocuments")
PATH_DATA_DST = PATH_DOCUMENTS & "\Klei\DoNotStarveTogether"
TargetPath = PATH_DATA_DST & "\token.data"
'================================================================================================================

Do
	if not objFSO.FileExists(TargetPath) then
		createData()
	else 
		chooseFunction()
	end if
Loop

'================================================================================================================
Sub chooseFunction()
	readData()
	createFileBAT()
	createFileToken()
	x = InputBox("============     Info Server     ============"_
		&vbLf&vbLf&_
		"=> Cluster Path: " &a(4)_
		&vbLf&_
		"=> Token: " &a(6)_
		&vbLf&vbLf&_
		"=====    Function Selection By Number    ====="_
		&vbLf&vbLf&_
		"1. Run Server"_
		&vbLf&vbLf&_
		"2. Update mods"_
		&vbLf&_
		"3. Delete mods"_
		&vbLf&_
		"4. Change Path Cluster"_
		&vbLf&_
		"5. Change TOKEN"_
		&vbLf&vbLf&_
		"6. Reset Script"_
		&vbLf&vbLf&_
		"Type in number:"_
		, title, 1)
		
	if IsNumeric(x) then
		Select Case x
			case 0
				objFSO.DeleteFile a(5)
				wscript.quit
			case 1
				objWS.run """"&a(0)&""""
				wscript.quit
			case 2
				updateMods()
			case 3
				deleteMods()
			case 4
				updateClusterPath()
			case 5	
				updateToken()
			case 6
				resetScript()
			Case Else
				MsgBox "Please enter the correct format!", vbCritical + vbSystemModal, title
		End Select
	else 
		MsgBox "Please enter the correct format!", vbCritical + vbSystemModal, title
	end if
End Sub


Sub createData()
	Set objFolder = objApp.BrowseForFolder(0,"Select Folder ""\steamapps"": ",0,17)
	if objFolder is nothing then
		WScript.Quit
	end if
	
	
	PATH_STEAM_APP = objFolder.Self.Path
	
	Set objFolder = objApp.BrowseForFolder(0,"Select Folder Cluster: ",0,PATH_DATA_DST)
	if objFolder is nothing then
		WScript.Quit
	end if
	PATH_DATA_CLUSTER = objFolder.Self.Path
	cluster_path = right (PATH_DATA_CLUSTER, Len(PATH_DATA_CLUSTER)-Len(PATH_DATA_DST)-1)
	cluster_path = Replace(cluster_path, "\", "/")
	
	Do
		cluster_token = InputBox("Token: ", title)
		if cluster_token <> "" then 
			Exit Do
		end if
	Loop
	Set File = objFSO.CreateTextFile(TargetPath,True)
	File.WriteLine PATH_STEAM_APP & "\common\Don't Starve Together Dedicated Server\bin\Dedicated Server DST.bat"
	File.WriteLine PATH_STEAM_APP & "\common\Don't Starve Together Dedicated Server\mods"
	File.WriteLine PATH_STEAM_APP & "\common\Don't Starve Together\mods"
	File.WriteLine PATH_STEAM_APP & "\workshop\content\322330"
	File.WriteLine cluster_path
	File.WriteLine PATH_DATA_CLUSTER & "\cluster_token.txt"
	File.Write cluster_token
	File.Close
	
	objFSO.DeleteFolder a(1)&"\*"
	MsgBox "COPY MODS, Please Wait!", vbExclamation + vbSystemModal, title
	copyFolderDST()
	copyFolderWorkshop()
	MsgBox "Success!", vbInformation + vbSystemModal, title
End Sub


Sub createFileBAT()
	tempPath = a(0)
	if not objFSO.FileExists(tempPath) then
		cluster_path = a(4)
		Set File = objFSO.CreateTextFile(tempPath,True)
		File.WriteLine "cd /D ""%~dp0"""
		File.WriteLine "start ""DST Server Master"" dontstarve_dedicated_server_nullrenderer.exe -skip_update_server_mods -cluster "&cluster_path&" -shard Master"
		File.WriteLine "start ""DST Server Caves"" dontstarve_dedicated_server_nullrenderer.exe -skip_update_server_mods -cluster "&cluster_path&" -shard Caves"
		File.Close
	else
		objFSO.DeleteFile (tempPath)
		createFileBAT()
	end if
End Sub


Sub createFileToken()
	tempPath = a(5)
	Set File = objFSO.CreateTextFile(tempPath,True)
	File.Write a(6)
	File.Close
End Sub
'================================================================================================================


Sub readData()
	Set oFile = objFSO.OpenTextFile(PATH_DATA_DST & "\token.data",1)
	For i = 0 To 6
	  a(i) = oFile.ReadLine
	Next
	oFile.Close
End Sub


'================================================================================================================

Sub updateClusterPath()
	Set oFile = objFSO.OpenTextFile(PATH_DATA_DST & "\token.data",1)
	temp = OFile.ReadAll
	oFile.Close
	
	Set objFolder = objApp.BrowseForFolder(0,"Select Folder Cluster: ",0,PATH_DATA_DST)
	if objFolder is nothing then 
		WScript.Quit
	end if
	
	PATH_DATA_CLUSTER = objFolder.Self.Path
	cluster_path = right (PATH_DATA_CLUSTER, Len(PATH_DATA_CLUSTER)-Len(PATH_DATA_DST)-1)
	cluster_path = Replace(cluster_path, "\", "/")
	
	
	
	temp = Replace(temp, a(4), cluster_path)
	temp = Replace(temp, a(5), PATH_DATA_CLUSTER & "\cluster_token.txt")
	
	Set oFile = objFSO.OpenTextFile(PATH_DATA_DST & "\token.data",2)
	oFile.Write temp
	oFile.Close
	objFSO.DeleteFile a(5)
	MsgBox "Cluster Path Updated!", vbInformation + vbSystemModal, title
End Sub

Sub updateToken()
	Set oFile = objFSO.OpenTextFile(PATH_DATA_DST & "\token.data",1)
	temp = OFile.ReadAll
	oFile.Close
	
	Do
		cluster_token = InputBox("Token: ", title)
		if cluster_token <> "" then 
			Exit Do
		end if
	Loop
	
	temp = Replace(temp, a(6), cluster_token)
	Set oFile = objFSO.OpenTextFile(PATH_DATA_DST & "\token.data",2)
	oFile.Write temp
	oFile.Close
	MsgBox "TOKEN Updated!", vbInformation + vbSystemModal, title
End Sub

Sub updateMods()
	temp = MsgBox ("Do You Want To Update Mods?", vbYesNo + vbQuestion + vbSystemModal, title)
	if temp = vbYes then
		objFSO.DeleteFolder a(1)&"\*"
		copyFolderDST()
		copyFolderWorkshop()
		MsgBox "Mods Updated!", vbInformation + vbSystemModal, title
	else
	end if
End Sub


'================================================================================================================


Sub copyFolderDST()
	objFSO.CopyFolder a(2)&"\*", a(1)
End Sub


Sub copyFolderWorkshop()
	folderTemp = a(1) & "\temp"
	if objFSO.FolderExists(folderTemp) then
		objFSO.DeleteFolder (folderTemp)
		objFSO.CreateFolder (folderTemp)
	else 
		objFSO.CreateFolder (folderTemp)
	end if
	
	objFSO.CopyFolder a(3)&"\*", folderTemp &"\"
	
	set objFolder = objFSO.GetFolder(folderTemp)
	set colSubfolders = objFolder.Subfolders
	for each objSubfolder in colSubfolders
		strNameOfFolder = objSubfolder.Name
		str = "workshop-"
		strLeft = left (strNameOfFolder, 9)
		strRight = right (strNameOfFolder, 9)
		if strLeft <> str AND IsNumeric(strRight) then
			objFSO.MoveFolder objFolder & "\" & strNameOfFolder, objFolder & "\" & str+strNameOfFolder
		end if
	next
	
	objFSO.CopyFolder folderTemp &"\*", a(1)
	objFSO.DeleteFolder (folderTemp)
End Sub


'================================================================================================================


Sub deleteMods()
	temp = MsgBox ("Do You Want To Delete Mods?", vbYesNo + vbQuestion + vbSystemModal, title)
	if temp = vbYes then
		objFSO.DeleteFolder a(1)&"\*"
		MsgBox "Mods Has Been Deleted!", vbInformation + vbSystemModal, title
	else
	end if
End Sub

Sub deleteData()
	objFSO.DeleteFile TargetPath
End Sub


'================================================================================================================

Sub resetScript()
	temp = MsgBox ("Do You Want To Reset Script?", vbYesNo + vbQuestion + vbSystemModal, title)
	if temp = vbYes then
		objFSO.DeleteFile a(5)
		objFSO.DeleteFolder a(1)&"\*"
		deleteData()
	else
	end if
End Sub

Function serverStop()
	Set ProcessList = objWMIService.ExecQuery _
	("Select * from Win32_Process Where Name ='dontstarve_dedicated_server_nullrenderer.exe'")
	For Each process In ProcessList
		prorun = process.Name
	Next
	if prorun = "" then
		MsgBox "Server stopped"
		wscript.quit
	else
		wscript.sleep 1000
		serverStop()
	end if
End Function



