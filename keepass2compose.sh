#!/bin/bash

# Function to extract secret from KeePass database
extract_secret() {
    local database="$1"
    local pass="$2"
    local entry_title="$3"
    local secret

    secret=$(echo $pass | keepassxc-cli show "$database" -a Password "$entry_title")

    echo "$secret"
}

# Function to replace placeholders in template file with actual secrets
replace_placeholders() {
    local template_file="$1"
    local output_file="$2"

    while IFS= read -r line; do
        for placeholder in "${!secrets[@]}"; do
            line="${line//<$placeholder>/${secrets[$placeholder]}}"
        done
        echo "$line" >> "$output_file"
    done < "$template_file"
}

# Prompt for the master password
echo -n "Enter master password for KeePass database: "
read -rs master_password
echo

# Define secrets you want to extract from the KeePass database
declare -A secrets
secrets["ANCHORE_DB_PASSWORD"]=$(extract_secret "anchore-secrets.kdbx" $master_password "ANCHORE_DB_PASSWORD")
secrets["ANCHORE_ADMIN_PASSWORD"]=$(extract_secret "anchore-secrets.kdbx" $master_password "ANCHORE_ADMIN_PASSWORD")
secrets["ANCHORE_AUTH_SECRET"]=$(extract_secret "anchore-secrets.kdbx" $master_password "ANCHORE_AUTH_SECRET")
# Add more secrets as needed

# Define input template file and output file
template_file="docker-compose-5.4.yaml.tmpl"
output_file="docker-compose.yaml"

rm -f $output_file

# Replace placeholders in the template file with actual secrets
replace_placeholders "$template_file" "$output_file"

echo "Secrets extracted and replaced into output file: $output_file"

