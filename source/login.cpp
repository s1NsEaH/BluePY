#include "login.h"
#include "ui_login.h"

#include <QMessageBox>
#include <QFile>
#include <QDir>
#include <QTextStream>

Login::Login(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Login)
{
    this->setWindowFlags(Qt::FramelessWindowHint);
//    this->setAttribute(Qt::WA_TranslucentBackground);
    ui->setupUi(this);
}

Login::~Login()
{
    delete ui;
}

bool Login::on_bt_login_clicked()
{
    QString username = ui->username->text();
    QString password = ui->password->text();
    QString filePath = QDir::currentPath();
    filePath+="/";
    filePath+="account.txt";

    QFile file(filePath);

    if(!file.open(QIODevice::ReadOnly))
        QMessageBox::information(0,"ERROR", file.errorString());

    QTextStream in(&file);

    QString setUsername = in.readLine();
    QString setPassword = in.readLine();

    if(username==setUsername && password==setPassword)
    {
        bl=true;
        close();
    }
    else
    {
        QMessageBox::information(0,"ERROR", "Password Incorrect", 0, 0);
    }
}

void Login::on_bt_quit_clicked()
{
    close();
}
