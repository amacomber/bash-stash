#!/bin/sh

$LOCALMOUNTPOINT="/Volumes/MountPoint1" ;
$LOCALMOUNTPOINT2="/Volumes/MountPoint2" ;
$LOCALMOUNTPOINT3="/Volumes/MountpPoint3" ;

[ ! -d $LOCALMOUNTPOINT ] && mkdir $LOCALMOUNTPOINT && /sbin/mount -t smbfs //username:password@server.local/mountname $LOCALMOUNTPOINT || echo already mounted $LOCALMOUNTPOINT && [ ! -d $LOCALMOUNTPOINT2 ] && mkdir $LOCALMOUNTPOINT2 && /sbin/mount -t smbfs //username:password@server.local/mountname2 $LOCALMOUNTPOINT2 || echo already mounted $LOCALMOUNTPOINT2 && [ ! -d $LOCALMOUNTPOINT3 ] && mkdir $LOCALMOUNTPOINT3 && /sbin/mount -t smbfs //username:password@server.local/mountname3 $LOCALMOUNTPOINT3 || echo already mounted $LOCALMOUNTPOINT3