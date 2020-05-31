#ifndef LOGIN_H
#define LOGIN_H

#include <QDialog>

namespace Ui {
class Login;
}

class Login : public QDialog
{
    Q_OBJECT
public:
    bool bl = false;
    QString os;

public:
    explicit Login(QWidget *parent = 0);
    ~Login();

private slots:
    bool on_bt_login_clicked();
    void on_bt_quit_clicked();

private:
    Ui::Login *ui;
public:
    bool ret_bool(bool bl=false);
};

#endif // LOGIN_H
