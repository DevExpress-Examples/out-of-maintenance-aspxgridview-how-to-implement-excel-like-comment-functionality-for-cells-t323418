using System;
using DevExpress.Web;
using System.Collections.Generic;

public partial class _Default : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {
        if (!IsPostBack)
            CommentsStorage.Set(5, "ProductName", "Comment sample");
    }

    protected void ASPxGridView1_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e) {
        if (e.MenuType == GridViewContextMenuType.Rows) {
            e.Items.Clear();
            e.Items.Add("Insert Comment", "InsertComment");
            e.Items.Add("Edit Comment", "EditComment");
            e.Items.Add("Delete Comment", "DeleteComment");
        }
    }

    protected void ASPxGridView1_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e) {
        if (e.VisibleIndex < 0)
            return;
        
        string comment = CommentsStorage.Get(e.KeyValue, e.DataColumn.FieldName);

        if (!string.IsNullOrEmpty(comment)) {
            e.Cell.Attributes["data-comment"] = comment;
            e.Cell.CssClass += " comment";
        }
            
        e.Cell.CssClass += " cellrel";
        e.Cell.Attributes["onmouseover"] = "Cell_OnMouseOver(this);";
        e.Cell.Attributes["oncontextmenu"] = string.Format("Cell_OnContextMenu(this, '{0}', '{1}')", e.DataColumn.FieldName, e.KeyValue);
    }

    protected void ASPxPopupControl1_WindowCallback(object source, PopupWindowCallbackArgs e) {
        string[] parts = e.Parameter.Split(new char[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
        int key = Convert.ToInt32(parts[1]);

        if (parts[0].Equals("APPLY"))
            CommentsStorage.Set(key, parts[2], parts[3]);
        else if (parts[0].Equals("DELETE"))
            CommentsStorage.Delete(key, parts[2]);
    }
}