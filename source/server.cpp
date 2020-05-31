#include "server.h"
#include "ui_server.h"

Server::Server(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Server)
{
    this->setWindowFlags(Qt::FramelessWindowHint);
    ui->setupUi(this);
}

Server::~Server()
{
    delete ui;
}

void Server::on_pushButton_clicked()
{
    ip[0]=ui->IP_1->text();
    ip[1]=ui->IP_2->text();
    ip[2]=ui->IP_3->text();
    ip[3]=ui->IP_4->text();

    for(int i=0;i<4;i++)
    {
        if(ip[i].toInt()>=255)
        {
            QMessageBox::warning(0,"ERROR", "IP ADDR IS ERROR!!", 0, 0);
            return ;
        }
    }


    if(ui->Linux->isChecked())
    {
        os="Linux";
    }
    else if(ui->Window->isChecked())
    {
        os="Window";
    }
    else
    {
        QMessageBox::warning(0,"ERROR", "NO SERVER SELECTED", 0, 0);
        return ;
    }

    close();
}

void Server::on_pushButton_2_clicked()
{
    destroy();
}
