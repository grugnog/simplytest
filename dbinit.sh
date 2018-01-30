#!/usr/bin/env sh
set -e
echo 'Running mysql_install_db'
mysql_install_db --user=mysql
echo 'Finished mysql_install_db'

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
MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
MYSQL_DRUPAL_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
mysql <<-EOSQL
  DELETE FROM mysql.user;
  CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
  GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
  DROP DATABASE IF EXISTS test ;
EOSQL
echo 'FLUSH PRIVILEGES' | mysql
echo "Installing Drupal"
drush site:install --yes --account-pass=drupal --db-su=root --db-su-pw="${MYSQL_ROOT_PASSWORD}" --db-url="mysql://drupal:${MYSQL_DRUPAL_PASSWORD}@localhost:3307/drupal"
echo "Finished installing Drupal"
if ! kill -s TERM "$pid" || ! wait "$pid"; then
  echo >&2 'MySQL init process failed.'
  exit 1
fi
echo 'MySQL init process done.'
echo
