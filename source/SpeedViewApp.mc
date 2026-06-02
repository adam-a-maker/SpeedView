import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SpeedViewApp extends Application.AppBase {

    // Référence publique pour que le delegate puisse appeler loadSettings()
    var field as SpeedViewField;

    function initialize() {
        AppBase.initialize();
        field = new SpeedViewField();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    function getInitialView() {
        // On retourne le field + un delegate qui écoute les boutons
        return [ field, new SpeedViewBehaviorDelegate(field) ];
    }

    // Rechargé automatiquement si settings changés depuis Connect IQ app
    function onSettingsChanged() {
        field.loadSettings();
    }
}

// BehaviorDelegate : reçoit les events boutons au niveau de la DataField view
class SpeedViewBehaviorDelegate extends WatchUi.BehaviorDelegate {

    private var _field as SpeedViewField;

    function initialize(field as SpeedViewField) {
        BehaviorDelegate.initialize();
        _field = field;
    }

    // Bouton MENU (appui court sur UP/MENU selon la montre) → ouvre settings
    function onMenu() {
        _field.openSettingsMenu();
        return true;
    }

    // Bouton SELECT (milieu) → reset max speed
    function onSelect() {
        _field.resetMax();
        WatchUi.requestUpdate();
        return true;
    }
}

function getApp() as SpeedViewApp {
    return Application.getApp() as SpeedViewApp;
}