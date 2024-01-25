#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QDebug>
#include <QtMultimedia/QtMultimedia>
#include <QtMultimediaWidgets/QVideoWidget>
#include <QUrl>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked() {
    qDebug("Button Pressed!");
    QMediaPlayer* player = new QMediaPlayer;
    QVideoWidget* videoWidget = ui->videoBox;
    player->setVideoOutput(videoWidget);
    player->setSource(QUrl("http://thinkingform.com/wp-content/uploads/2017/09/video-sample-mp4.mp4"));
    player->play();
}
