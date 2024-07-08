#!/bin/sh

# Taken from the mdfind manpage at https://ss64.com/osx/mdfind.html
# Needless to say this is macOS only.

# These can be included in the query expression to limit the type of documents returned:

# Applications kind:application, kind:applications, kind:app
# Audio/Music kind:audio, kind:music
# Bookmarks kind:bookmark, kind:bookmarks
# Contacts kind:contact, kind:contacts
# Email kind:email, kind:emails, kind:mail message, kind:mail messages
# Folders kind:folder, kind:folders
# Fonts kind:font, kind:fonts
# iCal Events kind:event, kind:events
# iCal To Dos kind:todo, kind:todos, kind:to do, kind:to dos
# Images kind:image, kind:images
# Movies kind:movie, kind:movies
# PDF kind:pdf, kind:pdfs
# Preferences kind:system preferences, kind:preferences
# Presentations kind:presentations, kind:presentation

# Define search terms and return first and last line of results.
allFoo=$( mdfind kind:app "foo" | tail -1 )
compare=$( mdfind kind:app "foo" | head -1 )

# While the first and last line of the search are different remove the file listed first.
while [[ "$allFoo" != "$compare" ]]; do
  echo "Removing $allFoo"
  rm -rf "$allFoo"
  echo "Removed Foo files."

# Re-Define the first line of the search so this loop can continue until there is only one result.
  allFoo=$( mdfind kind:app "foo" | tail -1 )
  echo "$allFoo"
done

# The possible results could be that there is 1 result or 0 results.
# Once the first and last result are the same do one more check in case there is 1 result.
# If there is 1 result run one more delete. If there is a 0 result then finish the job.
if [[ -d "$allFoo" ]]; then
  rm -rf "$allFoo"
  echo "Removing final Foo files."
fi

echo "All Foo files have been removed."

exit 0
# goteamgecko
