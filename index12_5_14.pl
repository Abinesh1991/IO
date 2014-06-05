#!/usr/bin/perl
use Data::Dumper;
use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);
$dbh=DBI->connect('DBI:mysql:IO','root','mysql123');
$inputtime=localtime();
$cgi=new CGI;
$OS_id=$cgi->param('Id');

print "Content-type:text/html\n\n";
print <<HTML;
<!Doctype html>
<html>
	<head>
		<title>Client Interoperability Matrix Report</title>
		
	</title>
		<link href="/CIMR_CM/style.css" rel="stylesheet" />
		<script src="/CIMR_CM/jquery-1.9.0.min.js"></script>
		<link href="/CIMR_CM/jquery.mCustomScrollbar.css" rel="stylesheet" />
		<script src="/CIMR_CM/jquery.mCustomScrollbar.concat.min.js"></script>
		<script type='text/javascript'>
		
			

		
		
		
	\$(document).ready(function(){

	// hide #back-top first
	\$("#top").hide();
	
	// fade in #back-top
	\$(function () {
		\$(window).scroll(function () {
			if (\$(this).scrollTop() > 100) {
				\$('#top').fadeIn();
			} else {
				\$('#top').fadeOut();
			}
		});

		// scroll body to 0px on click
		\$('#top').click(function () {
			\$('body,html').animate({
				scrollTop: 0
			}, 800);
			return false;
		});
		  
			
	});
	
	
	 
     
			
	

});
		
		
			function show1()
			{
			
;				var selectedValues = \$('#OS_select').val();
				
				
				if(selectedValues==null)
				{
				 
				  alert("Please Select OS");
				}
				else if (selectedValues.length==5)
				{
					alert("You can select only four OS");
				}
				else
				{
				value=selectedValues.join();
				
			
				var param = {Id:value};
				

				 \$.ajax({
								url: 'getId.pl',
								type: 'POST',
								data:param,
								cache: false,
								success:function(response){
								\$('#CompareDiv').show();
								\$('#CompareModel').hide();
								\$('#abb').show();
								\$('#abb_display').show();
								\$('#CompareDiv').html(response);
								}

				});
				}
		
		

			}
			function showModelDetails()
			{
				
			
			
					var selectedValues = \$('#Model_select').val();
					if(selectedValues==null)
					{
					 
					  alert("Please Select Clients");
					}
					else if (selectedValues.length==5)
					{
						alert("You can select only four OS");
					}
					else
					{
						value=selectedValues.join();
						var param = {OS_Model:value};
						 \$.ajax({
										url: 'getSeparateModelDetails.pl',
										type: 'POST',
										data:param,
										cache: false,
										success:function(response){
										\$('#CompareModel').show();
										\$('#abb').show();
										\$('#abb_display').show();
										\$('#CompareModel').html(response);
										}

						});
					}
			
			}
			
			function change_value()
				{
				var selectedValues = \$('#OS_select').val();
				
				value=selectedValues.join();
				
				var get_table = document.getElementById('compare_Table');
				var get_sel = get_table.getElementsByTagName('Select');
				var add_tot_sel = get_sel.length;
				var add_sel_id=new Array();
				var add_count=0;
					for (var i = 0; i < add_tot_sel; i++)
						{ 
							add_select_id=get_sel[i].getAttribute('id');
							var a=document.getElementById(add_select_id).value;
							add_sel_id[add_count]=a;
							add_count++;
							
			
						}
				
				ModelValue=add_sel_id.join();
				
				var param = {Id:value,Os_Model:ModelValue};
				\$.ajax({
								url: 'getModelDetails.pl',
								type: 'POST',
								data:param,
								
								success:function(response){
								
								\$('#CompareDiv').html(response);
								
								}

				});
			
				}
				
				function show_radio()
				{
					if(document.getElementById('Comp_model').checked)
					{
						\$('#OS_list').show();
						\$('#compare_Table').hide();
						\$('#abb').hide();
						\$('#abb_display').hide();
					}
					else
					{
					
						\$('#OS_list').hide();	
						\$('#compare_Table').show();
						\$('#abb').show();
						\$('#abb_display').show();
											
						
					}
				}
				
				function sel_radio(val)
				{
				
					var param = {Id:val};
					\$.ajax({
								url: 'getSeperateModelId.pl',
								type: 'POST',
								data:param,
								
								success:function(response){
								\$('#abb').hide();
								\$('#abb_display').hide();
								\$('#CompareDiv').html(response);
								
								}

				});
				
				
					
				
				}
				
		</script>
	</head>
	<body>
	<div class="large-arcs">
		<img class="arcs" alt="branding element" style=' ' src="http://c593754.r9.cf2.rackcdn.com/images/svg/arcs.svg">
	</div>
<div id="main">
	<table width="100%" style="margin-top:0px;height:60px;">
  		<tr>
  			<td width="230px"><img src="/CIMR/ruckus_logo.svg" width="150px" height="50px"></td>
  			<td><font style="color:#F07621;font-size:25px;">Client Interoperability Matrix Report</font></td>
  			<td width="230px" style="valign:top;"><div id="time">$inputtime</div></td>
  		</tr>
  	</table>
  	
HTML


print <<HTML;

		<div id='mainDiv'>
				
				<div id='selectDiv'>
							<div id='ZF_div' align='left' >
								<span  >ZF Version</span>
								<select name='select3' onChange='' id='ZF_select'>
												<option  value='ZD 1100'>1100</option>
												<option  value='ZD 3000'>3000</option>
												<option  value='ZD 5000'>5000</option>
								</select>

   						      	</div>
								
							<div id='AP_div'>
								<span > Access Point Model</span>
								 <select name='select1' id='AP_select' onChange='change(this.options[this.selectedIndex].id)'>
									<option value='Select'>R700</option>
									<option value='Select'>ZF7762-S/ZF7363/ZF7962</option>
									<option value='Select'>ZF7372/ZF7373-E/ZF7321</option>
								</select>
							</div>
							<div id='OS_div' align='right' >
							<table>
								<tr>
								<td style="width:147px;padding: 0 0 56px;">
								<span style="margin-top:10px">Operating System</span> <span style='font-size:10px;margin-left:48px'>(Muliple Select)</span> 
								</td>
								<td>
								
								<select	name='select2'  size="5" style="width:168px" id='OS_select' multiple>
									<option value='1' selected>Apple-iOS</option>
									<option value='2'>Android</option>
									<option value='3'>Windows & WP</option>
									<option value='4'>Mac OS</option>
									<option value='5'>Chrome OS</option>
									<option value='6'>Other</option>
								</select>
								</td
								</tr>
							</table><br>
							</div><br><br><br>
							<div align='center'>
							<input type='button' id="calculate" onClick="show1()" value='Compare OS' />
							</div>
				
								
				</div><!--selectDiv div Ends-->
		
		<div style="clear:both;"></div>
			</div>
		<!--main div Ends-->
		<div style='padding-top: 25px;'><span> </span></div>	
		
HTML
print "		
		<span id='abb_display' style='display:none'>*Abbrevation at the bottom</span>
		<div id='CompareDiv' align='center' style='display:none'>
		

		
		</div><!--CompareDiv div Ends--><a href='#top' id='top' style='text-decoration:none'><span>TOP</span></a>
		<div id='CompareModel' align='center' style='display:none' ></div>
			<div id='abb' align='center' style='display:none'><table>
		<tr>
			<td style='color:#F07621'>Y</td>
			<td>:</td>
			<td>Success</td>
			<td>&nbsp </td>
			<td style='color:#F07621'>N-AP.Fail</td>
			<td>:</td>
			<td>AP Failure</td>
			
			
		</tr>
		<tr>
		<td style='color:#F07621'>Partial(1)</td>
			<td>:</td>
			<td>Zero IT Download successful</td>
			<td> &nbsp</td>
			<td style='color:#F07621'>N.S.(Client)</td>
			<td>:</td>
			<td>Not Supported-Client Limitation</td>
			<td>&nbsp </td>
			
		</tr>
		<tr>
			<td style='color:#F07621'>Partial(2)</td>
			<td>:</td>
			<td>Zero IT Download & Installation successful</td>
			<td>&nbsp </td>
			<td style='color:#F07621'>N.A</td>
			<td>:</td>
			<td>Both Client & AP not supported</td>
			
		</tr>
		<tr>
			<td style='color:#F07621'>Partial(1,2)</td>
			<td>:</td>
			<td>Zero IT Download successful</td>
			<td>&nbsp </td>
			<td style='color:#F07621'>N-Client.Fail</td>
			<td>:</td>
			<td>Client Failure</td>
			
		</tr>
		</table></div>
		</div><!--mainDiv div Ends-->

	
 </body>
</html>
";


	
