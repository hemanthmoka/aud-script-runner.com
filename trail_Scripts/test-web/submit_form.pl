#!/usr/bin/perl

use strict;
use warnings;
use CGI;

# Create CGI object
my $cgi = CGI->new;

# Get the argument from the submitted form
my $argument = $cgi->param("argument");

# Execute your bash script with the argument
my $bash_script = "/Users/hemanth/Documents/Hemanth/Scripts/trail_Scripts/test-web/script.sh";
system("$bash_script $argument");

# Print a response if needed
print $cgi->header("text/plain");
print "Form submitted successfully!";
