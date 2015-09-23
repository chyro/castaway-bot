#!/bin/bash

SCREEN=/tmp/castaway.png
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PATTERNS=$DIR/patterns

#WINDOWID=root
echo "Select the Castaway window"
WINDOWID=`xwininfo | grep "Window id" | cut -d' ' -f4`
WINDOWTITLE=`xwininfo -id $WINDOWID | grep "Window id" | cut -d\" -f2 | cut -d, -f1`
WOFFSETX=`xwininfo -id $WINDOWID | grep "Absolute upper-left X" | cut -d: -f2`
WOFFSETY=`xwininfo -id $WINDOWID | grep "Absolute upper-left Y" | cut -d: -f2`
##Boundaries:
WWIDTH=`xwininfo -id $WINDOWID | grep "Width" | cut -d: -f2`
WHEIGHT=`xwininfo -id $WINDOWID | grep "Height" | cut -d: -f2`
WLEFT=$((WOFFSETX+15))
WTOP=$((WOFFSETY+100))
WRIGHT=$((WOFFSETX+WWIDTH-20))
WBOTTOM=$((WOFFSETY+WHEIGHT-110))
echo "Window: $WINDOWTITLE, id $WINDOWID, offset $WOFFSETX,$WOFFSETY"


while true; do
	#TODO: if left ctrl is pressed, exit 0
	
	#Pick up spoils
	for PATTERN in $PATTERNS/spoils-*.pat; do
		import -window $WINDOWID $SCREEN
		FOUND=`visgrep $SCREEN $PATTERN`
		if [ ! -z "$FOUND" ]; then
			WHERE=`echo $FOUND|cut -d\  -f1`
			COORDX=`echo $WHERE|cut -d, -f1`
			COORDX=$((COORDX+WOFFSETX))
			COORDY=`echo $WHERE|cut -d, -f2`
			COORDY=$((COORDY+WOFFSETY))
			filename=`basename $PATTERN`
			noext="${filename%.*}"
			item="${noext##*-}"
			echo "Picking $item ($COORDX,$COORDY)"
			xte "mousemove $COORDX $COORDY" "mouseclick 1" "sleep 5"
		fi
	done
	
	#Rest if hurt
	while [ -z "`visgrep $SCREEN $PATTERNS/healthy.pat`" ]; do
		echo "Injured - resting"
		sleep 5 # But what if I'm currently attacked?
		import -window $WINDOWID $SCREEN
	done
	
	#Fight
	WHERE=""
	DETECTED=""
	import -window $WINDOWID $SCREEN
	for PATTERN in $PATTERNS/enemy-*.pat; do
		FOUND=`visgrep $SCREEN $PATTERN`
		if [ ! -z "$FOUND" ]; then
			WHERE=`echo $FOUND|cut -d\  -f1`
			filename=`basename $PATTERN`
			noext="${filename%.*}"
			DETECTED="${noext##*-}"
			echo "Seeing $DETECTED ($WHERE)..."
		fi
	done
	if [ ! -z "$WHERE" ]; then
		COORDX=`echo $WHERE|cut -d, -f1`
		COORDX=$((COORDX+WOFFSETX))
		COORDY=`echo $WHERE|cut -d, -f2`
		COORDY=$((COORDY+WOFFSETY))
		echo "Attacking $DETECTED ($COORDX,$COORDY)"
		#Screenshot too slow, moved by then. Needs to compensate => either anticipate movement, or shotgun.
		#xte "mousemove $COORDX $COORDY" "mouseclick 1" "usleep 20" "mouseclick 1" "sleep 10"
		#Shotgun: (!do not click outside!)
		xte "mousemove $COORDX $COORDY" "mouseclick 1" "usleep 20" "mouseclick 1" "usleep 20"
		if [[ $((COORDX+20)) -lt $WRIGHT ]] && [[ $((COORDY+20)) -lt $WBOTTOM ]]; then
			xte "mousemove $((COORDX+20)) $((COORDY+20))" "mouseclick 1" "usleep 20" "mouseclick 1" "usleep 20"
		fi
		if [[ $((COORDX+20)) -lt $WRIGHT ]] && [[ $((COORDY-20)) -gt $WTOP ]]; then
			xte "mousemove $((COORDX+20)) $((COORDY-20))" "mouseclick 1" "usleep 20" "mouseclick 1" "usleep 20"
		fi
		if [[ $((COORDX-20)) -gt $WLEFT ]] && [[ $((COORDY+20)) -lt $WBOTTOM ]]; then
			xte "mousemove $((COORDX-20)) $((COORDY+20))" "mouseclick 1" "usleep 20" "mouseclick 1" "usleep 20"
		fi
		if [[ $((COORDX-20)) -lt $WLEFT ]] && [[ $((COORDY-20)) -lt $WTOP ]]; then
			xte "mousemove $((COORDX-20)) $((COORDY-20))" "mouseclick 1" "usleep 20" "mouseclick 1" "usleep 20"
		fi
		#Waiting until the fight is over...
		#xte "sleep 10"
		sleep 2
		import -window $WINDOWID $SCREEN
		MAXTURNS=50
		while [ ! -z "`visgrep $SCREEN $PATTERNS/fight-bar.pat`" ] && [ $((MAXTURNS--)) -gt 0 ] ; do
			#Use skills, if any
			import -window $WINDOWID $SCREEN
			for PATTERN in $PATTERNS/skill-*.pat; do
				FOUND=`visgrep $SCREEN $PATTERN`
				if [ ! -z "$FOUND" ]; then
					WHERE=`echo $FOUND|cut -d\  -f1`
					COORDX=`echo $WHERE|cut -d, -f1`
					COORDX=$((COORDX+WOFFSETX))
					COORDY=`echo $WHERE|cut -d, -f2`
					COORDY=$((COORDY+WOFFSETY))
					xte "mousemove $COORDX $COORDY" "mouseclick 1" "usleep 200"
				fi
			done
			sleep 1
			import -window $WINDOWID $SCREEN
		done
	fi
	echo "Looping..."
	sleep 1
done

#rm $SCREEN #would be nice, but won't run, until there is a proper loop cut...

