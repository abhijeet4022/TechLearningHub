#!/bin/bash

# Password policy variables
MIN_DAYS=0
MAX_DAYS=60
WARNING_DAYS=14
INACTIVE_DAYS=7
EXPIRE_DAYS=30


# Iterate over users with UID > 1000 and login shell /bin/bash
for user in $(awk -F: '($3 > 1000 && $7 == "/bin/bash") {print $1}' /etc/passwd); do
    echo "Updating password policy for user: $user"

    # Set password aging limits
    chage -m $MIN_DAYS -M $MAX_DAYS -W $WARNING_DAYS -I $INACTIVE_DAYS $user

    echo "Password policy updated for user: $user"
done

echo "Password policy update complete."
