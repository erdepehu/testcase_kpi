#!/usr/bin/perl -w

##
##  printenv -- demo CGI program which just prints its environment
##
use strict;
use warnings;

use lib "/home/deveushu/OmniBB/PERL_MODULES";
use Server_spec_datas qw( $DB SESS_REQED $LOG ); 
use CGI;
use View_ajax;
use Controller_ajax;
use Data::Dumper ;

my $datas;
$datas->{ 'cell_infos' }->{ 'project' }        = 1 ;  
$datas->{ 'cell_infos' }->{ 'test_case_type' } = 4 ;               

my $struct;
$DB = &Server_spec_datas::init( "testcase" );

=pod

my $data = {
    
          'add_version'    => { 
                  'VersionName'   => '1_05_156',
    				   } ,
          'add_testcasetype'    => { 
                  'TestCaseTypeName'   => 'proba_test_casetype',
                        } ,
          'add_result'    => { 
                  'ResultName'    => 'proba_RESULT',
                        } ,
          'add_project'    => { 
                  'ProjectName'    => 'proba_project',
                        } ,
          'add_test_case'    => { 
                 "TestCaseName"   => "proba_test_case_name",
                 "TestCaseTypeID" => 2,
                        } ,
          'add_test' =>{
              'ResultID'       => 2 ,
              'TestCaseName'   => "proba_test_global",
              'TestCaseTypeID' => 2,
              'ProjectID'      => 2,
              'Version'        => "1_xxx_xxx",
              'Revision'       => 32342,
              'Time'           => "2015-06-10 9:40_12"
          }, 
          'get_projects' =>{
              'get'       => 1 ,
          }, 
          'get_testcasetypes' =>{
              'get'       => 1 ,
          }, 
          'all_testcases_by_revision' =>{
              'function'       => "all_testcases_by_revision",
          },
         'all_testcases_by_revision' =>{
             'function'       => "all_testcases_by_revision",
             'params'         => $datas,
         },   
         
         'passed_testcases_by_revision' =>{
             'function'       => "passed_testcases_by_revision",
             'params'         => $datas,
         }, 
    
         'get_latest_revision_by_ProjectID_and_TestCaseTypeID' =>{
             'function'       => "passed_testcases_by_revision",
             'params'         => $datas,
         }  
         
         'get_latest_revision_by_ProjectID_and_TestCaseTypeID' =>{
             'function'       => "get_latest_revision_by_ProjectID_and_TestCaseTypeID",
             'params'         => $datas,
         }  
   
         'get_datas_by_act_cell' =>{
             'cell_infos' => $datas,
         } , 
        'all_testcases_by_revision' =>{
            'function'       => "all_testcases_by_version",
            'params'         => $datas,
        },   
        
        'passed_testcases_by_revision' =>{
            'function'       => "passed_testcases_by_version",
            'params'         => $datas,
        }, 
        
        'get_latest_revision_by_ProjectID_and_TestCaseTypeID' =>{
            'function'       => "passed_testcases_by_version",
            'params'         => $datas,
        },         
     } ;
     
=cut

my $data = {
          'get_screenshots_by_version'    => { 
                  'get'   => 1,
    				   } ,    
};

my $controller = Controller_ajax->new( { 'DB_HANDLE' => $DB, 
                                         'LOG_DIR'   => "/home/deveushu/web_log/test_results/",
                                         "MODEL"     => "Test_case_KPI"
                                        });
$struct = $controller->start_action( $data );


print Dumper $struct ;



