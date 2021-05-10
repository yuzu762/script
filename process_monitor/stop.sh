function KILL
{
     PID=`ps -ef | grep $1 | grep -v grep | awk '{print $2 "," $8}'`
     echo "wait $1 stop..."

     flag=0

     while true
     do
         let flag=0
         PID=`ps -ef | grep $1 | grep -v grep|grep -v $0| awk '{print $2 "," $8}'`
         for pid in ${PID};
         do
            APP_PID=`echo $pid | awk -F ',' '{print $1}'`
            APP_NAME_FULL=`echo $pid | awk -F ',' '{print $2}'`
            APP_NAME=`basename $APP_NAME_FULL`
            if [ $APP_NAME == $1 ]
            then
              let flag=1
              ps -f -p$APP_PID | grep $1 | grep -v grep |awk '{print "kill "  $3}'| sh
              ps -f -p$APP_PID | grep $1 | grep -v grep |awk '{print "kill "  $2}'| sh
            fi
         done

         if [ $flag == 0 ]
         then
          echo "end stop $1"
          return
         fi
     done

     echo "end stop $1..."
}

KILL test
