#ifndef TOUCHSTONE_H
#define TOUCHSTONE_H

#include <QtCharts/QChart>
#include <QtCharts/QChartView>

#include <QLineSeries>
#include <QAbstractSeries>
#include <QObject>
#include <QList>

using namespace QtCharts;

class touchstone: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString filename READ getFileName WRITE setFileName NOTIFY fileUpdated)
    Q_PROPERTY(int points READ getNumberOfPoints NOTIFY fileUpdated)
    Q_PROPERTY(double logMax READ getLogMax NOTIFY fileUpdated)
    Q_PROPERTY(double logMin READ getLogMin NOTIFY fileUpdated)
    Q_PROPERTY(double linMin READ getLinMin NOTIFY fileUpdated)
    Q_PROPERTY(double linMax READ getLinMax NOTIFY fileUpdated)
    Q_PROPERTY(double swrMin READ getSwrMin NOTIFY fileUpdated)
    Q_PROPERTY(double swrMax READ getSwrMax NOTIFY fileUpdated)
    Q_PROPERTY(double swrMin READ getSwrMin NOTIFY fileUpdated)
    Q_PROPERTY(double delayMax READ getDelayMax NOTIFY fileUpdated)
    Q_PROPERTY(double delayMin READ getDelayMin NOTIFY fileUpdated)
    Q_PROPERTY(double phaseMin READ getPhaseMin NOTIFY fileUpdated)
    Q_PROPERTY(double phaseMax READ getPhaseMax NOTIFY fileUpdated)
    Q_PROPERTY(double freqMax READ getFreqMax NOTIFY fileUpdated)
    Q_PROPERTY(double freqMin READ getFreqMin NOTIFY fileUpdated)
    Q_PROPERTY(int points12 READ getNumberOfPoints12 NOTIFY fileUpdated)
    Q_PROPERTY(int points21 READ getNumberOfPoints21 NOTIFY fileUpdated)
    Q_PROPERTY(int points22 READ getNumberOfPoints22 NOTIFY fileUpdated)
    Q_PROPERTY(int scalar READ getScalar WRITE setScalar NOTIFY fileUpdated)
    Q_PROPERTY(QString message READ getMessage NOTIFY messageUpdated)



public:
    touchstone();


public slots:

    void setFileName(QString);
    QString getFileName();
    int getNumberOfPoints(void);
    int getNumberOfPoints12(void);
    int getNumberOfPoints21(void);
    int getNumberOfPoints22(void);

    double getDb(int point, int param);
    double getMag(int point, int param);
    double getPhase(int point, int param);
    double getVswr(int point, int param);
    double getFrequency(int point);
    double getDelay(int point, int param);

    double getLogMax();
    double getLogMin();
    double getLinMax();
    double getLinMin();
    double getSwrMax();
    double getSwrMin();
    double getPhaseMax();
    double getPhaseMin();
    double getDelayMax();
    double getDelayMin();


    double getFreqMax();
    double getFreqMin();

    QString getMessage();

    void setScalar(int scalar);
    int getScalar();

Q_SIGNALS:
    void fileUpdated();
    void messageUpdated();

private:
    void openFile(QString filename);
    void findMaxScales();
    QList<double> frequency, x11_arg1, x11_arg2, x12_arg1, x12_arg2, x21_arg1, x21_arg2, x22_arg1, x22_arg2;

    int m_nop11 = 0;
    int m_nop12 = 0;
    int m_nop21 = 0;
    int m_nop22 = 0;

    QString m_filename, m_message;
    int freq_factor = 1e9;
    QString format = "MA"; //0 = MA (default), 1 = DB, 2 = RI
    QChar parameter = 'S'; //S, Y, Z, H, G
    double m_impedance;
    int m_scalar = 1;
    double m_logMax, m_logMin, m_linMax, m_linMin, m_phaseMax, m_phaseMin, m_swrMax, m_swrMin, m_freqMax, m_freqMin, m_delayMax, m_delayMin;

};

#endif // TOUCHSTONE_H
