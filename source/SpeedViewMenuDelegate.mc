import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;

class SpeedViewMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _field as SpeedViewField;

    function initialize(field as SpeedViewField) {
        Menu2InputDelegate.initialize();
        _field = field;
    }

    function onSelect(item) {
        var id = item.getId();

        if (id.equals("reset")) {
            _field.resetMax();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            return;
        }

        var min   = 0;
        var max   = 25;
        var step  = 5;
        var title = "Seuil Bleu (km/h)";

        if (id.equals("v2")) {
            min = 25; max = 50; step = 5;
            title = "Seuil Vert (km/h)";
        } else if (id.equals("v3")) {
            min = 50; max = 100; step = 10;
            title = "Seuil Orange (km/h)";
        }

        var submenu = new WatchUi.Menu2({ :title => title });
        for (var v = min; v <= max; v += step) {
            submenu.addItem(new WatchUi.MenuItem(
                v.format("%d") + " km/h",
                "",              // String vide, pas null
                v,
                {}
            ));
        }

        WatchUi.pushView(submenu,
            new SpeedViewValueDelegate(_field, id as String),
            WatchUi.SLIDE_UP);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    // Range builder removed; inlined in onSelect
}

class SpeedViewValueDelegate extends WatchUi.Menu2InputDelegate {

    private var _field as SpeedViewField;
    private var _key   as String;

    function initialize(field as SpeedViewField, key as String) {
        Menu2InputDelegate.initialize();
        _field = field;
        _key   = key;
    }

    function onSelect(item) {
        var val = item.getId();
        Storage.setValue(_key, val);   // remplace setProperty
        _field.loadSettings();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}