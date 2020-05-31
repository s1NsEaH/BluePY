#ifndef SEARCHING_H
#define SEARCHING_H

#include <QDialog>
#include <QWidgetItem>
#include "QMessageBox"
#include <QProcess>
#include <QDir>
#include <QTimer>
#include <QListWidgetItem>

namespace Ui {
class Searching;
}

class Searching : public QDialog
{
    Q_OBJECT

public:
    explicit Searching(QWidget *parent = 0);
    void SetList(QString);
    ~Searching();

    void SearchServer();
    void PrintText(QString , int);
    void PrintText2(QString , int);
public slots:
    void myfunction();
private slots:
    void on_SV_list_itemClicked(QListWidgetItem *item);

private:
    Ui::Searching *ui;
    QTimer *timer;
};

#endif // SEARCHING_H
