<!-- default file list -->
*Files to look at*:

* [CommentsStorage.cs](./CS/App_Code/CommentsStorage.cs) (VB: [CommentsStorage.vb](./VB/App_Code/CommentsStorage.vb))
* [Default.aspx](./CS/Default.aspx) (VB: [Default.aspx](./VB/Default.aspx))
* [Default.aspx.cs](./CS/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))
<!-- default file list end -->
# ASPxGridView - How to implement Excel-like comment functionality for cells
<!-- run online -->
**[[Run Online]](https://codecentral.devexpress.com/t323418/)**
<!-- run online end -->


<p>This example illustrates how to provide an end-user with the capability to assign comments to different cells (this is similar to the Excel-based feature: <a href="https://support.office.com/en-au/article/Annotate-a-worksheet-by-using-comments-3b7065dd-531a-4ffe-8f18-8d047a6ccae7">Annotate a worksheet by using comments</a>). Here are implementation details:</p>
<br>All comments as stored in the dictionary:<br>


```cs
public static class CommentsStorage {
    private static Dictionary<Tuple<object, string>, string> Comments
...
```


<p>The first parameter (Tuple) is a compound key value that consists of a row key and column name. The second parameter is a comment text. Although in the current implementation all values are stored in the Session variable, you can easily modify the <strong>CommentsStorage</strong> class method to store them in the database if necessary.<br><br>As for the ASPxGridView-specific implementation part, we handle the <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxGridView_HtmlDataCellPreparedtopic">ASPxGridView.HtmlDataCellPrepared</a> event to assign the required attributes, CSS styles and client-side event handlers (onmouseover, oncontextmenu) to cells. We customize the <a href="https://documentation.devexpress.com/#AspNet/CustomDocument17125">Context Menu</a> for rows to display the Insert/Edit/Delete commands for end-users, so that they can modify comments at runtime. Finally, we use two <a href="https://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxPopupControltopic">ASPxPopupControl</a> instances to display and edit comments correspondingly.</p>

<br/>


