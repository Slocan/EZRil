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
<<<<<<< HEAD
    Q_PROPERTY(QString state READ state NOTIFY orientationChanged)
=======
    Q_ENUMS(Orientation)
>>>>>>> 53b33897c30ba6b42dca4828a36d0d96f1215a3d
public:
    explicit Utility(QObject *parent = 0, QmlApplicationViewer *viewerRef=0);
    Q_INVOKABLE void taskSwitcher();
    QmlApplicationViewer *viewer;
<<<<<<< HEAD
    inline QString state() const { return m_state; }
    ~Utility();
=======
    enum Orientation {
        UnknownOrientation,
        Portrait,
        Landscape,
        PortraitInverted,
        LandscapeInverted
    };
    virtual Orientation orientation() const = 0;
>>>>>>> 53b33897c30ba6b42dca4828a36d0d96f1215a3d

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
