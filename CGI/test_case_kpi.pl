#!/usr/bin/perl -w

##
##  printenv -- demo CGI program which just prints its environment
##
use strict   ;
use warnings ;

use Test_case_KPI ;

my $kpi = new Test_case_KPI ;

print $kpi->RESULTS::PASSED;

print $kpi->RESULTS::PASSED . "\n";
print $kpi->RESULTS::FAILED . "\n";
print $kpi->PROJECTS::OMNI            . "\n";
print $kpi->PROJECTS::NDS0            . "\n";
print $kpi->TEST_TYPES::CUNIT         . "\n";
print $kpi->TEST_TYPES::SYSTEMTEST    . "\n";
print $kpi->TEST_TYPES::COMPONENTTEST . "\n";
print $kpi->TEST_TYPES::TASKTEST      . "\n";

print $kpi->get_version_number();

