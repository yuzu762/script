ulimit -c 10737418240

function STATE
{
  BPRINTA=0
  PID=`ps -ef | grep $1 | grep -v grep | awk '{print $2 "," $8}'`
  for pid in ${PID};
  do
    APP_PID=`echo $pid | awk -F ',' '{print $1}'`
    APP_NAME_FULL=`echo $pid | awk -F ',' '{print $2}'`
    APP_NAME=`basename $APP_NAME_FULL`
    if [ $APP_NAME == $1 ]
    then
      BPRINTA=1
      echo "$1 already started..."
      exit
    fi
  done
}

function  CHECK_STATUS
{
    restartCnt=0;
    while true
    do
      BPRINTA=0
      PID=`ps -ef | grep $1 | grep -v grep | awk '{print $2 "," $8}'`
      for pid in ${PID};
      do
        APP_PID=`echo $pid | awk -F ',' '{print $1}'`
        APP_NAME_FULL=`echo $pid | awk -F ',' '{print $2}'`
        APP_NAME=`basename $APP_NAME_FULL`
        if [ $APP_NAME == $1 ]
        then
          BPRINTA=1
        fi
      done
    if [ $BPRINTA -eq 0 ]
    then
      LOGTIME=$(date +"%Y%m%d_%H%M%S")
      LOGTIME2=$(date +"%Y/%m/%d %H:%M:%S")
      if [ ! -f $1 ]
      then
          echo "$1 is not exist, exit..."
          exit -1
      elif [ ! -d "../logs" ]
      then
          echo "There's no logs directory, now creating it..."
          mkdir ../logs
      fi
      nohup ./$1 1>../logs/$1${LOGTIME}.log 2>&1 &
      ln -sf ../logs/$1${LOGTIME}.log $11.log
      if [ $restartCnt -gt 0 ]
      then
        echo "$LOGTIME2:$1 has exited,now restarting! Restart count:$restartCnt" >> ../logs/restart.log
      fi
      restartCnt=$[$restartCnt+1]
      sleep 6
    fi
   done
}


CURRENT_DIR=`dirname $0`
cd $CURRENT_DIR
CURRENT_DIR=`pwd`

STATE startMd.sh
STATE test

export LD_LIBRARY_PATH=${CURRENT_DIR}

CHECK_STATUS test &
