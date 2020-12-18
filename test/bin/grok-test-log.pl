#!/usr/bin/perl


use v5.28;
use warnings;
use strict;
use English;




my $line;
my ($no_tests, $no_tests_fail, $no_tests_ok);
my ($total_tests, $total_tests_fail, $total_tests_ok);
# states
my $st_idle = 0;
my $st_expect_result = 1;
my $state=$st_idle;

sub reset_tests() {
    $no_tests=0;
    $no_tests_fail=0;
    $no_tests_ok=0;
}
sub report_tests() {
    printf "\t%d/%d ok, (%d failed)\n", $no_tests_ok, $no_tests, $no_tests_fail;
    $total_tests += $no_tests;
    $total_tests_fail += $no_tests_fail;
    $total_tests_ok   += $no_tests_ok;

    &reset_tests();
}

$state=$st_idle;
&reset_tests();
while ($line=<>) {

    # amforth sends cr lf, so deliberately delete '^M' == '0x0d'
    $line =~ s/\x0d//;
    chomp $line;

    #print "+ $line -\n";

    if ( $line =~ m/testing / ) {
        if ( $no_tests > 0) {
            &report_tests();
        }
        $line =~ s/^> testing/TESTING/;
        print "$line\n";
    }

    if ( $state == $st_idle ) {
        if ( $line =~ m/}t/i ) {
            #print "found test end\n";
            $no_tests++;
            $state=$st_expect_result;
            next;
        }
    }
    if ( $state == $st_expect_result ) {
        if ( $line =~ m/incorrect result:/i ) {
            $no_tests_fail++;
            print "$line\n";
        }
        else {
            $no_tests_ok++;
        }
        $state=$st_idle;
    }
    

}
if ( $no_tests > 0) {
    &report_tests();
}

print "Summary:\n";
printf "\t%d/%d ok, (%d failed)\n", $total_tests_ok, $total_tests, $total_tests_fail;
