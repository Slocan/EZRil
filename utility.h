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
public:
    explicit Utility(QObject *parent = 0, QmlApplicationViewer *viewerRef=0);
    Q_INVOKABLE void taskSwitcher();
    QmlApplicationViewer *viewer;

signals:

public slots:


};

#endif // UTILITY_H
