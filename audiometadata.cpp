#include "audiometadata.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <QString>

QString songName,artistName;

typedef struct {
    char tag[3];
    char title[30];
    char artist[30];
    char album[30];
    char year[4];
    char comment[30];
    unsigned char genre;
} ID3v1;

typedef struct {
    char tag[3];
    char title[30];
    char artist[30];
    char album[30];
    char year[4];
    char comment[30];
    unsigned char genre;
    unsigned int track;
} ID3v1_1;

typedef struct {
    char tag[3];
    char title[30];
    char artist[30];
    char album[30];
    char year[4];
    char comment[30];
    unsigned char genre;
    unsigned int track;
} ID3v2;

void print_id3v1(ID3v1 tag) {
    songName=tag.title;
    artistName=tag.artist;
}

void print_id3v1_1(ID3v1_1 tag) {
    songName=tag.title;
    artistName=tag.artist;
}

void print_id3v2(ID3v2 tag) {
    songName=tag.title;
    artistName=tag.artist;
}
void metaDataExtractor(QString filePath)
{
    FILE *fp;
    ID3v1 tag1;
    ID3v1_1 tag1_1;
    ID3v2 tag2;
    std::string str = filePath.toStdString();
    const char *cstr = str.c_str();
    fp = fopen(cstr, "rb");
    if (fp == NULL) {
        printf("Error opening file\n");
        //exit(EXIT_FAILURE);
    }
    fseek(fp, -128, SEEK_END);
    fread((void*)&tag1, sizeof(ID3v1), 1, fp);
    if (strncmp(tag1.tag, "TAG", 3) == 0) {
        print_id3v1(tag1);
        fclose(fp);
    }

    fseek(fp, -128, SEEK_END);
    fread((void*)&tag1_1, sizeof(ID3v1_1), 1, fp);
    if (strncmp(tag1_1.tag, "TAG", 3) == 0) {
        print_id3v1_1(tag1_1);
        fclose(fp);
    }

    fseek(fp, 0, SEEK_SET);
    fread((void*)&tag2, sizeof(ID3v2), 1, fp);
    if (strncmp(tag2.tag, "ID3", 3) == 0) {
        print_id3v2(tag2);
    }
    fclose(fp);
}
AudioMetaData::AudioMetaData(QObject *parent)
    : QObject{parent}
{
}
void AudioMetaData::fileChange(const QString filePath)
{
    metaDataExtractor(filePath);
    emit songNameChanged(songName);
    emit artistNameChanged(artistName);
}
QString AudioMetaData::listFileChange(const QString filePath)
{
    metaDataExtractor(filePath);
    QString str;
    strcat(songName,"//");
    strcat(songName,artistName);
    return std::tie(songName);
}
