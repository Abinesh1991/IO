#!/usr/bin/perl
use Data::Dumper;
use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);
$dbh=DBI->connect('DBI:mysql:IO','root','mysql123');
$inputtime=localtime();
$cgi=new CGI;
$OS_id=$cgi->param('Id');
$AP_id=$cgi->param('APId');

$OS_Model=$cgi->param('Os_Model');

print "Content-type:text/html\n\n";
print <<HTML;
<!Doctype html>
<html>
	
HTML
@OS=split(',',$OS_id);
@OS_Model_Id=split(',',$Os_Model);
print "@OS_Model_Id";




print "
<div align='center' id=''>Compare with in a Operating System&nbsp<input type='checkbox' onClick='show_radio()' id='Comp_model'></div><br>
<div align='center' id='OS_list' style='display:none;color:#336688'>";
foreach $a(@OS)
		{
			
				 $sql="select Value,Id from Master where Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
					 while(@result=$sth->fetchrow_array())
					{
						print "<input type='radio' name='OS' onchange='sel_radio(this.id)' id='$result[0]_$result[1]'>$result[0]&nbsp&nbsp&nbsp";
					}
					
		}

				 $sql="select Value from Master where Id=$AP_id";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				 $AP= $sth->fetchrow_array();

print "</div>
<h1>@OS_Model_Id[0]</h1>
<form method='GET' id='formS'>
		<div align='center' style='padding:10px' >Access Point Model:<span style='color:#F07621'>$AP</span></div>	
		<table class='Comp-tab' border=1 cellspacing='0' id='compare_Table' cellpadding='0'>
		<tr>
		<tr><td height='25px' colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>OS</td>";
		
		
		foreach $a(@OS)
		{
			
				 $sql="select Value from Master where Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
					 while(@result=$sth->fetchrow_array())
					{
						print "<td align='center'>	$result[0]</td>";
					}
					
		}
		print "</tr>";
		
		
		
		
		print "<tr id='OS_Model'>";
		print "<td height='25px' colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>Clients</td>";
		foreach $a(@OS)
		{
			print "<td height='25px'>";
				 $sql="select Id,Models_Name from OsModels where OS_Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
				my $Index=1;
				print "<select id='$a' style='width:100%;color:#FFFFFF;background:#FF8533;' onChange='change_value()'>";		
				my $selected="";
				 while(@result=$sth->fetchrow_array())
					{
						if($Index==1)
						{
						push(@OS_Model_Id,$result[0]);
						}
						$b="<option value='$result[0]'>$result[1]</option>";
						print "$b";
					$Index++;
					}
			print "</select></td>";
		}
	
	print "</tr><td colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>OS Version</td>";
	
	
	

#getting Version Details
	
	foreach $a(@OS_Model_Id)
		{
		
				 $sql="select Version from OsModels where Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
				
				 while(@result=$sth->fetchrow_array())
					{
						print "<td align='center'>$result[0]</td>"
					}
			
		}
	
	print "</tr><td colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>Chipset</td>";
	
	
	
	
	
#getting Chipset Details	
	foreach $a(@OS_Model_Id)
		{
			print "";
				 $sql="select Type from OsModels where Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
				
				 while(@result=$sth->fetchrow_array())
					{
						print "<td align='center'>$result[0]</td>"
					}
			
		}
	
	print "</tr>";
	
	
	
	
	
		
#getiing heading of Os Model	
	
			 $sql="select Id,FeatureHeading,OS_Id from Features ";
			 $sth=$dbh->prepare($sql);
			 $sth->execute();
			 $i=0;		
			 while(@result=$sth->fetchrow_array())
				{
				
					
					if($result[1] =~/!/)
					{
						@Double_heading=split('!',$result[1]);
						print "<tr ><td style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;'>@Double_heading[0]</td><td style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' colspan='5'>@Double_heading[1]</td>";
					}
					else
					{
					
							if($result[2]=='11')
							{
								print "<tr><td style='box-shadow: -1px 4px 5px #838383;background: #44C1DC;' colspan='15'>$result[1]</td></tr>";
							}
							else
							{
								print "<tr><td colspan='6' style=' box-shadow: -1px 4px 5px #838383;background: none repeat scroll 0 0 #DCDCD5;'>$result[1]</td>";
								
							}
					}
#getting Details of OSModels	
							foreach $M_Id(@OS_Model_Id)
								{
									 $fetch_details="select Details from ModelFeatureDetails where Model_Id=$M_Id and Feature_Id='$result[0]' and APId=$AP_id";
									 $fetch_details_sth=$dbh->prepare($fetch_details);
									 $fetch_details_sth->execute();	
									
									 while(@result1=$fetch_details_sth->fetchrow_array())
									 {
									 	if($result1[0] eq 'Partial(2)')
									 	{
									 		$classname='partial2';
									 		
									 	}
									 	
									 	elsif($result1[0] eq 'Partial(1)')
									 	{
									 		$classname='partial1';
									 		
									 	}
									 	elsif($result1[0] eq 'Partial(1,2)')
									 	{
									 		$classname='partial1_2';
									 		
									 	}
									 	elsif($result1[0] eq 'N.S.(client)')
									 	{
									 		$classname='N_S_Client';
									 		
									 	}
									 	elsif($result1[0] eq 'N-Client.Fail')
									 	{
									 		$classname='N_S_Fail';
									 		
									 	}
									 	elsif($result1[0] eq 'N.A.')
									 	{
									 		$classname='N_A';
									 		
									 	}
									 	else
									 	{
									 	$classname='even';	
									 		
									 	}

										print "<td align='center' class='$classname'>$result1[0]</td>" 	
									 }
								 }
					$i++;
					
				}

		
		print "</tr></table></form>
	
		";
	

