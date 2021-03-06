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
using Gee;

public class SettingsBox: Paned {
    public Gee.List<GLib.Settings> all_settings { get; private set; }
    public TreeView sections { get; private set; }
    public Map<string, AbstracSettingsBox> sections_contents { get; private set; }
    public Frame content;

    public SettingsBox() {
        var model = new ListStore (2, typeof (Gdk.Pixbuf), typeof (string), null);
        sections = new TreeView.with_model (model);
        sections.insert_column_with_attributes (-1, null, new CellRendererPixbuf(), "pixbuf", 0, null);
        sections.insert_column_with_attributes (-1, _("Sections"), new CellRendererText(), "text", 1, null);

        sections_contents = new HashMap<string, Widget>();
        all_settings = new Gee.LinkedList<GLib.Settings>();

        content = new Frame (null);

        pack1 (sections, true, false);
        pack2 (content, false, false);

        sections.cursor_changed.connect (() => {
            var select = sections.get_selection ();
            TreeModel m;
            TreeIter it;
            if (select.get_selected (out m, out it)) {
                Value v;
                m.get_value (it, 1, out v);
                foreach (Widget c in content.get_children()) {
                    content.remove (c);
                }
                content.add (sections_contents.get ((string) v));
                content.set_label ((string) v);
                content.show_all();
            }
        });
    }

    public void add_section (string icon_name, string label, AbstracSettingsBox content) {
        sections_contents.set (label, content);
        all_settings.add (content.settings);
        content.settings.delay();
        TreeIter it;
        var model = sections.get_model() as ListStore;
        model.append (out it);
        try {
            var img = Gtk.IconTheme.get_default ().load_icon (icon_name, 16, 0);
            model.set (it, 0, img, 1, label, -1);
        } catch (GLib.Error e) {
            debug ("%s\n", e.message);
            model.set (it, 0, null, 1, label, -1);
        }
    }
}
public void ui_settings_dialog() {
    var dlg = new Dialog.with_buttons (_("Preferences"), 
                                          window_main, 
                                          DialogFlags.MODAL,
                                          _("_Discard"),
                                          ResponseType.REJECT,
                                          _("_Cancel"),
                                          ResponseType.CANCEL,
                                          _("_Save"),
                                          ResponseType.OK,
                                          null);
    dlg.set_size_request (500, 500);
    dlg.resizable = true;
    var settings_box = new SettingsBox();
    var content_area = dlg.get_content_area();
    content_area.pack_start (settings_box);
    dlg.response.connect ((response_id) => {
        switch (response_id) {
            case ResponseType.REJECT:
                foreach (GLib.Settings s in settings_box.all_settings) {
                    s.revert();
                    s.apply();
                }
                break;
            case ResponseType.OK:
                foreach (GLib.Settings s in settings_box.all_settings) {
                    s.apply();
                }
                dlg.destroy();
                break;
            default:
                foreach (GLib.Settings s in settings_box.all_settings) {
                    s.revert();
                    s.apply();
                }
                dlg.destroy();
                break;
        }
    });

    settings_box.add_section ("accessories-text-editor", _("Editor"), new EditorSettingsBox());
    dlg.show_all ();
}
