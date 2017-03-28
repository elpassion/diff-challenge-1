#!/bin/bash -
#===============================================================================
#
#          FILE: start.sh
#
#         USAGE: ./start.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Rafał Lisowski
#  ORGANIZATION: El Passion
#       CREATED: 2017.03.28 07:26:46
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo '== Installing dependencies =='
gem install bundler --conservative
bundle check || bundle install

echo "== Preparing database =="
bin/rails db:setup

echo "== Removing old logs and tempfiles =="
bin/rails log:clear tmp:clear

echo "== Restarting application server =="
bundle exec puma
