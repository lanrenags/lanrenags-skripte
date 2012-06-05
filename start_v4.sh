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
  echo "Bitte Spiel auswaehlen: "
  echo "";
  echo "--------------------------------";
  echo "------ Turnier Games ---------";
  echo "--------------------------------";
  echo "1) Counter-Strike";
  echo "2) Counter-Strike:Source"
  echo "3) Call of Duty 4";
  echo "4) Team Fortress 2";
  echo "5) TrackMania Nations Forever";
  echo "6) Quake 3";
  echo "7) Unreal Tournament 2004";
  echo "8) HL2-Deathmatch"  
  echo "9) CSS-Gungame Turnier"
  echo "--------------------------------";
  echo "------ Sonstige Games ---------";
  echo "--------------------------------";
  echo "10) Battlefield 2";
  echo "11) Left4Dead 2";
  echo "12) CSS-Gungame";
  echo "13) CSS-Deathmatch";
  echo "14) CSS-Zombie";
  echo "15) CS1.6-Gungame";
  echo "16) CS1.6-Deathmatch";

echo -n "Spielnummer (1-15): ";
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
    GAME="hl2mp";
    ;;
  9)
    GAME="cssggt";
    ;;
  10)
    GAME="bf";
    ;;
  11)
    GAME="ldd";
    ;;
  12)
    GAME="cssgg";
    ;;
  13)
    GAME="cssdm";
    ;;
  14)
    GAME="csszm";
    ;;
  15)
    GAME="cstrikegg";
    ;;
  16)
    GAME="cstrikedm";
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
  IP="`ip addr show | grep inet | grep eth0 | awk '{print $2}' | awk -F/ '{print $1}'`";
  case $GAME in

    cstrike)
      cd $DIR
      START="./hlds_run -game cstrike +map de_dust2 -maxplayers 11 +ip 0.0.0.0 -port $PORT +sys_ticrate 1010 -pingboost 3 +servercfgfile server_$SERVERNO.cfg";
      ;;
    css)
      cd $DIR/css
      START="./srcds_run -game cstrike +map de_dust2 +maxplayers 11 -port $PORT +servercfgfile server_$SERVERNO.cfg +ip 0.0.0.0 -fps_max 66.67";
      ;;
    cod)
      cd $DIR
      START="./cod4_lnxded +set g_gametype sd +set fs_game mods/promodlive211 +set loc_language 2 +set net_ip 0.0.0.0 +set net_port $PORT +set dedicated 2 +exec server_$SERVERNO.cfg +map_rotate +set sv_maxclients 7 +set ttycon 0 +set developer 0 +set fs_homepath ./ +set fs_basepath ./"
      ;;
    tf)
      cd $DIR/orangebox
      START="./srcds_run -game tf -maxplayers 12 +map cp_badlands +ip $IP -port $PORT +servercfgfile server_$SERVERNO.cfg +fps_max 66.7";
      ;;
    tmnf)
      cd $DIR
      START="./TrackmaniaServer /lan /nodaemon /forceip=$IP /bindip=$IP /dedicated_cfg=war_$SERVERNO.txt /game_settings=MatchSettings/Nations/NationsGreen.txt /autoquit";
      ;;
    quake)
      cd $DIR
      START="./q3ded +set fs_game gsmod +set net_port $PORT +set sv_maxclients 12 +set com_hunkmegs 96 +set com_zoneMegs 64 +set vm_game 0 +set ttycon 0 +exec server.cfg";
      ;;
    ut)
      cd $DIR/System
      START="./ucc-bin server DM-Asbestos?game=xGame.xDeathMatch?AdminName=admin?AdminPassword=lr?ServerActors=AntiTCC2009r6.MutAntiTCCFinal?mutator=utcompv17a.MutUTComp,xGame.MutInstaGib,xGame.MutNoAdrenaline,xWeapons.MutNoSuperWeapon?TimeLimit=15?GoalScore=0?bPlayerMustBeReady=1?WeaponStay=0?Translocator=0 -nohomedir ini=server_$SERVERNO.ini";
      ;;
    bf)
      cd $DIR
      START="./start.sh gsmod +maxPlayers 12 +port $PORT +set net_ip $IP +set dedicated 2 +lowPriority";
      ;;
    hl2mp)
      cd $DIR/orangebox
      START="./srcds_run -game hl2mp +map dm_lockdown -ip 0.0.0.0 -port $PORT +maxplayers 12 +exec server_$SERVERNO.cfg"
      ;;
    cssggt)
      cd $DIR/css
      START="./srcds_run -game cstrike +map 3romms +maxplayers 7 -port $PORT +servercfgfile servergg.cfg +ip 0.0.0.0 -fps_max 66.67";
      ;;
    cssgg)
      cd $DIR/css
      START="./srcds_run -game cstrike +map 3romms +maxplayers 30 -port $PORT +servercfgfile servergg.cfg +ip 0.0.0.0 -fps_max 66.67";
      ;;
    cssdm)
      cd $DIR/css
      START="./srcds_run -game cstrike +map de_dust2 +maxplayers 30 -port $PORT +servercfgfile serverdm.cfg +ip 0.0.0.0 -fps_max 66.67";
      ;;    
    csszm)
      cd $DIR/css
      START="./srcds_run -game cstrike +map de_dust2 +maxplayers 30 -port $PORT +servercfgfile serverzm.cfg +ip 0.0.0.0 -fps_max 66.67";
      ;;
    ldd)
      cd $DIR/left4dead2
      START="./srcds_run -game left4dead2 +map c2m1_highway -port $PORT +servercfgfile server.cfg +ip 0.0.0.0";
      ;;
    cstrikegg)
      cd $DIR/css
      START="./hlds_run -game cstrike +map de_dust2 -maxplayers 30 +ip 0.0.0.0 -port $PORT +sys_ticrate 1010 -pingboost 3 +servercfgfile servergg.cfg";
      ;;
    cstrikedm)
      cd $DIR/css
      START="./hlds_run -game cstrike +map de_dust2 -maxplayers 30 +ip 0.0.0.0 -port $PORT +sys_ticrate 1010 -pingboost 3 +servercfgfile serverdm.cfg";
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