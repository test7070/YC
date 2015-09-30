<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
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
			var q_name = "vcc";
			var q_readonly = ['txtNoa', 'txtAccno', 'txtComp','txtSales', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtWorker', 'txtWorker2','txtDiscount'];
			var q_readonlys = ['txtTotal', 'txtOrdeno', 'txtNo2','txtNoq'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 9;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'datea';

			aPop = new Array(
				['txtCustno', 'lblCust', 'cust', 'noa,nick,tel,fax,zip_comp,addr_comp,paytype,trantype,salesno,sales', 'txtCustno,txtComp,txtTel,txtFax,txtPost,txtAddr,txtPaytype,cmbTrantype,txtSalesno,txtSales', 'cust_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtSalesno2', 'lblSales2', 'sss', 'noa,namea', 'txtSalesno2,txtSales2', 'sss_b.aspx'],
				['txtCustno2', 'lblCust2', 'cust', 'noa,comp', 'txtCustno2,txtComp2', 'cust_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtLengthc_', 'ucaucc_b.aspx']
			);

			var isinvosystem = false;
			//購買發票系統
			$(document).ready(function() {
				q_desc = 1;
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				//q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");
				//判斷是否有買發票系統
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function sum() {
				if(q_cur>2 || q_cur<1)
					return;
				
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_unit = $.trim($('#txtUnit_' + j).val()).toUpperCase();
					t_mount = q_float('txtMount_' + j);
					t_weight=+q_float('txtWeight_' + j);
					if (t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓') 
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_weight)), 0));
					else
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
					t1 = q_add(t1, dec(q_float('txtTotal_' + j)));
				}
				$('#txtMoney').val(round(t1, 0));
				q_tr('txtDiscount', Math.round(q_div(q_mul(q_float('txtMoney'),q_float('txtPrice')),100)));	
				calTax();
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1],['txtTotal', 15, 0, 1]];
				bbsNum = [['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1], ['txtMount', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTotal', 15, 0, 1]];
				q_cmbParse("cmbTypea", q_getPara('vcc.typea'));
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("combPay", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("combAddr", ' @ ');
				var t_where = "where=^^ 1=1  ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				$('#lblPrice').text('扣');
				$('#lblPer').html('%&nbsp;&nbsp;');
				
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入					
				$('#txtMemo').change(function(){
					if ($('#txtMemo').val().substr(0,1)=='*')
						$('#txtMon').removeAttr('readonly');
					else
						$('#txtMon').attr('readonly', 'readonly');
				});
				
				$('#txtMon').click(function(){
					if ($('#txtMon').attr("readonly")=="readonly" && (q_cur==1 || q_cur==2))
						q_msg($('#txtMon'), "月份要另外設定，請在"+q_getMsg('lblMemo')+"的第一個字打'*'字");
				});
				
				$('#btnOrdes').click(function() {
					var t_custno = trim($('#txtCustno').val());
					var t_where = '';
					if (t_custno.length > 0) {
						//t_where = "isnull(notv,0)>0  and isnull(enda,0)!=1 and isnull(cancel,0)!=1 and exists (select * from view_orde where isnull(apv,'')!='' and noa=view_ordes"+r_accy+".noa) and " + (t_custno.length > 0 ? q_sqlPara("custno", t_custno) : "");
						//104/07/06 邱小姐 數量重量箱數0的也要帶入
						t_where = " (isnull(notv,0)>0 or (isnull(notv,0)=0 or ISNULL(lengthc,0)=0 or ISNULL(mount,0)=0 or ISNULL(weight,0)=0))  and isnull(enda,0)!=1 and isnull(cancel,0)!=1 and exists (select * from view_orde where isnull(apv,'')!='' and noa=view_ordes"+r_accy+".noa) and " + (t_custno.length > 0 ? q_sqlPara("custno", t_custno) : "");
						if (!emp($('#txtOrdeno').val()))
							t_where += " && charindex(noa,'" + $('#txtOrdeno').val() + "')>0";
						t_where = t_where;
					} else {
						alert(q_getMsg('msgCustEmp'));
						return;
					}
					q_box("ordes_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "650px", q_getMsg('popOrde'));
				});

				$('#lblOrdeno').click(function() {
					q_pop('txtOrdeno', "orde.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";charindex(noa,'" + $('#txtOrdeno').val() + "')>0;" + r_accy + '_' + r_cno, 'orde', 'noa', '', "92%", "1024px", q_getMsg('lblOrdeno'), true);
				});

				$('#lblAccc').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('lblAccc'), true);
				});
				
				$('#lblUmmano').click(function() {
					t_where = '';
					t_ummano = $('#txtUmmano').val();
					if (t_ummano.length > 0) {
						t_where = "noa='" + t_ummano + "'";
						q_box("umma.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'umma', "95%", "95%", q_getMsg('popUmma'));
					}
				});
				
				$('#txtUmmano').change(function() {
					if(!emp($('#txtUmmano').val())){
						var t_where = "where=^^ noa='"+$('#txtUmmano').val()+"' ^^";
						q_gt('umma', t_where, 0, 0, 0, "umma_change", r_accy);
					}else{
						sum();
					}
				});

				$('#lblInvono').click(function() {
					t_where = '';
					t_invo = $('#txtInvono').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("vcca.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vcca', "95%", "95%", $('#lblInvono').val());
					}
				});
				
				$('#lblInvo').click(function() {
					t_where = '';
					t_invo = $('#txtInvo').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("invo.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'invo', "95%", "95%", $('#lblInvo').val());
					}
				});
				
				$('#cmbStype').change(function() {
					stype_chang();
				});
				
				$('#txtAddr').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});

				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});

				$('#txtCustno').change(function() {
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'  ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'^^";
						q_gt('cust', t_where, 0, 0, 0, "custgetaddr");
					}
				});
				
				$('#btnClose_div_stk').click(function() {
					$('#div_stk').hide();
				});
				
				$('#txtPrice').change(function(){
					sum();
				});
				
				$('#txtDiscount').change(function(){
					sum();
				});
				
				/*if (isinvosystem)
					$('.istax').hide();*/
			}

			function bbsGetOrdeList(){
				var t_custno = $.trim($('#txtCustno').val());
				if(t_custno.length > 0){
					var PnoArray = [];
					for(var j=0;j<q_bbsCount;j++){
						var t_productno = $.trim($('#txtProductno_'+j).val());
						var t_ordeno = $.trim($('#txtOrdeno_'+j).val());
						var t_no2 = $.trim($('#txtNo2_'+j).val());
						if((t_productno.length > 0) && (t_ordeno.length==0) && (t_no2.length==0)){
							PnoArray.push("'"+t_productno+"'");
						}
					}
					if(PnoArray.length > 0){
						var t_where = 'where=^^ 1=1 ';
						t_where += "and ((select isnull(enda,0) from view_orde where noa=view_ordes.noa)!=1) ";//BBM未結案
						t_where += "and (isnull(enda,0)!=1) ";//BBS未結案
						t_where += "and (custno=N'"+t_custno+"')";
						t_where += "and (productno in (" +PnoArray.toString()+ "))";
						q_gt('view_ordes', t_where, 0, 0, 0, "GetOrdeList");
					}
				}
			}
			
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSize,txtUnit,txtLengthc,txtOrdeno,txtNo2,txtPrice,txtMount,txtWeight,txtMemo,txtUno', b_ret.length, b_ret, 'productno,product,spec,size,unit,lengthc,noa,no2,price,mount,weight,memo,uno', 'txtProductno,txtProduct,txtUno');
							//寫入訂單號碼
							var t_oredeno = '';
							for (var i = 0; i < b_ret.length; i++) {
								if (t_oredeno.indexOf(b_ret[i].noa) == -1)
									t_oredeno = t_oredeno + (t_oredeno.length > 0 ? (',' + b_ret[i].noa) : b_ret[i].noa);
							}
							//取得訂單備註 + 指定地址
							if (t_oredeno.length > 0) {
								var t_where = "where=^^ charindex(noa,'" + t_oredeno + "')>0 ^^";
								q_gt('orde', t_where, 0, 0, 0, "", r_accy);
							}

							$('#txtOrdeno').val(t_oredeno);
							sum();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var t_msg = '';
			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var carnoList = [];
			var thisCarSpecno = '';
			var umma_total=0,umma_discount=0;
			function q_gtPost(t_name) {
				var as;
				switch (t_name) {
					case 'getcuststatus':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							if(as[0].status<'3'){
								check_custstatus=true;
								btnOk();
							}else{
								var status=q_getPara('cust.status').split(',');
								var t_status='';
								for (var i=0;i<status.length;i++){
									if(status[i].split('@')[0]==as[0].status){
										t_status=status[i].split('@')[1];
										break;
									}
								}
								alert('【'+$('#txtComp').val()+'】客戶'+t_status+'!!!');
								return;
							}
						}else{
							alert('【'+$('#txtCustno').val()+'】客戶不存在!!!');
							return;
						}
						break;
					case 'GetOrdeList':
						var as = _q_appendData("view_ordes", "", true);
						for(var k=0;k<q_bbsCount;k++){
							var thisPno = $.trim($('#txtProductno_'+k).val());
							if(thisPno.length > 0){
								$('#combOrdelist_'+k+' option').remove();
								$('#combOrdelist_'+k).append($("<option></option>").attr("value",'').text('')); 
								for(var j=0;j<as.length;j++){
									if(as[j].productno==thisPno){
										var FullOrdeno = $.trim(as[j].noa) + '-' + $.trim(as[j].no2);
										$('#combOrdelist_'+k).append($("<option></option>").attr("value",FullOrdeno).text(FullOrdeno)); 
									}
								}
							}
						}
						break;
					case 'msg_stk_all':
						var as = _q_appendData("stkucc", "", true);
						var rowslength=document.getElementById("table_stk").rows.length-3;
							for (var j = 1; j < rowslength; j++) {
								document.getElementById("table_stk").deleteRow(3);
							}
						var stk_row=0;
						
						var stkmount = 0;
						for (var i = 0; i < as.length; i++) {
							//倉庫庫存
							if(dec(as[i].mount)!=0){
								var tr = document.createElement("tr");
								tr.id = "bbs_"+j;
								tr.innerHTML = "<td id='assm_tdStoreno_"+stk_row+"'><input id='assm_txtStoreno_"+stk_row+"' type='text' class='txt c1' value='"+as[i].storeno+"' disabled='disabled'/></td>";
								tr.innerHTML+="<td id='assm_tdStore_"+stk_row+"'><input id='assm_txtStore_"+stk_row+"' type='text' class='txt c1' value='"+as[i].store+"' disabled='disabled' /></td>";
								tr.innerHTML+="<td id='assm_tdMount_"+stk_row+"'><input id='assm_txtMount_"+stk_row+"' type='text' class='txt c1 num' value='"+as[i].mount+"' disabled='disabled'/></td>";
								var tmp = document.getElementById("stk_close");
								tmp.parentNode.insertBefore(tr,tmp);
								stk_row++;
							}
							//庫存總計
							stkmount = stkmount + dec(as[i].mount);
						}
						var tr = document.createElement("tr");
						tr.id = "bbs_"+j;
						tr.innerHTML="<td colspan='2' id='stk_tdStore_"+stk_row+"' style='text-align: right;'><span id='stk_txtStore_"+stk_row+"' class='txt c1' >倉庫總計：</span></td>";
						tr.innerHTML+="<td id='stk_tdMount_"+stk_row+"'><span id='stk_txtMount_"+stk_row+"' type='text' class='txt c1 num' > "+stkmount+"</span></td>";
						var tmp = document.getElementById("stk_close");
						tmp.parentNode.insertBefore(tr,tmp);
						stk_row++;
						
						$('#div_stk').css('top',mouse_point.pageY-parseInt($('#div_stk').css('height')));
						$('#div_stk').css('left',mouse_point.pageX-parseInt($('#div_stk').css('width')));
						$('#div_stk').toggle();
						break;
					/*case 'ucca_invo':
						var as = _q_appendData("ucca", "", true);
						if (as[0] != undefined) {
							isinvosystem = true;
							$('.istax').hide();
						} else {
							isinvosystem = false;
						}
						break;*/
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'msg_ucc':
						var as = _q_appendData("ucc", "", true);
						t_msg = '';
						if (as[0] != undefined) {
							t_msg = "銷售單價：" + dec(as[0].saleprice) + "<BR>";
						}
						//客戶售價
						var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and datea<'" + q_date() + "' ^^ stop=1";
						q_gt('quat', t_where, 0, 0, 0, "msg_quat", r_accy);
						break;
					case 'msg_quat':
						var as = _q_appendData("quats", "", true);
						var quat_price = 0;
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if (as[0].productno == $('#txtProductno_' + b_seq).val())
									quat_price = dec(as[i].price);
							}
						}
						t_msg = t_msg + "最近報價單價：" + quat_price + "<BR>";
						//最新出貨單價
						var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and noa in (select noa from vccs" + r_accy + " where productno='" + $('#txtProductno_' + b_seq).val() + "' and price>0 ) ^^ stop=1";
						q_gt('vcc', t_where, 0, 0, 0, "msg_vcc", r_accy);
						break;
					case 'msg_vcc':
						var as = _q_appendData("vccs", "", true);
						var vcc_price = 0;
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if (as[0].productno == $('#txtProductno_' + b_seq).val())
									vcc_price = dec(as[i].price);
							}
						}
						t_msg = t_msg + "最近出貨單價：" + vcc_price;
						q_msg($('#txtPrice_' + b_seq), t_msg);
						break;
					case 'acomp_stk':
						var as = _q_appendData("acomp", "", true);
						var storeno = '';
						for (var i = 0; i < as.length; i++) {
							storeno = storeno + ',' + as[i].noa;
						}
						storeno = storeno.substr(1, storeno.length);
						var t_where = "where=^^ ['" + q_date() + "','" + storeno + "','') where productno='" + $('#txtProductno_' + b_seq).val() + "' ^^";
						q_gt('calstk', t_where, 0, 0, 0, "msg_stk", r_accy);
						break;
					case 'msg_stk':
						var as = _q_appendData("stkucc", "", true);
						var stkmount = 0;
						t_msg = '';
						for (var i = 0; i < as.length; i++) {
							stkmount = stkmount + dec(as[i].mount);
						}
						t_msg = "庫存量：" + stkmount;
						//平均成本
						var t_where = "where=^^ productno ='" + $('#txtProductno_' + b_seq).val() + "' order by datea desc ^^ stop=1";
						q_gt('wcost', t_where, 0, 0, 0, "msg_wcost", r_accy);
						break;
					case 'msg_wcost':
						var as = _q_appendData("wcost", "", true);
						var wcost_price;
						if (as[0] != undefined) {
							if (dec(as[0].mount) == 0) {
								wcost_price = 0;
							} else {
								wcost_price = round(q_div(q_add(q_add(q_add(dec(as[0].costa), dec(as[0].costb)), dec(as[0].costc)), dec(as[0].costd)), dec(as[0].mount)), 0);
								//wcost_price=round((dec(as[0].costa)+dec(as[0].costb)+dec(as[0].costc)+dec(as[0].costd))/dec(as[0].mount),0);
							}
						}
						if (wcost_price != undefined) {
							t_msg = t_msg + "<BR>平均成本：" + wcost_price;
							q_msg($('#txtMount_' + b_seq), t_msg);
						} else {
							//原料成本
							var t_where = "where=^^ productno ='" + $('#txtProductno_' + b_seq).val() + "' order by mon desc ^^ stop=1";
							q_gt('costs', t_where, 0, 0, 0, "msg_costs", r_accy);
						}
						break;
					case 'msg_costs':
						var as = _q_appendData("costs", "", true);
						var costs_price;
						if (as[0] != undefined) {
							costs_price = as[0].price;
						}
						if (costs_price != undefined) {
							t_msg = t_msg + "<BR>平均成本：" + costs_price;
						}
						q_msg($('#txtMount_' + b_seq), t_msg);
						break;
					case 'custaddr':
						var as = _q_appendData("custaddr", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].post + '@' + as[i].addr;
							}
						}
						document.all.combAddr2.options.length = 0;
						q_cmbParse("combAddr2", t_item);
						break;
					case 'custgetaddr':
						var as = _q_appendData("cust", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							t_item = t_item+","+as[0].zip_comp+"^^"+as[0].addr_comp+"@"+as[0].addr_comp;
							t_item = t_item+","+as[0].zip_fact+"^^"+as[0].addr_fact+"@"+as[0].addr_fact;
							t_item = t_item+","+as[0].zip_fact2+"^^"+as[0].addr_fact2+"@"+as[0].addr_fact2;
							t_item = t_item+","+as[0].zip_invo+"^^"+as[0].addr_invo+"@"+as[0].addr_invo;
							t_item = t_item+","+as[0].zip_home+"^^"+as[0].addr_home+"@"+as[0].addr_home;
						}
						$('#combAddr').text('')
						q_cmbParse("combAddr", t_item);
						break;
					case 'orde':
						var as = _q_appendData("orde", "", true);
						var t_memo = $('#txtMemo').val();
						var t_post = '';
						var t_addr = '';
						var t_post2 = '';
						var t_addr2 = '';
						for ( i = 0; i < as.length; i++) {
							t_memo = t_memo + (t_memo.length > 0 ? '\n' : '') + as[i].noa + ':' + as[i].memo;
							t_post = t_post+(t_post.length>0?';':'')+as[i].post;
							t_addr = t_addr+(t_addr.length>0?';':'')+as[i].addr;
							t_post2 = t_post2+(t_post2.length>0?';':'')+as[i].post2;
							t_addr2 = t_addr2+(t_addr2.length>0?';':'')+as[i].addr2;
						}
						$('#txtMemo').val(t_memo);
						if (as[0] != undefined){
							$('#txtPost').val(as[0].post);
							$('#txtAddr').val(as[0].addr);
							$('#txtPost2').val(as[0].post2);
							$('#txtAddr2').val(as[0].addr2);
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
							$('#cmbTaxtype').val(as[0].taxtype);
							$('#cmbTrantype').val(as[0].trantype);
							$('#txtPaytype').val(as[0].paytype);
							$('#txtPrice').val(as[0].price);
							$('#txtDiscount').val(as[0].weight);
							$('#txtCno').val(as[0].cno);
							$('#txtAcomp').val(as[0].acomp);
						}
						sum();
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case 'btnDele':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnDele();
						Unlock(1);
						break;
					case 'btnModi':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnModi();
						Unlock(1);
						$('#txtDatea').focus();

						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'^^";
							q_gt('cust', t_where, 0, 0, 0, "custgetaddr");
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
					case 'sss':
						as = _q_appendData('sss', '', true);
						break;
					case 'startdate':
						var as = _q_appendData('cust', '', true);
						var t_startdate='';
						if (as[0] != undefined) {
							t_startdate=as[0].startdate;
						}
						if(t_startdate.length==0 || ('00'+t_startdate).slice(-2)=='00' || $('#txtDatea').val().substr(7, 2)<('00'+t_startdate).slice(-2)){
							$('#txtMon').val($('#txtDatea').val().substr(0, 6));
						}else{
							var t_date=$('#txtDatea').val();
							var nextdate=new Date(dec(t_date.substr(0,3))+1911,dec(t_date.substr(4,2))-1,1);
				    		nextdate.setMonth(nextdate.getMonth() +1)
				    		t_date=''+(nextdate.getFullYear()-1911)+'/'+(nextdate.getMonth()<9?'0':'')+(nextdate.getMonth()+1);
							$('#txtMon').val(t_date);
						}
						check_startdate=true;
						btnOk();
						break;
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
						break;
					case 'umma_change':
						var as = _q_appendData("umma", "", true);
						if (as[0] != undefined) {
							sum();
						}else{
							alert('無【'+$('#txtUmmano').val()+'】預收單號');
							$('#txtUmmano').val('');
							sum();
						}
						break;
					case 'umma_btnOk':
						var as = _q_appendData("umma", "", true);
						if (as[0] != undefined) {
							umma_total=dec(as[0].total);
							umma_discount=dec(as[0].discount);
							var t_where = "where=^^ ummano='"+$('#txtUmmano').val()+"' and noa!='"+$('#txtNoa').val()+"' ^^";
							q_gt('view_vcc', t_where, 0, 0, 0, "umma_getvcc", r_accy);
						}else{
							alert('無【'+$('#txtUmmano').val()+'】預收單號');
						}
						break;
					case 'umma_getvcc':
						var as = _q_appendData("view_vcc", "", true);
						if (as[0] != undefined) {
							var vcc_money=0;
							for (var i = 0; i < as.length; i++) {
								vcc_money=vcc_money+dec(as[i].money);
							}
							if((umma_total-umma_discount-vcc_money-dec($('#txtMoney').val()))<0){
								alert('【'+$('#txtUmmano').val()+'】預收單號 金額超出'+Math.abs(umma_total-umma_discount-vcc_money-dec($('#txtMoney').val())));
							}else{
								check_umma=true;
								btnOk();
							}
						}else{
							if((umma_total-umma_discount-dec($('#txtMoney').val()))<0){
								alert('【'+$('#txtUmmano').val()+'】預收單號 金額超出'+FormatNumber(Math.abs(umma_total-umma_discount-dec($('#txtMoney').val()))));
							}else{
								check_umma=true;
								btnOk();
							}
						}
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
						q_tr('txtMount_'+n,q_mul(q_float('txtLengthc_'+n),dec(as[0].stdmount)));
						q_tr('txtWeight_'+n,q_mul(q_float('txtMount_'+n),dec(as[0].uweight)));
						sum();
					}
				}
			}
			
			var check_startdate=false;
			var check_umma=false;
			var check_custstatus=false;
			function btnOk() {
				var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')],['txtDatea', q_getMsg('lblDatea')], ['txtCustno', q_getMsg('lblCust')], ['txtCno', q_getMsg('lblAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				//判斷起算日,寫入帳款月份
				if(!check_startdate&&emp($('#txtMon').val())){
					var t_where = "where=^^ noa='"+$('#txtCustno').val()+"' ^^";
					q_gt('cust', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				/*if (emp($('#txtMon').val()))
					$('#txtMon').val($('#txtDatea').val().substr(0, 6));*/
					
				//判斷客戶狀態	
				if(!check_custstatus){
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('cust', t_where, 0, 0, 0, "getcuststatus");
					return;
				}
				
				//判斷超出預收
				if(!check_umma && !emp($('#txtUmmano').val())){
					var t_where = "where=^^ noa='"+$('#txtUmmano').val()+"' ^^";
					q_gt('umma', t_where, 0, 0, 0, "umma_btnOk", r_accy);
					return;
				}
				
				check_custstatus=false;
				check_umma=false;
				check_startdate=false;
					
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				
				sum();
				
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO"){
					q_gtnoa(q_name, replaceAll($('#txtCno').val() + $('#txtDatea').val(), '/', ''));
					//q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcc') + $('#txtDatea').val(), '/', ''));
				}else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('vcc_s.aspx', q_name + '_s', "500px", "630px", q_getMsg("popSeek"));
			}

			function combPay_chg() {
				var cmb = document.getElementById("combPay");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}

			function combAddr2_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr2').find("option:selected").text());
					$('#txtPost2').val($('#combAddr2').find("option:selected").val());
				}
			}
			
			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					var t_addr=$('#combAddr').find("option:selected").val().split('^^');
					$('#txtPost').val(t_addr[0]);
					$('#txtAddr').val(t_addr[1]);
				}
			}
			
			var mouse_point;
			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						$('#txtLengthc_'+i).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccstdmount_"+n, r_accy);
							}
						});
						
						$('#txtMount_'+i).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccuweight_"+n, r_accy);
							}
						});
						
						$('#txtWeight_' + i).change(function() {
							sum();
						});
						
						$('#combOrdelist_'+i).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							var thisVal = $.trim($(this).val());
							var ValArray = thisVal.split('-');
							if(ValArray[0] && ValArray[1]){
								$('#txtOrdeno_' + n).val(ValArray[0]);
								$('#txtNo2_' + n).val(ValArray[1]);
							}
							$(this).val('');
						});
						
						$('#txtUnit_' + i).focusout(function() {
							sum();
						});
						$('#txtPrice_' + i).focusout(function() {
							sum();
						});
						
						$('#txtMount_' + i).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
								$('#btnClose_div_stk').click();
						});
						
						$('#txtMount_' + i).focusin(function(e) {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//庫存
									//var t_where = "where=^^ ['" + q_date() + "','','" + $('#txtProductno_' + b_seq).val() + "')  ^^";
									//q_gt('calstk', t_where, 0, 0, 0, "msg_stk", r_accy);
									//顯示DIV 104/03/21
									mouse_point=e;
									mouse_point.pageY=$('#txtMount_'+b_seq).offset().top;
									mouse_point.pageX=$('#txtMount_'+b_seq).offset().left;
									document.getElementById("stk_productno").innerHTML = $('#txtProductno_' + b_seq).val();
									document.getElementById("stk_product").innerHTML = $('#txtProduct_' + b_seq).val();
									//庫存
									var t_where = "where=^^ ['" + q_date() + "','','" + $('#txtProductno_' + b_seq).val() + "') ^^";
									q_gt('calstk', t_where, 0, 0, 0, "msg_stk_all", r_accy);
								}
							}
						});
						$('#txtPrice_' + i).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									var t_where = "where=^^ noa='" + $('#txtProductno_' + b_seq).val() + "' ^^ stop=1";
									q_gt('ucc', t_where, 0, 0, 0, "msg_ucc", r_accy);
								}
							}
						});

						$('#btnRecord_' + i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "cust='" + $('#txtCustno').val() + "' and noq='" + $('#txtProductno_' + b_seq).val() + "'";
							q_box("z_vccrecord.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vccrecord', "95%", "95%", q_getMsg('lblRecord_s'));
						});
						
						$('#btnStk_' + i).mousedown(function(e) {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (!emp($('#txtProductno_' + b_seq).val()) && $("#div_stk").is(":hidden")) {
								mouse_point=e;
								document.getElementById("stk_productno").innerHTML = $('#txtProductno_' + b_seq).val();
								document.getElementById("stk_product").innerHTML = $('#txtProduct_' + b_seq).val();
								//庫存
								var t_where = "where=^^ ['" + q_date() + "','','" + $('#txtProductno_' + b_seq).val() + "') ^^";
								q_gt('calstk', t_where, 0, 0, 0, "msg_stk_all", r_accy);
							}
						});
					}
				}
				_bbsAssign();
				HiddenTreat();
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_date());
				$('#cmbTypea').val('1');
				$('#txtDatea').focus();
				$('#cmbTaxtype').val('1');
				var t_where = "where=^^ 1=1  ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				$('#combAddr').text('');
				q_cmbParse("combAddr", ' @ ');
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnModi', r_accy);
				bbsGetOrdeList();
			}

			function btnPrint() {
				 q_box("z_vccp_yc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa : trim($('#txtNoa').val())}) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno'] && !as['product']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['typea'] = abbm2['typea'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['datea'] = abbm2['datea'];
				as['custno'] = abbm2['custno'];
				if (abbm2['storeno'])
					as['storeno'] = abbm2['storeno'];

				t_err = '';
				if (as['price'] != null && (dec(as['price']) > 99999999 || dec(as['price']) < -99999999))
					t_err = q_getMsg('msgPriceErr') + as['price'] + '\n';
				if (as['total'] != null && (dec(as['total']) > 999999999 || dec(as['total']) < -99999999))
					t_err = q_getMsg('msgMoneyErr') + as['total'] + '\n';

				if (t_err) {
					alert(t_err);
					return false;
				}
				return true;
			}

			function q_stPost() {
				if (q_cur == 1 || q_cur == 2) {
					var s2 = xmlString.split(';');
					abbm[q_recno]['accno'] = s2[0];
				}
			}

			function refresh(recno) {
				_refresh(recno);
				/*if (isinvosystem)
					$('.istax').hide();*/
				HiddenTreat();
				stype_chang();
			}

			function HiddenTreat(returnType){
				returnType = $.trim(returnType).toLowerCase();
				var hasStyle = q_getPara('sys.isstyle');
				var isStyle = (hasStyle.toString()=='1'?$('.isStyle').show():$('.isStyle').hide());
				var hasSpec = q_getPara('sys.isspec');
				var isSpec = (hasSpec.toString()=='1'?$('.isSpec').show():$('.isSpec').hide());
				if(returnType=='style'){
					return (hasStyle.toString()=='1');
				}else if(returnType=='spec'){
					return (hasSpec.toString()=='1');
				}
				
				if (q_getPara('sys.project').toUpperCase()!='YC'){
					$('.islengthc').hide();
				}
			}
			
			function stype_chang(){
				if($('#cmbStype').val()=='3'){
					$('.invo').show();
					$('.vcca').hide();
				}else{
					$('.invo').hide();
					$('.vcca').show();
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
					$('#combAddr2').attr('disabled', 'disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
					$('#combAddr2').removeAttr('disabled');
				}
				HiddenTreat();
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				if ($('#txtMemo').val().substr(0,1)=='*')
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');
			}

			function btnMinus(id) {
				_btnMinus(id);
				var n=id.split('_')[id.split('_').length-1];
				$('#combOrdelist_'+n+' option').remove();
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				dataErr = !_q_appendData(t_Table);
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
				if (q_chkClose())
					return;
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnDele', r_accy);
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCustno':
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'^^";
							q_gt('cust', t_where, 0, 0, 0, "custgetaddr");
						}
						bbsGetOrdeList();
						break;
					case 'txtProductno_':
						bbsGetOrdeList();
						break;
				}
			}

			function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}
			
			function calTax() {
				var t_money = 0, t_tax = 0, t_total = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_money += q_float('txtTotal_' + j);
				}
				//104/05/29 稅金=應收-折扣*0.5
				t_money=q_sub(t_money,q_float('txtDiscount'));
				
				t_total = t_money;
				if (!isinvosystem) {
					var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
					switch ($('#cmbTaxtype').val()) {
						case '0': // 無
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '1': // 應稅
							t_tax = round(q_mul(t_money, t_taxrate), 0);
							t_total = q_add(t_money, t_tax);
							break;
						case '2': //零稅率
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '3': // 內含
							t_tax = round(q_mul(q_div(t_money, q_add(1, t_taxrate)), t_taxrate), 0);
							t_total = t_money;
							t_money = q_sub(t_total, t_tax);
							break;
						case '4': // 免稅
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '5': // 自定
							$('#txtTax').attr('readonly', false);
							$('#txtTax').css('background-color', 'white').css('color', 'black');
							t_tax = round(q_float('txtTax'), 0);
							t_total = q_add(t_money, t_tax);
							break;
						case '6': // 作廢-清空資料
							t_money = 0, t_tax = 0, t_total = 0;
							break;
						default:
					}
				}
				
				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				
				if(!emp($('#txtUmmano').val())){
					$('#txtTotal').val(FormatNumber(t_tax));
				}else{
					$('#txtTotal').val(FormatNumber(t_total));	
				}
			}
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 30%;
				border-width: 0px;
			}
			.tview {
				width: 100%;
				border: 5px solid gray;
				font-size: medium;
				background-color: black;
			}
			.tview tr {
				height: 30px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border-width: 0px;
				background-color: #FFFF66;
				color: blue;
			}
			.dbbm {
				float: left;
				width: 70%;
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
			.tbbm .tdZ {
				width: 1%;
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
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 30%;
				float: left;
			}
			.txt.c3 {
				width: 68%;
				float: left;
			}
			.txt.c4 {
				width: 49%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
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
			}
			.dbbs {
				width: 100%;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			select {
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<div id="div_stk" style="position:absolute; top:300px; left:400px; display:none; width:400px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_stk" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr>
					<td style="background-color: #f8d463;" align="center">產品編號</td>
					<td style="background-color: #f8d463;" colspan="2" id='stk_productno'> </td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" align="center">產品名稱</td>
					<td style="background-color: #f8d463;" colspan="2" id='stk_product'> </td>
				</tr>
				<tr id='stk_top'>
					<td align="center" style="width: 30%;">倉庫編號</td>
					<td align="center" style="width: 45%;">倉庫名稱</td>
					<td align="center" style="width: 25%;">倉庫數量</td>
				</tr>
				<tr id='stk_close'>
					<td align="center" colspan='3'>
						<input id="btnClose_div_stk" type="button" value="關閉視窗">
					</td>
				</tr>
			</table>
		</div>
		<div id="dmain" style="width: 1260px;">
			<!--#include file="../inc/toolbar.inc"-->
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewType'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='typea=vcc.typea'>~typea=vcc.typea</td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='comp,4'>~comp,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm" style="width: 872px;">
					<tr>
						<td class="td1" style="width: 108px;"><span> </span><a id='lblType' class="lbl"> </a></td>
						<td class="td2" style="width: 108px;"><select id="cmbTypea"> </select></td>
						<td class="td3" style="width: 108px;">
							<a id='lblStype' class="lbl" style="float: left;"> </a>
							<span style="float: left;"> </span>
							<select id="cmbStype"> </select>
						</td>
						<td class="td4" style="width: 108px;"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td class="td5" style="width: 108px;"><input id="txtDatea" type="text"  class="txt c1"/></td>
						<td class="td6" style="width: 108px;"> </td>
						<td class="td7" style="width: 108px;"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td8" style="width: 108px;"><input id="txtNoa" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCno" type="text" class="txt c1"/></td>
						<td class="td2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td class="td8"><input id="txtMon" type="text" class="txt c1"/></td>
						<td class="td8"> </td>
						<td class="td7">
							<span> </span>
							<a id='lblInvono' class="lbl btn vcca"> </a>
							<a id='lblInvo' class="lbl btn invo"> </a>
						</td>
						<td class="td8">
							<input id="txtInvono" type="text" class="txt c1 vcca"/>
							<input id="txtInvo" type="text" class="txt c1 invo"/>
						</td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCustno" type="text" class="txt c1"/></td>
						<td class="td2"><input id="txtComp" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblPay' class="lbl"> </a></td>
						<td class="td5"><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td class="td6"><select id="combPay" style="width: 100%;" onchange='combPay_chg()'> </select></td>
						<td class="td6"align="right"><input id="btnOrdes" type="button"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblTel" class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtTel" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id="lblFax" class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtFax" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td class="td5"><select id="cmbTrantype" style="width: 100%;"> </select></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblAddr" class="lbl"> </a></td>
						<td class="td2"><input id="txtPost" type="text" class="txt c1"/></td>
						<td class="td3" colspan='4'>
							<input id="txtAddr" type="text" class="txt c1" style="width: 412px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td class="td7"><span> </span><a id='lblOrdeno' class="lbl btn"> </a></td>
						<td class="td8"><input id="txtOrdeno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td class="td2"><input id="txtPost2"  type="text" class="txt c1"/></td>
						<td class="td3" colspan='4'>
							<input id="txtAddr2"  type="text" class="txt c1" style="width: 412px;"/>
							<select id="combAddr2" style="width: 20px" onchange='combAddr2_chg()'> </select>
						</td>
						<td class="td4" colspan="2" style="text-align: right;" >
							<a id='lblPrice' class="lbl" style="float:none"> </a>
							<input id="txtPrice"  type="text" class="txt num c1" style="float:none;width: 25%"/>
							<a id='lblPer' class="lbl" style="float:none"> </a>
							<a id='lblDiscount' class="lbl" style="float:none"> </a>
							<input id="txtDiscount"  type="text" class="txt num c1" style="float:none;width: 25%"/>
						</td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblMoney" class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtMoney" type="text" class="txt num c1"/></td>
						<td class="td4"><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td class="td5" colspan='2'>
							<input id="txtTax" type="text" class="txt num c1 istax"  style="width: 49%;"/>
							<select id="cmbTaxtype" style="width: 49%;" onchange="calTax();"> </select>
						</td>
						<td class="td7"><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td class="td8"><input id="txtTotal" type="text" class="txt num c1 istax"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id='lblSales' class="lbl btn"> </a></td>
						<td class="td2"><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td class="td3"><input id="txtSales" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblUmmano' class="lbl btn">預收單號</a></td>
						<td class="td5" colspan='2'><input id="txtUmmano" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td class="td2" colspan='7'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td class="td2"><input id="txtWorker" type="text" class="txt c1"/></td>
						<td class="td3"><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblAccc' class="lbl btn"> </a></td>
						<td class="td5" colspan='2'><input id="txtAccno" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1555px;">
			<table id="tbbs" class='tbbs'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;width:" /></td>
					<td align="center" style="width:200px"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:300px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:95px;" class="isStyle"><a id='lblStyle_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>
					<td align="center" style="width:80px;" class="islengthc"><a>箱數</a></td>
					<td align="center" style="width:80px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:80px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:80px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:120px;"><a id='lblStore_s'> </a></td>
					<td align="center" style="width:170px;"><a id='lblMemo_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblRecord_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblStk_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUno_s'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td>
						<input class="btn"  id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" />
					</td>
					<td align="center">
						<input class="txt c1"  id="txtProductno.*" type="text" />
						<input id="txtNoq.*" type="text" class="txt c6"/>
						<input class="btn"  id="btnProductno.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" />
						<input id="txtSpec.*" type="text" class="txt c1 isSpec" />
					</td>
					<td class="isStyle"><input id="txtStyle.*" type="text" class="txt c1"/></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td class="islengthc"><input id="txtLengthc.*" type="text" class="txt num c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1"/></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1"/></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 75%"/>
						<input class="btn"  id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore.*" type="text" class="txt c1"/>
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<select id="combOrdelist.*" style="width: 10%;"> </select>
						<input id="txtOrdeno.*" type="text"  class="txt" style="width:60%;"/>
						<input id="txtNo2.*" type="text" class="txt" style="width:18%;"/>
					</td>
					<td align="center"><input class="btn"  id="btnRecord.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn"  id="btnStk.*" type="button" value='.' style="width:1%;"/></td>
					<td><input id="txtUno.*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>