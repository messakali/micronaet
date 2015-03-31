<%@LANGUAGE="VBSCRIPT"%>
<!--#include virtual="/labnaet/Connections/SQLDocnaet.asp" -->
<%
' *** Edit Operations: declare variables

MM_editAction = CStr(Request("URL"))
If (Request.QueryString <> "") Then
  MM_editAction = MM_editAction & "?" & Request.QueryString
End If

' boolean to abort record edit
MM_abortEdit = false

' query string to execute
MM_editQuery = ""
%>
<%
' *** Update Record: set variables

If (CStr(Request("MM_update")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  MM_editConnection = MM_SQLDocnaet_STRING
  MM_editTable = "Nazioni"
  MM_editColumn = "ID_nazione"
  MM_recordId = "" + Request.Form("MM_recordId") + ""
  MM_editRedirectUrl = "nconferma.asp"
  MM_fieldsStr  = "txtDescrizione|value|txtNote|value"
  MM_columnsStr = "nazDescrizione|',none,''|nazNote|',none,''"

  ' create the MM_fields and MM_columns arrays
  MM_fields = Split(MM_fieldsStr, "|")
  MM_columns = Split(MM_columnsStr, "|")
  
  ' set the form values
  For i = LBound(MM_fields) To UBound(MM_fields) Step 2
    MM_fields(i+1) = CStr(Request.Form(MM_fields(i)))
  Next

  ' append the query string to the redirect URL
  If (MM_editRedirectUrl <> "" And Request.QueryString <> "") Then
    If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0 And Request.QueryString <> "") Then
      MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
    Else
      MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
    End If
  End If

End If
%>
<%
' *** Update Record: construct a sql update statement and execute it

If (CStr(Request("MM_update")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  ' create the sql update statement
  MM_editQuery = "update " & MM_editTable & " set "
  For i = LBound(MM_fields) To UBound(MM_fields) Step 2
    FormVal = MM_fields(i+1)
    MM_typeArray = Split(MM_columns(i+1),",")
    Delim = MM_typeArray(0)
    If (Delim = "none") Then Delim = ""
    AltVal = MM_typeArray(1)
    If (AltVal = "none") Then AltVal = ""
    EmptyVal = MM_typeArray(2)
    If (EmptyVal = "none") Then EmptyVal = ""
    If (FormVal = "") Then
      FormVal = EmptyVal
    Else
      If (AltVal <> "") Then
        FormVal = AltVal
      ElseIf (Delim = "'") Then  ' escape quotes
        FormVal = "'" & Replace(FormVal,"'","''") & "'"
      Else
        FormVal = Delim + FormVal + Delim
      End If
    End If
    If (i <> LBound(MM_fields)) Then
      MM_editQuery = MM_editQuery & ","
    End If
    MM_editQuery = MM_editQuery & MM_columns(i) & " = " & FormVal
  Next
  MM_editQuery = MM_editQuery & " where " & MM_editColumn & " = " & MM_recordId

  If (Not MM_abortEdit) Then
    ' execute the update
    Set MM_editCmd = Server.CreateObject("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_editConnection
    MM_editCmd.CommandText = MM_editQuery
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close

    If (MM_editRedirectUrl <> "") Then
      Response.Redirect(MM_editRedirectUrl)
    End If
  End If

End If
%>
<%
Dim Nazioni__MMColParam
Nazioni__MMColParam = "1"
if (Request.QueryString("ID_nazione") <> "") then Nazioni__MMColParam = Request.QueryString("ID_nazione")
%>
<%
set Nazioni = Server.CreateObject("ADODB.Recordset")
Nazioni.ActiveConnection = MM_SQLDocnaet_STRING
Nazioni.Source = "SELECT * FROM Nazioni WHERE ID_nazione = " + Replace(Nazioni__MMColParam, "'", "''") + ""
Nazioni.CursorType = 0
Nazioni.CursorLocation = 2
Nazioni.LockType = 3
Nazioni.Open()
Nazioni_numRows = 0
%>
<html>
<head>
<title>Inserimento lingua</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function goToURL(indirizzo) { //v3.0
  eval("document.location='"+indirizzo+"'");
}

function validateForm(Oggetto) { //v4.0
    if (!Oggetto.value) 
	{
	   alert ('Inserire necessariamente il nome della nazione!');
	   return false;
    }
	else 
	{
	   return true;
	}
}
//-->
</script>
</head>
<style type="text/css">
<!--
@import url(/labnaet/stili/homepage.css);
-->
</style>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="1" topmargin="10">
<form ACTION="<%=MM_editAction%>" METHOD="POST" name="frmInserimento">
   <div align="center">
    <table width="28%" border="0" bgcolor="#CCCCCC">
      <tr>
        <td align="center"> <b><font color="#009933">Modifica Nazioni</font></b> 
        </td>
    </tr>
  </table> </div> <br> <table width="28%" border="0" align="center">
    <tr> 
      <td width="23%" bgcolor="#FFFFCC">Nazioni:</td>
      <td width="77%" bgcolor="#CEEDFD"> 
        <input value="<%=(Nazioni.Fields.Item("nazDescrizione").Value)%>" type="text" name="txtDescrizione">
        <input type="hidden" name="hiddenField" value="<%=(Nazioni.Fields.Item("ID_nazione").Value)%>">
      </td>
    </tr>
    <tr> 
      <td width="23%" bgcolor="#FFFFCC">Note:</td>
      <td width="77%" bgcolor="#CEEDFD"> 
        <input value="<%=(Nazioni.Fields.Item("nazNote").Value)%>" type="text" name="txtNote">
      </td>
    </tr>
  </table>
  <div align="center"><br>
  </div>
  <table width="28%" border="0" align="center" bgcolor="#CCCCCC">
    <tr bgcolor="#CCCCCC"> 
      <td align="center"> 
        <input type="submit" name="Submit" value="Aggiorna" onClick="return validateForm(txtDescrizione);">
      </td>
      <td align="center"> 
        <input type="reset" name="Submit2" value="Ripresenta">
      </td>
      <td align="center"> 
        <input type="button" name="Submit3" value="Annulla" onClick="goToURL('nazioni.asp');return false">
      </td>
    </tr>
  </table>
  <input type="hidden" name="MM_update" value="true">
  <input type="hidden" name="MM_recordId" value="<%= Nazioni.Fields.Item("ID_nazione").Value %>">
</form>
</body>
</html>
<%
Nazioni.Close()
%>

