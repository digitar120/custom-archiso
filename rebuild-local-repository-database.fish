#!/bin/fish
# Shortcut for rebuilding the database in case of errors, or when testing.
bash -c "repo-add $DOWNLOAD_DIRECTORY/packages/local-package-repository.db.tar.zst $DOWNLOAD_DIRECTORY/packages/*[^sig]"
