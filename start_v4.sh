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



do_abfrage_cfg()
{
  echo -n "Bitte gib die Nummer des Servers an (servercfg): "
  read SERVERNO
}



do_abfrage_game()
{
clear;
echo -e "\033[1;37;44m######################################################\033[0m"
echo -e "\033[1;37;44m################      LANrena    #####################\033[0m"
echo -e "\033[1;37;44m################         5       #####################\033[0m"
echo -e "\033[1;37;44m################    The LANcode  #####################\033[0m"
echo -e "\033[1;37;44m######################################################\033[0m"

echo "";
echo "Bitte Spiele auswaehlen: ";
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
echo "9) HL2-Deathmatch";

echo -n "Spielnummer (1-9): ";
read GAME_SELECT;

case $GAME_SELECT in

  1)
    GAME="cstrike";
    ;;
  2)
    GAME="css";
    ;;
  3)
    GAME="cod";
    ;;  
  4)
    GAME="tf";
    ;;
  5)
    GAME="tmnf";
    ;;
  6)
    GAME="quake";
    ;;
  7)
    GAME="ut";
    ;;
  8)
    GAME="bf";
    ;;
  9)
    GAME="hl2mp";
    ;;

  * )
    for i in 5 4 3 2 1 ; do
      echo  "Ungueltige Eingabe! Bitte erneut versuchen in '$i' Sekunden";sleep 1;
    done  
    do_abfrage_game;
    ;;
esac
}

do_abfrage_port()
{
  PORT_LIST=(`ls /home | grep -i $GAME | awk '{print $1}' | awk -F $GAME '{print $2}'`);
  clear;
  echo "Bitte einen Port aus der Liste aussuchen und zur Bestätigung erneut eingeben: ";
  echo "";
 
  echo "1)${PORT_LIST[0]};"
  echo "2)${PORT_LIST[1]};"
  echo "3)${PORT_LIST[2]};"
  echo "4)${PORT_LIST[3]};"
  echo "5)${PORT_LIST[4]};"
  echo "6)${PORT_LIST[5]};"
  echo "7)${PORT_LIST[6]};"
  echo "8)${PORT_LIST[7]};"
  echo "9)${PORT_LIST[8]};"
  echo "10)${PORT_LIST[9]};"

  echo -n "Port Eingabe: "; 
  read PORT_TMP;
  PORT=${PORT_LIST[$PORT_TMP-1]}

  if [ -d /home/$GAME$PORT ];then
    do_set_startcmd;
    echo -e "\n";
    if [ `egrep -ic $GAME$PORT /etc/passwd` = 1 ];then
      /usr/bin/sudo -u $GAME$PORT $START;
    else
      echo "User $USER wurde nicht gefunden und wird jetzt angelegt!";
      /usr/sbin/useradd -d $DIR -k /etc/skel/ -m -s /bin/bash $GAME$PORT
      /usr/bin/sudo -u $GAME$PORT "$START";
    fi
  else
    echo -e "\nZiel $GAME$PORT nicht vorhanden. Abgebrochen!";
  fi

}

do_set_startcmd()
{
  DIR="/home/$GAME$PORT"
  IP="`ifconfig | grep 192. | awk '{print $2}' | awk -F: '{print $2}'`";
  case $GAME in

    cstrike)
      cd $DIR
      START="./hlds_run -game cstrike +map de_dust2 -maxplayers 12 +ip 0.0.0.0 -port $PORT +sys_ticrate 1020 -pingboost 3 +servercfgfile server_$SERVERNO.cfg";
      ;;
    css)
      cd $DIR/css
      START="./srcds_run -game cstrike +map de_dust2 +maxplayers 12 -port $PORT +servercfgfile server_$SERVERNO.cfg +ip 0.0.0.0 -fps_max 66.67";
      ;;
    cod)
      cd $DIR
      START="./cod4_lnxded +set g_gametype sd +set fs_game mods/promodlive211 +set loc_language 2 +set net_ip 0.0.0.0 +set net_port 28960 +set dedicated 2 +exec server_$SERVERNO.cfg +map_rotate +set sv_maxclients 12 +set ttycon 0 +set developer 0 +set fs_homepath ./ +set fs_basepath ./"
      ;;
    tf)
      cd $DIR/orangebox
      START="./srcds_run -game tf -tickrate 66 -maxplayers 24 +map cp_badlands +ip 0.0.0.0 -port $PORT +servercfgfile server_$SERVERNO.cfg";
      ;;
    tmnf)
      cd $DIR
      START="./TrackmaniaServer /lan /nodaemon /forceip=$IP /bindip=$IP /dedicated_cfg=dedicated_cfg.txt /game_settings=MatchSettings/Nations/NationsGreen.txt /autoquit";
      ;;
    quake)
      cd $DIR
      START="./q3ded +set fs_game gsmod +set net_port $PORT +set sv_maxclients 12 +set com_hunkmegs 96 +set com_zoneMegs 64 +set vm_game 0 +set ttycon 0 +exec server.cfg";
      ;;
    ut)
      cd $DIR/System
      START="./ucc-bin server DM-Asbestos?game=xGame.xDeathMatch?AdminName=admin?AdminPassword=lr?mutator=utcompv17a.MutUTComp?mutator=AntiTCC118j.MutAntiTCCFinal,xGame.MutVampire -nohomedir ini=server.ini";
      ;;
    bf)
      cd $DIR
      START="./start.sh gsmod +maxPlayers 12 +port $PORT +set net_ip $IP +set dedicated 2 +lowPriority";
      ;;
    hl2mp)
      cd $DIR/orangebox
      START="./srcds_run -game hl2mp +map dm_lockdown -ip 0.0.0.0 -port $PORT +maxplayers 12 +exec server_$SERVERNO.cfg"
      ;;

    * )
      for i in 5 4 3 2 1 ; do
        echo  "Ungueltige Game uegergabe! Bitte erneut versuchen in '$i' Sekunden";sleep 1;
      done
      do_abfrage_game;
      ;;
  esac
}

do_abfrage_game;
do_abfrage_cfg;
do_abfrage_port;

