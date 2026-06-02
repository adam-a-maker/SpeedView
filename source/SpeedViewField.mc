import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Math;
import Toybox.Attention;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;

class SpeedViewField extends WatchUi.DataField {

    private var curSpeed = 0.0;
    private var maxSpeed = 0.0;
    private var v1       = 20.0;
    private var v2       = 45.0;
    private var v3       = 70.0;

    function initialize() {
        DataField.initialize();
        loadSettings();
    }

    // Dans la classe SpeedViewField :
    function loadSettings() {
        var p1 = Storage.getValue("v1");
        var p2 = Storage.getValue("v2");
        var p3 = Storage.getValue("v3");
        if (p1 != null) { v1 = (p1 as Number).toFloat(); }
        if (p2 != null) { v2 = (p2 as Number).toFloat(); }
        if (p3 != null) { v3 = (p3 as Number).toFloat(); }
    }

    function compute(info) {
        if (info.currentSpeed != null) {
            curSpeed = info.currentSpeed * 3.6;
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

        dc.drawText(w / 2, h * 0.45, Graphics.FONT_NUMBER_THAI_HOT,
            maxSpeed.format("%.0f"), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w / 2, h * 0.82, Graphics.FONT_XTINY,
            "MAX SPEED", Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Tactile : tap ouvre le menu
    function onTap(location) {
        openSettingsMenu();
        return true;
    }

    // Boutons : appui MENU (bouton haut) ouvre le menu
    // DataField ne reçoit pas onKey directement — voir SpeedViewApp
    function openSettingsMenu() {
        var menu = new WatchUi.Menu2({ :title => "SpeedView" });
        menu.addItem(new WatchUi.MenuItem(
            "Seuil Bleu (v1)",
            v1.format("%.0f") + " km/h",
            "v1", {}));
        menu.addItem(new WatchUi.MenuItem(
            "Seuil Vert (v2)",
            v2.format("%.0f") + " km/h",
            "v2", {}));
        menu.addItem(new WatchUi.MenuItem(
            "Seuil Orange (v3)",
            v3.format("%.0f") + " km/h",
            "v3", {}));
        menu.addItem(new WatchUi.MenuItem(
            "Reset Max",
            maxSpeed.format("%.0f") + " km/h",
            "reset", {}));
        WatchUi.pushView(menu,
            new SpeedViewMenuDelegate(self),
            WatchUi.SLIDE_UP);
    }

    function resetMax() {
        maxSpeed = 0.0;
    }

    private function getSpeedColor(speed) {
        if (speed < v1) { return 0x00AAFF; }
        if (speed < v2) { return Graphics.COLOR_GREEN; }
        if (speed < v3) { return Graphics.COLOR_ORANGE; }
        return Graphics.COLOR_RED;
    }
}