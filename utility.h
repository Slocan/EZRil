#ifndef UTILITY_H
#define UTILITY_H

#if defined(Q_WS_MAEMO_5)
#   include <QDBusConnection>
#   include <QDBusMessage>

#endif

#include <QObject>
#include <QDebug>
#include "qmlapplicationviewer.h"

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
#   include <QOrientationSensor>
#endif

class Utility : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString state READ state NOTIFY orientationChanged)
public:
    explicit Utility(QObject *parent = 0, QmlApplicationViewer *viewerRef=0);
    Q_INVOKABLE void taskSwitcher();
    QmlApplicationViewer *viewer;
    inline QString state() const { return m_state; }
    ~Utility();

signals:
    void orientationChanged();

public slots:

private slots:
    void onReadingChanged();

private:
    QString m_state;
#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
    QtMobility::QOrientationSensor* m_sensor;
#endif

};

#endif // UTILITY_H
