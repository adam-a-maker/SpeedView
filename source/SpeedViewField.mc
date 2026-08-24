import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Attention;
import Toybox.Application.Storage;
import Toybox.Lang;

class SpeedViewField extends WatchUi.DataField {

    private var curSpeed = 0.0;
    private var maxSpeed = 0.0;
    private var v1       = 30.0;
    private var v2       = 50.0;
    private var v3       = 70.0;
    private var speedUnit = 0;
    private var speedFactor = 3.6;
    private var speedLabel = "km/h";
    private var colorZone1 = 0x00AAFF;
    private var colorZone2 = 0x55FF55;
    private var colorZone3 = 0xFFA500;
    private var colorZone4 = 0xFF0000;
    private var unitFont = Graphics.FONT_XTINY;
    private var unitY = 0.00;

    function initialize() {
        DataField.initialize();
        loadSettings();
    }

    function loadSettings() {
        var unit = Storage.getValue("speedUnit");
        var p1 = Storage.getValue("v1");
        var p2 = Storage.getValue("v2");
        var p3 = Storage.getValue("v3");
        var c1 = Storage.getValue("colorZone1");
        var c2 = Storage.getValue("colorZone2");
        var c3 = Storage.getValue("colorZone3");
        var c4 = Storage.getValue("colorZone4");

        if (unit != null) { speedUnit = (unit as Number).toLong(); }
        if (p1 != null) { v1 = (p1 as Number).toFloat(); }
        if (p2 != null) { v2 = (p2 as Number).toFloat(); }
        if (p3 != null) { v3 = (p3 as Number).toFloat(); }
        if (c1 != null) { colorZone1 = (c1 as Number).toLong(); }
        if (c2 != null) { colorZone2 = (c2 as Number).toLong(); }
        if (c3 != null) { colorZone3 = (c3 as Number).toLong(); }
        if (c4 != null) { colorZone4 = (c4 as Number).toLong(); }

        if (speedUnit == 1) {
            speedFactor = 1.0;
            speedLabel = "m/s";
        } else if (speedUnit == 2) {
            speedFactor = 1.0 / 1.852;
            speedLabel = "knot";
        } else if (speedUnit == 3) {
            speedFactor = 1.0 / 1225.0;
            speedLabel = "Mach";
        } else if (speedUnit == 4) {
            speedFactor = 2.236936;
            speedLabel = "mph";
        } else if (speedUnit == 5) {
            speedFactor = 3.28084;
            speedLabel = "ft/s";
        } else {
            speedFactor = 3.6;
            speedLabel = "km/h";
        }
    }

    function compute(info) {
        if (info.currentSpeed != null) {
            curSpeed = info.currentSpeed * speedFactor;
            if (curSpeed > maxSpeed) {
                maxSpeed = curSpeed;
                if (Attention has :vibrate) {
                    Attention.vibrate([new Attention.VibeProfile(100, 100)]);
                }
            }
        }
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();

        var colorTop    = getSpeedColor(curSpeed);
        var colorBottom = getSpeedColor(maxSpeed);

        dc.setColor(colorTop, colorTop);
        dc.fillRectangle(0, 0, w, h / 2);

        dc.setColor(colorBottom, colorBottom);
        dc.fillRectangle(0, h / 2, w, h / 2);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, h / 2, w, h / 2);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        dc.drawText(w / 2, h * 0.02, Graphics.FONT_NUMBER_THAI_HOT,
            curSpeed.format("%.0f"), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w / 2, h * 0.38, Graphics.FONT_XTINY,
            "INSTANT SPEED", Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(w / 2, h * unitY, unitFont,
            speedLabel, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(w / 2, h * 0.45, Graphics.FONT_NUMBER_THAI_HOT,
            maxSpeed.format("%.0f"), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w / 2, h * 0.82, Graphics.FONT_XTINY,
            "MAX SPEED", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function getSpeedColor(speed) {
        if (speed < v1) { return colorZone1; }
        if (speed < v2) { return colorZone2; }
        if (speed < v3) { return colorZone3; }
        return colorZone4;
    }
 }
