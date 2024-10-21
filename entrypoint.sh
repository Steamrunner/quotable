#!/bin/sh
set -e

echo "Service 'All': Status"
rc-status -a

echo "Service 'MongoDB': Starting ..."
rc-service mongodb start

echo "Update quotes DB"
cd /quotable-data
node cli/sync

echo "Service 'Quotable': Starting ..."
cd /quotable
npm run start

exec $@



