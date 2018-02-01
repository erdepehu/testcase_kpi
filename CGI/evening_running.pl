#!/usr/bin/perl -w

use strict;
use warnings;
use lib "/home/deveushu/OmniBB/PERL_MODULES";
use Server_spec_datas qw( $DB SESS_REQED $LOG ); 
use CGI;
use View_ajax;
use Controller_ajax;
use Data::Dumper ;

my $DB = &Server_spec_datas::init("omni");
my $script   = "perl ~/OmniBB/TOOLS/SYSTEM_TEST_RUNNER/CGI/evening_running.pl";
my $template = "FEATURE_FOLDER=\"/home/deveushu/workspace_omnibb/com.bbraun.test.guitest/script\"";
my @text;
my @test_datas;
my $data = {'get_evening_running_tests'=> {'get'=> 1}};
#my $controller = Controller_ajax->new( { 'DB_HANDLE' => $DB });                                         
my $controller = Controller_ajax->new( { 'DB_HANDLE' => $DB, 
                                         'LOG_DIR'   => "/home/deveushu/web_log/test_results/",
                                         "MODEL"     => "Test_case_KPI"
                                        });


my $struct = $controller->start_action( $data );

foreach(@{$struct->{'get_evening_running_tests'}}){
    push @text,$_->{"Text"};
    my $tmp->{"FeatureID"} = $_->{"FeatureID"};
    $tmp->{"Mode"} = $_->{"Mode"};
    push @test_datas,$tmp;
}

&set_evening_running_script(@text);
&set_feature_srcmode(@test_datas);

sub set_evening_running_script{
    my $text .= $script   . "\n";
       $text .= $template . "\n";
    foreach(@_){
        $text .= $_ . "\n";
    }
    chomp $text;
    &write_file($text);
}

sub write_file{
    my $dir = '/home/deveushu/workspace/com.bbraun.test.guitest/script/all_fea.sh';
    open(my $fh, ">", $dir) or die "Couldn't open: $!";
    print $fh $_[0];
    close $fh;
    chmod(0777, $dir) or die "Couldn't chmod $dir: $!";
    return $dir;
}

sub set_feature_srcmode{
    foreach(@_){
        if($_->{'Mode'} =~ /playback_mode/){
            $_->{'Mode'} = 2;
        }else{
            $_->{'Mode'} = 1;
        }
        
        $data = {'ScreenshotModeUpdate'=> {'FeatureID'        =>  $_->{'FeatureID'}   ,
                                            'ScreenshotModeID' =>  $_->{'Mode'}  }
        };
        $struct = $controller->start_action( $data );
    }
}