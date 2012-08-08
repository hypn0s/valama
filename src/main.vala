using Gtk;
using Vala;
using GLib;

static Window window_main;

static valama_project project;
static SourceView view;
static Label lbl_result;

public static void main(string[] args){
    Gtk.init(ref args);

    string sourcedir = Environment.get_current_dir();
    if (args.length > 1)
        sourcedir = args[1];

    project = new valama_project(sourcedir);

    /*project.guanako_project.add_package ("gobject-2.0");
    project.guanako_project.add_package ("glib-2.0");
    project.guanako_project.add_package ("gio-2.0");
    project.guanako_project.add_package ("libxml-2.0");
    project.guanako_project.add_package ("gee-1.0");
    project.guanako_project.add_package ("gmodule-2.0");
    project.guanako_project.add_package ("gdk-3.0");
    project.guanako_project.add_package ("gtk+-3.0");
    project.guanako_project.add_package ("clutter-1.0");
    project.guanako_project.add_package ("clutter-gtk-1.0");*/



    window_main = new Window();



    view = new SourceView();
    view.show_line_numbers = true;
    var bfr = (SourceBuffer)view.buffer;
    bfr.set_highlight_syntax(true);
    view.insert_spaces_instead_of_tabs = true;
    
    TestProvider tp = new TestProvider ();
    tp.priority = 1;
    tp.name = "Test Provider 1";

    view.completion.add_provider (tp);

    view.buffer.changed.connect(on_view_buffer_changed);

    var langman = new SourceLanguageManager();
    var lang = langman.get_language("vala");
    bfr.set_language(lang);

    var vbox_main = new VBox(false, 0);

    var toolbar = new Toolbar();
    vbox_main.pack_start(toolbar, false, true);
    
    var btnSave = new ToolButton.from_stock(Stock.SAVE);
    toolbar.add(btnSave);
    btnSave.clicked.connect(write_current_source_file);
    
    var btnBuild = new Gtk.ToolButton.from_stock(Stock.EXECUTE);
    btnBuild.clicked.connect(()=>{
        lbl_result.label = project.build();
    });
    toolbar.add(btnBuild);

        var hbox = new HBox(false, 0);

        var pbrw = new project_browser(project);
        hbox.pack_start(pbrw.widget, false, true);
        pbrw.source_file_selected.connect(on_source_file_selected);
        
        var scrw = new ScrolledWindow(null, null);
        scrw.add(view);
        hbox.pack_start(scrw, true, true);

        var scrw2 = new ScrolledWindow(null, null);
        var brw = new symbol_browser(project.guanako_project);
        scrw2.add(brw.widget);
        hbox.pack_start(scrw2, true, true);
    
    vbox_main.pack_start(hbox, true, true);


    lbl_result = new Label("");
    var scrw3 = new ScrolledWindow(null, null);
    scrw3.add_with_viewport(lbl_result);
    scrw3.set_size_request(0, 150);
    vbox_main.pack_start(scrw3, false, true);
    

    window_main.add(vbox_main);

    window_main.set_default_size(700, 600);
    window_main.destroy.connect(Gtk.main_quit);
    window_main.show_all();

    Gtk.main();
}

static SourceFile current_source_file = null;
static void on_source_file_selected(SourceFile file){
    current_source_file = file;
    
    string txt = "";
    FileUtils.get_contents(file.filename, out txt);
    view.buffer.text = txt;
}

void write_current_source_file(){
    var file = File.new_for_path (current_source_file.filename);
    
    // delete if file already exists
    if (file.query_exists ()) {
        file.delete ();
    }
    
    var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
    dos.put_string (view.buffer.text);
    project.guanako_project.update_file(current_source_file);
}

static void on_view_buffer_changed(){
}

class TestProvider : Gtk.SourceCompletionProvider, Object
{
  Gdk.Pixbuf icon;
  public string name;
  public int priority;
  GLib.List<Gtk.SourceCompletionItem> proposals;

  construct
  {
      Gdk.Pixbuf icon = this.get_icon ();

    this.proposals = new GLib.List<Gtk.SourceCompletionItem> ();
      this.proposals.prepend (new Gtk.SourceCompletionItem ("Proposal 3", "Proposal 3", null, null));
      this.proposals.prepend (new Gtk.SourceCompletionItem ("Proposal 2", "Proposal 2", null, null));
      this.proposals.prepend (new Gtk.SourceCompletionItem ("Proposal 1", "Proposal 1", null, null));
  }

  public string get_name ()
  {
      return this.name;
  }

  public int get_priority ()
  {
      return this.priority;
  }

  public bool match (Gtk.SourceCompletionContext context)
  {
      return true;
  }

  public void populate (Gtk.SourceCompletionContext context)
  {
    var props = new GLib.List<Gtk.SourceCompletionItem> ();

    var mark = view.buffer.get_insert();
    TextIter iter;
    view.buffer.get_iter_at_mark(out iter, mark);
    var line = iter.get_line() + 1;
    var col = iter.get_line_offset();

    TextIter iter_start;
    view.buffer.get_iter_at_line(out iter_start, line - 1);
    var current_line = view.buffer.get_text(iter_start, iter, false);

    string[] splt = current_line.split_set(" .");
    string last = "";
    if (splt.length > 0)
        last = splt[splt.length - 1];

    var proposals = project.guanako_project.propose_symbols(current_source_file, line, col, current_line);
    foreach (Symbol proposal in proposals){
        if (proposal.name != null){
            if (proposal.name.has_prefix(last))
                props.prepend(new Gtk.SourceCompletionItem (proposal.name, proposal.name, null, null));
        }
    }

    context.add_proposals (this, props, true);
  }

  public unowned Gdk.Pixbuf? get_icon ()
  {
      if (this.icon == null)
      {
          Gtk.IconTheme theme = Gtk.IconTheme.get_default ();
          this.icon = theme.load_icon (Gtk.STOCK_DIALOG_INFO, 16, 0);
      }
      return this.icon;
  }

  public bool activate_proposal (Gtk.SourceCompletionProposal proposal,
                                 Gtk.TextIter iter)
  {
    return true;
  }

  public Gtk.SourceCompletionActivation get_activation ()
  {
    return Gtk.SourceCompletionActivation.INTERACTIVE |
              Gtk.SourceCompletionActivation.USER_REQUESTED;
  }

  public unowned Gtk.Widget? get_info_widget (Gtk.SourceCompletionProposal proposal)
  {
    return null;
  }

  public int get_interactive_delay ()
  {
    return -1;
  }

  public bool get_start_iter (Gtk.SourceCompletionContext context,
                              Gtk.SourceCompletionProposal proposal,
                              Gtk.TextIter iter)
  {
    return false;
  }

  public void update_info (Gtk.SourceCompletionProposal proposal, 
                           Gtk.SourceCompletionInfo info)
  {
  }
}