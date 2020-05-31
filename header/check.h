#ifndef CHECK_H
#define CHECK_H

#include <QDialog>
#include <QListWidgetItem>
#include <QMessageBox>
#include "searching.h"

namespace Ui {
class Check;
}

class Check : public QDialog
{
    Q_OBJECT
private:
    QListWidgetItem *qitem=0;
public:
    QList<QString> ch_sv_list;

public:
    explicit Check(QWidget *parent = 0);
    void SetLeft(QString);
    ~Check();

private slots:
    void on_SetRight_clicked();

    void on_SetLeft_clicked();

    void on_LeftWG_itemClicked(QListWidgetItem *item);

    void on_setRight_clicked();

    void on_RightWG_itemClicked(QListWidgetItem *item);

    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

private:
    Ui::Check *ui;
};

#endif // CHECK_H
