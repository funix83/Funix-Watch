import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.Sensor;

class Battery extends WatchUi.Drawable
{
    hidden var batteryLevel;

    // pass location as locX, locY params
    function initialize(options) {
        Drawable.initialize(options);
    }

    function setLevel(percentage) {
        batteryLevel = percentage;
    }

    function draw(dc) {
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_LT_GRAY);
        dc.drawRectangle(locX, locY, width, height);
        dc.fillRectangle(locX+2,locY+2,(width-4)*batteryLevel/100,height-4);
    }
}

class FunixWatch_wordView extends WatchUi.WatchFace {

    //variables pour l'heure
    var clockTime;
    var timeString;
    var viewheure;
    var secondString;
    var viewSecond;
    //variables date
    var today;
    var dateString;
    var viewdate;
    //variables pourcentage batterie
    var mystats;
    var batString;
    var viewbat;
    //variables jauge batterie
    var batteryLevel;
    var viewbatbar;
    //variables heartbeat
    var coeurbat;
    var coeurbatString;
    var viewcoeur;
    //variables pas
    var pas;
    var pasString;
    var viewpas;
    //variables éphéméride
    var loc;
    var lever_moment;
    var coucher_moment;
    var lever;
    var coucher;
    var sunInfoString;
    var viewEphemeride;
    //position par défaut (Toulon)
    var myLocation = new Position.Location(
  	{
        	:latitude => 43.1257311,
        	:longitude => 5.9304919,
        	:format => :degrees
    });

    function initialize() {
        WatchFace.initialize();
        // affichage logo Funix
        var FunixLogo = new WatchUi.Bitmap({:rezId=>Rez.Drawables.FunixLogo});
        // affichage logo coeur
        var Coeur = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Coeur});
        // affichage logo pas
        var Pas = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Pas});
        // affichage sunrise sunset
		var Sunrise = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Sunrise});
        var Sunset = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Sunset});
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        //var myfont = Toybox.WatchUi.loadResource(Rez.Fonts.FONTdejavu5);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    //update les secondes toutes les secondes
    function onPartialUpdate(dc) {
        // affichage de l'heure
        clockTime = System.getClockTime();
        dc.setClip(119,72,40,40);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawText(
				119,
				75,
				Graphics.FONT_SYSTEM_NUMBER_MEDIUM,
                clockTime.sec.format("%02d"),
				Graphics.TEXT_JUSTIFY_LEFT
			);
        dc.clearClip();
    }
    // Update the view
    function onUpdate(dc as Dc) as Void {
        // affichage de l'heure
        clockTime = System.getClockTime();
        timeString = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        viewheure = View.findDrawableById("TimeLabel") as Text;
        viewheure.setText(timeString);
        // affichage des secondes
        secondString = Lang.format("$1$", [clockTime.sec.format("%02d")]);
        viewSecond = View.findDrawableById("SecondLabel") as Text;
        viewSecond.setText(secondString);
        // affichage de la date
        today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        dateString = Lang.format("$1$ $2$ $3$", [today.day, today.month, today.year]);
        viewdate = View.findDrawableById("DateDisplay") as Text;
        viewdate.setText(dateString);
        // affichage de la batterie
        mystats = System.getSystemStats();
        batString = Lang.format("$1$j", [mystats.batteryInDays.format("%2d")]);
        viewbat = View.findDrawableById("BatteryDisplay") as Text;
        viewbat.setText(batString);
        // affichage de la gauge batterie
        batteryLevel = System.getSystemStats().battery;
        viewbatbar = View.findDrawableById("batterie") as Battery;
        viewbatbar.setLevel(batteryLevel); 
        // affichage hearbeat
        coeurbat = Activity.getActivityInfo().currentHeartRate;
        if (coeurbat == null)
        {
            coeurbat ="0";
        }
        coeurbatString = coeurbat.toString();
        viewcoeur = View.findDrawableById("HeartBeat") as Text;
        viewcoeur.setText(coeurbatString);
        // affichage pas
        pas = ActivityMonitor.getInfo().steps;
        if (pas == null)
        {
            pas = "0";
        }
        pasString = pas.toString();
        viewpas = View.findDrawableById("Pas") as Text;
        viewpas.setText(pasString);
        // affichage éphéméride
        var loc = Toybox.Activity.getActivityInfo().currentLocation;
        if (loc == null)
        {
            loc = myLocation;
        }
        lever_moment = Toybox.Weather.getSunrise(loc,Time.now());
        coucher_moment = Toybox.Weather.getSunset(loc,Time.now());
        lever = Gregorian.info(lever_moment, Time.FORMAT_MEDIUM);
        coucher = Gregorian.info(coucher_moment, Time.FORMAT_MEDIUM);
        sunInfoString = Lang.format("   $1$:$2$     $3$:$4$", [lever.hour.format("%02d"), lever.min.format("%02d"), coucher.hour.format("%02d"), coucher.min.format("%02d")]);       
        viewEphemeride = View.findDrawableById("Ephemeride") as Text;
        viewEphemeride.setText(sunInfoString);
     
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}