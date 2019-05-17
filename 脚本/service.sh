#!/bin/sh
#
# service script
# Check the application status
#
# This function checks if the application is running
check_status() {
  # Running ps with some arguments to check if the PID exists
  # -C : specifies the command name
  # -o : determines how columns must be displayed
  # h : hides the data header
  s=$(ps -ef | grep -E 'java|node' | grep -v 'grep' | grep $b | grep -v '/bin/sh' | awk '{print $2}')
  # s=$(pgrep -of $b | grep -v '/bin/sh')
  echo $s
  # In any another case, return 0
  if [[ ! -n "$s" ]] ; then
    return 0
  fi

  # If somethig was returned by the ps command, this function returns the PID
  return $s

}

# Starts the application
start() {

  # At first checks if the application is already started calling the check_status
  # function
  pid=$(check_status)

  if [[ "$pid" -eq "" ]]
  then
    pid=0
  fi

  if [ $pid -ne 0 ] ; then
    echo "The application is already started"
    return
  fi

  # If the application isn't running, starts it
  echo -n "Starting application: "

  # Redirects default and error output to a log file
  #java -jar /path/to/application.jar >> /path/to/logfile 2>&1 &
  
  if [ -e "$d/package.json" ] ; then
    cd $d
    npm start >> ~/logs/console.log 2>&1 &
  else 
    echo $e
    java -Dspring.profiles.active=dev -jar $a >> ~/logs/$e 2>&1 &
  fi
  echo "OK"

}

# Stops the application
stop() {

  # Like as the start function, checks the application status
  pid=$(check_status)

  if [[ "$pid" -eq "" ]]
  then
    pid=0
  fi

  if [ $pid -eq 0 ] ; then
    echo "Application is already stopped"
    return
  fi

  # Kills the application process
  echo -n "Stopping application: "
  kill $pid &
  echo "OK"

}

# Redeploys the application
redeploy() {
t
  stop
  rebuild
  start

}

# Show the application status
status() {

  # The check_status function, again...
  pid=$(check_status)

  # If the PID was returned means the application is running
  if [ "$pid" -ne 0 ] ; then
    echo "Application is started: $pid"
  else
    echo "Application is stopped"
  fi

}

# build the application
rebuild() {
  currentDir=`pwd`
  cd $d
  git pull
  if [ -e "$d/pom.xml" ]; then 
    echo "build maven project"
    mvn clean install -DskipTests
  elif [ -e "$d/build.gradle" ]; then
    echo "build gradle project" 
    ./gradlew clean build
  elif [ -e "$d/package.json" ]; then
    echo "build vue-web project"
    cnpm install
  else
    echo "can not recognize project type"
    return 0
  fi
  cd $currentDir
}

# global var
# a is short for application name
# b is short for basename
# d is short for directory
d="$HOME/$2"
if [[ ! -d "$d" ]] ; then
  echo "Application not found"
  exit 0
fi

if [ -e "$d/package.json" ]; then 
  a="$2"  
else
  a=`find ~/$2 -name "$2*.jar"`  
fi

if [[ ! -n "$a" ]] ; then
    echo "Application not build, build first"
    rebuild
    a=`find ~/$2 -name "$2*.jar"`
    b=`basename "$a"`
else
    echo "Found application at $a"
    b=`basename "$a"`
fi
e="$b.log"

# Main logic, a simple case to call functions
case "$1" in
  rebuild)
    rebuild
    ;;
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    ;;
  redeploy)
    redeploy
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|reload|status|redeploy|rebuild} appname"
    exit 1
esac

exit 0
