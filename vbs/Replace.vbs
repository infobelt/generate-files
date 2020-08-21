'Replace.vbs
'This script is designed to cycle through all files with an ini extension in a specified folder
'and replace the old server name with the new server name. Server name must include the \isuite2 string.
'Command line arguments will supercede hardwired values.

Dim FileName, Find, ReplaceWith, FileContents, dFileContents, strStartFolder, strServerName, strHelpMessage

strServerName = "\isuite2"
strStartFolder = "C:\Program Files\ISuite\User_Profiles"
strHelpMessage = "REPLACE.VBS: Searches the " & StrStartFolder & " folder for .ini files and replaces " & _
  "the occurence of the old I-Suite DB name with the new I-Suite DB name. Do not specify the " & _
  "service name (" & strServerName & "). This script will either run without arguments " & _
  "using values set in the script or can be used with arguments in the following format:" & vbCrLf & vbCrLf & _
  "     replace (OldName NewName | help)"

'Hardwired settings for search and replace
Find = "oldservername"
ReplaceWith = "newservername"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder(strStartFolder)

if Wscript.Arguments.Count > 0 Then
  if Wscript.Arguments(0) = "help" or Wscript.Arguments(0) = "-h" or Wscript.Arguments(0) = "-?" Then
    wscript.echo strHelpMessage
  Else
    Find = Wscript.Arguments(0)
    ReplaceWith = Wscript.Arguments(1)
  End If
End If

Find = Find & strServerName
ReplaceWith = ReplaceWith & StrServerName

Set colFiles = objFolder.Files
For Each objFile in colFiles
  '
  if objFSO.getextensionname(objFile) = "ini" then 
    Filename = strStartFolder & "\" & objFile.Name

    'Read source text file
    FileContents = GetFile(FileName)

    'replace all string In the source file
    dFileContents = Replace(FileContents, Find, ReplaceWith, 1, -1, 1)

    'Compare source And result
    if dFileContents <> FileContents Then
      'write result If different
      WriteFile FileName, dFileContents

      '  Wscript.Echo "Replace done."
      If Len(ReplaceWith) <> Len(Find) Then 'Can we count n of replacements?
        'Wscript.Echo ( (Len(dFileContents) - Len(FileContents)) / (Len(ReplaceWith)-Len(Find)) ) & " replacements."
      End If
    Else
      'Wscript.Echo "Searched string Not In the source file"
    End If
  end if
Next

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'Read text file
function GetFile(FileName)
  If FileName<>"" Then
    Dim FS, FileStream
    Set FS = CreateObject("Scripting.FileSystemObject")
      on error resume Next
      Set FileStream = FS.OpenTextFile(FileName)
      GetFile = FileStream.ReadAll
  End If
End Function

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'Write string As a text file.
function WriteFile(FileName, Contents)
  Dim OutStream, FS

  on error resume Next
  Set FS = CreateObject("Scripting.FileSystemObject")
    Set OutStream = FS.OpenTextFile(FileName, 2, True)
    OutStream.Write Contents
End Function

