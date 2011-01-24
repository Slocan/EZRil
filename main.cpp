#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "utility.h"
#include <QDeclarativeContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    Utility *utility = new Utility(qApp, &viewer);
    //QDeclarativeContext *context = viewer.rootContext();

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.rootContext()->setContextProperty("utility", utility);
    viewer.setMainQmlFile(QLatin1String("qml/EZRil/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
