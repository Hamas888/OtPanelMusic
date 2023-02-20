import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.4
import QtQml.Models 2.11
import QtMultimedia 5.15
import Qt.labs.folderlistmodel 2.15
//import "qrc:/cdnjs/jsmediatags.min.js" as Jsmediatags

Window {
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Music Player")
    color: "#012E46"
    function milliSecondsToString(miliseconds){
        miliseconds = miliseconds > 0 ? miliseconds : 0
        var timeInSeconds = Math.floor(miliseconds/1000)
        var minutes = Math.floor(timeInSeconds/60)
        var minutesString = minutes < 10 ? "0" + minutes : minutes
        var seconds = Math.floor(timeInSeconds%60)
        var secondsString = seconds < 10 ? "0" + seconds : seconds
        return minutesString + ":" + secondsString
    }
    Rectangle{
        id: mainRec
        width: 1677
        height: 1080
        color: "#5784A6"
        radius: 25
        anchors.right: parent.right
        Rectangle{
            width: 25
            height: 1080
            color: "#5784A6"
            anchors.right: parent.right
        }
        // Music Bar Area
        Rectangle{
            id: musicBar
            width: 887
            height: 121
            color: "#012E46"
            radius: 20
            anchors.left: parent.left
            anchors.leftMargin: 67
            anchors.top: parent.top
            anchors.topMargin: 308
            visible: true
            Rectangle{
                width: 887
                height: 20
                color: "#012E46"
                anchors.bottom: parent.bottom
            }
            // Multimedia


            MediaPlayer{
                id: musicfile
                audioRole: MediaPlayer.MusicRole
                volume: 0.1
                property string filePath: "file:Music/After All.mp3"
                source: filePath
                autoLoad: true
                onStatusChanged: {
                    //console.log(musicfile.metaData.mediaType)
                }

            }
            // Music ProgressBar

            Slider{
                id: musicSlider
                anchors.left: musicBar.left
                anchors.leftMargin: 112
                anchors.top: musicBar.top
                //enabled: musicfile.seekable
                anchors.topMargin: 90
//                from: 0
                value: musicfile.duration>0?musicfile.position/musicfile.duration:0
//                to: musicfile.duration
                background: Rectangle {
                         x: musicSlider.leftPadding
                         y: musicSlider.topPadding + musicSlider.availableHeight / 2 - height / 2
                         implicitWidth: 550
                         implicitHeight: 6
                         width: musicSlider.availableWidth
                         height: implicitHeight
                         radius: 3
                         color: "#bdbebf"

                         Rectangle {
                             width: musicSlider.visualPosition * parent.width
                             height: parent.height
                             color: "#40C3FF"
                             radius: 3
                         }
                     }
                handle: Rectangle {
                        x: musicSlider.leftPadding + musicSlider.visualPosition * (musicSlider.availableWidth - width)
                        y: musicSlider.topPadding + musicSlider.availableHeight / 2 - height / 2
                        implicitWidth: 21
                        implicitHeight: 21
                        radius: 21/2
                        color: musicSlider.pressed ? "#40C3FF" : "white"
                        border.color: "white"
                    }
                onMoved: function(){
                    musicfile.seek(musicfile.duration * musicSlider.position)
                }

            }
            Label{
                width: 20
                height: 12
                text: milliSecondsToString(musicfile.position)
                font.family: "Inter"
                color: "white"
                font.pixelSize: 10
                anchors.left: musicSlider.left
                anchors.leftMargin: 6
                anchors.bottom: musicSlider.top
                anchors.bottomMargin: 1
            }
            Label{
                width: 20
                height: 12
                text: milliSecondsToString(musicfile.duration - musicfile.position)
                font.family: "Inter"
                color: "white"
                font.pixelSize: 10
                anchors.right: musicSlider.right
                anchors.rightMargin: 12
                anchors.bottom: musicSlider.top
                anchors.bottomMargin: 1
            }
            Item{
                id: player
                width: 120
                height: 50
                anchors.right: musicBar.right
                anchors.rightMargin: 30
                anchors.bottom: musicBar.bottom
                anchors.bottomMargin: 15
                Rectangle{
                    id: prev
                    width: 22
                    height: 22
                    radius: 22/2
                    color: "transparent"
                    anchors.left: player.left
                    anchors.top: player.top
                    anchors.topMargin: 14
                    Image {
                        id: prevIcon
                        anchors.fill: parent
                        source: "qrc:/Pics/prev.png"
                    }
                }
                Rectangle{
                    id: next
                    width: 22
                    height: 22
                    radius: 22/2
                    color: "transparent"
                    anchors.right: player.right
                    anchors.top: player.top
                    anchors.topMargin: 14
                    Image {
                        id: nextIcon
                        anchors.fill: parent
                        source: "qrc:/Pics/next.png"
                    }
                }
                Rectangle{
                    id: playButton
                    width: 50
                    height: 50
                    radius: 50/2
                    color: "white"
                    anchors.horizontalCenter: player.horizontalCenter
                    property bool playButtonFlag: false
                    Rectangle{
                        width: 46
                        height: 46
                        radius: 46/2
                        color:"#102E46"
                        anchors.centerIn: parent
                        Rectangle{
                            id: play
                            width: 42
                            height: 42
                            radius: 42/2
                            color: "#04517A"
                            anchors.centerIn: parent
                            Image {
                                anchors.centerIn: parent
                                id: playIcon
                                source: "qrc:/Pics/play.png"

                            }
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            playButton.playButtonFlag = (playButton.playButtonFlag)? false : true
                            playIcon.source = (playButton.playButtonFlag)? "qrc:/Pics/pause.png" : "qrc:/Pics/play.png"
                            //console.log(musicfile.metaData.title)
                            AudioMetaData.fileChange(musicfile.filePath.replace("file:",""))
                            if(playButton.playButtonFlag)
                            {
                                musicfile.play()
                            }
                            else
                            {
                                musicfile.pause()
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: songCover
                width: 70
                height: 70
                color: "#D9D9D9"
                radius: 9
                anchors.left: parent.left
                anchors.leftMargin: 22
                anchors.top: parent.top
                anchors.topMargin: 15
            }
            Label{
                id: songName
                width: 331
                height: 36
                color: "white"
                anchors.left: songCover.right
                anchors.leftMargin: 20
                anchors.top: songCover.top
                text: "Song Name"
                font.family: "Inter"
                font.pixelSize: 30
                font.weight: "Bold"
                Connections{
                    target: AudioMetaData
                    onSongNameChanged: songName.text = song
                }
            }
            Label{
                id: artistName
                width: 104
                height: 24
                color: "white"
                anchors.left: songName.left
                anchors.top: songName.bottom
                text: "Artis Name"
                font.family: "Inter"
                font.pixelSize: 20
                Connections{
                    target: AudioMetaData
                    onArtistNameChanged: artistName.text = artist
                }
            }
        }
        Rectangle{
            id: listView
            width: 887
            height: 500
            color: "white"
            radius: 25
            anchors.left: musicBar.left
            anchors.top: musicBar.bottom
            clip: true
            Rectangle{
                id: ref
                width: 887
                height: 20
                color: "white"
                anchors.top: listView.top
            }

            //property string folderPath: "file:Music/" // folder path
            ListView {
                id:list
                width: 887
                height: 500
                anchors.horizontalCenter: listView.horizontalCenter
                anchors.top: ref.bottom
                FolderListModel {
                    id: folderModel
                    folder: "file:Music/"
                    nameFilters: ["*.mp3"]
                }
                Component {
                    id: fileDelegate
                    Rectangle{
                        id: test
                        width: 795
                        height: folderModel.count * 10
                        color: "transparent"//"red"//"transparent"
                        anchors.left: parent.left
                        anchors.leftMargin: 46
                        Label{

                            id: mp3FileIndexNumber
                            width: 100
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            font.family: "Inter"
                            font.pixelSize: 20
                            color: "#727272"
                            text:"0"+ (index+1)
                            onTextChanged:{
                                console.log(fileName)
                                var data = AudioMetaData.listFileChange("Music/"+fileName)
                                mp3FileName.text = String
                                artistNames.text = qml.tuple.get(1,data)
                            }
                        }
                        Label{
                            id: mp3FileName
                            width: 350
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: mp3FileIndexNumber.right
                            font.family: "Inter"
                            font.pixelSize: 20
                            color: "black"
                            text:""//fileName.replace(".mp3","")
                        }
                        Label{
                            id: artistNames
                            width: 250
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: mp3FileName.right
                            font.family: "Inter"
                            font.pixelSize: 20
                            color: "#727272"
                            text:""
//                            Connections{
//                                target: AudioMetaData
//                                onMusicListUpdate: artistNames.text = fileArtist

//                            }
                        }
                    }
                }
                model: folderModel
                delegate: fileDelegate
            }
        }
    }

}
