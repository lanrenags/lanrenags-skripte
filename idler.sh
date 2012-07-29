PROZ=`cat /proc/cpuinfo | grep processor | wc -l`
IDLER=`ps aux | grep idler | wc -l`
i=0

if [ ! $IDLER -gt 1 ]; then

  while [ $i -lt $PROZ ]
  do
    nice taskset -c $i ./idler &
    i=`expr $i + 1`
  done
else
  echo "Idler laeuft schon"
fi
