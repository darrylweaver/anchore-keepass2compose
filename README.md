# Keepass2compose file for Anchore Enterprise

## Setup

Create a new keepass database file: anchore-secrets.kdbx
Add the following entries with the names:
ANCHORE_DB_PASSWORD
ANCHORE_ADMIN_PASSWORD
ANCHORE_AUTH_SECRET


For each entry set the password field to the value you want.

## Run

Run the script:
./keepass2compose.sh

This will prompt you for the keepass database password.
The default keepass database included here has the password: anchoreadmin

The script will load the template file and output the replaced secrets to a file: docker-compose.yaml

You can then use the docker-compose.yaml file to launch the docker compose stack for Anchore Enterprise.
