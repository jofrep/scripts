#!/usr/bin/perl
#
# Extract certificates and signature from a JAD file
# 

use strict;
use warnings; 
use Text::Wrap;
$Text::Wrap::columns = 64;

my $keyword= "MIDlet-Certificate";
my $certificate = "";
my $outname = "";
my @warray;
my $certbase64 = "";

if  ("$#ARGV" < 0)
{
 	print "  Add JAD file where to extract information";
}else{
	my $jadname = $ARGV[0];
	print "  Opening $jadname...\n";
	open JADFILE, "<$jadname" or die "Cannot open $jadname for read:$!";
	
	while (readline(JADFILE))
	{
		my $line =$_;
		print "  Line ".$line;
		
		if ($line =~ $keyword)
		{
			@warray = split(": ", $line);
			$outname = $jadname."-".$warray[0].".txt";
			$certificate = $warray[1];
			print "  Found certificate $certificate\nthat will be stored in: $outname\n";
			open CERTFILE, ">$outname" or die "Cannot open $outname for write:$!\n";			
			$certbase64 = "-----BEGIN CERTIFICATE-----\n".wrap('', '', $certificate)."-----END CERTIFICATE-----\n";
			print CERTFILE $certbase64;
			close CERTFILE;
			system ("openssl x509 -in $outname -text -noout");
		}
		if ($line =~ $keywordsign)
		{
			@warray = split(": ", $line);
			$outname = $jadname."-".$warray[0].".txt";
			$certificate = $warray[1];
			print "  Found certificate $certificate\nthat will be stored in: $outname\n";
			open CERTFILE, ">$outname" or die "Cannot open $outname for write:$!\n";			
			$certbase64 = wrap('', '', $certificate);
			print CERTFILE $certbase64;
			close CERTFILE;
#			system ("openssl x509 -in $outname -text -noout");
			# system ("del certtemp.txt");
		}
	}
}
