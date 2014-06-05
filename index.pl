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
	<link rel="shortcut icon" href="/UI/ruckus.ico">
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
		
	//moseover	
		\$(function(){
		  \$("#OS_selectMulti").mouseover(function(){
		  	\$("#msg_img_OS").show();
		  	 setTimeout(function(){\$('#msg_img_OS').fadeOut() }, 2000);
		   		  });
		  \$("#OS_selectMulti").mouseout(function(){
			 \$("#msg_img_OS").hide();
		  });
		 });
		 
		 
		 \$(function(){
		  \$("#AP_selectMulti").mouseover(function(){
		  	\$("#msg_img_AP").show();
		  	 setTimeout(function(){\$('#msg_img_AP').fadeOut() }, 2000);
		   		  });
		  \$("#AP_selectMulti").mouseout(function(){
			 \$("#msg_img_AP").hide();
		  });
		 });
		 
		
	
	});
		
		
			function show1(call)
			{
				
				if(document.getElementById('MultiAPSelect').checked)
				{
					var selectedValuesAP = \$('#AP_selectMulti').val();
					var OSvalue=document.getElementById('OS_select').options[document.getElementById("OS_select").selectedIndex].value;
					if(selectedValuesAP==null)
						{
						 
						  alert("Please Select two AP Model");
						}
					else if(selectedValuesAP.length=='1')
					{
						alert("Please select one more AP Model to compare")						
					}
						else
						{
								value=selectedValuesAP.join();
								var param = {APId:value,OSId:OSvalue};
								\$.ajax({
										url: 'MultiApDetails.pl',
										type: 'POST',
										data:param,
										cache: false,
										success:function(response)
										{
												\$('#reset').show();
												\$('#showDiv').show();
												\$('#CompareDiv').show();
												\$('#CompareModel').hide();
												\$('#abb').show();
												\$('#abb_display').show();
												\$('#CompareDiv').html(response);
												document.getElementById("MultiAPSelect").disabled=true;
											
										}
									});
							
						}
					
				}
				else
				{
						/*\$('#reset').hide();*/
						var selectedValues = \$('#OS_selectMulti').val();
						var APvalue=document.getElementById('AP_select').options[document.getElementById("AP_select").selectedIndex].value;
					
						if(selectedValues==null)
						{
						 
						  alert("Please Select OS");
						}
						else if (selectedValues.length>4)
						{
							alert("You can select only four OS");
						}
						else if(selectedValues.length==1)
						{
							text=\$("#OS_selectMulti :selected").text();
							val=document.getElementById('OS_selectMulti').options[document.getElementById("OS_selectMulti").selectedIndex].value
							passing_val=text+"_"+val;
							\$('#CompareModel').hide();
							\$("#CompareDiv").show();
							sel_radio(passing_val);
						
							\$('#back').hide();
						
						}
						else
						{
						value=selectedValues.join();
						var param = {Id:value,APId:APvalue};
						\$.ajax({
										url: 'getId.pl',
										type: 'POST',
										data:param,
										cache: false,
										success:function(response){
											if(call=='back')
											{
												
												\$('#CompareDiv').html(response);
												document.getElementById('Comp_model').checked = true;
												\$('#OS_list').show();
												\$('#compare_Table').hide();
												\$('#CompareModel').hide();
												\$('#abb').hide();
												\$('#abb_display').hide();
												\$('#reset_top').hide();
												\$('#calculate').show();
										
												
											}
											else
											{
										
												\$('#CompareDiv').show();
												\$('#CompareModel').hide();
												\$('#abb').show();
												\$('#abb_display').show();
												\$('#CompareDiv').html(response);
												\$('#back').hide();
											}
										}
							});
						}
				}
			}
			function showModelDetails()
			{
					var selectedValues = \$('#Model_select').val();
					var APvalue=document.getElementById('AP_select').options[document.getElementById("AP_select").selectedIndex].value;
			
					if(selectedValues==null)
					{
					 
					  alert("Please Select Clients");
					}
					else if (selectedValues.length>4)
					{
						alert("You can select only four OS");
					}
					else
					{
						value=selectedValues.join();
						var param = {OS_Model:value,APId:APvalue};
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
				var selectedValues = \$('#OS_selectMulti').val();
				value=selectedValues.join();
				var APvalue=document.getElementById('AP_select').options[document.getElementById("AP_select").selectedIndex].value;
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
				var param = {Id:value,Os_Model:ModelValue,APId:APvalue};
				\$.ajax({
								url: 'getModelDetails.pl',
								type: 'POST',
								data:param,
								
								success:function(response){
								
								\$('#CompareDiv').html(response);
								
								}

				});
			
				}
				
				
				
				function change_valueAP()
				{
				var selectedValuesAP = \$('#AP_selectMulti').val();
				value=selectedValuesAP.join();
				
					if(selectedValuesAP==null)
					{
					 
					 	 alert("Please Select two AP Model");
					}
					else if(selectedValuesAP.length=='1')
					{
						alert("Please select one more AP Model to compare")		
						\$('#showDiv').hide();				
					}
					else
					{
				
							var OSvalue=document.getElementById('OS_select').options[document.getElementById("OS_select").selectedIndex].value;
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
							var param = {AP_ID:value,OS_val:ModelValue,OSId:OSvalue};
							\$.ajax({
											url: 'MultiAPSelectDetails.pl',
											type: 'POST',
											data:param,
											
											success:function(response){
											
											\$('#CompareDiv').html(response);
											
											}
			
							});
					}
			
				}
				
				
				
				
				
				
				
				
				function show_radio()
				{
					if(document.getElementById('Comp_model').checked)
					{
						\$('#OS_list').show();
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
								async:false,
								success:function(response){
								\$('#abb').hide();
								\$('#abb_display').hide();
								\$('#calculate').hide();
								/*\$('#reset_top').show();*/
								\$('#CompareDiv').html(response);
								
								}

				});
				
				}
				
				
				function multiSelection()
				{
					var selectedValues = \$('#OS_selectMulti').val();
					
				
					
					if(document.getElementById('MultiAPSelect').checked)	
					{
							\$('#showDiv').hide();
							\$('#td_MultiOS').hide();showDiv
							document.getElementById("td_MultiOS").disabled=true;
							\$('#td_OS').show();
							\$('#td_MultiAP').show();
							\$('#td_AP').hide();
							if(\$('#calculate').css('display') == 'none' && \$('#td_MultiOS').css('display') == 'none')
							{
								\$('#reset_top').hide();
								\$('#calculate').show();
								
							}
						
							
							document.getElementById("td_AP").disabled=true;
					}
					else
					{
						
							\$('#showDiv').show();
							\$('#td_MultiOS').show();
							\$('#td_OS').hide();
							\$('#td_MultiAP').hide();
							\$('#td_AP').show();
							if(selectedValues.length=='1' && \$('#td_OS').css('display') == 'none')
							{
								\$('#reset_top').show();
								\$('#calculate').hide();
								
							}
							
					}
					
				}
				function goBack() {
   					  window.location.assign("../CIMR_CM/index.pl")
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
				<!--span  style=" float:right;margin-top:-19px;color:red;font-size:11px">*Multiple Selection [Ctrl+click]</span> -->
					<table width='1024px' align='center' style='margin:0px auto;'>
						<tr>
							<td align='top' width='250px' style='padding: 0 0 96px'>
								<div id='ZF_div'>
									<span  >ZF Version</span>
									<select name='select3' onChange='' id='ZF_select'>
													<option  value='ZD 1100'>9.8</option>
												
									</select>

	   						      	</div>
   						      	</td>
							<td align='top' width='400px' style='padding: 0 0 57px'>	
								<div id='AP_div'>
									<table>
										<tr>
											<td style="width:156px;padding: 0 0 17px;">
												<span style="margin-top:10px">Access Point Model</span>&nbsp<input type='checkbox' name='sel' value='AP' id ='MultiAPSelect' onclick='multiSelection()'><span style='font-size:12px'>Multiple AP Model</span> 
											</td>
											<td id='td_AP' style="padding: 0 0 35px;" >
												 <select name='select1' id='AP_select'  >
													<option value='7'>R700</option>
													<option value='8'>ZF7762-S/ZF7363/ZF7962</option>
													<option value='9'>ZF7372/ZF7373-E/ZF7321</option>
												</select>
											</td>
											<td id='td_MultiAP' style='display:none'>
												<select name='select1' size="3" id='AP_selectMulti' multiple >
													<option value='7'>R700</option>
													<option value='8'>ZF7762-S/ZF7363/ZF7962</option>
													<option value='9'>ZF7372/ZF7373-E/ZF7321</option>
												</select>
											</td
										</tr>
								   </table>
								</div>
							</td>
							<td align='top' width='360px'  style='padding: 0 0 25px' >
								<div id='OS_div' >
								<table>
									<tr>
										<td  style="width:198px;padding: 0 0 50px;" >
										<span style="margin-top:10px">Client Operating System</span> 
										</td>
										<td style='display:none;padding:0 0 46px;' id='td_OS' >
											<select	name='select2' style="width:168px;" id='OS_select'>
												<option value='1' selected>Apple-iOS</option>
												<option value='2'>Android</option>
												<option value='3'>Windows & WP</option>
												<option value='4'>Mac OS</option>
												<option value='5'>Chrome OS</option>
												<option value='6'>Other</option>
											</select>
										</td>
										<td id='td_MultiOS'>
											<select	name='select2'  size="4" style="width:168px" id='OS_selectMulti' multiple>
												<option value='1'>Apple-iOS</option>
												<option value='2'>Android</option>
												<option value='3'>Windows & WP</option>
												<option value='4'>Mac OS</option>
												<option value='5'>Chrome OS</option>
												<option value='6'>Other</option>
											</select>
										</td
									</tr>
								</table><br>
							</div>
							</td></tr></table>
							<div id='msg_img_AP' align='center' style='display:none'><img src='/CIMR_CM/speech-bubble-md.png' width='126px'></div>
							<div id='msg_img_OS' style='display:none'><img src='/CIMR_CM/speech-bubble-md.png' width='126px'></div>
							<div align='center'>
							<input type='button' id="calculate" onClick="show1('first_call')" value='Interoperability Report' />
							<input type='button' id="reset" value='Reset' onClick='goBack()' style='background-image: linear-gradient(#FFB870, #EA7600 60%, #8E4800);color:#FFFFFF'/>
							<input type='button' id="reset_top" value='Reset' onClick='goBack()' style='display:none;background-image: linear-gradient(#FFB870, #EA7600 60%, #8E4800);color:#FFFFFF;margin-left:-38px'/>
						
							</div>
				</div><!--selectDiv div Ends-->
		<div style="clear:both;"></div>
			</div>
		<!--main div Ends-->
		<div style='padding-top: 25px;'><span> </span></div>	
		
HTML
print "	

<div id='showDiv'>

		<span id='abb_display' style='display:none'>*Abbrevations at the bottom</span>
		<div id='Compare'>
		<div id='CompareDiv' align='center' style='display:none'></div><!--CompareDiv div Ends-->
		<a href='#top' id='top' style='text-decoration:none'><span>TOP</span></a>
		
		<div id='CompareModel' align='center' style='display:none' ></div>
		</div>
			<div id='abb' align='center' style='display:none'><table>
		<tr>
			<td style='color:black'>Y</td>
			<td>:</td>
			<td>Success</td>
			<td>&nbsp </td>
			<td style='color:#F07621'>N-AP.Fail</td>
			<td>:</td>
			<td>AP Failure</td>
		</tr>
		<tr>
		<td style='color:#F0B2D1'>Partial(1)</td>
			<td>:</td>
			<td>Zero IT Download successful</td>
			<td> &nbsp</td>
			<td style='color:#B2B2CC'>N.S.(Client)</td>
			<td>:</td>
			<td>Not Supported-Client Limitation</td>
			<td>&nbsp </td>
			
		</tr>
		<tr>
			<td style='color:#BFAA94'>Partial(2)</td>
			<td>:</td>
			<td>Zero IT Download & Installation successful</td>
			<td>&nbsp </td>
			<td style='color:#E0D1B2'>N.A</td>
			<td>:</td>
			<td>Both Client & AP not supported</td>
			
		</tr>
		<tr>
			<td style='color:#B8D0E8'>Partial(1,2)</td>
			<td>:</td>
			<td>Zero IT Download successful</td>
			<td>&nbsp </td>
			<td style='color:#FF9999'>N-Client.Fail</td>
			<td>:</td>
			<td>Client Failure</td>
			
		</tr>
		</table></div>
		</div>
		</div><!--mainDiv div Ends-->

	
 </body>
</html>
";


	
