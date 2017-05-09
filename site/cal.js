
// cal.js

(function _init()
 {
    // Confirm module load order
    if (SFW.delay_init("../cal",_init, "calendar"))
       return;

    // Subclass contained iclasses:
    if (!SFW.derive(_cal_views, "cs_calviews", "calendar") ||
        !SFW.derive(_cal, "cs_calendar", "cs_calviews") ||
        !SFW.derive(_day, "cs_daytable", "table"))
        return;

    window.reportFunc = function()
    {
       var content = document.getElementById("SFW_Content");
       var count = content.children.length;

       var xdoc = document.XMLDocument;
       if (xdoc)
       {
          var str = serialize(xdoc.documentElement);
          alert(str);
       }
       
       return count;
    };

    function _cal_views(base,doc,caller,data)
    {
       SFW.types["calendar"].call(this,base,doc,caller,data);
       this.cur_view = "calendar";
    }

    _cal_views.prototype.pre_transform = function()
    {
       this.xmldocel().setAttribute("cur_view", this.cur_view);
    };

    _cal_views.prototype.post_transform = function()
    {
       this.xmldocel().removeAttribute("cur_view");
    };

    // IClass cs_calendar
    function _cal(base,doc,caller,data)
    {
       SFW.types["cs_calviews"].call(this,base,doc,caller,data);
    }

    _cal.prototype.child_finished = function(cfobj)
    {
       SFW.base.prototype.child_finished.call(this,cfobj);
       this.replot(true);
    };

    // IClass cs_daytable
    function _day(base,doc,caller,data)
    {
       SFW.types["table"].call(this,base,doc,caller,data);
    }

    _day.prototype.date_str = function()
    {
       return this.data().did;
    };

    _day.prototype.get_calendar_element = function()
    {
       return this.data().caldoc.selectSingleNode("/resultset/calendar");
    };

    _day.prototype.pre_transform = function()
    {
       var xpath = "/resultset/events/event[@edate='" + this.date_str() + "']";
       this.set_table_lines(xpath);

       var cal = this.get_calendar_element();
       if (cal)
          cal.setAttribute("view","table");
    };

    _day.prototype.post_transform = function()
    {
       this.clear_table_lines();
       var cal = this.get_calendar_element();
       if (cal)
          cal.removeAttribute("view");
    };

    /**
     * Called just before a rendered interaction is released to the client,
     * allowing the caller a chance for final preparation.
     */
    _day.prototype.child_ready = function(child)
    {
       var button, data = "data" in child ? child.data() : null;
       if (data && "button" in data && (button=data.button))
       {
          if (button.getAttribute("data-task")=="cal.srm?add")
          {
             child.set_field("edate",this.date_str());
          }
       }
    };

    /**
     * Called when a child interaction is completed, giving the caller a chance to act.
     */
    _day.prototype.child_finished = function(cfobj)
    {
       var caller = this.caller();

       // Note second argument to update_row() is set to "true"
       // in order to preserve the content.  It makes and uses a
       // copy of the update record so it's still available for
       // the child_finished() call that follows.
       if (caller)
          caller.update_row(cfobj,true);

       this.baseproto().child_finished.call(this, cfobj);
    };

//    SFW.document_object(_day);

})();
