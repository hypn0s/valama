/*
 * src/dialogs/settings/editor_settings.vala
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

public class EditorSettings: GLib.Settings {
    public EditorSettings() {
        Object (schema_id: "org.valama.editor");    
    }

    public string color_scheme {
        owned get { return this.get_string ("color-scheme"); }
        set { this.set_string ("color-scheme", value); }
        default = "classic";
    }
    public string font {
        owned get { return this.get_string ("font"); }
        set { this.set_string ("font", value); }
        default = "monospace 11";
    }
    public bool show_line_numbers {
        get { return this.get_boolean ("show-line-numbers"); }
        set { this.set_boolean ("show-line-numbers", value); }
        default = true;
    }
    public bool use_spaces_instead_of_tabs {
        get { return this.get_boolean ("use-spaces-instead-of-tabs"); }
        set { this.set_boolean ("use-spaces-instead-of-tabs", value); }
        default = true;
    }
    public int tab_width {
        get { return this.get_int ("tab-width"); }
        set { this.set_int ("tab-width", value); }
        default = 4;
    }
    public bool highlight_matching_brackets {
        get { return this.get_boolean ("highlight-matching-brackets"); }
        set { this.set_boolean ("highlight-matching-brackets", value); }
        default = true;
    }
    public bool highlight_syntax {
        get { return this.get_boolean ("highlight-syntax"); }
        set { this.set_boolean ("highlight-syntax", value); }
        default = true;
    }
    public bool show_right_margin {
        get { return this.get_boolean ("show-right-margin"); }
        set { this.set_boolean ("show-right-margin", value); }
        default = false;
    }
    public int right_margin_position {
        get { return this.get_int ("right-margin-position"); }
        set { this.set_int ("right-margin-position", value); }
        default = 80;
    }
    public Gtk.SourceDrawSpacesFlags show_spaces {
        get { return (Gtk.SourceDrawSpacesFlags) this.get_flags ("show-spaces"); }
        set { this.set_flags ("show-spaces", value); }
        default = 0;
    }
    public bool auto_indent {
        get { return this.get_boolean ("auto-indent"); }
        set { this.set_boolean ("auto-indent", value); }
        default = true;
    }
}

public class EditorSettingsBox: Box {
    public EditorSettingsBox() {
        this.orientation = Orientation.VERTICAL;
        this.margin = 5;

        var grid = new Grid();
        grid.set_column_spacing (20);
        grid.set_column_homogeneous (false);
        grid.set_row_homogeneous (false);

        var show_line_numbers_switch = new Switch();
        editor_settings.bind ("show-line-numbers", show_line_numbers_switch, "active", SettingsBindFlags.DEFAULT);
        grid.attach (show_line_numbers_switch, 1, 0, 1, 1);
        grid.attach_next_to (new Label (_("Show line numbers")), show_line_numbers_switch, PositionType.LEFT, 1, 1);

        var use_spaces_instead_of_tabs_switch = new Switch();
        editor_settings.bind ("use-spaces-instead-of-tabs", use_spaces_instead_of_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        grid.attach_next_to (use_spaces_instead_of_tabs_switch, show_line_numbers_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Use spaces instead of tabs")), use_spaces_instead_of_tabs_switch, PositionType.LEFT, 1, 1);

        var tab_width_button = new SpinButton.with_range (1.0, 8.0, 1.0);
        editor_settings.bind ("tab-width", tab_width_button, "value", SettingsBindFlags.DEFAULT);
        grid.attach_next_to (tab_width_button, use_spaces_instead_of_tabs_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Tab width")), tab_width_button, PositionType.LEFT, 1, 1);

        var highlight_matching_brackets_switch = new Switch();
        editor_settings.bind ("highlight-matching-brackets", highlight_matching_brackets_switch, "active", SettingsBindFlags.DEFAULT);
        grid.attach_next_to (highlight_matching_brackets_switch, tab_width_button, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Highlight matching brackets")), highlight_matching_brackets_switch, PositionType.LEFT, 1, 1);

        var highlight_syntax_switch = new Switch();
        editor_settings.bind ("highlight-syntax", highlight_syntax_switch, "active", SettingsBindFlags.DEFAULT);
        grid.attach_next_to (highlight_syntax_switch, highlight_matching_brackets_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Highlight the syntax")), highlight_syntax_switch, PositionType.LEFT, 1, 1);

        var show_right_margin_switch = new Switch();
        editor_settings.bind ("show-right-margin", show_right_margin_switch, "active", SettingsBindFlags.DEFAULT);
        grid.attach_next_to (show_right_margin_switch, highlight_syntax_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Show the right margin")), show_right_margin_switch, PositionType.LEFT, 1, 1);

        var right_margin_position_button = new SpinButton.with_range (0.0, 300.0, 1.0);
        editor_settings.bind ("right-margin-position", right_margin_position_button, "value", SettingsBindFlags.DEFAULT);
        grid.attach_next_to (right_margin_position_button, show_right_margin_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Right margin position")), right_margin_position_button, PositionType.LEFT, 1, 1);

        // Show different spaces character
        var show_spaces_switch = new Switch();
        show_spaces_switch.set_active ((editor_settings.show_spaces & SourceDrawSpacesFlags.SPACE) != 0);
        show_spaces_switch.notify["active"].connect (() => {
            editor_settings.show_spaces ^= SourceDrawSpacesFlags.SPACE;
        });
        var lbl = new Label (_("Show spaces"));
        grid.attach_next_to (lbl, show_line_numbers_switch, PositionType.RIGHT, 1, 1);
        grid.attach_next_to (show_spaces_switch, lbl, PositionType.RIGHT, 1, 1);

        var show_tabs_switch = new Switch();
        show_tabs_switch.set_active ((editor_settings.show_spaces & SourceDrawSpacesFlags.TAB) != 0);
        show_tabs_switch.notify["active"].connect (() => {
            editor_settings.show_spaces ^= SourceDrawSpacesFlags.TAB;
        });
        grid.attach_next_to (show_tabs_switch, show_spaces_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Show tabs")), show_tabs_switch, PositionType.LEFT, 1, 1);

        var show_newline_switch = new Switch();
        show_newline_switch.set_active ((editor_settings.show_spaces & SourceDrawSpacesFlags.NEWLINE) != 0);
        show_newline_switch.notify["active"].connect (() => {
            editor_settings.show_spaces ^= SourceDrawSpacesFlags.NEWLINE;
        });
        grid.attach_next_to (show_newline_switch, show_tabs_switch, PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (new Label (_("Show newline")), show_newline_switch, PositionType.LEFT, 1, 1);

        editor_settings.changed.connect ( (key) => {
            if (key == "show_spaces") {
                show_spaces_switch.set_active ((editor_settings.show_spaces & SourceDrawSpacesFlags.SPACE) == SourceDrawSpacesFlags.SPACE);
                show_tabs_switch.set_active ((editor_settings.show_spaces & SourceDrawSpacesFlags.TAB) == SourceDrawSpacesFlags.TAB);
                show_newline_switch.set_active ((editor_settings.show_spaces & SourceDrawSpacesFlags.NEWLINE) == SourceDrawSpacesFlags.NEWLINE);
            }
        });

        foreach (Widget w in grid.get_children()) {
            w.set_halign (Align.START);
        }

        this.pack_start (grid, false, false);

        var list = new ListStore (2, typeof (string), typeof (string), null);
        TreeIter iter;
        TreePath path = null;
        foreach (string id in style_manager.get_scheme_ids()) {
            list.append (out iter);
            Gtk.SourceStyleScheme style = style_manager.get_scheme (id);
            list.set (iter, 0, id, 1, style.description, -1);
            if (id == editor_settings.color_scheme) {
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
                editor_settings.color_scheme = (string) v;
            }
        });
        var schema_scroll = new ScrolledWindow (null, null);
        schema_scroll.add (list_view);
        this.pack_start (schema_scroll);

        var font_button = new FontButton.with_font (editor_settings.font);
        font_button.set_filter_func ( (family, face) => {
            return family.is_monospace();
        });
        this.pack_start (font_button, false, false);
        editor_settings.bind ("font", font_button, "font_name", SettingsBindFlags.DEFAULT);
    }
}
