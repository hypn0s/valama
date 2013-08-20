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
        settings = new Settings ("apps.valama");
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

}

// vim: set ai ts=4 sts=4 et sw=4
