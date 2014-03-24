#!/usr/bin/perl
###############################################################
#   Check CRL list                                            #
#   Downloads a given CRL and prints it statevv               #
###############################################################

use strict;
use warnings; 
use LWP::UserAgent;
use File::Copy;

# Variable you must to set 
my $baseurl = "http://crl.host.com/path/";
my @listofcrls = ('crl01.crl', 'clr02.crl');
my $userAgent = "CRL-Checker/0.1 (Check CRL - your.email\@example.com)";

my $verbose="off";
my $makecopy="off";
my $proxy="";
my $tempcertfile = "tempcrl.crl";
my $sleeptime = 3600;
my $debugfile = "crlcheck.log";


sub printtrace($)
{
	my($texttoprint) = @_;	
	use POSIX qw(strftime);
	my $timestamp = strftime "%Y%m%d-%H%M%S", localtime;	
	#Open file to place results for testing. 
	open DEBUGFILEOUT, ">>$debugfile" or die "Cannot open $debugfile for write :$!";
	my @arraytoprint = split(/\n/, $texttoprint);
	foreach my $indexarraytoprint (0 .. $#arraytoprint)
	{
		# print $timestamp.": ".$arraytoprint[$indexarraytoprint]."\n";
		print $arraytoprint[$indexarraytoprint]."\n";
		print DEBUGFILEOUT $timestamp.": ".$arraytoprint[$indexarraytoprint]."\n";
		} 
	close DEBUGFILEOUT;	
}

print "\n";
print "  CheckCRLs v0.1\n\n";

foreach my $argnum (0 .. $#ARGV) {
	if($ARGV[$argnum]eq "-v")
	{
		$verbose="on";
		print "Verbose mode set to on\n";
	}
		if($ARGV[$argnum]eq "-b")
	{
		$makecopy="on";
		print "Copy CRLs mode set to on\n";
	}
	if($ARGV[$argnum]eq "-u")
	{
	   $baseurl=$ARGV[$argnum+1];
	}
	if($ARGV[$argnum]eq "-p")
	{
	   $proxy=$ARGV[$argnum+1];
	}
		if($ARGV[$argnum]eq "-t")
	{
	   $sleeptime=$ARGV[$argnum+1];
	}		
	if($ARGV[$argnum]eq "-l")
	{
	   $debugfile=$ARGV[$argnum+1];
	}
		if($ARGV[$argnum]eq "-h")
	{
	   print "Usage:\n";
	   print "  -v : Verbose\n";
	   print "  -u url: Set base url (default is $baseurl)\n";
	   print "  -p proxy: Set Proxy settings (default is $proxy)\n";
	   print "  -t seconds: Set sleep time (default is $sleeptime)\n";
	   print "  -l logname: Set file log name (default is $debugfile)\n";
	   print "  -b Makes a copy of every CRL\n";	   
	   exit 0;
	}
}

my $ua = new LWP::UserAgent; 
$ua->agent($userAgent);  
$ua->proxy(['http', 'ftp'], $proxy );

print "     CRLs to be monitored:\n";
foreach my $indexlistofcrls (0..$#listofcrls)
{
	my $urlcrl="$baseurl"."$listofcrls[$indexlistofcrls]";
  print "     $urlcrl\n";
}
print "\n     Proxy set to: $proxy\n";     
print "     User Agent set to: $userAgent\n";  
print "     Sleep time: $sleeptime seconds\n";  
print "     Log file is: $debugfile\n"; 
print "     Help: perl crl-check.pl -h\n\n";  
       
while(1)
{
  foreach my $indexlistofcrls (0..$#listofcrls)
  {
	  my $urlcrl="$baseurl"."$listofcrls[$indexlistofcrls]";
		if($verbose eq "on"){print "\nChecking URL: $urlcrl\n";}

	  my $req = new HTTP::Request 'GET' => $urlcrl;
	  $req->header(Accept => "text/html, text/vnd.wap.wml, text/vnd.sun.j2me.app-descriptor, application/java-archive, application/octet-stream");    
	  my $res = $ua->request($req, $tempcertfile);
	
	  if ($res->is_success)
	  {
	  	my $contentType = $res->header('Content_Type');
	    my $base = $res->base;
	    if($verbose eq "on")
	    { 
	      printtrace ("  The received Content Type is : $contentType \n");
	      printtrace ("  The base url is: $base \n\n");
	    }
		    if($makecopy eq "on")
	    { 
	    	use POSIX qw(strftime);
				my $timestampfile = strftime "%Y%m%d-%H%M%S", localtime;	
	  		my $crlfilename = "$timestampfile-$listofcrls[$indexlistofcrls]";
				copy("tempcrl.crl", $crlfilename);
				if($verbose eq "on")
	    	{ 
	      	printtrace ("  Copied CRL file: $crlfilename \n");    
	    	}
	    }
          
#			system('openssl crl -inform DER -in tempcrl.crl -noout -nextupdate');
			open(OPENSSL, "openssl crl -inform DER -in tempcrl.crl -noout -nextupdate|");
   		my $opensslresult = <OPENSSL>;
   		close(OPENSSL); 
   		chop $opensslresult;
   		printtrace( "$opensslresult $listofcrls[$indexlistofcrls]\n"); 
			unlink "tempcrl.crl";
	  }
	  else
	  {
	    my $httpresponse =  HTTP::Status::status_message($res->code);
	    printtrace( "Error: $httpresponse $listofcrls[$indexlistofcrls] \n");
	  }
	}
  sleep($sleeptime); 
}