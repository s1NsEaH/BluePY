#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTreeWidgetItem>
#include <QProcess>
#include <QDir>
#include "chart.h"
#include "server.h"
#include "check.h"
#include "information.h"
#include "setting.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_treeWidget_clicked(const QModelIndex &index);

    void on_treeWidget_itemClicked(QTreeWidgetItem *item, int column);

    void on_actionServer_triggered();

    void on_actionQuit_triggered();

    void on_actionFinder_triggered();

    void on_actionSearch_triggered();

    void on_actionHome_triggered();

    void on_actionInfo_triggered();

    void on_BT_Server_clicked();

    void on_BT_Search_clicked();

    void on_BT_Explorer_clicked();

    void on_BT_Home_clicked();

    void on_BT_Save_clicked();

    void on_actionSave_triggered();

    void on_BT_Exit_clicked();

    void on_BT_Help_clicked();

    void on_actionHelp_triggered();

    void on_BT_Info_clicked();

    void on_comboBox_currentIndexChanged(int index);

    void on_BT_Config_clicked();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
