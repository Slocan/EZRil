#include "utility.h"
#include "qmlapplicationviewer.h"
#if defined(Q_WS_MAEMO_5)
#   include <QDBusConnection>
#   include <QDBusMessage>
#endif
#if defined(Q_OS_SYMBIAN)
        #include <eikenv.h>
#endif

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
#elif defined(Q_OS_SYMBIAN)
        CEikonEnv::Static()->DisplayTaskList();
#else
    viewer->showMinimized();
#endif
}
