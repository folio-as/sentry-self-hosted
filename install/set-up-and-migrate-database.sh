echo "${_group}Setting up / migrating database ..."

# Using django ORM to provide broader support for users with external databases
$dcr web shell -c "
from django.db import connection

with connection.cursor() as cursor:
  cursor.execute('ALTER TABLE IF EXISTS sentry_groupedmessage DROP CONSTRAINT IF EXISTS sentry_groupedmessage_project_id_id_515aaa7e_uniq;')
  cursor.execute('DROP INDEX IF EXISTS sentry_groupedmessage_project_id_id_515aaa7e_uniq;')
"

if [[ -n "${CI:-}" || "${SKIP_USER_CREATION:-0}" == 1 ]]; then
  $dcr web upgrade --noinput
  echo ""
  echo "Did not prompt for user creation. Run the following command to create one"
  echo "yourself (recommended):"
  echo ""
  echo "  $dc_base run --rm web createuser"
  echo ""
else
  $dcr web upgrade
fi

echo "${_endgroup}"
