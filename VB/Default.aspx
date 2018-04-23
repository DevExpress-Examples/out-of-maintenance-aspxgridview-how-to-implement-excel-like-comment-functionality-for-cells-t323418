<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>GridViewCommentsWeb</title>
	<style type="text/css">
		.cellrel {
			position: relative;
		}
		.comment:after {
			content: "12";
			position: absolute;
			top: 0;
			right: 0;
			width: 0;
			height: 0;
			display: block;
			border-left: 7px solid transparent;
			border-bottom: 7px solid transparent;
			border-top: 7px solid #f00;
		}
	</style>

	<script type="text/javascript">
		function OnContextMenu(s, e) {
			if (e.objectType == 'row') {
				var commentExists = e.htmlEvent.target.className.indexOf('comment') != -1;
				var commandCell = e.htmlEvent.target.className.indexOf('CommandColumn') != -1 || e.htmlEvent.target.parentElement.className.indexOf('CommandColumn') != -1;
				e.menu.GetItemByName('InsertComment').SetVisible(!commentExists && !commandCell);
				e.menu.GetItemByName('EditComment').SetVisible(commentExists && !commandCell);
				e.menu.GetItemByName('DeleteComment').SetVisible(commentExists && !commandCell);
			}
		}

		function OnContextMenuItemClick(s, e) {
			var popupX = s.currentCell.offsetLeft + s.currentCell.offsetWidth;
			var popupY = s.currentCell.offsetTop;

			switch (e.item.name) {
				case 'InsertComment':
					memo.SetText('');
					popupEditor.ShowAtPos(popupX, popupY);
					break;
				case 'EditComment':
					memo.SetText(s.currentCell.getAttribute('data-comment'));
					popupEditor.ShowAtPos(popupX, popupY);
					break;
				case 'DeleteComment':
					popupEditor.PerformCallback('DELETE|' + s.currentKey + '|' + s.currentColumn);
					s.currentCell.removeAttribute('data-comment');
					s.currentCell.className = s.currentCell.className.replace('comment', '');
					break;
			}

			popupInfo.Hide();
		}

		function OnTextChanged(s, e) {
			popupEditor.PerformCallback('APPLY|' + grid.currentKey + '|' + grid.currentColumn + '|' + s.GetText());
			grid.currentCell.setAttribute('data-comment', s.GetText());
			grid.currentCell.className += ' comment';
		}

		function Cell_OnMouseOver(cell) {
			var comment = cell.getAttribute('data-comment');
			var popupX = cell.offsetLeft + cell.offsetWidth;
			var popupY = cell.offsetTop;

			if (comment && !popupEditor.GetClientVisible()) {
				label.SetText(comment);
				popupInfo.ShowAtPos(popupX, popupY);
			}
			else
				popupInfo.Hide();
		}

		function Cell_OnContextMenu(cell, column, key) {
			grid.currentCell = cell;
			grid.currentColumn = column;
			grid.currentKey = key;
		}
	</script>
</head>
<body>
	<form id="form1" runat="server">
	<div>
		<dx:ASPxGridView ID="ASPxGridView1" runat="server" ClientInstanceName="grid" DataSourceID="AccessDataSource1"
			KeyFieldName="ProductID" AutoGenerateColumns="False" OnFillContextMenuItems="ASPxGridView1_FillContextMenuItems"
			OnHtmlDataCellPrepared="ASPxGridView1_HtmlDataCellPrepared">
			<SettingsContextMenu Enabled="True" />
			<ClientSideEvents ContextMenu="OnContextMenu" ContextMenuItemClick="OnContextMenuItemClick" />
			<Columns>
				<dx:GridViewCommandColumn VisibleIndex="0" ShowNewButton="true" ShowEditButton="true"
					ShowDeleteButton="true">
				</dx:GridViewCommandColumn>
				<dx:GridViewDataTextColumn FieldName="ProductID" ReadOnly="True" VisibleIndex="1">
					<EditFormSettings Visible="False" />
				</dx:GridViewDataTextColumn>
				<dx:GridViewDataTextColumn FieldName="ProductName" VisibleIndex="2">
				</dx:GridViewDataTextColumn>
				<dx:GridViewDataTextColumn FieldName="UnitPrice" VisibleIndex="3">
				</dx:GridViewDataTextColumn>
				<dx:GridViewDataTextColumn FieldName="UnitsOnOrder" VisibleIndex="4">
				</dx:GridViewDataTextColumn>
			</Columns>
		</dx:ASPxGridView>
		<dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" ClientInstanceName="popupEditor" PopupAnimationType="Fade" CloseAnimationType="Fade"
			CloseAction="OuterMouseClick" OnWindowCallback="ASPxPopupControl1_WindowCallback" ShowHeader="false">
			<ContentStyle Paddings-Padding="0px" />
			<ContentCollection>
				<dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True">
					<dx:ASPxMemo ID="ASPxMemo1" runat="server" ClientInstanceName="memo" Width="100%" Height="100" Border-BorderStyle="None">
						<ClientSideEvents TextChanged="OnTextChanged" />
					</dx:ASPxMemo>
				</dx:PopupControlContentControl>
			</ContentCollection>
		</dx:ASPxPopupControl>
		<dx:ASPxPopupControl ID="ASPxPopupControl2" runat="server" ClientInstanceName="popupInfo" PopupAnimationType="None" CloseAnimationType="None"
			CloseAction="OuterMouseClick" ShowHeader="false" Width="70px" >
			<ContentStyle Paddings-Padding="0px" />
			<ContentCollection>
				<dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server" SupportsDisabledAttribute="True">
					<dx:ASPxLabel ID="ASPxLabel1" runat="server" ClientInstanceName="label" Width="100%" BackColor="Yellow" />
				</dx:PopupControlContentControl>
			</ContentCollection>
		</dx:ASPxPopupControl>
		<asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/App_Data/nwind.mdb"
			SelectCommand="SELECT [ProductID], [ProductName], [UnitPrice], [UnitsOnOrder] FROM [Products]"
			DeleteCommand="DELETE FROM [Products] WHERE [ProductID] = ?" InsertCommand="INSERT INTO [Products] ([ProductName], [UnitPrice], [UnitsOnOrder]) VALUES (?, ?, ?)"
			UpdateCommand="UPDATE [Products] SET [ProductName] = ?, [UnitPrice] = ?, [UnitsOnOrder] = ? WHERE [ProductID] = ?">
			<DeleteParameters>
				<asp:Parameter Name="ProductID" Type="Int32" />
			</DeleteParameters>
			<InsertParameters>
				<asp:Parameter Name="ProductName" Type="String" />
				<asp:Parameter Name="UnitPrice" Type="Decimal" />
				<asp:Parameter Name="UnitsOnOrder" Type="Int16" />
			</InsertParameters>
			<UpdateParameters>
				<asp:Parameter Name="ProductName" Type="String" />
				<asp:Parameter Name="UnitPrice" Type="Decimal" />
				<asp:Parameter Name="UnitsOnOrder" Type="Int16" />
				<asp:Parameter Name="ProductID" Type="Int32" />
			</UpdateParameters>
		</asp:AccessDataSource>
	</div>
	</form>
</body>
</html>