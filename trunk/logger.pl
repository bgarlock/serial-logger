#!/usr/bin/perl
#
# Requires: Device::SerialPort 0.12 or greater
#
# Author: Bruce Garlock (bruce at bgarlock dot com)
# Date:   2002-09-11
# License: GPLv3, see: http://www.gnu.org/copyleft/gpl.txt
#
# Version: 0.1: Initial version.
# Version: 0.2: Added in License/Contact info.
#
# Description:  This perl script is for logging of data from a serial
# port, to a specified logfile.  The logfile can then be parsed with
# other programs for reporting purposes.
# 
# This program was written for logging Multitech's
# MTASR2-203 T1 Router.  The router outputs text to the command
# port with 57.6k, 8-1-N, and No flow control.
#
# The port can be setup below using ditty or stty.  Please
# obecify this in the TTYPROG name variable.
#
# Ideas/Code from this were taken right from the sample code in the Device::SerialPort
# PERL module from CPAN.
#
#
# 2008-05-02:  B. Garlock - Added to Google Code  http://code.google.com/p/serial-logger/
#
#

use Device::SerialPort 0.12;

$LOGDIR    = "/var/log";              # path to data file
$LOGFILE   = "converting.log";        # file name to output to
$PORT      = "/dev/ttyE10";           # port to watch

#
#
# Serial Settings
#
#

$ob = Device::SerialPort->new ($PORT) || die "Can't Open $PORT: $!";
$ob->baudrate(57600)   || die "failed setting baudrate";
$ob->parity("none")    || die "failed setting parity";
$ob->databits(8)       || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings    || die "no settings";

#
# Send a string to the port
#
#
$pass=$ob->write("AT");
sleep 1;

#
# open the logfile, and Port
#


open(LOG,">>${LOGDIR}/${LOGFILE}")
    ||die "can't open smdr file $LOGDIR/$LOGFILE for append: $SUB $!\n";

open(DEV, "<$PORT") 
    || die "Cannot open $PORT: $_";

select(LOG), $| = 1;      # set nonbufferd mode

#
# Loop forver, logging data to the log file
#

while($_ = <DEV>){        # print input device to file
    print LOG $_;
}

undef $ob;
