#!/usr/bin/perl
my $cgi = CGI->new;

## Retrieve form data
my $arg1 = $cgi->param('arg1');
my $arg2 = $cgi->param('arg2');

#my $arg1 = "hemanth";
#    my $arg2 = ' hemanth@gmail.com';
        # Execute the bash script with arguments
my $output = `/Users/hemanth/Documents/Hemanth/Scripts/trail_Scripts/test-web/script.sh $arg1 $arg2`;

# Print the output or perform any desired action
print "Output: $output\n";