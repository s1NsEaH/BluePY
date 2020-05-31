#include "searching.h"
#include "ui_searching.h"
#include <QDebug>
#include <QThread>

Searching::Searching(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Searching)
{
    this->setWindowFlags(Qt::FramelessWindowHint);
    ui->setupUi(this);
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(myfunction()));
    timer->start(10);
}

Searching::~Searching()
{
    delete ui;
}

void Searching::SearchServer()
{
    ui->progressBar->setValue(0);
    int _cnt = ui->SV_list->count();     
    QListWidgetItem *qitem;
    QProcess *runScript = new QProcess(this);
    QProcess *runScript2 = new QProcess(this);
    QProcess *SortReportFile = new QProcess(this);
    QProcess *SortReportFile2 = new QProcess(this);
    QDir _qDir = QDir::current();

    ui->plainTextEdit->setPlainText("SUCCESS : Server list loading");
    ui->plainTextEdit->repaint();
//    QMessageBox::information(0,"HELLO", "TITLE", 0,0);
//    qDebug() << _qDir.currentPath();
//    QMessageBox::information(0,"TITLE", process->workingDirectory(), 0, 0);
    for(int i=0;i<_cnt;i++)
    {
        ui->progressBar->setValue(0);
        qitem = ui->SV_list->takeItem(0);
        ui->SV_list->repaint();
        ui->plainTextEdit->appendPlainText("START : "+ qitem->text()+" Server");
        ui->plainTextEdit->repaint();
        _qDir.mkdir(qitem->text());
        ui->plainTextEdit->appendPlainText("SUCCESS : Create Folder");
        ui->plainTextEdit->repaint();
        runScript->setWorkingDirectory(_qDir.currentPath());
        SortReportFile->setWorkingDirectory(_qDir.currentPath());
        runScript2->setWorkingDirectory(_qDir.currentPath());
        SortReportFile2->setWorkingDirectory(_qDir.currentPath());
//        qDebug() << CreateFolder->workingDirectory();
        if(i<2)
        {
            runScript->start("./manager/Script_For_Manager.exe", QStringList() << qitem->text());
            runScript->waitForFinished();
            runScript->close();

            runScript2->start("./analasis/Linux_Check_2.exe", QStringList() << qitem->text());
            runScript2->waitForFinished();
            runScript2->close();

            SortReportFile->start("SET_IP_SORT.bat", QStringList() << qitem->text());
            SortReportFile->waitForFinished();
            SortReportFile->close();

            SortReportFile2->start("SET_IP_SORT_2.bat", QStringList() << qitem->text());
            SortReportFile2->waitForFinished();
            SortReportFile2->close();
            PrintText(qitem->text(),0);
        }else{
            runScript->start("./manager_window/Script_For_Manager_window.exe", QStringList() <<qitem->text());
            runScript->waitForFinished();
            runScript->close();

            SortReportFile->start("SET_IP_SORT_window.bat", QStringList() << qitem->text());
            SortReportFile->waitForFinished();
            SortReportFile->close();

            runScript2->start("./analasis2/xlsx_to_txt.exe", QStringList() << QDir::currentPath() << qitem->text());
            runScript2->waitForFinished();
            runScript2->close();
            PrintText2(qitem->text(),1);
        }
    }
    QMessageBox::StandardButton reply;
    reply = QMessageBox::information(this, "COMPLETE", "Check and Analasis is Complete!!", QMessageBox::Yes);

    if(reply == QMessageBox::Yes)
    {
        close();
    }
}

void Searching::PrintText(QString ipaddr, int os)
{
    QString line;
    QString _cnt;
    int valNum = 0;
    if(os==0)
        line = "CHECK : L-";
    else if(os==1)
        line = "CHECK : W-";
    for(int i=1;i<=73;i++)
    {
        _cnt=_cnt.setNum(i);
        valNum++;
        ui->progressBar->setValue(valNum);
        ui->plainTextEdit->appendPlainText(line+_cnt);
        ui->plainTextEdit->repaint();
    }
    ui->plainTextEdit->appendPlainText("SUCCESS : Check server");
    ui->plainTextEdit->repaint();
    ui->plainTextEdit->appendPlainText("START : Analasis result");
    ui->plainTextEdit->repaint();
    if(os==0)
        line = "Analasis : L-";
    else if(os==1)
        line = "Analasis : W-";
    for(int i=1;i<=73;i++)
    {
        _cnt=_cnt.setNum(i);
        valNum++;
        ui->progressBar->setValue(valNum);
        ui->plainTextEdit->appendPlainText(line+_cnt);
        ui->plainTextEdit->repaint();
    }
}

void Searching::PrintText2(QString ipaddr, int os)
{
    QString line;
    QString _cnt;
    int valNum = 0;
    if(os==0)
        line = "CHECK : L-";
    else if(os==1)
        line = "CHECK : W-";
    ui->progressBar->setMaximum(164);
    for(int i=1;i<=82;i++)
    {
        _cnt=_cnt.setNum(i);
        valNum++;
        ui->progressBar->setValue(valNum);
        ui->plainTextEdit->appendPlainText(line+_cnt);
        ui->plainTextEdit->repaint();
    }
    ui->plainTextEdit->appendPlainText("SUCCESS : Check server");
    ui->plainTextEdit->repaint();
    ui->plainTextEdit->appendPlainText("START : Analasis result");
    ui->plainTextEdit->repaint();
    if(os==0)
        line = "Analasis : L-";
    else if(os==1)
        line = "Analasis : W-";
    for(int i=1;i<=82;i++)
    {
        _cnt=_cnt.setNum(i);
        valNum++;
        ui->progressBar->setValue(valNum);
        ui->plainTextEdit->appendPlainText(line+_cnt);
        ui->plainTextEdit->repaint();
    }
}

void Searching::myfunction()
{
//    QMessageBox::information(0, "TITLE", ui->SV_list->takeItem(0)->text(), 0, 0);
    timer->stop();
    ui->plainTextEdit->setReadOnly(true);
    SearchServer();

    //    qDebug() << "update..";
}

void Searching::SetList(QString ip)
{
    ui->SV_list->addItem(ip);
}

void Searching::on_SV_list_itemClicked(QListWidgetItem *item)
{
}
