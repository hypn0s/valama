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
        Object (schema_id: "org.valama.window");    
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

}

// vim: set ai ts=4 sts=4 et sw=4
