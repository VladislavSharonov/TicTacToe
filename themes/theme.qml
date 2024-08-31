pragma Singleton

import QtQuick 2.15

QtObject {
    readonly property string red: "#cc3927"
    readonly property string orange: "#f1562c"
    readonly property string yellow: "#f8951d"
    readonly property string white: "#f8fafd"
    readonly property string green: "#589a43"
    readonly property string grey: "#8fa1a7"
    readonly property string blue: "#78a2d6"
    readonly property string transparent: "#00000000"
    readonly property string darkerTransparent: "#80000000"

    readonly property FontLoader mainFont: FontLoader {
        source: "../resources/fonts/Century Gothic/centurygothic_bold.ttf"
    }

    readonly property Gradient restartButtonGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0.0
            color: Theme.yellow
        }
        GradientStop {
            position: 0.66
            color: Theme.orange
        }
        GradientStop {
            position: 1.0
            color: Theme.red
        }
    }

    readonly property Gradient startButtonGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0.0
            color: "#3bbbec"
        }
        GradientStop {
            position: 0.66
            color: "#3e76bb"
        }
        GradientStop {
            position: 1.0
            color: "#434a9f"
        }
    }
}
