
// cal.js

(function _init()
 {
    // Confirm module load order
    if (SFW.delay_init("../cal",_init, "calendar"))
       return;

    // Subclass contained iclasses:
    if (!SFW.derive(_cal, "cs_calendar", "calendar") ||
        !SFW.derive(_day, "cs_daytable", "table"))
        return;

    // IClass cs_calendar
    function _cal(base,doc,caller,data)
    {
       SFW.types["calendar"].call(this,base,doc,caller,data);
    }

    _cal.prototype.process_day_click = function(t,did)
    {
       SFW.render_interaction("cs_daytable",this._xmldoc,SFW.stage,this,did);
    };

    _cal.prototype.child_finished = function(cfobj)
    {
       SFW.base.prototype.child_finished.call(this,cfobj);
       this.replot();
    };

    // IClass cs_daytable
    function _day(base,doc,caller,data)
    {
       SFW.types["table"].call(this,base,doc,caller,data);
    }

    _day.prototype.pre_transform = function()
    {
       var xpath = "/resultset/events/event[@edate='" + this.data + "']";
       this.set_table_lines(xpath);
       
       var cal = this._xmldoc.selectSingleNode("/resultset/calendar");
       if (cal)
          cal.setAttribute("view","table");
    };

    _day.prototype.post_transform = function()
    {
       this.clear_table_lines();
       var cal = this._xmldoc.selectSingleNode("/resultset/calendar");
       if (cal)
          cal.removeAttribute("view");
    };

    /**
     * Called just before a rendered interaction is released to the client,
     * allowing the caller a chance for final preparation.
     */
    _day.prototype.child_ready = function(child)
    {
       var button, data = "data" in child ? child.data : null;
       if (data && "button" in data && (button=data.button))
       {
          if (button.getAttribute("data-task")=="cal.srm?add")
          {
             // get day information (the date!)
             // pre-set form field edate
             debugger;
          }
       }
    };

    /**
     * Called when a child interaction is completed, giving the caller a chance to act.
     */
    _day.prototype.child_finished = function(cfobj)
    {
       // Use preserve_result==true to copy rather than move
       // 
       this._caller.update_row(cfobj,true);

       // Use "table" child_finished because it does
       // a few things that would otherwise need to
       // done explicitely here:
       // 1. update the day-view table row
       // 2. replot the day-view table in the host
       // 3. restore the saved scroll position,
       // 4. call SFW.base.prototype.child_finished.call(this,cfobj)
       //    for final object cleanup
       this._baseproto.child_finished.call(this, cfobj);
    };

//    SFW.document_object(_day);

})();
