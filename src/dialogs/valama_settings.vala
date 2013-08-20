/*
 * src/dialogs/valama_settings.vala
 * Copyright (C) 2013, Valama development team
 *
 * Valama is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Valama is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
 
using GLib;
using Gtk;
 
public void ui_settings_dialog () {
    string last_scheme = settings.color_scheme;

    var dlg = new Dialog.with_buttons (_("Global settings"), 
                                          window_main, 
                                          DialogFlags.MODAL,
                                          Stock.CANCEL,
                                          ResponseType.CANCEL,
                                          Stock.SAVE,
                                          ResponseType.OK,
                                          null);
    dlg.set_size_request (420, 200);
    dlg.resizable = false;

    var box = dlg.get_content_area();
    box.set_orientation (Orientation.VERTICAL);
    var list = new ListStore (1, typeof (string), null);
    TreeIter iter;
    TreePath path = null;
    foreach (string id in style_manager.get_scheme_ids()) {
        list.append (out iter);
        list.set (iter, 0, id, -1);
        if (id == settings.color_scheme) {
            path = list.get_path (iter);
        }
    }
    var list_view = new TreeView.with_model (list);
    list_view.insert_column_with_attributes (-1, _("Color scheme"), new CellRendererText (), "text", 0, null);
    if (path != null) {
        list_view.set_cursor (path, null, false);
    }
    list_view.cursor_changed.connect (() => {
        var select = list_view.get_selection ();
        TreeModel m;
        TreeIter it;
        if (select.get_selected (out m, out it)) {
            Value v;
            m.get_value (it, 0, out v);
            settings.color_scheme = (string) v;
        }
    });

    dlg.response.connect ((response_id) => {
        switch (response_id) {
            case ResponseType.OK:
                dlg.destroy();
                break;
            default:
                settings.color_scheme = last_scheme;
                dlg.destroy();
                break;
        }
    });
    box.pack_start (list_view);
    dlg.show_all ();
}
