import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import Qt.labs.platform 1.0
import QtQuick.Dialogs 1.2


Window {
    width: 700
    height: 450
    visible: true
    color: "white"

    property var scalar: 1

    property bool s11Active: true
    property bool s12Active: false
    property bool s21Active: false
    property bool s22Active: false

    property bool logActive: true
    property bool linActive: false
    property bool swrActive: false
    property bool phaseActive: false
    property bool delayActive: false

    property bool logChart: true
    property bool polarChart: false

    property bool  log11: false
    property bool  log12: false
    property bool  log21: false
    property bool  log22: false

    property bool  lin11: false
    property bool  lin12: false
    property bool  lin21: false
    property bool  lin22: false

    property bool  phase11: false
    property bool  phase12: false
    property bool  phase21: false
    property bool  phase22: false

    property bool  swr11: false
    property bool  swr12: false
    property bool  swr21: false
    property bool  swr22: false

    property bool  polar11: false
    property bool  polar12: false
    property bool  polar21: false
    property bool  polar22: false

    property bool  delay11: false
    property bool  delay12: false
    property bool  delay21: false
    property bool  delay22: false

    function clearCharts() {
        s11LogSeries.clear();
        s11LinSeries.clear();
        s11SwrSeries.clear();
        s11PhaseSeries.clear();

        s12LogSeries.clear();
        s12LinSeries.clear();
        s12SwrSeries.clear();
        s12PhaseSeries.clear();

        s21LogSeries.clear();
        s21LinSeries.clear();
        s21SwrSeries.clear();
        s21PhaseSeries.clear();

        s22LogSeries.clear();
        s22LinSeries.clear();
        s22SwrSeries.clear();
        s22PhaseSeries.clear();

        s11polarseries.clear();
        s12polarseries.clear();
        s21polarseries.clear();
        s22polarseries.clear();


        s11DelaySeries.clear();
        s12DelaySeries.clear();
        s21DelaySeries.clear();
        s22DelaySeries.clear();

        log11 = false;
        log12 = false;
        log21 = false;
        log22 = false;

        lin11 = false;
        lin12 = false;
        lin21 = false;
        lin22 = false;

        swr11 = false;
        swr12 = false;
        swr21 = false;
        swr22 = false;

        polar11 = false;
        polar12 = false;
        polar21 = false;
        polar22 = false;

        phase11 = false;
        phase12 = false;
        phase21 = false;
        phase22 = false;

        delay11 = false;
        delay12 = false;
        delay21 = false;
        delay22 = false;


        console.log("Chart series cleared");
    }

    function initialChartCreation(){
        for (var i=0; i< ts.points;i++){
            if (logActive) {
                if ((s11Active) && (i<ts.points) && !log11) s11LogSeries.append(ts.getFrequency(i),ts.getDb(i,11));
                if ((s12Active) && (i<ts.points12) && !log12) s12LogSeries.append(ts.getFrequency(i),ts.getDb(i,12));
                if ((s21Active) && (i<ts.points21) && !log21) s21LogSeries.append(ts.getFrequency(i),ts.getDb(i,21));
                if ((s22Active) && (i<ts.points22) && !log22) s22LogSeries.append(ts.getFrequency(i),ts.getDb(i,22));
            }
            if (linActive) {
                if ((s11Active) && (i<ts.points) && !lin11) s11LinSeries.append(ts.getFrequency(i),ts.getMag(i,11));
                if ((s12Active) && (i<ts.points12) && !lin12) s12LinSeries.append(ts.getFrequency(i),ts.getMag(i,12));
                if ((s21Active) && (i<ts.points21) && !lin21) s21LinSeries.append(ts.getFrequency(i),ts.getMag(i,21));
                if ((s22Active) && (i<ts.points22) && !lin22) s22LinSeries.append(ts.getFrequency(i),ts.getMag(i,22));
            }
            if (phaseActive) {
                if ((s11Active) && (i<ts.points) && !phase11) s11PhaseSeries.append(ts.getFrequency(i),ts.getPhase(i,11));
                if ((s12Active) && (i<ts.points12) && !phase12) s12PhaseSeries.append(ts.getFrequency(i),ts.getPhase(i,12));
                if ((s21Active) && (i<ts.points21) && !phase21) s21PhaseSeries.append(ts.getFrequency(i),ts.getPhase(i,21));
                if ((s22Active) && (i<ts.points22) && !phase22) s22PhaseSeries.append(ts.getFrequency(i),ts.getPhase(i,22));
            }
            if (swrActive) {
                if ((s11Active) && (i<ts.points) && !swr11) s11SwrSeries.append(ts.getFrequency(i),ts.getVswr(i,11));
                if ((s12Active) && (i<ts.points12) && !swr12) s12SwrSeries.append(ts.getFrequency(i),ts.getVswr(i,12));
                if ((s21Active) && (i<ts.points21) && !swr21) s21SwrSeries.append(ts.getFrequency(i),ts.getVswr(i,21));
                if ((s22Active) && (i<ts.points22) && !swr22) s22SwrSeries.append(ts.getFrequency(i),ts.getVswr(i,22));
            }
            if (delayActive) {
                if ((s11Active) && (i<ts.points) && !delay11) s11DelaySeries.append(ts.getFrequency(i),ts.getDelay(i,11));
                if ((s12Active) && (i<ts.points12) && !delay12) s12DelaySeries.append(ts.getFrequency(i),ts.getDelay(i,12));
                if ((s21Active) && (i<ts.points21) && !delay21) s21DelaySeries.append(ts.getFrequency(i),ts.getDelay(i,21));
                if ((s22Active) && (i<ts.points22) && !delay22) s22DelaySeries.append(ts.getFrequency(i),ts.getDelay(i,22));
            }
            if (polarChart) {
                if ((s11Active) && (i<ts.points) && !polar11) s11polarseries.append(ts.getPhase(i,11),ts.getMag(i,11));
                if ((s12Active) && (i<ts.points12) && !polar12) s12polarseries.append(ts.getPhase(i,12),ts.getMag(i,12));
                if ((s21Active) && (i<ts.points21) && !polar21) s21polarseries.append(ts.getPhase(i,21),ts.getMag(i,21));
                if ((s22Active) && (i<ts.points22) && !polar22) s22polarseries.append(ts.getPhase(i,22),ts.getMag(i,22));
            }
        }

        if (s11LogSeries.count>0) log11 = true;
        if (s12LogSeries.count>0) log12 = true;
        if (s21LogSeries.count>0) log21 = true;
        if (s22LogSeries.count>0) log22 = true;

        if (s11LinSeries.count>0) lin11 = true;
        if (s12LinSeries.count>0) lin12 = true;
        if (s21LinSeries.count>0) lin21 = true;
        if (s22LinSeries.count>0) lin22 = true;

        if (s11PhaseSeries.count>0) phase11 = true;
        if (s12PhaseSeries.count>0) phase12 = true;
        if (s21PhaseSeries.count>0) phase21 = true;
        if (s22PhaseSeries.count>0) phase22 = true;

        if (s11SwrSeries.count>0) swr11 = true;
        if (s12SwrSeries.count>0) swr12 = true;
        if (s21SwrSeries.count>0) swr21 = true;
        if (s22SwrSeries.count>0) swr22 = true;


        if (s11DelaySeries.count>0) delay11 = true;
        if (s12DelaySeries.count>0) delay12 = true;
        if (s21DelaySeries.count>0) delay21 = true;
        if (s22DelaySeries.count>0) delay22 = true;

        if (s11polarseries.count>0) polar11 = true;
        if (s12polarseries.count>0) polar12 = true;
        if (s21polarseries.count>0) polar21 = true;
        if (s22polarseries.count>0) polar22 = true;

        if (ts.points==0) s11Active = false;
        if (ts.points12==0) s12Active = false;
        if (ts.points21==0) s21Active = false;
        if (ts.points22==0) s22Active = false;
    }

    function refreshScale(){
        if (logActive) {
            yAxis.max = ts.logMax
            yAxis.min = ts.logMin
        }
        if (linActive) {
            yAxis.max = ts.linMax
            yAxis.min = ts.linMin
        }
        if (swrActive) {
            yAxis.max = ts.swrMax
            yAxis.min = ts.swrMin
        }
        if (phaseActive) {
            yAxis.max = ts.phaseMax
            yAxis.min = ts.phaseMin
        }
        if (delayActive) {
            yAxis.min = ts.delayMin
            yAxis.max = ts.delayMax
        }
        if (polarChart) {
            axisRadial.max = ts.linMax
            axisRadial.min = 0
        }

        xAxis.max = ts.getFreqMax();
        xAxis.min = ts.getFreqMin();
    }

    Row {
        id: globalRow
        width: parent.width
        height: parent.height


        Column {
            id: colParameters
            width: (parent.width-10*3) * 0.1
            height: parent.height
            spacing: 10
            padding: 10

            Rectangle {
                id: openButton
                width: parent.width
                height: (parent.height-10*7)/6
                border.color: "black"
                border.width: 2
                color: "lightskyblue"
                radius: 10

                Text{
                    width: parent.width
                    height: parent.height
                    text: "Open"
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fileDialog.visible = true

                    }
                }
            }
            Rectangle {
                id: s11Button
                width: parent.width
                height: (parent.height-10*7)/6
                border.color: "black"
                border.width: 2
                color: "blue"
                radius: 10
                visible: ts.points>0 ? true: false

                Text{
                    id: s11ButtonText
                    width: parent.width
                    height: parent.height
                    text: "S11"
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        s11Active = !s11Active
                        s11Button.color = s11Active ? "blue" : "lightskyblue"
                        s11ButtonText.color = s11Active ? "white" : "black"
                        initialChartCreation()
                    }
                }
            }
            Rectangle {
                id: s12Button
                width: parent.width
                height: (parent.height-10*7)/6
                border.color: "black"
                border.width: 2
                color: "lightskyblue"
                radius: 10
                visible:  ts.points12>0 ? true: false

                Text{
                    id: s12ButtonText
                    width: parent.width
                    height: parent.height
                    text: "S12"
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        s12Active = !s12Active
                        s12Button.color = s12Active ? "blue" : "lightskyblue"
                        s12ButtonText.color = s12Active ? "white" : "black"
                        initialChartCreation()
                    }
                }
            }
            Rectangle {
                id: s21Button
                width: parent.width
                height: (parent.height-10*7)/6
                border.color: "black"
                border.width: 2
                color: "lightskyblue"
                radius: 10
                visible: ts.points21>0 ? true: false

                Text{
                    id: s21ButtonText
                    width: parent.width
                    height: parent.height
                    text: "S21"
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        s21Active = !s21Active
                        s21Button.color = s21Active ? "blue" : "lightskyblue"
                        s21ButtonText.color = s21Active ? "white" : "black"
                        initialChartCreation()
                    }
                }
            }
            Rectangle {
                id: s22Button
                width: parent.width
                height: (parent.height-10*7)/6
                border.color: "black"
                border.width: 2
                color: "lightskyblue"
                radius: 10
                visible: ts.points22>0 ? true: false

                Text{
                    id: s22ButtonText
                    width: parent.width
                    height: parent.height
                    text: "S22"
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        s22Active = !s22Active
                        s22Button.color = s22Active ? "blue" : "lightskyblue"
                        s22ButtonText.color = s22Active ? "white" : "black"
                        initialChartCreation()
                    }
                }
            }
            Rectangle {
                id: scaleButton
                width: parent.width
                height: (parent.height-10*7)/6
                border.color: "black"
                border.width: 2
                color: "lightskyblue"
                radius: 10

                Text{
                    width: parent.width
                    height: parent.height
                    text: "Auto Scale"
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: refreshScale()
                }
            }
        }
        Column {
            width: (parent.width-10*3)*0.9
            height: parent.height
            spacing: 10
            leftPadding: 10


            Row{
                width: parent.width
                height: parent.height*0.1
                spacing: 10
                padding: 10


                Rectangle {
                    id: logButton
                    width: (parent.width-10*7)/6
                    height: parent.height
                    border.color: "black"
                    border.width: 2
                    color: logActive ? "blue" : "lightskyblue"
                    radius: 10

                    Text{
                        id: logButtonText
                        width: parent.width
                        height: parent.height
                        text: "Log"
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: logActive ? "white" : "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logActive = true
                            linActive = false
                            swrActive = false
                            delayActive = false
                            phaseActive = false

                            logChart = true
                            polarChart = false
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                }
                Rectangle {
                    id: linButton
                    width: (parent.width-10*7)/6
                    height: parent.height
                    border.color: "black"
                    border.width: 2
                    color: linActive ? "blue" : "lightskyblue"
                    radius: 10

                    Text{
                        id: linButtonText
                        width: parent.width
                        height: parent.height
                        text: "Lin"
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: linActive ? "white" : "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logActive = false
                            linActive = true
                            swrActive = false
                            delayActive = false
                            phaseActive = false

                            logChart = true
                            polarChart = false
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                }
                Rectangle {
                    id: vswrButton
                    width: (parent.width-10*7)/6
                    height: parent.height
                    border.color: "black"
                    border.width: 2
                    color: swrActive ? "blue" : "lightskyblue"
                    radius: 10

                    Text{
                        id: vswrButtonText
                        width: parent.width
                        height: parent.height
                        text: "VSWR"
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: swrActive ? "white" : "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logActive = false
                            linActive = false
                            swrActive = true
                            delayActive = false
                            phaseActive = false

                            logChart = true
                            polarChart = false
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                }
                Rectangle {
                    id: phaseButton
                    width:(parent.width-10*7)/6
                    height: parent.height
                    border.color: "black"
                    border.width: 2
                    color: phaseActive ? "blue" : "lightskyblue"
                    radius: 10

                    Text{
                        id: phaseButtonText
                        width: parent.width
                        height: parent.height
                        text: "Phase"
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: phaseActive ? "white" : "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logActive = false
                            linActive = false
                            swrActive = false
                            delayActive = false
                            phaseActive = true

                            logChart = true
                            polarChart = false
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                }
                Rectangle {
                    id: delayButton
                    width: (parent.width-10*7)/6
                    height: parent.height
                    border.color: "black"
                    border.width: 2
                    color: delayActive ? "blue" : "lightskyblue"
                    radius: 10

                    Text{
                        id: delayButtonText
                        width: parent.width
                        height: parent.height
                        text: "Delay"
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: delayActive ? "white" : "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logActive = false
                            linActive = false
                            swrActive = false
                            delayActive = true
                            phaseActive = false

                            logChart = true
                            polarChart = false
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                }
                Rectangle {
                    id: polarButton
                    width:(parent.width-10*7)/6
                    height: parent.height
                    border.color: "black"
                    border.width: 2
                    color: polarChart ? "blue" : "lightskyblue"
                    radius: 10

                    Text{
                        id: polarButtonText
                        width: parent.width
                        height: parent.height
                        text: "Polar"
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: polarChart ? "white" : "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logActive = false
                            linActive = false
                            swrActive = false
                            delayActive = false
                            phaseActive = false

                            logChart = false
                            polarChart = true
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                }
            }
            Row{
                width: parent.width
                height: parent.height*0.9
                spacing: 10
                padding: 10
                Column {
                    //scale control column
                    width: parent.width*0.12
                    height: parent.height
                    spacing: 5
                    Rectangle {

                        width: parent.width
                        height: parent.height*0.05

                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom
                            text: "Max Scale"
                            fontSizeMode: Text.Fit
                            font.pointSize: 12
                        }
                    }
                    Rectangle {
                        id: maxScalePlus
                        width: parent.width
                        height: parent.height*0.1
                        border.color:  "black"
                        radius: 20

                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "+"
                            fontSizeMode: Text.Fit
                            font.pointSize: 24
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var ma
                                if (logChart) {
                                    ma = (yAxis.max-yAxis.min)/10
                                    yAxis.max += ma
                                    console.log("ma = " + ma)
                                    console.log("yAxis max = " + yAxis.max)
                                }
                                if (polarChart) {
                                    ma = (axisRadial.max-axisRadial.min)/10
                                    axisRadial.max += ma
                                    console.log("ma = " + ma)
                                    console.log("axisRadial max = " + axisRadial.max)
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: maxScaleMinus
                        width: parent.width
                        height: parent.height*0.1
                        border.color:  "black"
                        radius: 20
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            text: "-"
                            fontSizeMode: Text.Fit
                            font.pointSize: 24
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var ma
                                if (logChart) {
                                    ma = (yAxis.max-yAxis.min)/10
                                    yAxis.max -= ma
                                    console.log("ma = " + ma)
                                    console.log("yAxis max = " + yAxis.max)
                                }
                                if (polarChart) {
                                    ma = (axisRadial.max-axisRadial.min)/10
                                    axisRadial.max -=ma
                                    console.log("ma = " + ma)
                                    console.log("axisRadial max = " + axisRadial.max)
                                }
                            }
                        }
                    }
                    ComboBox {
                        height: parent.height*0.25
                        width: parent.width
                        displayText: currentText
                        font.pixelSize: width/7
                        model: ["Hz", "kHz", "MHz", "GHz"]
                        onActivated: {
                            if (currentIndex == 0) ts.scalar = 1
                            if (currentIndex == 1) ts.scalar = 1e3
                            if (currentIndex == 2) ts.scalar = 1e6
                            if (currentIndex == 3) ts.scalar = 1e9
                            console.log("scalar = " + ts.scalar)
                            clearCharts()
                            initialChartCreation()
                            refreshScale()
                        }
                    }
                    Rectangle {
                        id: minScalePlus
                        width: parent.width
                        height: parent.height*0.1
                        visible: logChart
                        border.color:  "black"
                        radius: 20
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "+"
                            fontSizeMode: Text.Fit
                            font.pointSize: 24
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var ma = (yAxis.max-yAxis.min)/10
                                yAxis.min += ma
                                console.log("yAxis min = " + yAxis.min)
                            }
                        }
                    }
                    Rectangle {
                        id: minScaleMinus
                        width: parent.width
                        height: parent.height*0.1
                        visible: logChart
                        border.color:  "black"
                        radius: 20
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "-"
                            fontSizeMode: Text.Fit
                            font.pointSize: 24
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var ma = (yAxis.max-yAxis.min)/10
                                yAxis.min -= ma
                                console.log("yAxis min = " + yAxis.min)

                            }


                        }
                    }
                    Rectangle {

                        width: parent.width
                        height: parent.height*0.05
                        visible: logChart
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignTop
                            text: "Min Scale"
                            fontSizeMode: Text.Fit
                            font.pointSize: 12
                        }
                    }
                }
                ChartView {
                    id: linearChart
                    height: parent.height
                    width: parent.width*0.88

                    antialiasing: true
                    visible: logChart //will use this with the polar button
                    legend.alignment: "AlignBottom"
                    margins.top: 10


                    ValueAxis {
                        id: yAxis
                        min: -100
                        max: 100
                        tickCount: 11
                        labelsFont: Qt.font({pointSize: 7})

                    }
                    ValueAxis {
                        id: xAxis
                        min: ts.freqMin
                        max: ts.freqMax
                        tickCount: 11
                        labelsFont: Qt.font({pointSize: 7})
                    }
                    LineSeries {
                        id: s11LinSeries
                        name: "S11"
                        axisY: yAxis
                        axisX: xAxis
                        color: "blue"
                        visible: s11Active && linActive
                        onHovered: {

                        }

                    }
                    LineSeries {
                        id: s12LinSeries
                        name: "S12"
                        axisY: yAxis
                        axisX: xAxis
                        color: "red"
                        visible: s12Active && linActive
                    }
                    LineSeries {
                        id: s21LinSeries
                        name: "S21"
                        axisY: yAxis
                        axisX: xAxis
                        color: "green"
                        visible: s21Active && linActive
                    }
                    LineSeries {
                        id: s22LinSeries
                        name: "S22"
                        axisY: yAxis
                        axisX: xAxis
                        color: "orange"
                        visible: s22Active && linActive
                    }
                    LineSeries {
                        id: s11LogSeries
                        name: "S11"
                        axisY: yAxis
                        axisX: xAxis
                        color: "blue"
                        visible: s11Active && logActive
                    }
                    LineSeries {
                        id: s12LogSeries
                        name: "S12"
                        axisY: yAxis
                        axisX: xAxis
                        color: "red"
                        visible: s12Active && logActive
                    }
                    LineSeries {
                        id: s21LogSeries
                        name: "S21"
                        axisY: yAxis
                        axisX: xAxis
                        color: "green"
                        visible: s21Active && logActive
                    }
                    LineSeries {
                        id: s22LogSeries
                        name: "S22"
                        axisY: yAxis
                        axisX: xAxis
                        color: "orange"
                        visible: s22Active && logActive
                    }
                    LineSeries {
                        id: s11SwrSeries
                        name: "S11"
                        axisY: yAxis
                        axisX: xAxis
                        color: "blue"
                        visible: s11Active && swrActive
                    }
                    LineSeries {
                        id: s12SwrSeries
                        name: "S12"
                        axisY: yAxis
                        axisX: xAxis
                        color: "red"
                        visible: s12Active && swrActive
                    }
                    LineSeries {
                        id: s21SwrSeries
                        name: "S21"
                        axisY: yAxis
                        axisX: xAxis
                        color: "green"
                        visible: s21Active && swrActive
                    }
                    LineSeries {
                        id: s22SwrSeries
                        name: "S22"
                        axisY: yAxis
                        axisX: xAxis
                        color: "orange"
                        visible: s22Active && swrActive
                    }
                    LineSeries {
                        id: s11PhaseSeries
                        name: "S11"
                        axisY: yAxis
                        axisX: xAxis
                        color: "blue"
                        visible: s11Active && phaseActive
                    }
                    LineSeries {
                        id: s12PhaseSeries
                        name: "S12"
                        axisY: yAxis
                        axisX: xAxis
                        color: "red"
                        visible: s12Active && phaseActive
                    }
                    LineSeries {
                        id: s21PhaseSeries
                        name: "S21"
                        axisY: yAxis
                        axisX: xAxis
                        color: "green"
                        visible: s21Active && phaseActive
                    }
                    LineSeries {
                        id: s22PhaseSeries
                        name: "S22"
                        axisY: yAxis
                        axisX: xAxis
                        color: "orange"
                        visible: s22Active && phaseActive
                    }
                    LineSeries {
                        id: s11DelaySeries
                        name: "S11"
                        axisY: yAxis
                        axisX: xAxis
                        color: "blue"
                        visible: s11Active && delayActive
                    }
                    LineSeries {
                        id: s12DelaySeries
                        name: "S12"
                        axisY: yAxis
                        axisX: xAxis
                        color: "red"
                        visible: s12Active && delayActive
                    }
                    LineSeries {
                        id: s21DelaySeries
                        name: "S21"
                        axisY: yAxis
                        axisX: xAxis
                        color: "green"
                        visible: s21Active && delayActive
                    }
                    LineSeries {
                        id: s22DelaySeries
                        name: "S22"
                        axisY: yAxis
                        axisX: xAxis
                        color: "orange"
                        visible: s22Active && delayActive
                    }


                }
                PolarChartView{
                    id: polarChartView
                    height: parent.height
                    width: parent.width*0.88
                    antialiasing: true
                    legend.alignment: "AlignRight"
                    margins.top: 10


                    visible: polarChart //will use this with the polar button
                    enabled: polarChart
                    ValueAxis {
                        id: axisAngular
                        min: -180
                        max: 180
                        tickCount: 9
                        labelsFont: Qt.font({pointSize: 7})

                    }
                    ValueAxis {
                        id: axisRadial
                        min: 0
                        max: 1
                        tickCount: 5
                        labelsFont: Qt.font({pointSize: 7})
                    }
                    LineSeries {
                        id: s11polarseries
                        name: "S11"
                        axisAngular: axisAngular
                        axisRadial: axisRadial
                        color: "blue"
                        visible: s11Active
                    }
                    LineSeries {
                        id: s12polarseries
                        name: "S12"
                        axisAngular: axisAngular
                        axisRadial: axisRadial
                        color: "red"
                        visible: s12Active
                    }
                    LineSeries {
                        id: s21polarseries
                        name: "S21"
                        axisAngular: axisAngular
                        axisRadial: axisRadial
                        color: "green"
                        visible: s21Active
                    }
                    LineSeries {
                        id: s22polarseries
                        name: "S22"
                        axisAngular: axisAngular
                        axisRadial: axisRadial
                        color: "orange"
                        visible: s22Active
                    }
                }

            }

            Rectangle {
                width: parent.width
                height: 0.1 * parent.height
                border.color: "black"
                border.width: 2
                visible: false
                Text {
                    id: messageBox
                    anchors.fill: parent
                    anchors.centerIn: parent
                    fontSizeMode: Text.Fit
                    text: ts.message
                }
            }

        }
    }

    FileDialog {
        id: fileDialog
        title: "Choose a TouchStone File"
        onAccepted: {
            ts.filename = fileDialog.fileUrl.toString()
            messageBox.text = "You Chose " + ts.filename
            console.log("You chose " + ts.filename)
            visible: false
            clearCharts()
            initialChartCreation()
            refreshScale()
        }
        onRejected: {
            messageBox.text = "You cancelled"
            console.log("You cancelled")
            visible: false
        }
        Component.onCompleted: visible = false
    }
}
