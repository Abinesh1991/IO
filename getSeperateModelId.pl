#!/usr/bin/perl
use Data::Dumper;
use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);
$dbh=DBI->connect('DBI:mysql:IO','root','mysql123');
$inputtime=localtime();
$cgi=new CGI;
$Model_id=$cgi->param('Id');
$Os_Model=$cgi->param('Os_Model');
print "Content-type:text/html\n\n";
print <<HTML;
<!Doctype html>
<html>
	<head>
		</title>
		<link href="/CIMR_CM/style.css" rel="stylesheet" />
		
			<script>
			
			</script
		</head>
HTML
@OS=split(',',$Os_id);
map {$OS_Model{$_}="selected"} split(',',$Os_Model);
@OS_Model_Id=split(',',$Os_Model);

@Model_id1=split('_',$Model_id);
print "<div align='center'> <span style='color:#B2491E	'>Operating Systerm:</span>$Model_id1[0]</div><br>";


				 $sql="select Id,Models_Name from OsModels where OS_Id=$Model_id1[1]";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				print "<div><select id='Model_select' align='center'  style='width:20%;color:#B2491E'  multiple>";		
				my $selected="";
				while(@result=$sth->fetchrow_array())
					{

						$b="<option value='$result[0]'>$result[1]</option>";
						print "$b";
						
						
					
					}
			print "</select></div><br>
			<div align='center'>
			<input type='button' id='calculate' style='margin-left:-28px' onClick='showModelDetails()' value='Compare Clients' /><input type='button' id='back' style='margin-left:9px;background-image: linear-gradient(#FFB870, #EA7600 60%, #8E4800);color:#FFFFFF' onClick='show1(\"back\")' value='Back' /></div>";

















