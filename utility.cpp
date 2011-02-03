#include "utility.h"
#include "qmlapplicationviewer.h"
#if defined(Q_WS_MAEMO_5)
#   include <QDBusConnection>
#   include <QDBusMessage>
#endif
#if defined(Q_OS_SYMBIAN)
        #include <eikenv.h>
#endif

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
#include <QOrientationSensor>
#include <QOrientationReading>
QTM_USE_NAMESPACE
#endif

// Orientation code adapted from http://cdumez.blogspot.com/2010/12/screen-orientation-detection-for-qml.html

Utility::Utility(QObject *parent, QmlApplicationViewer *viewerRef) :
    QObject(parent), m_state("Portrait")
{
    viewer = viewerRef;
    #if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
    m_sensor = new QOrientationSensor(this);
    connect(m_sensor, SIGNAL(readingChanged()), SLOT(onReadingChanged()));
    m_sensor->start();
    #endif
}

Utility::~Utility() {
    #if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
    delete m_sensor;
    #endif
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

void Utility::onReadingChanged()
{
    #if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
  QOrientationReading* reading = m_sensor->reading();
  switch(reading->orientation())
  {
  case QOrientationReading::TopUp:
    m_state = "Landscape";
    emit orientationChanged();
    break;
  case QOrientationReading::TopDown:
    m_state = "LandscapeInverted";
    emit orientationChanged();
    break;
  case QOrientationReading::LeftUp:
    m_state = "Portrait";
    emit orientationChanged();
    break;
  case QOrientationReading::RightUp:
    m_state = "PortraitInverted";
    emit orientationChanged();
  default:
    break;
  }
#endif
}
