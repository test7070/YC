<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_tables = 's';
			var q_name = "ina";
			var q_readonly = ['txtNoa','txtStation','txtComp','txtStore','txtCardeal','txtAddr','txtTranstart','txtWorker','txtWorker2','txtTotal'];
			var q_readonlys = ['txtTotal'];
			var bbmNum = [['txtTotal', 15, 0, 1]];
			var bbsNum = [['txtMount', 10, 0, 1], ['txtPrice', 10, 2, 1], ['txtTotal', 15, 0, 1],['txtLengthb', 10, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				['txtStationno', 'lblStation', 'part', 'noa,part', 'txtStationno,txtStation', 'part_b.aspx'],
				['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				['txtCustno', 'lblCust', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucaucc_b.aspx']
				//,['txtSssno_', 'btnCust_', 'cust', 'noa,nick', 'txtSssno_,txtNamea_', 'cust_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
			});

			var abbsModi = [];

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}

				mainForm(1);
			}

			function mainPost() {
				bbsNum = [['txtMount', 15, q_getPara('vcc.mountPrecision'), 1],['txtWeight', 15, q_getPara('vcc.weightPrecision'), 1],['txtMweight', 15, q_getPara('vcc.weightPrecision'), 1], ['txtPrice', 10, q_getPara('vcc.pricePrecision'), 1], ['txtTotal', 15, 0, 1],['txtLengthb', 10, 0, 1]];
				q_getFormat();
				bbmMask = [['txtDatea', r_picd]];
				q_mask(bbmMask);
				q_cmbParse("cmbItype", q_getPara('inafe.typea'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				
				if (q_getPara('sys.project').toUpperCase()=='YC'){
					$('#lblStation').text('部門');
					$('#lblMweight_s').text('公斤單價');
				}
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			function q_popPost(s1) {
				switch (s1) {
					case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
					case 'txtPost':
						GetTranPrice();
						break;
					case 'txtTranstartno':
						GetTranPrice();
						break;	
				}
			}

			function q_gtPost(t_name) {
				switch (t_name) {
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
				if(t_name.split('_')[0]=="uccuweight"){
					var n=t_name.split('_')[1];
					var as = _q_appendData("ucc", "", true);
					if (as[0] != undefined) {
						q_tr('txtWeight_'+n,q_mul(q_float('txtMount_'+n),dec(as[0].uweight)));
						sum();
					}
				}
				if(t_name.split('_')[0]=="uccstdmount"){
					var n=t_name.split('_')[1];
					var as = _q_appendData("ucc", "", true);
					if (as[0] != undefined) {
						q_tr('txtMount_'+n,q_mul(q_float('txtLengthb_'+n),dec(as[0].stdmount)));
						q_tr('txtWeight_'+n,q_mul(q_float('txtMount_'+n),dec(as[0].uweight)));
						sum();
					}
				}
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_ina') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('ina_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtMount_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccuweight_"+n, r_accy);
							}
							sum();
						});
						
						$('#txtWeight_' + j).change(function() {
							sum();
						});
						
						$('#txtMweight_' + j).change(function() {
							sum();
						});
						
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						
						$('#txtLengthb_'+j).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccstdmount_"+n, r_accy);
							}
						});
					}
				}
				_bbsAssign();
				HiddenTreat()
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				//取得車號下拉式選單
				/*var thisVal = $('#txtCardealno').val();
				var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
				q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");*/
				$('#txtProduct').focus();
			}

			function btnPrint() {
				q_box('z_inap_yc.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['datea'] = abbm2['datea'];
				return true;
			}

			function sum() {
				if(q_cur>2 || q_cur<1)
					return;
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_unit = $.trim($('#txtUnit_' + j).val()).toUpperCase();
					t_mount = q_float('txtMount_' + j);
					t_weight = q_float('txtWeight_' + j);
					if(q_getPara('sys.project').toUpperCase()=='YC'){
						if( q_float('txtMweight_'+j)!=0 && q_float('txtWeight_'+j)!=0)
							q_tr('txtPrice_'+j,round(q_div(q_mul(q_float('txtWeight_'+j),q_float('txtMweight_'+j)),q_float('txtMount_'+j)),q_getPara('vcc.weightPrecision')));
							
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
					}else{
						if (t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓' )
							$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_weight)), 0));
						else
							$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
					}
						
					t1 = q_add(t1, dec(q_float('txtTotal_' + j)));
				}
				$('#txtTotal').val(round(t1, 0));
			}

			function refresh(recno) {
				_refresh(recno);
				HiddenTreat();
			}

			function HiddenTreat(){
				var hasStyle = q_getPara('sys.isstyle');
				var isStyle = (hasStyle.toString()=='1'?$('.isStyle').show():$('.isStyle').hide());
				var hasSpec = q_getPara('sys.isspec');
				var isSpec = (hasSpec.toString()=='1'?$('.isSpec').show():$('.isSpec').hide());
				
				if (q_getPara('sys.project').toUpperCase()!='YC'){
					$('.islengthb').hide();
					$('.bbsmweight').hide();
				}else{
					$('#lblMweight_s').text('公斤單價');
					$('#lblLengthbt_s').text('箱數');
					$('#vewStation').text('部門');
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				HiddenTreat();
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 98%;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 98%;
				margin: -1px;
				border: 1px black solid;
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 9%;
			}
			.tbbm .tdZ {
				width: 2%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 38%;
				float: left;
			}
			.txt.c3 {
				width: 60%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.tbbm textarea {
				font-size: medium;
			}

			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 1260px;">
			<div class="dview" id="dview" style="float: left; width:32%;" >
				<table class="tview" id="tview" border="1" cellpadding='2' cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewStation'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='station'>~station</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 68%;float:left">
				<table class="tbbm" id="tbbm" border="0" cellpadding='2' cellspacing='0'>
					<tr class="tr1">
						<td class='td1'><span> </span><a id="lblItype" class="lbl"> </a></td>
						<td class="td2"><select id="cmbItype" class="txt c1"> </select></td>
						<td class='td3'><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td class="td4"><input id="txtDatea" type="text" class="txt c1"/></td>
						<td class='td3'><span> </span><a id="lblNoa" class="lbl" > </a></td>
						<td class="td4"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr3">
						<td class='td1'><span> </span><a id="lblStation" class="lbl btn" > </a></td>
						<td class="td2" colspan="3">
							<input id="txtStationno" type="text" class="txt c2"/>
							<input id="txtStation" type="text" class="txt c3"/>
						</td>
						<td class='td5'><span> </span><a id="lblOrdeno" class="lbl" > </a></td>
						<td class="td6"><input id="txtOrdeno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr4">
						<td class='td1'><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td class="td2" colspan="3">
							<input id="txtCustno" type="text" class="txt c2"/>
							<input id="txtComp" type="text" class="txt c3"/>
						</td>
						<td class="td5"><span> </span><a id="lblTrantype" class="lbl"> </a></td>
						<td class="td6"><select id="cmbTrantype" class="txt c1"> </select></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id="lblStore" class="lbl btn" > </a></td>
						<td class="td2" colspan="3">
							<input id="txtStoreno" type="text" class="txt c2"/>
							<input id="txtStore" type="text" class="txt c3"/>
						</td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblTotal" class="lbl"> </a></td>
						<td class="td2"><input id="txtTotal" type="text" class="txt num c1" /></td>
						<td class='td3'><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td class="td4"><input id="txtWorker" type="text" class="txt c1"/></td>	
						<td class='td3'><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td class="td4"><input id="txtWorker2" type="text" class="txt c1"/></td>					
					</tr>
					<tr class="tr9">
						<td class='td1'><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td class="td2" colspan='5'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1260px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<!--<td align="center" style="width:100px;"><a id='lblSssno_s'>客戶編號</a></td>
					<td align="center" style="width:150px;"><a id='lblNamea_s'>客戶名稱</a></td>-->
					<td align="center" style="width:130px;"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:300px;"><a id='lblProduct_s'> </a> <a class="isSpec">/</a> <a id='lblSpec' class="isSpec"> </a></td>
					<td align="center" style="width:8%;" class="isStyle"><a id='lblStyles'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>
					<td align="center" style="width:90px;" class="islengthb"><a id="lblLengthbt_s"> </a></td>
					<td align="center" style="width:90px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:90px;" class="bbsmweight"><a id='lblMweight_s'> </a></td>
					<td align="center" style="width:90px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center"><a id='lblMemo_st'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<!--<td>
						<input id="txtSssno.*" type="text" style="width:70%;" />
						<input class="btn" id="btnCust.*" type="button" value='.' style="width:1%;" />
					</td>
					<td><input class="txt c1" id="txtNamea.*" type="text" /></td>-->
					<td>
						<input id="txtProductno.*" type="text" style="width:70%;" />
						<input class="btn" id="btnProductno.*" type="button" value='.' style="width:1%;" />
					</td>
					<td>
						<input class="txt c1" id="txtProduct.*" type="text" />
						<input class="txt c1 isSpec" id="txtSpec.*" type="text"/>
					</td>
					<td class="isStyle"><input id="txtStyle.*" type="text" class="txt c1"/></td>
					<td><input class="txt c1" id="txtUnit.*" type="text"/></td>
					<td class="islengthb"><input class="txt num c1" id="txtLengthb.*" type="text" /></td>
					<td><input class="txt num c1" id="txtMount.*" type="text" /></td>
					<td><input class="txt num c1" id="txtWeight.*" type="text" /></td>
					<td><input class="txt num c1 bbsmweight" id="txtMweight.*" type="text" /></td>
					<td><input class="txt num c1" id="txtPrice.*" type="text" /></td>
					<td><input class="txt num c1" id="txtTotal.*" type="text" /></td>
					<td>
						<input class="txt c1" id="txtMemo.*" type="text" />
						<input id="txtNoq.*" type="text" style="display:none;" />
						<input id="recno.*" type="text" style="display:none;" />
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>