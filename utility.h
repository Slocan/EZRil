#ifndef UTILITY_H
#define UTILITY_H

#if defined(Q_WS_MAEMO_5)
#   include <QDBusConnection>
#   include <QDBusMessage>
#endif

#include <QObject>
#include <QDebug>
#include "qmlapplicationviewer.h"

class Utility : public QObject
{
    Q_OBJECT
    Q_ENUMS(Orientation)
public:
    explicit Utility(QObject *parent = 0, QmlApplicationViewer *viewerRef=0);
    Q_INVOKABLE void taskSwitcher();
    QmlApplicationViewer *viewer;
    enum Orientation {
        UnknownOrientation,
        Portrait,
        Landscape,
        PortraitInverted,
        LandscapeInverted
    };
    virtual Orientation orientation() const = 0;

signals:
    void orientationChanged();

public slots:


};

#endif // UTILITY_H
