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
			var q_name = "rc2";
			var q_readonly = ['txtNoa', 'txtAcomp', 'txtTgg', 'txtWorker', 'txtWorker2','txtTranstart','txtMoney','txtTotal'];
			var q_readonlys = ['txtNoq','txtOrdeno','txtNo2'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'datea';
			aPop = new Array(
				['txtTggno', 'lblTgg', 'tgg', 'noa,nick,tel,zip_invo,addr_comp,paytype', 'txtTggno,txtTgg,txtTel,txtPost,txtAddr,txtPaytype', 'tgg_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtPost', 'lblAddr', 'addr2', 'noa,post', 'txtPost', 'addr2_b.aspx'],
				['txtPost2', 'lblAddr2', 'addr2', 'noa,post', 'txtPost2', 'addr2_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp,addr', 'txtCno,txtAcomp,txtAddr2', 'acomp_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_', 'ucaucc_b.aspx'],
				['txtUno_', 'btnUno_', 'view_uccc', 'uno', 'txtUno_', 'uccc_seek_b.aspx?;;;1=0', '95%', '60%']
			);
			var isinvosystem = false;
			//購買發票系統
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				//判斷是否有買發票系統
				//q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");
			}).mousedown(function (e) {
		        if (!$('#div_row').is(':hidden')) {
		            if (mouse_div) {
		                $('#div_row').hide();
		            }
		            mouse_div = true;
		        }
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
					if (t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M'  || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓') 
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_weight)), 0));
					else
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
					t1 = q_add(t1, dec(q_float('txtTotal_' + j)));
				}
				$('#txtMoney').val(round(t1, 0));
				calTax();
			}
			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 15, 0, 1]];
				bbsNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1],['txtWeight', 15, q_getPara('rc2.weightPrecision'), 1], ['txtPrice', 15, q_getPara('rc2.pricePrecision'), 1], ['txtTotal', 15, 0, 1]];
				
				q_cmbParse("cmbTypea", q_getPara('rc2.typea'));
				q_cmbParse("cmbStype", q_getPara('rc2.stype'));
				q_cmbParse("combPaytype", q_getPara('rc2.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				
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
				
				$('#lblAccc').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('lblAccc'), true);
				});
				
				$('#lblPayano').click(function() {
					t_where = '';
					t_payano = $('#txtPayano').val();
					if (t_payano.length > 0) {
						t_where = "noa='" + t_payano + "'";
						q_box("paya.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'paya', "95%", "95%", q_getMsg('popPaya'));
					}
				});
				
				$('#txtPayano').change(function() {
					if(!emp($('#txtPayano').val())){
						var t_where = "where=^^ noa='"+$('#txtPayano').val()+"' ^^";
						q_gt('paya', t_where, 0, 0, 0, "paya_change", r_accy);
					}else{
						sum();
					}
				});
				
				$('#lblOrdc').click(function() {
					lblOrdc();
				});
				
				$('#lblInvono').click(function() {
					t_where = '';
					t_invo = $('#txtInvono').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("rc2a.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'rc2a', "95%", "95%", q_getMsg('popRc2a'));
					}
				});
				
				$('#lblInvo').click(function() {
					t_where = '';
					t_invo = $('#txtInvo').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("invoi.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'invoi', "95%", "95%", $('#lblInvo').val());
					}
				});
				
				$('#txtTotal').change(function() {
					sum();
				});
				
				$('#txtTggno').change(function() {
					if (!emp($('#txtTggno').val())) {
						var t_where = "where=^^ tggno='" + $('#txtTggno').val() + "' and datea>='"+q_cdn(q_date(),-183)+"' ^^ stop=999";
						q_gt('view_rc2', t_where, 0, 0, 0, "custgetaddr", r_accy);
					}
				});
				$('#txtAddr').change(function() {
					var t_tggno = trim($(this).val());
					if (!emp(t_tggno)) {
						focus_addr = $(this).attr('id');
						zip_fact = $('#txtPost').attr('id');
						var t_where = "where=^^ noa='" + t_tggno + "' ^^";
						q_gt('tgg', t_where, 0, 0, 0, "");
					}
				});
				
				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						zip_fact = $('#txtPost2').attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
				
				if (isinvosystem)
					$('.istax').hide();
					
				
				$('#txtTranadd').change(function(){
					sum();
				});
				
				$('#cmbStype').change(function() {
					stype_chang();
				});
				
				$('#btnClose_div_stk').click(function() {
					$('#div_stk').hide();
				});
				
				//上方插入空白行
		        $('#lblTop_row').mousedown(function (e) {
		            if (e.button == 0) {
		                mouse_div = false;
		                q_bbs_addrow(row_bbsbbt, row_b_seq, 0);
		            }
		        });
		        //下方插入空白行
		        $('#lblDown_row').mousedown(function (e) {
		            if (e.button == 0) {
		                mouse_div = false;
		                q_bbs_addrow(row_bbsbbt, row_b_seq, 1);
		            }
		        });
			}
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordcs':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0) {
								b_pop = '';
								return;
							}
							//取得採購的資料
							var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
							q_gt('ordc', t_where, 0, 0, 0, "", r_accy);
							$('#txtOrdcno').val(b_ret[0].noa);
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtUno,txtProductno,txtSpec,txtProduct,txtUnit,txtMount,txtWeight,txtOrdeno,txtNo2,txtPrice,txtTotal,txtMemo', b_ret.length, b_ret, 'uno,productno,spec,product,unit,mount,weight,noa,no2,price,total,memo', 'txtProductno,txtProduct');
							bbsAssign();
							sum();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			var focus_addr = '', zip_fact = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var carnoList = [];
			var thisCarSpecno = '';
			var ordcoverrate = [],rc2soverrate = [];
			var paya_total=0,paya_discount=0;
			function q_gtPost(t_name) {
				switch (t_name) {
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
					case 'custgetaddr':
						var as = _q_appendData("view_rc2", "", true);
						var t_item = " @ ";
						
						for (var i = 0; i < as.length; i++) {
							var tt_item=t_item.split(',');
							var t_exists=false;
							for (var j=0;j<tt_item.length;j++){
								if(as[i].post2 + '@' + as[i].addr2==tt_item[j]){
									t_exists=true;
									break;
								}
							}
							if(!t_exists)
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].post2 + '@' + as[i].addr2;
						}
						
						document.all.combAddr.options.length = 0;
						q_cmbParse("combAddr", t_item);
						break;
					case 'tgg':
						var as = _q_appendData("tgg", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + zip_fact).val(as[0].zip_fact);
							$('#' + focus_addr).val(as[0].addr_fact);
							zip_fact = '';
							focus_addr = '';
						}
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + zip_fact).val(as[0].zip_fact);
							$('#' + focus_addr).val(as[0].addr_fact);
							zip_fact = '';
							focus_addr = '';
						}
						break;
					case 'btnDele':
						var as = _q_appendData("pays", "", true);
						if (as[0] != undefined) {
							var t_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									t_msg += String.fromCharCode(13) + '付款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (t_msg.length > 0) {
								alert('已沖帳:' + t_msg);
								Unlock(1);
								return;
							}
						}
						_btnDele();
						Unlock(1);
						break;
					case 'btnModi':
						var as = _q_appendData("pays", "", true);
						if (as[0] != undefined) {
							var t_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									t_msg += String.fromCharCode(13) + '付款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (t_msg.length > 0) {
								alert('已沖帳:' + t_msg);
								Unlock(1);
								return;
							}
						}
						_btnModi();
						Unlock(1);
						$('#txtDatea').focus();
						if (!emp($('#txtTggno').val())) {
							var t_where = "where=^^ tggno='" + $('#txtTggno').val() + "' and datea>='"+q_cdn(q_date(),-183)+"' ^^ stop=999";
							q_gt('view_rc2', t_where, 0, 0, 0, "custgetaddr", r_accy);
						}
						break;
					case 'ordc':
						var ordc = _q_appendData("ordc", "", true);
						if (ordc[0] != undefined) {
							$('#combPaytype').val(ordc[0].paytype);
							$('#txtPaytype').val(ordc[0].pay);
							$('#cmbTrantype').val(ordc[0].trantype);
							$('#txtPost2').val(ordc[0].post2);
							$('#txtAddr2').val(ordc[0].addr2);
						}
						break;
					case 'startdate':
						var as = _q_appendData('tgg', '', true);
						var t_startdate='';
						if (as[0] != undefined) {
							t_startdate=as[0].startdate;
						}
						if(t_startdate.length==0 || ('00'+t_startdate).slice(-2)=='00' || $('#txtDatea').val().substr(7, 2)<('00'+t_startdate).substr(-2)){
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
					case 'ordc_overrate':
						ordcoverrate = _q_appendData('view_ordc', '', true);
						if (ordcoverrate[0] != undefined) {
							//抓已進貨數量
							var t_where ='';
							for (var i = 0; i < ordcoverrate.length; i++) {
								t_where=t_where+" or ordeno='"+ordcoverrate[i].noa+"'";
							}
							if(t_where.length>0){
								t_where = "where=^^ (1=0 "+t_where+") and noa!='"+$('#txtNoa').val()+"' ^^";
								q_gt('view_rc2s', t_where, 0, 0, 0, "rc2s_overrate",'');
							}
						}else{
							check_ordc_overrate=true;
							btnOk();
						}
						break;
					case 'rc2s_overrate':
						rc2soverrate = _q_appendData('view_rc2s', '', true);
						//抓ordcs的資料
						var t_where ='';
						for (var i = 0; i < ordcoverrate.length; i++) {
							t_where=t_where+" or noa='"+ordcoverrate[i].noa+"'";
						}
						if(t_where.length>0){
							t_where = "where=^^ 1=0 "+t_where+" ^^";
							q_gt('view_ordcs', t_where, 0, 0, 0, "ordcs_overrate",'');
						}
						break;
					case 'ordcs_overrate':
						var as = _q_appendData('view_ordcs', '', true);
						var t_msg='';
						//計算超交數量
						for (var j = 0; j < as.length; j++) {
							as[j].overmount=as[j].mount;
							for (var i = 0; i < ordcoverrate.length; i++) {
								if(ordcoverrate[i].noa==as[j].noa){
									as[j].overmount=q_mul(as[j].mount,q_add(1,q_div(dec(ordcoverrate[i].overrate),100)));
								}
							}
						}
						//寫入已入庫數量
						for (var j = 0; j < as.length; j++) {
							as[j].rc2smount=0;
							for (var i = 0; i < rc2soverrate.length; i++) {
								if(as[j].noa==rc2soverrate[i].ordeno && as[j].no2==rc2soverrate[i].no2){
									as[j].rc2smount=q_add(dec(as[j].rc2smount),dec(rc2soverrate[i].mount));			
								}
							}
						}
						//判斷是否超交
						for (var i = 0; i < q_bbsCount; i++) {
							for (var j = 0; j < as.length; j++) {
								if (!emp($('#txtOrdeno_'+i).val()) && $('#txtOrdeno_'+i).val()==as[j].noa && $('#txtNo2_'+i).val()==as[j].no2	
									&& (q_sub(dec(as[j].overmount),dec(as[j].rc2smount))< dec($('#txtMount_'+i).val()))){
									t_msg=t_msg+(t_msg.length>0?',':'')+$('#txtProduct_'+i).val();
								}
							}
						}
						
						if(t_msg.length>0){
							alert(t_msg+'進貨數量高於允需超交數量!!');
						}else{
							check_ordc_overrate=true;
							btnOk();
						}
						break;
					case 'paya_change':
						var as = _q_appendData("paya", "", true);
						if (as[0] != undefined) {
							sum();
						}else{
							alert('無【'+$('#txtPayano').val()+'】預付單號');
							$('#txtPayano').val('');
							sum();
						}
						break;
					case 'paya_btnOk':
						var as = _q_appendData("paya", "", true);
						if (as[0] != undefined) {
							paya_total=dec(as[0].total);
							paya_discount=dec(as[0].discount);
							var t_where = "where=^^ payano='"+$('#txtPayano').val()+"' and noa!='"+$('#txtNoa').val()+"' ^^";
							q_gt('view_rc2', t_where, 0, 0, 0, "paya_getrc2", r_accy);
						}else{
							alert('無【'+$('#txtPayano').val()+'】預付單號');
						}
						break;
					case 'paya_getrc2':
						var as = _q_appendData("view_rc2", "", true);
						if (as[0] != undefined) {
							var rc2_money=0;
							for (var i = 0; i < as.length; i++) {
								rc2_money=rc2_money+((as[i].typea=='2'?-1:1)*dec(as[i].money));
							}
							if((paya_total-paya_discount-rc2_money-dec($('#txtMoney').val()))<0){
								alert('【'+$('#txtPayano').val()+'】預付單號 金額超出'+Math.abs(paya_total-paya_discount-rc2_money-dec($('#txtMoney').val())));
							}else{
								check_paya=true;
								btnOk();
							}
						}else{
							if((paya_total-paya_discount-dec($('#txtMoney').val()))<0){
								alert('【'+$('#txtPayano').val()+'】預付單號 金額超出'+FormatNumber(Math.abs(paya_total-paya_discount-dec($('#txtMoney').val()))));
							}else{
								check_paya=true;
								btnOk();
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
			}
			function lblOrdc() {
				var t_tggno = trim($('#txtTggno').val());
				var t_ordeno = trim($('#txtOrdeno').val());
				var t_where = " kind!='2' &&";
				if (t_tggno.length > 0) {
					if (t_ordeno.length > 0)
						t_where = "isnull(b.enda,0)=0 && isnull(b.cancel,'0')='0' && datea>='"+$('#txtDatea').val()+"' && isnull(view_ordcs.enda,0)=0 && " + (t_tggno.length > 0 ? q_sqlPara("tggno", t_tggno) : "") + "&& " + (t_ordeno.length > 0 ? q_sqlPara("noa", t_ordeno) : "");
					else
						t_where = "isnull(b.enda,0)=0 && isnull(b.cancel,'0')='0' && datea>='"+$('#txtDatea').val()+"' && isnull(view_ordcs.enda,0)=0 && " + (t_tggno.length > 0 ? q_sqlPara("tggno", t_tggno) : "");
					t_where = t_where;
				} else {
					var t_err = q_chkEmpField([['txtTggno', q_getMsg('lblTgg')]]);
					alert(t_err);
					return;
				}
				q_box("ordcs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where + ";" + r_accy, 'ordcs', "95%", "95%", $('#lblOrdc').text());
			}
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				var s1 = xmlString.split(';');
				abbm[q_recno]['accno'] = s1[0];
				$('#txtAccno').val(s1[0]);
			}
			
			var check_startdate=false;
			var check_ordc_overrate=false;
			var check_paya=false;
			function btnOk() {
				var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')],['txtDatea', q_getMsg('lblDatea')], ['txtTggno', q_getMsg('lblTgg')], ['txtCno', q_getMsg('lblAcomp')]]);
				// 檢查空白
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				/*$('#txtMon').val($.trim($('#txtMon').val()));
				if ($('#txtMon').val().length > 0 && !(/^[0-9]{3}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val())) {
					alert(q_getMsg('lblMon') + '錯誤。');
					return;
				}
				
				if (emp($('#txtMon').val()))
					$('#txtMon').val($('#txtDatea').val().substr(0, 6));*/
					
				//判斷起算日,寫入帳款月份
				//104/09/30 如果備註沒有*字就重算帳款月份
				//if(!check_startdate && emp($('#txtMon').val())){
				if(!check_startdate && $('#txtMemo').val().substr(0,1)!='*'){	
					var t_where = "where=^^ noa='"+$('#txtTggno').val()+"' ^^";
					q_gt('tgg', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				
				//判斷超出預付
				if(!check_paya && !emp($('#txtPayano').val())){
					var t_where = "where=^^ noa='"+$('#txtPayano').val()+"' ^^";
					q_gt('paya', t_where, 0, 0, 0, "paya_btnOk", r_accy);
					return;
				}
				
				//檢查是否有超交	
				if(!check_ordc_overrate){
					var t_where ='';
					for (var i = 0; i < q_bbsCount; i++) {
						if (!emp($('#txtOrdeno_'+i).val()) && t_where.indexOf($('#txtOrdeno_'+i).val())==-1){
							t_where=t_where+" or noa='"+$('#txtOrdeno_'+i).val()+"'";
						}
					}
					if(t_where.length>0){
						t_where = "where=^^ (1=0 "+t_where+") and isnull(overrate,0)>0 ^^";
						q_gt('view_ordc', t_where, 0, 0, 0, "ordc_overrate",'');
						return;
					}
				}
				
				check_startdate=false;
				check_ordc_overrate=false;
				check_paya=false;
				sum();
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				if (q_cur == 2)
					$('#txtWorker2').val(r_name);
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_rc2') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}
			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('rc2_yc_s.aspx', q_name + '_s', "500px", "500px", q_getMsg("popSeek"));
			}
			function cmbPaytype_chg() {
				var cmb = document.getElementById("combPaytype");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}
			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").text());
					$('#txtPost2').val($('#combAddr').find("option:selected").val());
				}
			}
			function bbsAssign() {
				for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#btnMinus_' + j).click(function() {
							btnMinus($(this).attr('id'));
						}).mousedown(function (e) {
		                    if (e.button == 2) {
		                        mouse_div = false;
		                        ////////////控制顯示位置
		                        $('#div_row').css('top', e.pageY);
		                        $('#div_row').css('left', e.pageX);
		                        ////////////
		                        t_IdSeq = -1;
		                        q_bodyId($(this).attr('id'));
		                        b_seq = t_IdSeq;
		                        $('#div_row').show();
		                        row_b_seq = b_seq;
		                        row_bbsbbt = 'bbs';
		                    }
		                });
						$('#txtUnit_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_unit = $('#txtUnit_' + b_seq).val();
							var t_mount = $('#txtMount_' + b_seq).val();
							$('#txtTotal_' + b_seq).val(round(q_mul(dec($('#txtPrice_' + b_seq).val()), dec(t_mount)), 0));
						});
						
						$('#txtMount_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccuweight_"+n, r_accy);
							}
							sum();
						});
						
						$('#txtMount_' + j).focusout(function() {
                            if (q_cur == 1 || q_cur == 2)
                                sum();
                                $('#btnClose_div_stk').click();
                        });
                        
                        $('#txtMount_' + j).focusin(function(e) {
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
						
						$('#txtWeight_' + j).change(function() {
							sum();
						});
						
						$('#txtPrice_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_unit = $('#txtUnit_' + b_seq).val();
							//var t_mount = (!t_unit || emp(t_unit) || trim( t_unit).toLowerCase() != 'kg' ? $('#txtMount_' + b_seq).val() : $('#txtWeight_' +b_seq).val()); // 計價量
							var t_mount = $('#txtMount_' + b_seq).val();
							$('#txtTotal_' + b_seq).val(round(q_mul(dec($('#txtPrice_' + b_seq).val()), dec(t_mount)), 0));
							sum();
						});
						$('#txtTotal_' + j).focusout(function() {
							sum();
						});
						/*$('#btnRecord_' + j).click(function() {
						 t_IdSeq = -1;
						 q_bodyId($(this).attr('id'));
						 b_seq = t_IdSeq;
						 t_where = "tgg='" + $('#txtTggno').val() + "' and noq='" + $('#txtProductno_' + b_seq).val() + "'";
						 q_box("z_rc2record.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'rc2record', "95%", "95%", q_getMsg('lblRecord_s'));
						 });*/
						$('#btnRecord_' + j).click(function() {
							var n = replaceAll($(this).attr('id'), 'btnRecord_', '');
							q_box("z_rc2record.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";tgg=" + $('#txtTggno').val() + "&product=" + $('#txtProductno_' + n).val() + ";" + r_accy, 'z_vccstp', "95%", "95%", q_getMsg('popPrint'));
						});
						
						$('#btnS1_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#txtProduct_'+b_seq).val()+'∮');
						});
						
						$('#btnStk_' + j).mousedown(function(e) {
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
				
				$('#btnCopystore').unbind('click');
				$('#btnCopystore').click(function() {
					if(q_cur==1 || q_cur==2){
						if(!emp($('#txtStoreno_0').val())){
							var t_storeno=$('#txtStoreno_0').val();
							var t_store=$('#txtStore_0').val();
							for (var i = 1; i < q_bbsCount; i++) {
								if(emp($('#txtStoreno_'+i).val()) && !emp($('#txtProductno_'+i).val())){
									$('#txtStoreno_'+i).val(t_storeno);
									$('#txtStore_'+i).val(t_store);
								}
							}
						}
					}
				});
				
			}
			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				$('#cmbTaxtype').val(1);
				$('#combAddr').text('');
			}
			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ rc2no='" + $('#txtNoa').val() + "'^^";
				q_gt('pays', t_where, 0, 0, 0, 'btnModi', r_accy);
			}
			function btnPrint() {
				q_box("z_rc2fep.aspx?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}
			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}
			function bbsSave(as) {
				if (!as['productno'] && !as['product'] && !as['spec'] && !dec(as['total'])) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['type'] = abbm2['type'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['datea'] = abbm2['datea'];
				as['tggno'] = abbm2['tggno'];
				as['kind'] = abbm2['kind'];
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
			function refresh(recno) {
				_refresh(recno);
				if (isinvosystem)
					$('.istax').hide();
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
			}
			
			function stype_chang(){
				if($('#cmbStype').val()=='7'){
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
					//恢復滑鼠右鍵
		            document.oncontextmenu = function () {
		                return true;
		            }
				} else {
					$('#combAddr').removeAttr('disabled');
					//防滑鼠右鍵
		            document.oncontextmenu = function () {
		                return false;
		            }
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
				sum();
			}
			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();
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
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ rc2no='" + $('#txtNoa').val() + "'^^";
				q_gt('pays', t_where, 0, 0, 0, 'btnDele', r_accy);
			}
			function btnCancel() {
				_btnCancel();
			}
			function q_popPost(s1) {
				switch (s1) {
					case 'txtTggno':
						if (!emp($('#txtTggno').val())) {
							var t_where = "where=^^ tggno='" + $('#txtTggno').val() + "' and datea>='"+q_cdn(q_date(),-183)+"' ^^  stop=999";
							q_gt('view_rc2', t_where, 0, 0, 0, "custgetaddr");
						}
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
				t_total = t_money;
				if (!isinvosystem) {
					var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
					switch ($('#cmbTaxtype').val()) {
						case '0':
							// 無
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '1':
							// 應稅
							t_tax = round(q_mul(t_money, t_taxrate), 0);
							t_total = q_add(t_money, t_tax);
							break;
						case '2':
							//零稅率
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '3':
							// 內含
							t_tax = round(q_mul(q_div(t_money, q_add(1, t_taxrate)), t_taxrate), 0);
							t_total = t_money;
							t_money = q_sub(t_total, t_tax);
							break;
						case '4':
							// 免稅
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '5':
							// 自定
							$('#txtTax').attr('readonly', false);
							$('#txtTax').css('background-color', 'white').css('color', 'black');
							t_tax = round(q_float('txtTax'), 0);
							t_total = q_add(t_money, t_tax);
							break;
						case '6':
							// 作廢-清空資料
							t_money = 0, t_tax = 0, t_total = 0;
							break;
						default:
							break;
					}
				}
				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				
				if(!emp($('#txtPayano').val())){
					//$('#txtTotal').val(FormatNumber(t_tax));
					//105/04/27有預付單號 稅額也不算
					$('#txtTotal').val(0);
				}else{
					$('#txtTotal').val(FormatNumber(t_total));	
				}
			}
			
			var mouse_div = true; //控制滑鼠消失div
		    var row_bbsbbt = ''; //判斷是bbs或bbt增加欄位
		    var row_b_seq = ''; //判斷第幾個row
		    //插入欄位
		    function q_bbs_addrow(bbsbbt, row, topdown) {
		        //取得目前行
		        var rows_b_seq = dec(row) + dec(topdown);
		        if (bbsbbt == 'bbs') {
		            q_gridAddRow(bbsHtm, 'tbbs', 'txtNo2', 1);
		            //目前行的資料往下移動
		            for (var i = q_bbsCount - 1; i >= rows_b_seq; i--) {
		                for (var j = 0; j < fbbs.length; j++) {
		                    if (i != rows_b_seq)
		                        $('#' + fbbs[j] + '_' + i).val($('#' + fbbs[j] + '_' + (i - 1)).val());
		                    else
		                        $('#' + fbbs[j] + '_' + i).val('');
		                }
		            }
		        }
		        if (bbsbbt == 'bbt') {
		            q_gridAddRow(bbtHtm, 'tbbt', fbbt, 1, '', '', '', '__');
		            //目前行的資料往下移動
		            for (var i = q_bbtCount - 1; i >= rows_b_seq; i--) {
		                for (var j = 0; j < fbbt.length; j++) {
		                    if (i != rows_b_seq)
		                        $('#' + fbbt[j] + '__' + i).val($('#' + fbbt[j] + '__' + (i - 1)).val());
		                    else
		                        $('#' + fbbt[j] + '__' + i).val('');
		                }
		            }
		        }
		        $('#div_row').hide();
		        row_bbsbbt = '';
		        row_b_seq = '';
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
			.txt.c4 {
				width: 20%;
				float: left;
			}
			.txt.c5 {
				width: 78%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.ime {
				ime-mode:disabled;
				-webkit-ime-mode: disabled;
				-moz-ime-mode:disabled;
				-o-ime-mode:disabled;
				-ms-ime-mode:disabled;
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
			.tbbm td {
				width: 9%;
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
			#div_row{
				display:none;
				width:750px;
				background-color: #ffffff;
				position: absolute;
				left: 20px;
				z-index: 50;
			}
			.table_row tr td .lbl.btn {
                color: #000000;
                font-weight: bolder;
                font-size: medium;
                cursor: pointer;
            }
            .table_row tr td .lbl.btn:hover {
                color: #FF8F19;
            }
		</style>
	</head>
	<body>
		<div id="div_row" style="position:absolute; top:300px; left:500px; display:none; width:150px; background-color: #ffffff; ">
			<table id="table_row"  class="table_row" style="width:100%;" border="1" cellpadding='1'  cellspacing='0'>
				<tr>
					<td align="center" ><a id="lblTop_row" class="lbl btn">上方插入空白行</a></td>
				</tr>
				<tr>
					<td align="center" ><a id="lblDown_row" class="lbl btn">下方插入空白行</a></td>
				</tr>
			</table>
		</div>
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
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="overflow:hidden; width: 1270px;">
			<div class="dview" id="dview">
				<table class="tview" id="tview" >
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewTypea'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewTgg'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='typea=rc2.typea'>~typea=rc2.typea</td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='tggno tgg,4' style="text-align: left;">~tggno ~tgg,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm" style="width: 872px;">
					<tr class="tr1">
						<td class="td1"><span> </span><a id='lblType' class="lbl"> </a></td>
						<td class="td2"><select id="cmbTypea" class="txt c1"> </select></td>
						<td class="td3"><span> </span><a id='lblStype' class="lbl"> </a></td>
						<td class="td4"><select id="cmbStype" class="txt c1"> </select></td>
						<td class="td5"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td class="td6"><input id="txtDatea" type="text" class="txt c1 ime"/></td>
						<td class="td7"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td8"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr2">
						<td class="td1"><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCno" type="text" class="txt c1"/></td>
						<td class="td3" colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td class="td7" ><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td class="td8"><input id="txtMon" type="text" class="txt c1"/></td>
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
					<tr class="tr3">
						<td class="td1"><span> </span><a id='lblTgg' class="lbl btn"> </a></td>
						<td class="td2"><input id="txtTggno" type="text" class="txt c1" /></td>
						<td class="td3" colspan="2"><input id="txtTgg" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td class="td2"><input id="txtTel" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span><a id='lblOrdc' class="lbl btn"> </a></td>
						<td class="td8"><input id="txtOrdcno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr4">
						<td class="td1"><span> </span><a id='lblAddr' class="lbl btn"> </a></td>
						<td class="td2"><input id="txtPost" type="text" class="txt c1"/></td>
						<td class="td3" colspan='4' >
							<input id="txtAddr" type="text" class="txt" style="width: 98%;"/>
						</td>
						<td class="td7"><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td class="td8">
							<input id="txtPaytype" type="text" class="txt c5"/>
							<select id="combPaytype" class="txt c4" onchange='cmbPaytype_chg()'> </select>
						</td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id='lblAddr2' class="lbl btn"> </a></td>
						<td class="td2"><input id="txtPost2" type="text" class="txt c1"/></td>
						<td class="td3" colspan='4' >
							<input id="txtAddr2" type="text" class="txt" style="width: 95%;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td class="td7"><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td class="td8"><select id="cmbTrantype" class="txt c1"> </select></td>
					</tr>
					<tr class="tr8">
						<td class="td1"><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td class="td2"colspan='2'>
							<input id="txtMoney" type="text" class="txt num c1" />
						</td>
						<td class="td4" ><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td class="td5" colspan='2' >
							<input id="txtTax" type="text" class="txt num c1 istax" style="width: 49%;" />
							<select id="cmbTaxtype" class="txt c1" style="width: 49%;" onchange="calTax();"> </select>
						</td>
						<td class="td7"><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td class="td8"><input id="txtTotal" type="text" class="txt num c1 istax" /></td>
					</tr>
					<tr class="tr10">
						<td class="td1"><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td class="td2" colspan='7' >
							<input id="txtMemo" type="text" class="txt" style="width:98%;"/>
						</td>
					</tr>
					<tr class="tr11">
						<td class="td1"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td2"><input id="txtWorker" type="text" class="txt c1"/></td>
						<td class="td3"><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblAccc' class="lbl btn"> </a></td>
						<td class="td5" colspan="2"><input id="txtAccno" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id='lblPayano' class="lbl btn">預付單號</a></td>
						<td class="td2"><input id="txtPayano" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1260px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;">
						<input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" />
					</td>
					<td align="center" style="width:100px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:250px;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:95px;" class="isStyle"><a id='lblStyle'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:80px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:80px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:80px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:100px;"><a id='lblStore_s'> </a>
						<input id="btnCopystore" type="button" value="≡">
					</td>
					<td align="center"><a id='lblMemos'> </a></td>
					<td align="center" style="width:40px;"><a id='lblRecord_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUno_s'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td>
						<input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" />
					</td>
					<td>
						<input id="txtProductno.*" type="text" class="txt c1" style="line-height:20px;"/>
						<input class="btn" id="btnProductno.*" type="button" value='.' style="font-weight: bold;" />
						<input id="txtNoq.*" type="text" class="txt c6"/>
					</td>
					<td>
						<input type="text" id="txtProduct.*" class="txt c1"/>
						<input type="text" id="txtSpec.*" class="txt c1 isSpec"/>
						<input class="btn" id="btnS1.*" type="button" value='∮' style="font-size: 10px;float: left;padding: 2px 5px;height: 24px;line-height: 20px;" />
					</td>
					<td class="isStyle"><input id="txtStyle.*" type="text" class="txt c1"/></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt num c1" /></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1" /></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1" /></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 65%"/>
						<input class="btn" id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore.*" type="text" class="txt c1"/>
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<input id="txtOrdeno.*" type="text" class="txt" style="width:65%;" />
						<input id="txtNo2.*" type="text" class="txt" style="width:25%;" />
						<input id="recno.*" style="display:none;"/>
					</td>
					<td align="center"><input class="btn" id="btnRecord.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td><input id="txtUno.*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>