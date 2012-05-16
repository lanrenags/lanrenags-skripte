#!/bin/bash
######################################################
#                                                    #
#            LANrena - The LAN Code                  #
#                 start-Skript                       #
#                                                    #
#                   Copyright:                       #
#                                                    #
#           Marcus "LR|^bnl" Bauernheim              #
#          Christoph "Rattlesanke" Raible            #
#                                                    #
######################################################



do_abfrage_port()
{
  echo -n "Bitte Port für den neuen Server festlegen: "
  read PORT;
  echo ""
}

do_abfrage_game()
{
  clear;
  echo "Bitte Spiel auswaehlen: " 
  echo "";
  echo "";
  echo "1) Counter-Strike";
  echo "2) Counter-Strike:Source"
  echo "3) Call of Duty 4";
  echo "4) Team Fortress 2";
  echo "5) TrackMania Nations Forever";
  echo "6) Quake 3";
  echo "7) Unreal Tournament 2004";
  echo "8) Battlefield 2";
  echo "9) HL2-Deathmatch"
  echo "";
  echo -n "Spielnummer (1-9): "
  read GAME_SELECT;

  case $GAME_SELECT in

    1)
      GAME=cstrike
      do_abfrage_port;
      ;;
    2)
      GAME=css;
      do_abfrage_port;
      ;;
    3)
      GAME=cod;
      do_abfrage_port;
      ;;
    4)
      GAME=tf;
      do_abfrage_port;
      ;;
    5)
      GAME=tmnf;
      do_abfrage_port;
      ;;
    6)
      GAME=quake;
      do_abfrage_port;
      ;;
    7)
      GAME=ut;
      do_abfrage_port;
      ;;
    8)
      GAME=bf;
      do_abfrage_port;
      ;;
    9)
      GAME=hl2mp;
      do_abfrage_port;
      ;;

    * )
      for i in 5 4 3 2 1 
        do
          echo  "Ungueltige Eingabe! Bitte erneut versuchen in '$i' Sekunden";sleep 1;
        done
        do_abfrage_game;
        ;;
esac
}

do_rsync()
{
  MASTER='192.168.2.146'
  DIR='/usr/local/games/'
  /usr/bin/sudo -u $GAME$PORT /usr/bin/rsync -av root@$MASTER:$DIR/$GAME/ /home/$GAME$PORT;
}

check_requ()
{
  if [ `egrep -ic $GAME$PORT /etc/passwd` = 0 ];then
    echo "User nicht gefunden und wird jetzt angelegt";
    useradd $GAME$PORT -m -d /home/$GAME$PORT -s /bin/bash;
    check_requ;
  elif [ -d /home/$GAME$PORT ];then
    echo "Ziel vorhanden. Download beginnt in kuerze......";
    sleep 2;
    do_rsync;
  else
    echo "Verzeichnis /home/$GAME$PORT existiert nicht und wird nun angelegt";
    mkdir /home/$GAME$PORT;
    do_rsync;
  fi
}

# Main
do_abfrage_game;
check_requ;
