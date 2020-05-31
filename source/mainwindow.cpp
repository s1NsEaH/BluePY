#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QTextStream>
#include <QGraphicsOpacityEffect>
#include <QImage>
#include <QPixmap>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    //Qt
    this->setWindowFlags(Qt::FramelessWindowHint);
    ui->setupUi(this);
    ui->stackedWidget->setCurrentIndex(0);
//    qDebug() << ui->page_main->windowOpacity();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_treeWidget_itemClicked(QTreeWidgetItem *item, int column)
{
    if(item->text(0)=="Chart")
    {
        ui->stackedWidget->setCurrentIndex(1);
        if(item->parent()->parent()->text(0)=="Linux")
        {
            QString a;
            QList<int> Risk;
            //QMessageBox::information(0,"TITLE", "HELLO", 0, 0);

            {
                Risk.append(2); //1
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(1); //5
                Risk.append(0);
                Risk.append(1);
                Risk.append(1);
                Risk.append(1);
                Risk.append(0); //10
                Risk.append(0);
                Risk.append(0);
                Risk.append(1);
                Risk.append(0);
                Risk.append(0); //15
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);  //20
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);  //25
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(0); //30
                Risk.append(1);
                Risk.append(1);
                Risk.append(1);
                Risk.append(1);
                Risk.append(0);  //35
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);  //40
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);  //45
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);  //50
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);  //55
                Risk.append(2);
                Risk.append(2);
                Risk.append(2);
                Risk.append(1);
                Risk.append(0);  //60
                Risk.append(1);
                Risk.append(0);
                Risk.append(1);
                Risk.append(1);
                Risk.append(1);  //65
                Risk.append(1);
                Risk.append(0);
                Risk.append(1);
                Risk.append(1);
                Risk.append(1);  //70
                Risk.append(2);
                Risk.append(2);
                Risk.append(0); //73
            }
            //QMessageBox::information(0,"TITLE", "HELLO2", 0, 0);
            QString filePath = QDir::currentPath();
            QString filePath2 = QDir::currentPath();

            filePath+="/";
            filePath+=item->parent()->text(0);
    //        QMessageBox::information(0, "TITLE", filePath, 0, 0);
            filePath+="/report_excel.txt";
            QFile file(filePath);
            if(!file.open(QIODevice::ReadOnly))
                QMessageBox::information(0,"ERROR", file.errorString());

            filePath2+="/report/explain.txt";
            QFile file2(filePath2);
            if(!file2.open(QIODevice::ReadOnly))
                QMessageBox::information(0,"ERROR", file.errorString());

            QTextStream in(&file);
            in.readLine();

            QString _ret="";
            _ret+=in.readLine();
            _ret+=in.readLine();
            _ret+=in.readLine();
            _ret+=in.readLine();
            _ret+=in.readLine();

            QTextStream in2(&file2);

            ui->tableWidget->setRowCount(73);
            for(int i=1;i<=73;i++)
            {
                QString temp;
                temp=temp.setNum(i);
                a="L-";
                a+=temp;
                QString mRisk;
                if(Risk[i-1]==0)
                    mRisk="Low";
                else if(Risk[i-1]==1)
                    mRisk="Middle";
                else if(Risk[i-1]==2)
                    mRisk="High";

                QString VALRET;
                if(_ret[i-1]=='0')
                    VALRET="GOOD";
                else if(_ret[i-1]=='1')
                    VALRET="BAD";
                else if(_ret[i-1]=='2')
                    VALRET="HOLD";


                QTableWidgetItem *CODE = new QTableWidgetItem();
                QTableWidgetItem *RISK = new QTableWidgetItem();
                QTableWidgetItem *RESULT = new QTableWidgetItem();
                QTableWidgetItem *EXPLAIN = new QTableWidgetItem();

                CODE->setText(a);
                RISK->setText(mRisk);
                RESULT->setText(VALRET);
                EXPLAIN->setText(in2.readLine());

                ui->tableWidget->setColumnWidth(3,this->width()/3);
                ui->tableWidget->setItem(i-1, 0, CODE);
                ui->tableWidget->setItem(i-1, 1, RISK);
                ui->tableWidget->setItem(i-1, 2, RESULT);
                ui->tableWidget->setItem(i-1, 3, EXPLAIN);

                if(VALRET=="GOOD")
                {
                    CODE->setBackgroundColor(Qt::green);
                    RISK->setBackgroundColor(Qt::green);
                    RESULT->setBackgroundColor(Qt::green);
                    EXPLAIN->setBackgroundColor(Qt::green);
                }
                else if(VALRET=="BAD")
                {
                    CODE->setBackgroundColor(Qt::red);
                    RISK->setBackgroundColor(Qt::red);
                    RESULT->setBackgroundColor(Qt::red);
                    EXPLAIN->setBackgroundColor(Qt::red);
                }
                else if(VALRET=="HOLD")
                {
                    CODE->setBackgroundColor(Qt::gray);
                    RISK->setBackgroundColor(Qt::gray);
                    RESULT->setBackgroundColor(Qt::gray);
                    EXPLAIN->setBackgroundColor(Qt::gray);
                }
            }

        }
        else
        {
            QString a;
            QList<int> Risk;

            QString filePath = QDir::currentPath();
            QString filePath2 = QDir::currentPath();

            filePath+="/";
            filePath+=item->parent()->text(0);
    //        QMessageBox::information(0, "TITLE", filePath, 0, 0);
            filePath+="/excel_data.txt";
            QFile file(filePath);
            if(!file.open(QIODevice::ReadOnly))
                QMessageBox::information(0,"ERROR", file.errorString());

            filePath2+="/report/explain2.txt";
            QFile file2(filePath2);
            if(!file2.open(QIODevice::ReadOnly))
                QMessageBox::information(0,"ERROR", file.errorString());

            QTextStream in(&file);

            QString _ret="";
            _ret+=in.readLine();

            QString _rk = "";
            _rk+=in.readLine();

            for(int i=0;i<82;i++)
            {
                if(_rk[i]=='0')
                    Risk.append(0);
                else if(_rk[i]=='1')
                    Risk.append(1);
                if(_rk[i]=='2')
                    Risk.append(2);
            }

            QTextStream in2(&file2);

            ui->tableWidget->setRowCount(82);
            for(int i=1;i<=82;i++)
            {
                QString temp;
                temp=temp.setNum(i);
                a="W-";
                a+=temp;
                QString mRisk;
                if(Risk[i-1]==0)
                    mRisk="Low";
                else if(Risk[i-1]==1)
                    mRisk="Middle";
                else if(Risk[i-1]==2)
                    mRisk="High";

                QString VALRET;
                if(_ret[i-1]=='0')
                    VALRET="GOOD";
                else if(_ret[i-1]=='1')
                    VALRET="BAD";
                else if(_ret[i-1]=='2')
                    VALRET="HOLD";


                QTableWidgetItem *CODE = new QTableWidgetItem();
                QTableWidgetItem *RISK = new QTableWidgetItem();
                QTableWidgetItem *RESULT = new QTableWidgetItem();
                QTableWidgetItem *EXPLAIN = new QTableWidgetItem();

                CODE->setText(a);
                RISK->setText(mRisk);
                RESULT->setText(VALRET);
                EXPLAIN->setText(in2.readLine());

                ui->tableWidget->setColumnWidth(3,this->width()/3);
                ui->tableWidget->setItem(i-1, 0, CODE);
                ui->tableWidget->setItem(i-1, 1, RISK);
                ui->tableWidget->setItem(i-1, 2, RESULT);
                ui->tableWidget->setItem(i-1, 3, EXPLAIN);

                if(VALRET=="GOOD")
                {
                    CODE->setBackgroundColor(Qt::green);
                    RISK->setBackgroundColor(Qt::green);
                    RESULT->setBackgroundColor(Qt::green);
                    EXPLAIN->setBackgroundColor(Qt::green);
                }
                else if(VALRET=="BAD")
                {
                    CODE->setBackgroundColor(Qt::red);
                    RISK->setBackgroundColor(Qt::red);
                    RESULT->setBackgroundColor(Qt::red);
                    EXPLAIN->setBackgroundColor(Qt::red);
                }
                else if(VALRET=="HOLD")
                {
                    CODE->setBackgroundColor(Qt::gray);
                    RISK->setBackgroundColor(Qt::gray);
                    RESULT->setBackgroundColor(Qt::gray);
                    EXPLAIN->setBackgroundColor(Qt::gray);
                }
            }
        }
    }
    if(item->text(0)=="Report")
    {
        ui->stackedWidget->setCurrentIndex(2);
        ui->comboBox->clear();
        QList<QTableWidgetItem*> badItems;
        QStringList cmbItems;
        badItems = ui->tableWidget->findItems("BAD", 0);

        int _cnt = badItems.length();
        for(int i=0;i<_cnt; i++)
        {
             cmbItems.append(ui->tableWidget->item(badItems[i]->row(), 0)->text());
        }
        ui->comboBox->addItems(cmbItems);
    }
}


void MainWindow::on_treeWidget_clicked(const QModelIndex &index)
{

}

void MainWindow::on_actionServer_triggered()
{
    Server  server;
    server.setModal(true);
    server.exec();

    QString _OS = server.os;
    QTreeWidgetItem *OsItem;
    if(_OS=="Linux")
    {
        OsItem = ui->treeWidget->topLevelItem(0);
    }
    else if(_OS=="Window")
    {
        OsItem = ui->treeWidget->topLevelItem(1);
    }
    else{
        return ;
    }

    QString _ip="";
    _ip+=server.ip[0];
    _ip+=".";
    _ip+=server.ip[1];
    _ip+=".";
    _ip+=server.ip[2];
    _ip+=".";
    _ip+=server.ip[3];

    int _cntLinux = ui->treeWidget->topLevelItem(0)->childCount();
    int _cntWindow = ui->treeWidget->topLevelItem(1)->childCount();
    for(int i=0;i<_cntLinux;i++)
    {
        if(_ip==ui->treeWidget->topLevelItem(0)->child(i)->text(0))
        {
            QMessageBox::warning(0,"ERROR", "SERVER IS ALREADY EXIST", 0, 0);
            return ;
        }
    }
    for(int i=0;i<_cntWindow;i++)
    {
        if(_ip==ui->treeWidget->topLevelItem(1)->child(i)->text(0))
        {
            QMessageBox::warning(0,"ERROR", "SERVER IS ALREADY EXIST", 0, 0);
            return ;
        }
    }

    QTreeWidgetItem *ipItem = new QTreeWidgetItem(OsItem);
    ipItem->setText(0, _ip);
}

void MainWindow::on_actionQuit_triggered()
{
    QMessageBox::StandardButton reply;
    reply = QMessageBox::question(this, "QUIT", "Exit Program?", QMessageBox::Yes | QMessageBox::Cancel);

    if(reply == QMessageBox::Yes)
    {
        close();
    }
    else if(reply == QMessageBox::Cancel)
    {

    }
}

void MainWindow::on_actionFinder_triggered()
{
    QProcess *process = new QProcess(this);
    process->start("explorer.exe",QStringList() << QDir::currentPath());
}

void MainWindow::on_actionSearch_triggered()
{
    Check check;
    check.setModal(true);
    int _cntLinux = ui->treeWidget->topLevelItem(0)->childCount();
    int _cntWindow = ui->treeWidget->topLevelItem(1)->childCount();
    for(int i=0;i<_cntLinux;i++)
    {
        check.SetLeft(ui->treeWidget->topLevelItem(0)->child(i)->text(0));
    }
    for(int i=0;i<_cntWindow;i++)
    {
        check.SetLeft(ui->treeWidget->topLevelItem(1)->child(i)->text(0));
    }

    check.exec();
    QList<QString> ch_sv_list = check.ch_sv_list;
//    QMessageBox::information(0, "TITLE", "HELLO", 0, 0);
    int _cnt = ch_sv_list.length();
    if(_cnt==0)
    {
        return ;
    }
    {
        QTreeWidgetItem * lqitem, * wqitem;
        lqitem = ui->treeWidget->topLevelItem(0);
        wqitem = ui->treeWidget->topLevelItem(1);

        int _lcnt = lqitem->childCount();
        int _wcnt = wqitem->childCount();
        for(int i=0;i<_cnt;i++)
        {
            if(_lcnt==0)
            {

            }else
            {
                for(int j=0;j<_lcnt;j++)
                {
                    if(lqitem->child(j)->text(0)==ch_sv_list[i] && lqitem->child(j)->childCount()==0)
                    {
                        QTreeWidgetItem * l1 = new QTreeWidgetItem(lqitem->child(j), QStringList() << "Chart");
                        QTreeWidgetItem * l2 = new QTreeWidgetItem(lqitem->child(j), QStringList() << "Report");
                    }
                }
            }
            if(_wcnt==0)
            {

            }else{
                for(int j=0;j<_wcnt;j++)
                {
                    if(wqitem->child(j)->text(0)==ch_sv_list[i] && wqitem->child(j)->childCount()==0)
                    {
                        QTreeWidgetItem * l1 = new QTreeWidgetItem(wqitem->child(j), QStringList() << "Chart");
                        QTreeWidgetItem * l2 = new QTreeWidgetItem(wqitem->child(j), QStringList() << "Report");
                    }
                }
            }
        }
    }
}

void MainWindow::on_actionHome_triggered()
{
    ui->stackedWidget->setCurrentIndex(0);
}

void MainWindow::on_actionInfo_triggered()
{
    Information info;
    info.setModal(true);
    info.exec();
}

void MainWindow::on_BT_Server_clicked()
{
    this->on_actionServer_triggered();
}

void MainWindow::on_BT_Search_clicked()
{
    this->on_actionSearch_triggered();
}


void MainWindow::on_BT_Explorer_clicked()
{
    this->on_actionFinder_triggered();
}


void MainWindow::on_BT_Home_clicked()
{
    this->on_actionHome_triggered();
}


void MainWindow::on_BT_Save_clicked()
{
    this->on_actionSave_triggered();
}

void MainWindow::on_actionSave_triggered()
{

}

void MainWindow::on_BT_Exit_clicked()
{
    this->on_actionQuit_triggered();
}


void MainWindow::on_BT_Help_clicked()
{
    this->on_actionHelp_triggered();
}

void MainWindow::on_actionHelp_triggered()
{

}

void MainWindow::on_BT_Info_clicked()
{
    this->on_actionInfo_triggered();
}

void MainWindow::on_comboBox_currentIndexChanged(int index)
{
    QImage *Img = new QImage();
    QPixmap *buffer = new QPixmap();
    QString filePath;
    if(ui->comboBox->itemText(index).left(1)=="L")
        filePath = ":/resource/report/LINUX/";
    else
        filePath = ":/resource/report/WINDOW/";

//    QMessageBox::information(0,"TITLE", filePath, 0, 0);

    if(ui->comboBox->itemText(index).length()==3)
        filePath += ui->comboBox->itemText(index).right(1);
    else
        filePath += ui->comboBox->itemText(index).right(2);
    filePath += ".PNG";

    if(Img->load(filePath))
    {
        *buffer = QPixmap::fromImage(*Img);
        *buffer = buffer->scaled(Img->width(), Img->height());
    }
    else
    {
    }

    ui->report_img->setPixmap(*buffer);
    ui->report_img->resize(buffer->width(), buffer->height());
    ui->report_img->move(0,0);
}

void MainWindow::on_BT_Config_clicked()
{
    Setting setting;
    setting.exec();
}
