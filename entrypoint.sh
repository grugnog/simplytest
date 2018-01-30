#!/usr/bin/env sh

if [ ! -z "$@" ]; then
  echo "Installing $@"

  mysqld --user=mysql &
	pid="$!"

	for i in {30..0}; do
		if echo 'SELECT 1' | mysql &> /dev/null; then
			break
		fi
		echo 'MySQL init process in progress...'
		sleep 1
	done
	if [ "$i" = 0 ]; then
		echo >&2 'MySQL init process failed.'
		exit 1
	fi

  composer require "drupal/$@" --ansi
  drush --yes pm:enable "$@"
  chown -R apache:apache /var/www/localhost/

	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo >&2 'MySQL init process failed.'
		exit 1
	fi
	echo 'MySQL init process done.'
fi

if [ -z $BUILDONLY ]; then
  /run.sh
fi
