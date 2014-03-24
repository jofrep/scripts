#!/usr/bin/perl
#
# Remove certificates and signature from JAD files
# 

use strict;
use warnings; 
 
use File::Copy;
my $keyword = "MIDlet-Certificate-";
my $keyword2 = "MIDlet-Jar-RSA-SHA1";
my $dirtoget=".";

print "Ready for deleting all signatures in all JAD files of the current directory?\n";
#read <> $tmp; 
			
opendir(IMD, $dirtoget) || die("Cannot open directory");
my @thefiles= readdir(IMD);
closedir(IMD);

foreach my $f (@thefiles)
{
	print "Checking file $f \n";
	unless ( ($f eq ".") || ($f eq "..") )
 	{ 
 		if ($f =~ ".jad\$")
		{
			my $jadname = $f;
			my $cpjadname = $jadname.".bk";
			
			copy($jadname, $cpjadname);

			print "Opening $jadname...\n";
			open ORIGINALJADFILE, "<$cpjadname" or die "Cannot open $cpjadname for read:$!";
			open NEWJADFILE, ">$jadname" or die "Cannot open $jadname for write:$!";
			
			while (readline(ORIGINALJADFILE))
			{
				my $line =$_;
				# print "  Line ".$line;
				if (($line =~ $keyword)||($line =~ $keyword2))
				{
					print " Removing line: $line\n";		
				}else
				{
						print NEWJADFILE $line;
				}
			}
			
			close ORIGINALJADFILE;
			close NEWJADFILE;
  	}
  }
}
