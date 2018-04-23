Imports System
Imports DevExpress.Web
Imports System.Collections.Generic

Partial Public Class _Default
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		If Not IsPostBack Then
			CommentsStorage.Set(5, "ProductName", "Comment sample")
		End If
	End Sub

	Protected Sub ASPxGridView1_FillContextMenuItems(ByVal sender As Object, ByVal e As ASPxGridViewContextMenuEventArgs)
		If e.MenuType = GridViewContextMenuType.Rows Then
			e.Items.Clear()
			e.Items.Add("Insert Comment", "InsertComment")
			e.Items.Add("Edit Comment", "EditComment")
			e.Items.Add("Delete Comment", "DeleteComment")
		End If
	End Sub

	Protected Sub ASPxGridView1_HtmlDataCellPrepared(ByVal sender As Object, ByVal e As ASPxGridViewTableDataCellEventArgs)
		If e.VisibleIndex < 0 Then
			Return
		End If

		Dim comment As String = CommentsStorage.Get(e.KeyValue, e.DataColumn.FieldName)

		If Not String.IsNullOrEmpty(comment) Then
			e.Cell.Attributes("data-comment") = comment
			e.Cell.CssClass &= " comment"
		End If

		e.Cell.CssClass &= " cellrel"
		e.Cell.Attributes("onmouseover") = "Cell_OnMouseOver(this);"
		e.Cell.Attributes("oncontextmenu") = String.Format("Cell_OnContextMenu(this, '{0}', '{1}')", e.DataColumn.FieldName, e.KeyValue)
	End Sub

	Protected Sub ASPxPopupControl1_WindowCallback(ByVal source As Object, ByVal e As PopupWindowCallbackArgs)
		Dim parts() As String = e.Parameter.Split(New Char() { "|"c }, StringSplitOptions.RemoveEmptyEntries)
		Dim key As Integer = Convert.ToInt32(parts(1))

		If parts(0).Equals("APPLY") Then
			CommentsStorage.Set(key, parts(2), parts(3))
		ElseIf parts(0).Equals("DELETE") Then
			CommentsStorage.Delete(key, parts(2))
		End If
	End Sub
End Class