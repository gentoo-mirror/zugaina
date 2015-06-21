#!/sbin/runscript

depend() {
	need net
	use apache
}

start() {
	ebegin "Starting Shibboleth Service Provider Daemon"
	  start-stop-daemon --start --pidfile "/var/run/shibboleth/shibd.pid" --exec \
	    /usr/sbin/shibd -- ${SHIBD_OPTS}
	eend $?

}

stop() {
	ebegin "Stopping Shibboleth Service Provider Daemon"
	  start-stop-daemon --stop --exec /usr/sbin/shibd \
	    --pidfile "/var/run/shibboleth/shibd.pid"
	eend $?
}
