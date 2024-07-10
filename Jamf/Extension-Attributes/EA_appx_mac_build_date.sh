#!/bin/sh
#
# Parse machine serial number for date (week and year) of manufacture
# based on pyMacWarranty by Michael Lynn (https://github.com/pudquick/pyMacWarranty)
#
# Rocky Waters - Humboldt State University - Oct 2016
#

function mnfdate()
{
 local WEEK=$1 YEAR=$2
 local JAN1_WEEK JAN1_DAY
 local FIRST_MON
 local DATE_FMT="%d %b %Y"
 local DATEYEAR DAYS DAYSTMP

 DATEYEAR="01-Jan-$YEAR"
 JAN1_WEEK=$(date -jf "%d-%b-%Y" "$DATEYEAR" +%W)
 JAN1_DAY=$(date -jf "%d-%b-%Y" "$DATEYEAR" +%u)

 # If Jan 1 is Monday then use Jan 1, else calculate what date is first Monday of year
 if ((JAN1_WEEK))
 then
   FIRST_MON=$YEAR-Jan-01
 else
   FIRST_MON=$YEAR-Jan-$((01 + (7 - JAN1_DAY + 1) ))
 fi
 (( DAYSTMP = $WEEK * 7 ))
 DAYS="-v+"$DAYSTMP"d"
 DATEYEAR=$(date -j -f "%Y-%b-%d" $DAYS "$FIRST_MON" +"%Y-%m-%d")
 echo "$DATEYEAR"
}

SERIAL=`ioreg -c IOPlatformExpertDevice -d 2 | awk -F" '/IOPlatformSerialNumber/{print $(NF-1)}'`

if [ "${#SERIAL}" = '11' ]
  then
  # Old Serial number format (11 Chars) - Changed in 2010
  # Year is third character in serial number
  YEAR=${SERIAL:2:1}
  # Key index for years
  KEY_YEAR='   3456789012'
  # Strip characters from KEY_YEAR after the YEAR
  IDX_YEAR="${KEY_YEAR%%$YEAR*}"
  # Base year is 2000, Manufactured year is base year + position of the YEAR in the KEY_YEAR
  MNF_YEAR=$((2000 + ${#IDX_YEAR}))
  # Week manufactured is characters 4-5 in serial number
  WEEK=${SERIAL:3:2}
  # Get an approximate date manufactured given the week number and year
  MNFDATEAPPROX=$(mnfdate $WEEK $MNFYEAR)

elif [ "${#SERIAL}" = '12' ]
  then
  # New Serial number format (12 chars)
  # Key index for years: c is first half of 2010, d is second half 2010...
  # goes through 2019
  KEY_YEAR='cdfghjklmnpqrstvwxyz'
  # Year is fourth character in serial number
  YEAR=${SERIAL:3:1}
  # Set YEAR to lowercase
  YEAR=$(echo $YEAR| tr '[:upper:]' '[:lower:]')
  # Strip characters from KEY_YEAR after the YEAR
  IDX_YEAR="${KEY_YEAR%%$YEAR*}"
  # Base year is 2010, Manufactured year is base year + position of the YEAR in the KEY_YEAR
  # divided by 2 (each letter is half year)
  MNF_YEAR=$(( 2010 + ${#IDX_YEAR} / 2))
  # determine first or second half of year
  HALF_YEAR=$(( ${#IDX_YEAR} % 2))
  # Key index for weeks - only gives half year need to know forst or second half to calculate
  KEY_WEEK="123456789cdfghjklmnpqrtvwxy"
  # Week manufactured is character 5 in serial number
  ALPHA_WEEK=${SERIAL:4:1}
  # Set ALPHA_WEEK to lowercase
  ALPHA_WEEK=$(echo $ALPHA_WEEK| tr '[:upper:]' '[:lower:]')
  # Strip characters from KEY_WEEK after ALPHA_WEEK
  IDX_WEEK="${KEY_WEEK%%$ALPHA_WEEK*}"
  # Position of ALPHA_WEEK in KEY_WEEK
  IDX_WEEK=${#IDX_WEEK}
  # WEEK is the IDX_WEEK plus 26 weeks if it is the second half of the year
  WEEK=$(( IDX_WEEK + ( HALF_YEAR * 26 ) ))
  # Get an approximate date manufactured given the week number and year
  MNFDATEAPPROX=$(mnfdate $WEEK $MNF_YEAR)

fi

echo "<result>$MNFDATEAPPROX</result>"
