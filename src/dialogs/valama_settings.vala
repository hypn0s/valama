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
    public TreeView sections { get; private set; }
    public Map<string, Widget> sections_contents { get; private set; }
    public Frame content;

    public SettingsBox() {
        var model = new ListStore (2, typeof (Gdk.Pixbuf), typeof (string), null);
        sections = new TreeView.with_model (model);
        sections.insert_column_with_attributes (-1, null, new CellRendererPixbuf(), "pixbuf", 0, null);
        sections.insert_column_with_attributes (-1, _("Sections"), new CellRendererText(), "text", 1, null);

        sections_contents = new HashMap<string, Widget>();

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

    public void add_section (string icon_name, string label, Widget content) {
        sections_contents.set (label, content);
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
    settings.delay();

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
    var box = new Box (Orientation.VERTICAL, 10);
    box.margin = 5;

    var grid = new Grid();
    grid.set_column_spacing (20);
    grid.set_column_homogeneous (false);
    grid.set_row_homogeneous (false);

    var show_line_numbers_switch = new Switch();
    settings.bind ("show-line-numbers", show_line_numbers_switch, "active", SettingsBindFlags.DEFAULT);
    grid.attach (show_line_numbers_switch, 1, 0, 1, 1);
    grid.attach_next_to (new Label (_("Show line numbers")), show_line_numbers_switch, PositionType.LEFT, 1, 1);

    var use_spaces_instead_of_tabs_switch = new Switch();
    settings.bind ("use-spaces-instead-of-tabs", use_spaces_instead_of_tabs_switch, "active", SettingsBindFlags.DEFAULT);
    grid.attach_next_to (use_spaces_instead_of_tabs_switch, show_line_numbers_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Use spaces instead of tabs")), use_spaces_instead_of_tabs_switch, PositionType.LEFT, 1, 1);

    var tab_width_button = new SpinButton.with_range (1.0, 8.0, 1.0);
    settings.bind ("tab-width", tab_width_button, "value", SettingsBindFlags.DEFAULT);
    grid.attach_next_to (tab_width_button, use_spaces_instead_of_tabs_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Tab width")), tab_width_button, PositionType.LEFT, 1, 1);

    var highlight_matching_brackets_switch = new Switch();
    settings.bind ("highlight-matching-brackets", highlight_matching_brackets_switch, "active", SettingsBindFlags.DEFAULT);
    grid.attach_next_to (highlight_matching_brackets_switch, tab_width_button, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Highlight matching brackets")), highlight_matching_brackets_switch, PositionType.LEFT, 1, 1);

    var highlight_syntax_switch = new Switch();
    settings.bind ("highlight-syntax", highlight_syntax_switch, "active", SettingsBindFlags.DEFAULT);
    grid.attach_next_to (highlight_syntax_switch, highlight_matching_brackets_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Highlight the syntax")), highlight_syntax_switch, PositionType.LEFT, 1, 1);

    var show_right_margin_switch = new Switch();
    settings.bind ("show-right-margin", show_right_margin_switch, "active", SettingsBindFlags.DEFAULT);
    grid.attach_next_to (show_right_margin_switch, highlight_syntax_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Show the right margin")), show_right_margin_switch, PositionType.LEFT, 1, 1);

    var right_margin_position_button = new SpinButton.with_range (0.0, 300.0, 1.0);
    settings.bind ("right-margin-position", right_margin_position_button, "value", SettingsBindFlags.DEFAULT);
    grid.attach_next_to (right_margin_position_button, show_right_margin_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Right margin position")), right_margin_position_button, PositionType.LEFT, 1, 1);

    // Show different spaces character
    var show_spaces_switch = new Switch();
    show_spaces_switch.set_active ((settings.show_spaces & SourceDrawSpacesFlags.SPACE) != 0);
    show_spaces_switch.notify["active"].connect (() => {
        settings.show_spaces ^= SourceDrawSpacesFlags.SPACE;
    });
    var lbl = new Label (_("Show spaces"));
    grid.attach_next_to (lbl, show_line_numbers_switch, PositionType.RIGHT, 1, 1);
    grid.attach_next_to (show_spaces_switch, lbl, PositionType.RIGHT, 1, 1);

    var show_tabs_switch = new Switch();
    show_tabs_switch.set_active ((settings.show_spaces & SourceDrawSpacesFlags.TAB) != 0);
    show_tabs_switch.notify["active"].connect (() => {
        settings.show_spaces ^= SourceDrawSpacesFlags.TAB;
    });
    grid.attach_next_to (show_tabs_switch, show_spaces_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Show tabs")), show_tabs_switch, PositionType.LEFT, 1, 1);

    var show_newline_switch = new Switch();
    show_newline_switch.set_active ((settings.show_spaces & SourceDrawSpacesFlags.NEWLINE) != 0);
    show_newline_switch.notify["active"].connect (() => {
        settings.show_spaces ^= SourceDrawSpacesFlags.NEWLINE;
    });
    grid.attach_next_to (show_newline_switch, show_tabs_switch, PositionType.BOTTOM, 1, 1);
    grid.attach_next_to (new Label (_("Show newline")), show_newline_switch, PositionType.LEFT, 1, 1);

    settings.changed.connect ( (key) => {
        if (key == "show_spaces") {
            show_spaces_switch.set_active ((settings.show_spaces & SourceDrawSpacesFlags.SPACE) == SourceDrawSpacesFlags.SPACE);
            show_tabs_switch.set_active ((settings.show_spaces & SourceDrawSpacesFlags.TAB) == SourceDrawSpacesFlags.TAB);
            show_newline_switch.set_active ((settings.show_spaces & SourceDrawSpacesFlags.NEWLINE) == SourceDrawSpacesFlags.NEWLINE);
        }
    });

    foreach (Widget w in grid.get_children()) {
        w.set_halign (Align.START);
    }

    box.pack_start (grid, false, false);

    var list = new ListStore (2, typeof (string), typeof (string), null);
    TreeIter iter;
    TreePath path = null;
    foreach (string id in style_manager.get_scheme_ids()) {
        list.append (out iter);
        Gtk.SourceStyleScheme style = style_manager.get_scheme (id);
        list.set (iter, 0, id, 1, style.description, -1);
        if (id == settings.color_scheme) {
            path = list.get_path (iter);
        }
    }
    var list_view = new TreeView.with_model (list);
    list_view.insert_column_with_attributes (-1, _("Color scheme"), new CellRendererText(), "text", 0, null);
    list_view.insert_column_with_attributes (-1, _("Description"), new CellRendererText(), "text", 1, null);
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
    var schema_scroll = new ScrolledWindow (null, null);
    schema_scroll.add (list_view);
    box.pack_start (schema_scroll);

    var font_button = new FontButton.with_font (settings.font);
    font_button.set_filter_func ( (family, face) => {
        return family.is_monospace();
    });
    box.pack_start (font_button, false, false);
    settings.bind ("font", font_button, "font_name", SettingsBindFlags.DEFAULT);
    dlg.response.connect ((response_id) => {
        switch (response_id) {
            case ResponseType.REJECT:
                settings.revert();
                break;
            case ResponseType.OK:
                settings.apply();
                dlg.destroy();
                break;
            default:
                settings.revert();
                settings.apply();
                dlg.destroy();
                break;
        }
    });

    settings_box.add_section ("accessories-text-editor", _("Editor"), box);
    dlg.show_all ();
}
