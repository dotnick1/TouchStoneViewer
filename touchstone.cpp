#include "touchstone.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QUrl>
#include "math.h"
#include <QAbstractSeries>

using namespace QtCharts;

touchstone::touchstone()
{

}


//open files
void touchstone::setFileName(QString filename) {

#if defined(Q_OS_WIN)
    m_filename = QUrl(filename).toLocalFile(); //this works for windows
    openFile(m_filename); //this works for android
    qDebug() << "Windows detected";
#elif defined(Q_OS_ANDROID)
    m_filename = filename;
    openFile(m_filename); //this works for android
#endif
}
QString touchstone::getFileName() {
    return m_filename;
}
void touchstone::openFile(QString filename) {

    QFile tsFile(filename);
    QTextStream tsData(&tsFile);
    if (!tsFile.open(QFile::ReadOnly | QIODevice::Text)) {
        m_message = "File Not Opened: " + filename;
        emit messageUpdated();
        return;
    }
    //clear all previous data
    frequency.clear();
    x11_arg1.clear();
    x11_arg2.clear();
    x12_arg1.clear();
    x12_arg2.clear();
    x21_arg1.clear();
    x21_arg2.clear();
    x22_arg1.clear();
    x22_arg2.clear();

    int eof = 0;
    while (eof<4) {  //read the whole file
        QString data = tsData.readLine();
        QString subData;
        if (data.length()==0) {
            qDebug() << "Found an empty line";
            while ((eof<4) && (data.length()==0)) {
                data = tsData.readLine();
                if (data.length()==0) eof++; //look for 5 lines in a row that have no data
            }
            if (eof<4) eof=0; //reset end of file indicator
        }

        if (data.contains("!")) {
            qDebug() << "Found a comment line.";
        } else if (data.contains("#")) {
            qDebug() << "Found the options line.";
            if (data.contains(" Hz ", Qt::CaseInsensitive)) {
                freq_factor = 1;  //sets factor to 1 Hz per unit
                qDebug() << "Hz Unit detected";
            }
            if (data.contains(" kHz ", Qt::CaseInsensitive)) {
                freq_factor = 1e3; //sets factor to 1 kHz per unit
                qDebug() << "kHz Unit detected";
            }
            if (data.contains(" MHz ", Qt::CaseInsensitive)) {
                freq_factor = 1e6;//sets factor to 1 MHz per unit
                qDebug() << "MHz Unit detected";
            }
            if (data.contains(" GHz ", Qt::CaseInsensitive)) {
                freq_factor = 1e9;//sets factor to 1 GHz per unit
                qDebug() << "GHz Unit detected";
            }
            if (!data.contains("Hz", Qt::CaseInsensitive)){
                freq_factor = 1e9;//sets factor to 1 Hz per unit, default per specification if not specified
                qDebug() << "Hz Unit NOT detected";
            }

            if (data.contains(" MA ", Qt::CaseInsensitive)) {
                format = "MA"; //default format, Magnitude and Angle
                qDebug() << "MA format detected";
            }
            if (data.contains(" DB ", Qt::CaseInsensitive)) {
                format = "DB"; //DB and angle
                qDebug() << "DB format detected";
            }
            if (data.contains(" RI ", Qt::CaseInsensitive)) {
                format = "RI"; //Real and Imaginary
                qDebug() << "RI format detected";
            }

            if (data.contains(" S ", Qt::CaseInsensitive)) {
                parameter = 'S';
                qDebug() << "S paramaters detected";
            }
            if (data.contains(" Y ", Qt::CaseInsensitive)) {
                parameter = 'Y';
                qDebug() << "Y paramaters detected";
            }
            if (data.contains(" Z ", Qt::CaseInsensitive)) {
                parameter = 'Z';
                qDebug() << "Z paramaters detected";
            }
            if (data.contains(" H ", Qt::CaseInsensitive)) {
                parameter = 'H';
                qDebug() << "H paramaters detected";
            }
            if (data.contains(" G ", Qt::CaseInsensitive)) {
                parameter = 'G';
                qDebug() << "G paramaters detected";
            }

            if (data.contains("R")) {
                int a = data.indexOf(" R ", Qt::CaseInsensitive)+3;
                QString impedance;
                for (int i = a; i<data.length();i++) {
                    if ((data.mid(i,1) == " ") && (impedance.length()>0)) {
                        break;
                    }
                    if (data.mid(i,1) != " ") {
                        impedance.append(data.midRef(i,1));
                    }
                }
                bool ok;
                m_impedance = impedance.toDouble(&ok);
                qDebug() << "Setting the impedance is " << m_impedance;

            }
        } else if (eof<4){
            int location1=-1;
            int location2=-1;
            QString delim;

            if (data.indexOf(" ",0) >= 0) {
                delim = " ";
            }
            if (data.indexOf("\t",0) >= 0) {
                delim = "\t";
            }
            location1 = data.indexOf(delim,0);

            bool ok;
            if (location1 > 0) frequency.append((data.midRef(0,location1)).toDouble(&ok)*freq_factor); //find the frequency of the first argument

            for (int i=0; i<8; i++) {
                while (data.mid(location1,delim.length()) == delim) {  //cycle through the space characters
                    location1 += delim.length();
                }
                location2 = data.indexOf(delim, location1+delim.length()); //find next space character
                if (location2 == -1) location2 = data.length();
                subData = data.mid(location1, location2-location1);

                switch (i) {
                case 0:
                    x11_arg1.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 1:
                    x11_arg2.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 2:
                    x21_arg1.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 3:
                    x21_arg2.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 4:
                    x12_arg1.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 5:
                    x12_arg2.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 6:
                    x22_arg1.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                case 7:
                    x22_arg2.append(data.midRef(location1, location2-location1).toDouble(&ok));
                    break;
                }
                if (!ok) qDebug() << "There was an error in loop " << x11_arg1.length()-1 << " for case " << i;
                if (location2 >= data.length() || (location2 == -1)) {
                    //qDebug() << "Ending the collection loop early    i=" << i;
                    i = 8;
                } else {
                    location1 = location2;
                }

            }
        }

    }

    tsFile.close();
    if (frequency.length()>0) {
        m_freqMin = frequency.at(0);
        m_freqMax = frequency.last();
        m_nop11 = x11_arg1.length();
        m_nop12 = x12_arg1.length();
        m_nop21 = x21_arg1.length();
        m_nop22 = x22_arg1.length();
    }
    findMaxScales();
    emit fileUpdated();
}


//return size of arrays
int touchstone::getNumberOfPoints(){
    return m_nop11;
}
int touchstone::getNumberOfPoints12(){
    return m_nop12;
}
int touchstone::getNumberOfPoints21(){
    return m_nop21;
}
int touchstone::getNumberOfPoints22(){
    return m_nop22;
}

//return data from files to the QML frontend
double touchstone::getDb(int point, int param){
    if (parameter == 'S') {
        if (format == "DB") {
            if ((param == 11) && (point<m_nop11)) return x11_arg1.at(point);
            if ((param == 12) && (point<m_nop12)) return x12_arg1.at(point);
            if ((param == 21) && (point<m_nop21)) return x21_arg1.at(point);
            if ((param == 22) && (point<m_nop22)) return x22_arg1.at(point);
        }
        if (format == "MA") {
            double db=0;
            if ((param == 11) && (point<m_nop11)) {
                db = 20*log10(x11_arg1.at(point));
            }
            if ((param == 12) && (point<m_nop12)) {
                db = 20*log10(x12_arg1.at(point));
            }
            if ((param == 21) && (point<m_nop21)) {
                db = 20*log10(x21_arg1.at(point));
            }
            if ((param == 22) && (point<m_nop22)) {
                db = 20*log10(x22_arg1.at(point));
            }
            return db;
        }
        if (format == "RI") {
            double db = 0;
            double mag = 0;
            if ((param == 11) && (point<m_nop11)) mag = pow(pow(x11_arg1.at(point),2) + pow(x11_arg2.at(point),2),0.5);
            if ((param == 12) && (point<m_nop12)) mag = pow(pow(x12_arg1.at(point),2) + pow(x12_arg2.at(point),2),0.5);
            if ((param == 21) && (point<m_nop21)) mag = pow(pow(x21_arg1.at(point),2) + pow(x21_arg2.at(point),2),0.5);
            if ((param == 22) && (point<m_nop22)) mag = pow(pow(x22_arg1.at(point),2) + pow(x22_arg2.at(point),2),0.5);
            db = 20*log10(mag);
            return db;
        }
        return 0;
    }
}
double touchstone::getMag(int point, int param){
    if (parameter == 'S') {
        if (format == "DB") {
            if ((param == 11) && (point<m_nop11)) return pow(10,x11_arg1.at(point)/20);
            if ((param == 12) && (point<m_nop12)) return pow(10,x12_arg1.at(point)/20);
            if ((param == 21) && (point<m_nop21)) return pow(10,x21_arg1.at(point)/20);
            if ((param == 22) && (point<m_nop11)) return pow(10,x22_arg1.at(point)/20);
        }
        if (format == "MA") {
            if ((param == 11) && (point<m_nop11)) return x11_arg1.at(point);
            if ((param == 12) && (point<m_nop12)) return x12_arg1.at(point);
            if ((param == 21) && (point<m_nop21)) return x21_arg1.at(point);
            if ((param == 22) && (point<m_nop22)) return x22_arg1.at(point);
        }
        if (format == "RI") {
            double mag = 0;
            if ((param == 11) && (point<m_nop11)) mag = pow(pow(x11_arg1.at(point),2) + pow(x11_arg2.at(point),2),0.5);
            if ((param == 12) && (point<m_nop12)) mag = pow(pow(x12_arg1.at(point),2) + pow(x12_arg2.at(point),2),0.5);
            if ((param == 21) && (point<m_nop21)) mag = pow(pow(x21_arg1.at(point),2) + pow(x21_arg2.at(point),2),0.5);
            if ((param == 22) && (point<m_nop22)) mag = pow(pow(x22_arg1.at(point),2) + pow(x22_arg2.at(point),2),0.5);
            return mag;
        }
        return 0;
    }
}
double touchstone::getPhase(int point, int param){
    if (parameter == 'S') {
        if ((format == "DB") || (format == "MA"))  {
            if ((param == 11) && (point<m_nop11)) return x11_arg2.at(point);
            if ((param == 12) && (point<m_nop12)) return x12_arg2.at(point);
            if ((param == 21) && (point<m_nop21)) return x21_arg2.at(point);
            if ((param == 22) && (point<m_nop22)) return x22_arg2.at(point);
        }
        if (format == "RI") {
            double phaseOffset=0;
            if ((param == 11) && (point<m_nop11)) {
                if (x11_arg1.at(point) < 0) phaseOffset = 180;
                return atan2(x11_arg2.at(point),x11_arg1.at(point))+phaseOffset;
            }
            if ((param == 12) && (point<m_nop12)) {
                if (x12_arg1.at(point) < 0) phaseOffset = 180;
                return atan2(x12_arg2.at(point),x12_arg1.at(point))+phaseOffset;
            }
            if ((param == 21) && (point<m_nop21)) {
                if (x21_arg1.at(point) < 0) phaseOffset = 180;
                return atan2(x21_arg2.at(point),x21_arg1.at(point))+phaseOffset;
            }
            if ((param == 22) && (point<m_nop22)) {
                if (x22_arg1.at(point) < 0) phaseOffset = 180;
                return atan2(x22_arg2.at(point),x22_arg1.at(point))+phaseOffset;
            }
        }
        return 0;
    }
}
double touchstone::getFrequency(int point){

    return frequency.at(point)/m_scalar; //returns the frequency in Hz
}
double touchstone::getVswr(int point, int param){
    if (parameter == 'S') {
        double mag=0;
        if (format == "DB") {
            if ((param == 11) && (point<m_nop11)) mag = pow(10,x11_arg1.at(point)/20);
            if ((param == 12) && (point<m_nop12)) mag = pow(10,x12_arg1.at(point)/20);
            if ((param == 21) && (point<m_nop21)) mag = pow(10,x21_arg1.at(point)/20);
            if ((param == 22) && (point<m_nop22)) mag = pow(10,x22_arg1.at(point)/20);
        }
        if (format == "MA") {
            if ((param == 11) && (point<m_nop11)) mag = x11_arg1.at(point);
            if ((param == 12) && (point<m_nop12)) mag = x12_arg1.at(point);
            if ((param == 21) && (point<m_nop21)) mag = x21_arg1.at(point);
            if ((param == 22) && (point<m_nop22)) mag = x22_arg1.at(point);
        }
        if (format == "RI") {
            if ((param == 11) && (point<m_nop11)) mag = pow(pow(x11_arg1.at(point),2) + pow(x11_arg2.at(point),2),0.5);
            if ((param == 12) && (point<m_nop12)) mag = pow(pow(x12_arg1.at(point),2) + pow(x12_arg2.at(point),2),0.5);
            if ((param == 21) && (point<m_nop21)) mag = pow(pow(x21_arg1.at(point),2) + pow(x21_arg2.at(point),2),0.5);
            if ((param == 22) && (point<m_nop22)) mag = pow(pow(x22_arg1.at(point),2) + pow(x22_arg2.at(point),2),0.5);
        }
        double vswr = (1+mag)/(1-mag);
        return vswr;
    }
}
double touchstone::getDelay(int point, int param){
    double delay = 0;
    if (point == 0) return delay;
    if (parameter == 'S') {
        if ((format == "DB") || (format == "MA"))  {
            if ((param == 11) && (point<m_nop11)) {
                double ph=x11_arg2.at(point);
                delay = -(ph-x11_arg2.at(point-1))/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
            if ((param == 12) && (point<m_nop12)) {
                double ph=x12_arg2.at(point);
                delay = -(ph-x12_arg2.at(point-1))/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
            if ((param == 21) && (point<m_nop21)) {
                double ph=x21_arg2.at(point);
                delay = -(ph-x21_arg2.at(point-1))/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
            if ((param == 22) && (point<m_nop22)) {
                double ph=x22_arg2.at(point);
                delay = -(ph-x22_arg2.at(point-1))/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
        }
        if (format == "RI") {
            double phaseOffset=0;
            double phase=0;
            double phasePrev=0;
            if ((param == 11) && (point<m_nop11)) {

                if (x11_arg1.at(point) < 0) phaseOffset = 180;
                phase = atan2(x11_arg2.at(point),x11_arg1.at(point))+phaseOffset;
                phasePrev = atan2(x11_arg2.at(point-1),x11_arg1.at(point-1))+phaseOffset;
                delay = -(phase-phasePrev)/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
            if ((param == 12) && (point<m_nop12)) {
                if (x12_arg1.at(point) < 0) phaseOffset = 180;
                phase = atan2(x12_arg2.at(point),x12_arg1.at(point))+phaseOffset;
                phasePrev = atan2(x12_arg2.at(point-1),x12_arg1.at(point-1))+phaseOffset;
                delay = -(phase-phasePrev)/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
            if ((param == 21) && (point<m_nop21)) {
                if (x21_arg1.at(point) < 0) phaseOffset = 180;
                phase = atan2(x21_arg2.at(point),x21_arg1.at(point))+phaseOffset;
                phasePrev = atan2(x21_arg2.at(point-1),x21_arg1.at(point-1))+phaseOffset;
                delay = -(phase-phasePrev)/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
            if ((param == 22) && (point<m_nop22)) {
                if (x22_arg1.at(point) < 0) phaseOffset = 180;
                phase = atan2(x22_arg2.at(point),x22_arg1.at(point))+phaseOffset;
                phasePrev = atan2(x22_arg2.at(point-1),x22_arg1.at(point-1))+phaseOffset;
                delay = -(phase-phasePrev)/(2*M_PI*(frequency.at(point)-frequency.at(point-1)));
                return delay;
            }
        }
        return 0;
    }
}

//return max and min scale values
double touchstone::getLogMax(){


    return m_logMax;
}
double touchstone::getLogMin(){
    return m_logMin;
}
double touchstone::getLinMax(){
    return m_linMax;
}
double touchstone::getLinMin(){
    return m_linMin;
}
double touchstone::getSwrMax(){
    return m_swrMax;
}
double touchstone::getSwrMin(){
    return m_swrMin;
}
double touchstone::getPhaseMax(){
    return m_phaseMax;
}
double touchstone::getPhaseMin(){
    return m_phaseMin;
}
double touchstone::getDelayMax(){
    return  m_delayMax;
}
double touchstone::getDelayMin(){
    return m_delayMin;
}

double touchstone::getFreqMax(){
    return m_freqMax/m_scalar;
}
double touchstone::getFreqMin(){
    return m_freqMin/m_scalar;
}

//conversion between Hz, kHz, MHz, and GHz
void touchstone::setScalar(int scalar){
    m_scalar = scalar;
    emit fileUpdated();
}
int touchstone::getScalar(){
    return m_scalar;
}

void touchstone::findMaxScales(){
    if (parameter == 'S'){
        double max=-1000;
        double min=1000;

        double delMax, delMin, delCurrent;

        for (int i=0; i<x11_arg1.length(); i++) {
            if ((format == "MA") || (format == "DB")) { //MA format will find a value between 0 and 1 (passive S parameters), DB will find something between 0 and -100ish)
                if (x11_arg1.at(i) > max) max = x11_arg1.at(i);
                if (x11_arg1.at(i) < min) min = x11_arg1.at(i);
            }
            if (format == "RI") {
                double magnitude = pow(pow(x11_arg1.at(i),2)+pow(x11_arg2.at(i),2),0.5);
                if ( magnitude > max) max = magnitude;
                if (magnitude < min) min = magnitude;
            }
            if (i==1) {
                delCurrent = getDelay(i,11);
                delMax = delCurrent;
                delMin = delCurrent;
            }
            if (i>1) {
                delCurrent = getDelay(i,11);
                if (delMax < delCurrent) delMax = delCurrent;
                if (delMin > delCurrent) delMin = delCurrent;
            }
        }
        for (int i=0; i<x12_arg1.length(); i++) {
            if ((format == "MA") || (format == "DB")) {
                if (x12_arg1.at(i) > max) max = x12_arg1.at(i);
                if (x12_arg1.at(i) < min) min = x12_arg1.at(i);
            }
            if (format == "RI") {
                double magnitude = pow(pow(x12_arg1.at(i),2)+pow(x12_arg2.at(i),2),0.5);
                if ( magnitude > max) max = magnitude;
                if (magnitude < min) min = magnitude;
            }
            if (i==1) {
                delCurrent = getDelay(i,11);
                delMax = delCurrent;
                delMin = delCurrent;
            }
            if (i>1) {
                delCurrent = getDelay(i,11);
                if (delMax < delCurrent) delMax = delCurrent;
                if (delMin > delCurrent) delMin = delCurrent;
            }
        }
        for (int i=0; i<x21_arg1.length(); i++) {
            if ((format == "MA") || (format == "DB")) {
                if (x21_arg1.at(i) > max) max = x21_arg1.at(i);
                if (x21_arg1.at(i) < min) min = x21_arg1.at(i);
            }
            if (format == "RI") {
                double magnitude = pow(pow(x21_arg1.at(i),2)+pow(x21_arg2.at(i),2),0.5);
                if ( magnitude > max) max = magnitude;
                if (magnitude < min) min = magnitude;
            }
            if (i==1) {
                delCurrent = getDelay(i,11);
                delMax = delCurrent;
                delMin = delCurrent;
            }
            if (i>1) {
                delCurrent = getDelay(i,11);
                if (delMax < delCurrent) delMax = delCurrent;
                if (delMin > delCurrent) delMin = delCurrent;
            }
        }
        for (int i=0; i<x22_arg1.length(); i++) {
            if ((format == "MA") || (format == "DB")) {
                if (x22_arg1.at(i) > max) max = x22_arg1.at(i);
                if (x22_arg1.at(i) < min) min = x22_arg1.at(i);
            }
            if (format == "RI") {
                double magnitude = pow(pow(x22_arg1.at(i),2)+pow(x22_arg2.at(i),2),0.5);
                if ( magnitude > max) max = magnitude;
                if (magnitude < min) min = magnitude;
            }
            if (i==1) {
                delCurrent = getDelay(i,11);
                delMax = delCurrent;
                delMin = delCurrent;
            }
            if (i>1) {
                delCurrent = getDelay(i,11);
                if (delMax < delCurrent) delMax = delCurrent;
                if (delMin > delCurrent) delMin = delCurrent;
            }
        }

        if ((format == "MA") || (format == "RI")) {
            m_linMax = max;
            m_linMin = min;
            m_logMax = 20*log10(max);
            m_logMin = 20*log10(min);         
            m_swrMax = (1+max)/(1-max);
            m_swrMin = 1;
            m_phaseMax = 180;
            m_phaseMin = -180;
            m_delayMax = delMax;
            m_delayMin = delMin;
        }
        if (format == "DB") {
            double temp=0;
            m_linMax = pow(10,max/20);
            m_linMin = pow(10,min/20);
            m_logMax = max;
            m_logMin = min;
            if (max > -3.5) {
                temp = -3.5;
            } else temp = max;
            m_swrMax = (1+pow(10,temp/20))/(1-pow(10,temp/20));
            m_swrMin = 1;
            m_phaseMax = 180;
            m_phaseMin = -180;
            m_delayMax = delMax;
            m_delayMin = delMin;
        }
    }
}

//return a message string to the frontend.  Normally hidden
QString touchstone::getMessage(){
    return m_message;
}
