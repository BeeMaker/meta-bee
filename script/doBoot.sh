#!/bin/sh

COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_PURPLE='\033[0;35m'
RESET='\033[0m'

USE_SSH=${USE_SSH:="false"}
if [ "$USE_SSH" == "false" ]; then
  echo -e "\n$COLOR_RED----- NO DOWNLOAD IMAGE SET, PLEASE SET USE_SSH=true for it ----- $RESET"
fi

printColor () {
  echo -e "\n$COLOR_GREEN$1$RESET"
}

printColor "***** Generating Environment Remote *****"
MACHINE=${MACHINE:=odroid-xu4}
HOSTNAME=${HOSTNAME:=odroid-Bee}
DSTDIR=${DSTDIR:=~/Yocto/build/}
IMG=${IMG:=core-image-minimal}
MEDIA=${MEDIA:=/dev/mmcblk0p1}
CARDSIZE=${CARDSIZE:=2}
FILE_EXT=${FILE:=sdcard}

FILENAME="$IMG-$MACHINE.$FILE_EXT"


echo -e "\tMACHINE:  $COLOR_PURPLE$MACHINE$RESET"
echo -e "\tHOSTNAME: $COLOR_PURPLE$HOSTNAME$RESET"
echo -e "\tDSTDIR:   $COLOR_PURPLE$DSTDIR$RESET"
echo -e "\tIMG:      $COLOR_PURPLE$IMG$RESET"
echo -e "\tMEDIA:    $COLOR_PURPLE$MEDIA$RESET"
echo -e "\tCARDSIZE: $COLOR_PURPLE$CARDSIZE$RESET"
echo -e "\tFILENAME: $COLOR_PURPLE$FILENAME$RESET"


printColor "***** Generating Environment Remote *****"
DOWNLOAD=${DOWNLOAD:=/developer/BeeMaker/Yocto/imgs}
echo -e "\tDOWNLOAD: $COLOR_PURPLE$DOWNLOAD$RESET"

mkdir -p $DOWNLOAD

if [ "$USE_SSH" == "true" ]; then
  read -r -p "Set the server address to call scp! " input
  ConnectSSH="ssh $input "
  CommandSSH="ls $DSTDIR/$FILENAME.tar.gz"

  cmd="$ConnectSSH '$CommandSSH'"
  PATHOFFILE=$(eval $cmd)

  if [ "$PATHOFFILE" != "" ]; then
    echo "File $PATHOFFILE found"
  else
    echo "Cannot found $FILENAME"
    exit 1
  fi

  if [[ -f $DOWNLOAD/`basename $PATHOFFILE` ]]; then
    read -r -p "$DOWNLOAD/`basename $PATHOFFILE` already exists. Do you want to remove it ? [Y/n] " input

    case $input in
      [yY][eE][sS]|[yY]) 
	rm $DOWNLOAD/`basename $PATHOFFILE`
	break
      ;;
      
      [nN][oO]|[nN]) 
        echo "Cancel Download !"
	break
      ;;
      
      *)
        echo "Invalid input... y(yes) or n(no)!"
        ;;
      esac
    fi

  if [[ ! -e $DOWNLOAD/`basename $PATHOFFILE` ]]; then
    printColor "***** Download Image `basename $PATHOFFILE` *****"
    cmd="scp $input:$PATHOFFILE $DOWNLOAD"
    eval $cmd

    printColor "***** Download MD5  *****"
    cmd="scp $input:$PATHOFFILE.md5 $DOWNLOAD"
    eval $cmd
  fi

fi

printColor "***** Check MD5 and uncompress *****"

md5=`md5sum $DOWNLOAD/$FILENAME.tar.gz | awk '{print $1}'`
md5_expect=`cat $DOWNLOAD/$FILENAME.tar.gz.md5 | awk '{print $1}'`

if [ "$md5" != "$md5_expect" ]; then
  echo "File md5 not compatible. Stop flash !"
  exit 1
else
  echo -e "\tMD5 OK"
fi

rm -rf $DOWNLOAD/$FILENAME
newDir=`tar -xvf $DOWNLOAD/$FILENAME.tar.gz -C $DOWNLOAD`

printColor "***** Flash Start *****"

while true;
do
  read -r -p "Flash `basename $newDir` in $MEDIA ? [Y/n] " input

  case $input in
    [yY][eE][sS]|[yY]) 
      echo "start Upload !"
      sudo dd if=$DOWNLOAD/$newDir of=$MEDIA bs=1M
      break
    ;;
    
    [nN][oO]|[nN]) 
      echo "Cancel doFlash !"
      exit 1
    ;;
    
    *)
      echo "Invalid input... y(yes) or n(no)!"
      ;;
    esac
done

printColor "***** Done *****"
