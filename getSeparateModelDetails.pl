#!/usr/bin/perl
use Data::Dumper;
use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);
$dbh=DBI->connect('DBI:mysql:IO','root','mysql123');
$inputtime=localtime();
$cgi=new CGI;
$Model_id=$cgi->param('Id');
$Os_Model=$cgi->param('OS_Model');
$AP_id=$cgi->param('APId');
print "Content-type:text/html\n\n";
@OS_Model_Id=split(',',$Os_Model);
$sql="select Value from Master where Id=$AP_id";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				 $AP= $sth->fetchrow_array();

print "
 	


		<div align='center' style='padding:10px' >Access Point Model:<span style='color:#F07621'>$AP</span></div>

		<table class='Comp-tab' border=1 cellspacing='0' id='compare_Table' cellpadding='0'>";
		
		
		print "<tr id='OS_Model'>";
		print "<td height='25px' colspan='6' style='box-shadow: -1px 4px 5px #838383; background: none repeat scroll 0 0 #DCDCD5;' align='center'>Clients</td>";
		foreach $a(@OS_Model_Id)
		{
			print "<td height='25px' align='center'>";
				 $sql="select Models_Name from OsModels where Id=$a";
				 $sth=$dbh->prepare($sql);
				 $sth->execute();
				
				while(@result=$sth->fetchrow_array())
					{

						$b="$result[0]";
						print "$b";
						
						
					
					}
			print "</td>";
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

		
		print "</table>	";
	

