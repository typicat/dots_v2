#!/bin/sh

# Functions to fetch system data
get_battery() {
    # apm -l returns percentage only
    # apm -a returns 1 for AC, 0 for battery
    BATT=$(apm -l)
    AC=$(apm -a)
    STATE=" bat"
    [ "$AC" -eq 1 ] && STATE=" ac"
    echo -n "$STATE: $BATT%"
}

get_brightness() {
    BRI=$(xbacklight | awk '{printf "%.0f", $1}')
    echo -n "bri: $BRI%"
}

get_volume() {
    # sndioctl output.level returns a value between 0 and 1
    # awk extracts the number and converts it to a percentage
    VOL=$(sndioctl -n output.level | awk '{print int($1 * 100)}')
    echo -n "vol: $VOL% "
}

get_time() {
    date "+%Y-%m-%d %H:%M"
}

get_load() {
    # sysctl vm.loadavg provides 1, 5, and 15 minute averages
    LOAD=$(sysctl -n vm.loadavg | awk '{print $2}')
    echo -n "load: $LOAD"
}

get_mem() {
    # This fetches used memory specifically for OpenBSD/FreeBSD style sysctl
    # If on Linux, this would need to pull from /proc/meminfo
    MEM=$(vmstat | tail -n 1 | awk '{print $3}')
    echo -n "mem: ${MEM}"
}

# Main loop to output formatted text to lemonbar
while true; do
    # Combining the new functions into the left and right sections
    BAT=$(get_battery)
    LD=$(get_load)
    TM=$(get_time)
    MEM=$(get_mem)
    VOL=$(get_volume)
    BRI=$(get_brightness)
    echo "%{l} $LD | $MEM %{c}$TM %{r}$VOL | $BRI | $BAT "
    sleep 2
done | lemonbar-xft -d -p -g 1920x20+0+0 -f "Sans:pixelsize=10" -B "#66222222" -F "#ffffff"
