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

class ValamaSettings: Settings {

    public ValamaSettings() {
        Object (schema_id: "org.valama.editor");    
    }

    public int window_size_x {
        get { return this.get_int ("window-size-x"); }
        set { this.set_int ("window-size-x", value); }
        default = 950;
    }
    public int window_size_y {
        get { return this.get_int ("window-size-y"); }
        set { this.set_int ("window-size-y", value); }
        default = 700;
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

// vim: set ai ts=4 sts=4 et sw=4
