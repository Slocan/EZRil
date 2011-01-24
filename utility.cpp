#include "utility.h"
#   include <QDBusConnection>
#   include <QDBusMessage>
#include "qmlapplicationviewer.h"

Utility::Utility(QObject *parent, QmlApplicationViewer *viewerRef) :
    QObject(parent)
{
    viewer = viewerRef;
}
void Utility::taskSwitcher()
{
#if defined(Q_WS_MAEMO_5)
        QDBusConnection c = QDBusConnection::sessionBus();
        QDBusMessage m = QDBusMessage::createSignal("/", "com.nokia.hildon_desktop", "exit_app_view");
        c.send(m);
#else
        viewer->showMinimized();
#endif
}
