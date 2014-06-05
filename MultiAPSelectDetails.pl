#!/usr/bin/perl
use Data::Dumper;
use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);
$dbh=DBI->connect('DBI:mysql:IO','root','mysql123');
$inputtime=localtime();
$cgi=new CGI;
$AP_id=$cgi->param('AP_ID');
$OS_val=$cgi->param('OS_val');
$OS_id=$cgi->param('OSId');
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
@AP=split(',',$AP_id);
map {$OS_val{$_}="selected"} split(',',$OS_val);
@OS_Model_Id1=split(',',$OS_val);
foreach $getOSId(@OS_Model_Id1)
{
@OS_Model_Id2=split('-',$getOSId);
push(@OS_Model_Id,$OS_Model_Id2[1])
}

print"

<form method='GET' id='formS'>

		<table class='Comp-tab' border=1 cellspacing='0' id='compare_Table' cellpadding='0'><tr ><td height='25px' colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>Access Point Model</td>";
		
		
		foreach $a(@AP)
		{
			
				 $sql="select Value from Master where Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
					 while(@result=$sth->fetchrow_array())
					{
						print "<td align='center'>$result[0]</td>";
					}
					
		}
		print "</tr>";
		
		
		print "<tr id='OS_Model'>";
		print "<td height='25px' colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>Clients</td>";
		foreach $a(@AP)
		{
			print "<td height='25px'>";
				 $sql="select Id,Models_Name from OsModels where OS_Id=$OS_id";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				print "<select id='$a' style='width:100%;color:#FFFFFF;background:#FF8533;' onChange='change_valueAP()'>";		
				my $selected="";
				my $Index=1;
				while(@result=$sth->fetchrow_array())
					{
						
						$sel="$a-$result[0]";
						$b="<option $OS_val{$sel} value='$a-$result[0]'>$result[1]</option>";
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
	
	
	
			 $sql="select Id,FeatureHeading,OS_Id from Features ";
			 $sth=$dbh->prepare($sql);
			 $sth->execute();
			 $i=0;		
			 while(@result=$sth->fetchrow_array())
				{
				
					
					if($result[1] =~/!/)
					{
						@Double_heading=split('!',$result[1]);
						print "<tr><td style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;'>@Double_heading[0]</td><td colspan='5' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;'>@Double_heading[1]</td>";
					}
					else
					{
					
							if($result[2]=='11')
							{
								print "<tr><td style='box-shadow: -1px 4px 5px #838383;background: #44C1DC;' colspan='15'>$result[1]</td></tr>";
							}
							else
							{
								print "<tr><td colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;'>$result[1]</td>";
								
							}
					}
							for($j=0;$j<scalar(@AP);$j++)
								{
									 $fetch_details="select Details from ModelFeatureDetails where Model_Id='$OS_Model_Id[$j]' and Feature_Id='$result[0]' and APId='$AP[$j]'";
									 $fetch_details_sth=$dbh->prepare($fetch_details);
									 $fetch_details_sth->execute();	
									#print "<td>$fetch_details</td>";
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

		
		print "</table></form>
			";
	

