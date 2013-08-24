/*
 * src/settings.vala
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

class ValamaSettings {

    public signal void changed (string key);

    public ValamaSettings() {
        settings = new Settings ("org.valama");
        settings.changed.connect ( (key) => {
            changed (key);
        });
    }
    Settings settings;

    public int window_size_x {
        get { return settings.get_int ("window-size-x"); }
        set { settings.set_int ("window-size-x", value); }
        default = 950;
    }
    public int window_size_y {
        get { return settings.get_int ("window-size-y"); }
        set { settings.set_int ("window-size-y", value); }
        default = 700;
    }
    public string color_scheme {
        owned get { return settings.get_string ("color-scheme"); }
        set { settings.set_string ("color-scheme", value); }
        default = "classic";
    }
    public string font {
        owned get { return settings.get_string ("font"); }
        set { settings.set_string ("font", value); }
        default = "monospace 11";
    }
    public bool show_line_numbers {
        get { return settings.get_boolean ("show-line-numbers"); }
        set { settings.set_boolean ("show-line-numbers", value); }
        default = true;
    }
    public bool use_spaces_instead_of_tabs {
        get { return settings.get_boolean ("use-spaces-instead-of-tabs"); }
        set { settings.set_boolean ("use-spaces-instead-of-tabs", value); }
        default = true;
    }
    public int tab_width {
        get { return settings.get_int ("tab-width"); }
        set { settings.set_int ("tab-width", value); }
        default = 4;
    }
    public bool highlight_matching_brackets {
        get { return settings.get_boolean ("highlight-matching-brackets"); }
        set { settings.set_boolean ("highlight-matching-brackets", value); }
        default = true;
    }
    public bool highlight_syntax {
        get { return settings.get_boolean ("highlight-syntax"); }
        set { settings.set_boolean ("highlight-syntax", value); }
        default = true;
    }
    public bool show_right_margin {
        get { return settings.get_boolean ("show-right-margin"); }
        set { settings.set_boolean ("show-right-margin", value); }
        default = false;
    }
    public int right_margin_position {
        get { return settings.get_int ("right-margin-position"); }
        set { settings.set_int ("right-margin-position", value); }
        default = 80;
    }
    public Gtk.SourceDrawSpacesFlags show_spaces {
        owned get { return (Gtk.SourceDrawSpacesFlags) settings.get_int ("show-spaces"); }
        set { settings.set_int ("show-spaces", value); }
        default = 0;
    }
    public bool auto_indent {
        get { return settings.get_boolean ("auto-indent"); }
        set { settings.set_boolean ("auto-indent", value); }
        default = true;
    }

}

// vim: set ai ts=4 sts=4 et sw=4
