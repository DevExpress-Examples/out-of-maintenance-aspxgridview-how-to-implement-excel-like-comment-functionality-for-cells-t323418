using System;
using System.Web;
using System.Collections.Generic;

public static class CommentsStorage {
    private static Dictionary<Tuple<object, string>, string> Comments {
        get {
            if (HttpContext.Current.Session["CommentsStorage"] == null)
                HttpContext.Current.Session["CommentsStorage"] = new Dictionary<Tuple<object, string>, string>();
            return HttpContext.Current.Session["CommentsStorage"] as Dictionary<Tuple<object, string>, string>;
        }
    }

    private static bool CommentExists(object key, string columnName) {
        var tkey = new Tuple<object, string>(key, columnName);

        if (!Comments.ContainsKey(tkey))
            return false;

        return Comments[tkey] != null;
    }

    public static void Set(object key, string columnName, string comment) {
        Comments[new Tuple<object, string>(key, columnName)] = comment;
    }

    public static string Get(object key, string columnName) {
        if (CommentExists(key, columnName))
            return Comments[new Tuple<object, string>(key, columnName)];
        else
            return null;
    }

    public static void Delete(object key, string columnName) {
        Comments.Remove(new Tuple<object, string>(key, columnName));
    }
}