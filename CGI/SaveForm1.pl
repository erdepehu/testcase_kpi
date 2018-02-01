#!/usr/bin/perl -w

##
##  printenv -- demo CGI program which just prints its environment
##
use strict;
use warnings;
use lib '/home/deveushu/OmniBB/PERL_MODULES' ;

use Server_spec_datas qw( $DB SESS_REQED $LOG ); 
use CGI;
use View_ajax;
use Controller_ajax;
use Data::Dumper ;


my $ajax       = View_ajax->new()      ;
my $struct;
my $data;          

$data = $ajax->get_data_from_server();

$DB = &Server_spec_datas::init( "testcase" );

my $controller = Controller_ajax->new( { 
                                         'DB_HANDLE' => $DB, 
                                         'LOG_DIR'   => "/home/deveushu/web_log/test_results/",
                                         "MODEL"     => "Test_case_KPI"
                                        });

$struct = $controller->start_action( $data );
$ajax->send_data_to_server( $struct, "JSON" );