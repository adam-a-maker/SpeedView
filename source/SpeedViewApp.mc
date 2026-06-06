import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SpeedViewApp extends Application.AppBase {

    var field as SpeedViewField;

    function initialize() {
        AppBase.initialize();
        field = new SpeedViewField();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    function getInitialView() {
        return [ field ];
    }

    // Appelé automatiquement quand les settings changent dans l'app Connect IQ
    function onSettingsChanged() {
        field.loadSettings();
        WatchUi.requestUpdate();
    }
}

function getApp() as SpeedViewApp {
    return Application.getApp() as SpeedViewApp;
}
