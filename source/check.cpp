#include "check.h"
#include "ui_check.h"

Check::Check(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Check)
{
    this->setWindowFlags(Qt::FramelessWindowHint);
    ui->setupUi(this);
}

void Check::SetLeft(QString item)
{
    ui->LeftWG->addItem(item);
}

Check::~Check()
{
    delete ui;
}

void Check::on_SetRight_clicked()
{
//    QList<QListWidgetItem *> _QLitem = ui->LeftWG->selectedItems();
//    ui->LeftWG->selectedItems()
//    int _qlen = _QLitem.size();
//    ui->RightWG->addItem(_QLitem[0]->text());
    if(qitem==0)
    {
        return ;
    }
    ui->LeftWG->takeItem(ui->LeftWG->currentRow());
    ui->RightWG->addItem(qitem->text());
    qitem=0;
}

void Check::on_SetLeft_clicked()
{
    if(qitem==0)
    {
        return ;
    }
    ui->RightWG->takeItem(ui->RightWG->currentRow());
    ui->LeftWG->addItem(qitem->text());
    qitem=0;
}

void Check::on_LeftWG_itemClicked(QListWidgetItem *item)
{
    qitem=item;
}

void Check::on_setRight_clicked()
{

}


void Check::on_RightWG_itemClicked(QListWidgetItem *item)
{
    qitem=item;
}

void Check::on_pushButton_clicked()
{
    int i=ui->RightWG->count();
    if(!i)
    {
        QMessageBox::warning(0,"ERROR", "Server not selected",0,0);
        return ;
    }
    for(int j=0;j<i;j++)
    {
        ch_sv_list.append(ui->RightWG->item(j)->text());
    }
    Searching srch;
    srch.setModal(true);
    for(int j=0;j<i;j++)
    {
        srch.SetList(ui->RightWG->item(j)->text());
    }
    close();
    srch.exec();
}

void Check::on_pushButton_2_clicked()
{
    close();
}
