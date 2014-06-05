#!/usr/bin/perl
use Data::Dumper;
use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);
$dbh=DBI->connect('DBI:mysql:IO','root','mysql123');
$inputtime=localtime();
$cgi=new CGI;
$AP_id=$cgi->param('APId');
$OS_Id=$cgi->param('OSId');
print "Content-type:text/html\n\n";
print <<HTML;
<!Doctype html>
<html>
	
HTML
@AP=split(',',$AP_id);







print "</div>

<form method='GET' id='formS'>
			
		<table class='Comp-tab' border=1 cellspacing='0' id='compare_Table' cellpadding='0'>
		<tr><td height='25px' colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>Access Point Model</td>";
		
		
		foreach $a(@AP)
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
		foreach $M_Id(@AP)
		{	
			print "<td height='25px'>";
				 $sql="select Id,Models_Name from OsModels where OS_Id=$OS_Id";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
				my $Index=1;
				print "<select id='$M_Id-os-$OS_Id' style='width:100%;color:#FFFFFF;background:#FF8533;' onChange='change_valueAP()'>";		
				my $selected="";
				 while(@result=$sth->fetchrow_array())
					{
						if($Index==1)
						{
						push(@First_OS_Model_Id,$result[0]);
						}
						$b="<option value='$M_Id-$result[0]'>$result[1]</option>";
						print "$b";
					$Index++;
					}
		
			print "</select></td>";
	
	}
			print "</tr><td colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>OS Version</td>";
	
	
		
	
#getting Version Details
	foreach $a(@First_OS_Model_Id)
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
	foreach $a(@First_OS_Model_Id)
		{
				 $sql="select Type from OsModels where Id=@First_OS_Model_Id[0]";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
				
				 while(@result=$sth->fetchrow_array())
					{
						print "<td align='center'>$result[0]</td>"
					}
		
		}
	print "</tr>";
	
	
	
	
	
		
#getting heading of Os Model	
	
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
							for($j=0;$j<scalar(@AP);$j++)
							{
									 $fetch_details="select Details from ModelFeatureDetails where Model_Id=$First_OS_Model_Id[$j] and Feature_Id='$result[0]' and APId=@AP[$j]";
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

		
		print "</tr></table></form>
	
		";
	

