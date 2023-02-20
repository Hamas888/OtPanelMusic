#ifndef AUDIOMETADATA_H
#define AUDIOMETADATA_H

#include <QObject>

class AudioMetaData : public QObject
{
    Q_OBJECT
public:
    explicit AudioMetaData(QObject *parent = nullptr);

signals:
    void songNameChanged(QString song);
    void artistNameChanged(QString artist);
public slots:
    void fileChange(const QString filePath);
    QString listFileChange(const QString filePath);
};

#endif // AUDIOMETADATA_H
