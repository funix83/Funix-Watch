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

/*
// class pour l'affichage d'une jauge de batterie
// sous la forme d'un rectangle qui se remplit
// class for displaying a battery gauge as a rectangle that fills
class Batterie extends WatchUi.Drawable
{
    hidden var batteryLevel;

    // pass location as locX, locY params in layout.xml
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
}*/

class JaugePasBatArc extends WatchUi.Drawable
{
    // Draw Body Battery and Steps arcs
    // librement inspiré du site / freely inspired by the site
    // https://medium.com/@ericbt/design-your-own-garmin-watch-face-21d004d38f99
    var steps;
    var stepGoal;
    
    function initialize(options) {
        Drawable.initialize(options);
    }

    function draw(dc) {
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();
        var ARCLENGTH = 40;
        var ArcWidthBody = 2;
        var ArcWidthFill = 10;
        var nbSteps = ActivityMonitor.getInfo().steps;
        //var ObjSteps = Toybox.ActivityMonitor.getInfo().stepGoal;
        var ObjSteps = 10000;
        var nivbatterie = System.getSystemStats().battery;
        var ratio;
     
        // Dessin du corps de l'arc pour la charge batterie
        // Draw Body Battery Arc
        dc.setPenWidth(ArcWidthBody);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(WIDTH/2+5, HEIGHT/2+20, HEIGHT/2 - ArcWidthBody/2, Graphics.ARC_CLOCKWISE, 180 + ARCLENGTH / 2, 180 - ARCLENGTH / 2);
        dc.drawArc(WIDTH/2+15, HEIGHT/2+20, HEIGHT/2 - ArcWidthBody/2, Graphics.ARC_CLOCKWISE, 180 + ARCLENGTH / 2, 180 - ARCLENGTH / 2);
        dc.drawLine(12,79,22,80);
        dc.drawLine(12,139,22,136);

        // remplissage du corps de l'arc batterie
        // Fill body battery arc
        dc.setPenWidth(ArcWidthFill);
        if (nivbatterie != null) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(WIDTH/2+7, HEIGHT/2+20, HEIGHT/2 - ArcWidthFill/2, Graphics.ARC_CLOCKWISE, 180 + ARCLENGTH/2, 180 + ARCLENGTH/2 - ARCLENGTH * nivbatterie / 100);
        }

        // dessin du corps de l'arc pour le ratio entre le nb de pas et l'objectif des pas
        // Draw Body Steps Arc
        dc.setPenWidth(ArcWidthBody);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(WIDTH/2-5, HEIGHT/2+20, HEIGHT / 2 - ArcWidthBody/2, Graphics.ARC_COUNTER_CLOCKWISE, 0 - ARCLENGTH / 2, 0 + ARCLENGTH / 2);
        dc.drawArc(WIDTH/2-15, HEIGHT/2+20, HEIGHT / 2 - ArcWidthBody/2, Graphics.ARC_COUNTER_CLOCKWISE, 0 - ARCLENGTH / 2, 0 + ARCLENGTH / 2);
        dc.drawLine(156,81,166,79);
        dc.drawLine(156,136,166,140);
        
        // remplissage du corps de l'arc du ratio pas
        // Fill body steps arc
        dc.setPenWidth(ArcWidthFill);
        if (nbSteps != null && nbSteps > 0 && ObjSteps != null) {
            if (nbSteps > ObjSteps) {
                nbSteps = ObjSteps;
            }
            ratio = 1.0 * nbSteps / ObjSteps;
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(WIDTH/2-7, HEIGHT/2+20, HEIGHT / 2 - ArcWidthFill / 2, Graphics.ARC_COUNTER_CLOCKWISE, 0 - ARCLENGTH / 2, 0 - ARCLENGTH / 2 + ARCLENGTH * ratio);
        }
    }
}

class FunixWatchView extends WatchUi.WatchFace
{
    //variables pour l'heure
    var clockTime;
    var hourString;
    var minString;
    var viewHeure;
    var viewMin;
    var secondString;
    var viewSecond;
    var fontSecond=WatchUi.loadResource(Rez.Fonts.DejaVu25);
    //variables date
    var today;
    var dateString;
    var viewDate;
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
    var viewsteps;
    //variables éphéméride
    var loc;
    var lever_moment;
    var coucher_moment;
    var lever;
    var coucher;
    var sunInfoString;
    var viewEphemeride;

    //position par défaut (Toulon)
    //position by default (Toulon city)
    var myLocation = new Position.Location(
  	{
        	:latitude => 43.1257311,
        	:longitude => 5.9304919,
        	:format => :degrees
    });

    function initialize() {
        WatchFace.initialize();
        // affichage logo Funix / display Funix logo
        var FunixLogo = new WatchUi.Bitmap({:rezId=>Rez.Drawables.FunixLogo});
        // affichage logo coeur / display heart logo
        var Coeur = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Coeur});
        // affichage logo pas /display step logo
        var Pas = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Pas});
        // affichage sunrise sunset / display sunrise & sunset logo
		var Sunrise = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Sunrise});
        var Sunset = new WatchUi.Bitmap({:rezId=>Rez.Drawables.Sunset});
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // on met à jour une zone partielle de l'affichage
    // toutes les secondes pour l'affichage des secondes
    // le reste de l'écran est mis à jour toutes les minutes
    // a partial area of ​​the display is updated every second to display the seconds
    // the rest of the screen is updated every minute by onupdate function
    function onPartialUpdate(dc) {
        // affichage des secondes dans un petit carré
        clockTime = System.getClockTime();
        // définition de la zone à rafraichir
        // definition of the area to refresh
        dc.setClip(134,80,30,30);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // affichage des secondes
        // attention de mettre la même position
        // et la même font que dans layout.xml
        // seconds display
        // be careful to put the same position and the same font as in layout.xml
		dc.drawText(
				134,
				80,
				fontSecond,
                clockTime.sec.format("%02d"),
				Graphics.TEXT_JUSTIFY_LEFT
			);
       
        // seconde zone à dessiner pour la mise à jour du battement de coeur
        // second area to draw for heartbeat update
        coeurbat = Activity.getActivityInfo().currentHeartRate;
        if (coeurbat == null)
        {
            coeurbat ="0";
        }
        dc.setClip(142,7,30,40);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
                152,
                8,
                Graphics.FONT_XTINY,
                coeurbat,
                Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.clearClip();
    }
    // Update the view every minute
    function onUpdate(dc as Dc) as Void {
        
        // affichage de l'heure / hour display
        clockTime = System.getClockTime();
        hourString = Lang.format("$1$:", [clockTime.hour.format("%02d")]);
        viewHeure = View.findDrawableById("HourLabel") as Text;
        viewHeure.setText(hourString);
        // affichage des minutes / minutes display
        minString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        viewMin = View.findDrawableById("MinLabel") as Text;
        viewMin.setText(minString);
        // affichage des secondes /seconde display every minute only
        secondString = Lang.format("$1$", [clockTime.sec.format("%02d")]);
        viewSecond = View.findDrawableById("SecondLabel") as Text;
        viewSecond.setText(secondString);
        // affichage de la date / date display
        today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        dateString = Lang.format("$1$ $2$ $3$ $4$", [today.day_of_week, today.day, today.month, today.year]);
        viewDate = View.findDrawableById("DateDisplay") as Text;
        viewDate.setText(dateString);
        // affichage de l'état de la batterie en jour/ battery status display in days
        mystats = System.getSystemStats();
        batString = Lang.format("$1$j", [mystats.batteryInDays.format("%2d")]);
        viewbat = View.findDrawableById("BatteryDisplay") as Text;
        viewbat.setText(batString);
        // affichage hearbeat / display heartbeat
        coeurbat = Activity.getActivityInfo().currentHeartRate;
        if (coeurbat == null)
        {
            coeurbat ="0";
        }
        coeurbatString = coeurbat.toString();
        viewcoeur = View.findDrawableById("HeartBeat") as Text;
        viewcoeur.setText(coeurbatString);
        // affichage nombre de pas quotidien / daily steps display
        pas = ActivityMonitor.getInfo().steps;
        if (pas == null)
        {
            pas = "0";
        }
        pasString = pas.toString();
        viewpas = View.findDrawableById("Pas") as Text;
        viewpas.setText(pasString);
        // affichage heures coucher et lever du soleil / display sunset and sunrise times
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