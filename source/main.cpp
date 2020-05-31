#include "mainwindow.h"
#include "login.h"
#include <QApplication>
#include <QMessageBox>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Login  login;
    login.exec();
    bool bl = login.bl;

    if(bl)
    {
        MainWindow w;
        w.show();

        return a.exec();
    }
}
