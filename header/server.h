#ifndef SERVER_H
#define SERVER_H

#include <QDialog>
#include <QMessageBox>

namespace Ui {
class Server;
}

class Server : public QDialog
{
    Q_OBJECT
public:
    QString ip[4];
    QString os="NONE";
public:
    explicit Server(QWidget *parent = 0);
    ~Server();

private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

private:
    Ui::Server *ui;
};

#endif // SERVER_H
