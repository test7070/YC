﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
            var q_name = "cub_s";
			aPop = new Array(['txtTggno', 'lblTggno', 'sss', 'noa,namea', 'txtTggno', 'sss_b.aspx']);
            $(document).ready(function() {
                main();
            });

            function main() {
                mainSeek();
                q_gf('', q_name);
            }

            function q_gfPost() {
                q_getFormat();
                q_langShow();
                bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]];
                q_mask(bbmMask);
                
                $('#lblDatea').text('預交日');
                $('#lblTggno').text('員工編號');
                $('#lblTgg').text('員工姓名');
                
                /*q_cmbParse("cmbEnda", '@全部,1@結案,0@未結案');
                q_cmbParse("cmbCancel", '@全部,1@取消,0@未取消');*/
                $('#txtBdate').datepicker();
				$('#txtEdate').datepicker(); 
                $('#txtNoa').focus();
            }

            function q_seekStr() {
            	/*t_enda = $.trim($('#cmbEnda').val());
            	t_cancel = $.trim($('#cmbCancel').val());*/
            	
                t_noa = $.trim($('#txtNoa').val());
                t_bdate = $('#txtBdate').val();
		        t_edate = $('#txtEdate').val();
		        t_tggno = $.trim($('#txtTggno').val());
		        t_tgg = $.trim($('#txtTgg').val());
		        
		        t_ordeno = $.trim($('#txtOrdeno').val());
		        t_no2 = $.trim($('#txtNo2').val());
		        
		        t_uno = $.trim($('#txtUno').val());
                
		        var t_where = " 1=1 " 
		        + q_sqlPara2("noa", t_noa) 
		        + q_sqlPara2("datea", t_bdate, t_edate) 		     
		        + q_sqlPara2("tggno", t_tggno);
		        /*if (t_enda.length>0)
		        	t_where += " and isnull(enda,0)="+t_enda;
		        if (t_cancel.length>0)
		        	t_where += " and isnull(cancel,0)="+t_cancel;*/
		        if (t_tgg.length>0)
		        	t_where += " and charindex('"+t_tgg+"',tgg)"	
		        	
		        if(t_ordeno.length>0)
		        	t_where += " and exists(select noa from view_cubs where noa=view_cub"+r_accy+".noa and ordeno='"+t_ordeno+"' "+q_sqlPara2("no2", t_no2) +" ) ";
		       	 	
		       	if(t_uno.length>0)
		       		t_where += " and (exists(select noa from view_cubt where view_cubt.noa=cub"+r_accy+".noa and view_cubt.uno='"+t_uno+"') or exists(select noa from view_cubs where view_cubs.noa=cub"+r_accy+".noa and view_cubs.uno='"+t_uno+"'))";
		       		
		        t_where = ' where=^^' + t_where + '^^ ';
		        return t_where;
            }
		</script>
		<style type="text/css">
            .seek_tr {
                color: white;
                text-align: center;
                font-weight: bold;
                background-color: #76a2fe;
            }
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<!--<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblEnda'> </a></td>
					<td><select id="cmbEnda" style="width:215px; font-size:medium;" > </select></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCancel'> </a></td>
					<td><select id="cmbCancel" style="width:215px; font-size:medium;" > </select></td>
				</tr>-->
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblNoa'> </a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td   style="width:35%;" ><a id='lblDatea'> </a></td>
					<td style="width:65%;  ">
						<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
						<span style="display:inline-block; vertical-align:middle">&sim;</span>
						<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblTggno'> </a></td>
					<td><input class="txt" id="txtTggno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblTgg'> </a></td>
					<td><input class="txt" id="txtTgg" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblOrdeno'> </a></td>
					<td>
						<input class="txt" id="txtOrdeno" type="text" style="width:150px; font-size:medium;" />
						<input class="txt" id="txtNo2" type="text" style="width:55px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblUno'> </a></td>
					<td><input class="txt" id="txtUno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>