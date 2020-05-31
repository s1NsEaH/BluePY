#include "setting.h"
#include "ui_setting.h"
#include <QMessageBox>
#include <QDir>
#include <QFile>
#include <QTextStream>

Setting::Setting(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Setting)
{
    ui->setupUi(this);
    this->setWindowFlags(Qt::FramelessWindowHint);
}

Setting::~Setting()
{
    delete ui;
}

void Setting::on_pushButton_2_clicked()
{
    if(ui->username->text()=="" || ui->username->text()=="")
        QMessageBox::warning(0, "ERROR", "Insert Username and Password", 0, 0);

    QString filePath = QDir::currentPath();
    filePath+="/";
    filePath+="account.txt";

    QFile file(filePath);
    file.open(QFile::WriteOnly | QFile::Text);
    QTextStream out(&file);

    out << ui->username->text() << "\n" << ui->password->text();
    file.flush();
    file.close();

    close();
}


void Setting::on_pushButton_clicked()
{
    close();
}
