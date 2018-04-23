Imports System
Imports System.Web
Imports System.Collections.Generic

Public NotInheritable Class CommentsStorage

	Private Sub New()
	End Sub

	Private Shared ReadOnly Property Comments() As Dictionary(Of Tuple(Of Object, String), String)
		Get
			If HttpContext.Current.Session("CommentsStorage") Is Nothing Then
				HttpContext.Current.Session("CommentsStorage") = New Dictionary(Of Tuple(Of Object, String), String)()
			End If
			Return TryCast(HttpContext.Current.Session("CommentsStorage"), Dictionary(Of Tuple(Of Object, String), String))
		End Get
	End Property

	Private Shared Function CommentExists(ByVal key As Object, ByVal columnName As String) As Boolean
		Dim tkey = New Tuple(Of Object, String)(key, columnName)

		If Not Comments.ContainsKey(tkey) Then
			Return False
		End If

		Return Comments(tkey) IsNot Nothing
	End Function

	Public Shared Sub [Set](ByVal key As Object, ByVal columnName As String, ByVal comment As String)
		Comments(New Tuple(Of Object, String)(key, columnName)) = comment
	End Sub

	Public Shared Function [Get](ByVal key As Object, ByVal columnName As String) As String
		If CommentExists(key, columnName) Then
			Return Comments(New Tuple(Of Object, String)(key, columnName))
		Else
			Return Nothing
		End If
	End Function

	Public Shared Sub Delete(ByVal key As Object, ByVal columnName As String)
		Comments.Remove(New Tuple(Of Object, String)(key, columnName))
	End Sub
End Class