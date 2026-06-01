import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Math;
import Toybox.Attention;

class SpeedViewField extends WatchUi.DataField {

    private var curSpeed = 0.0;
    private var maxSpeed = 0.0;
    private var v1 = 20.0;
    private var v2 = 45.0;
    private var v3 = 70.0;

    function initialize() {
        DataField.initialize();
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

        dc.drawText(w / 2, h * 0.02, Graphics.FONT_NUMBER_THAI_HOT, curSpeed.format("%.0f"), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w / 2, h * 0.38, Graphics.FONT_XTINY, "INSTANT SPEED", Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(w / 2, h * 0.45, Graphics.FONT_NUMBER_THAI_HOT, maxSpeed.format("%.0f"), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w / 2, h * 0.82, Graphics.FONT_XTINY, "MAX SPEED", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function getSpeedColor(speed) {
        if (speed < v1) { return 0x00AAFF; }
        if (speed < v2) { return Graphics.COLOR_GREEN; }
        if (speed < v3) { return Graphics.COLOR_ORANGE; }
        return Graphics.COLOR_RED;
    }
}
