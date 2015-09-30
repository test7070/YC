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
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_desc = 1;
			q_tables = 's';
			var q_name = "orde";
			var q_readonly = ['txtNoa','txtApv', 'txtWorker', 'txtWorker2', 'txtComp', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtSales', 'txtOrdbno', 'txtOrdcno','txtWeight'];
			var q_readonlys = ['txtTotal', 'txtQuatno', 'txtNo2', 'txtNo3', 'txtC1', 'txtNotv'];
			var bbmNum = [['txtTotal', 10, 0, 1], ['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1]];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'odate';
			brwCount2 = 11;
			
			aPop = new Array(
				['txtProductno_', 'btnProduct_', 'ucaucc2', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtLengthc_', 'ucaucc2_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtCustno', 'lblCust', 'cust', 'noa,nick,paytype,trantype,tel,fax,zip_fact,addr_fact,salesno,sales', 'txtCustno,txtComp,txtPaytype,cmbTrantype,txtTel,txtFax,txtPost,txtAddr,txtSalesno,txtSales', 'cust_b.aspx'],
				['ordb_txtTggno_', '', 'tgg', 'noa,comp', 'ordb_txtTggno_,ordb_txtTgg_', '']
			);
			
			var isinvosystem = false;
			//購買發票系統
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'no2'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				$('#txtOdate').focus();
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
					if (t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓'){ 
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_weight)), 0));
						q_tr('txtNotv_' + j, q_sub(t_weight, q_float('txtC1' + j)));
					}else{
						$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
						q_tr('txtNotv_' + j, q_sub(t_mount, q_float('txtC1' + j)));
					}
					t1 = q_add(t1, dec($('#txtTotal_' + j).val()));
				}
				$('#txtMoney').val(round(t1, 0));
				
				q_tr('txtWeight', Math.round(q_div(q_mul(q_float('txtMoney'),q_float('txtPrice')),100)));
				
				calTax();
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtOdate', r_picd]];
				q_mask(bbmMask);
				bbsMask = [['txtDatea', r_picd]];
				bbsNum = [['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1], ['txtMount', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTotal', 10, 0, 1],['txtC1', 10, q_getPara('vcc.mountPrecision'), 1], ['txtNotv', 10, q_getPara('vcc.mountPrecision'), 1]];
				q_cmbParse("cmbStype", q_getPara('orde.stype'));
				q_cmbParse("combPaytype", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));

				var t_where = "where=^^ 1=1 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				$('#lblPrice').text('扣');
				$('#lblPer').html('%&nbsp;&nbsp;');
				$('#lblWeight').text('折讓');
				
				$('#btnQuat').click(function() {
					btnQuat();
				});
				
				$('#btnApv').click(function(e){
                    Lock(1, {
                        opacity : 0
                    });
                    q_func('qtxt.query.apv', 'orde.txt,apv,'+ encodeURI(r_userno) + ';' + encodeURI($('#txtNoa').val()));
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
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'^^";
						q_gt('cust', t_where, 0, 0, 0, "custgetaddr");
					}
				});

				$('#btnCredit').click(function() {
					if (!emp($('#txtCustno').val())) {
						q_box("z_credit.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";custno='" + $('#txtCustno').val() + "';" + r_accy + ";" + q_cur, 'ordei', "95%", "95%", q_getMsg('btnCredit'));
					}
				});
				////-----------------以下為addr2控制事件---------------
				$('#btnAddr2').mousedown(function(e) {
					var t_post2 = $('#txtPost2').val().split(';');
					var t_addr2 = $('#txtAddr2').val().split(';');
					var maxline=0;//判斷最多有幾組地址
					t_post2.length>t_addr2.length?maxline=t_post2.length:maxline=t_addr2.length;
					maxline==0?maxline=1:maxline=maxline;
					var rowslength=document.getElementById("table_addr2").rows.length-1;
					for (var j = 1; j < rowslength; j++) {
						document.getElementById("table_addr2").deleteRow(1);
					}
					
					for (var i = 0; i < maxline; i++) {
						var tr = document.createElement("tr");
						tr.id = "bbs_"+i;
						tr.innerHTML = "<td id='addr2_tdBtn2_"+i+"'><input class='btn addr2' id='btnAddr_minus_"+i+"' type='button' value='-' style='width: 30px' onClick=minus_addr2("+i+") /></td>";
						tr.innerHTML+= "<td id='addr2_tdPost2_"+i+"'><input id='addr2_txtPost2_"+i+"' type='text' class='txt addr2' value='"+t_post2[i]+"' style='width: 70px'/></td>";
						tr.innerHTML+="<td id='addr2_tdAddr2_"+i+"'><input id='addr2_txtAddr2_"+i+"' type='text' class='txt c1 addr2' value='"+t_addr2[i]+"' /></td>";
						var tmp = document.getElementById("addr2_close");
						tmp.parentNode.insertBefore(tr,tmp);
					}
					readonly_addr2();
					$('#div_addr2').show();
				});
				$('#btnAddr_plus').click(function() {
					var rowslength=document.getElementById("table_addr2").rows.length-2;
					var tr = document.createElement("tr");
						tr.id = "bbs_"+rowslength;
						tr.innerHTML = "<td id='addr2_tdBtn2_"+rowslength+"'><input class='btn addr2' id='btnAddr_minus_"+rowslength+"' type='button' value='-' style='width: 30px' onClick=minus_addr2("+rowslength+") /></td>";
						tr.innerHTML+= "<td id='addr2_tdPost2_"+rowslength+"'><input id='addr2_txtPost2_"+rowslength+"' type='text' class='txt addr2' value='' style='width: 70px' /></td>";
						tr.innerHTML+="<td id='addr2_tdAddr2_"+rowslength+"'><input id='addr2_txtAddr2_"+rowslength+"' type='text' class='txt c1 addr2' value='' /></td>";
						var tmp = document.getElementById("addr2_close");
						tmp.parentNode.insertBefore(tr,tmp);
				});
				$('#btnClose_div_addr2').click(function() {
					if(q_cur==1||q_cur==2){
						var rows=document.getElementById("table_addr2").rows.length-3;
						var t_post2 = '';
						var t_addr2 = '';
						for (var i = 0; i <= rows; i++) {
							if(!emp($('#addr2_txtPost2_'+i).val())||!emp($('#addr2_txtAddr2_'+i).val())){
								t_post2 += $('#addr2_txtPost2_'+i).val()+';';
								t_addr2 += $('#addr2_txtAddr2_'+i).val()+';';
							}
						}
						$('#txtPost2').val(t_post2.substr(0,t_post2.length-1));
						$('#txtAddr2').val(t_addr2.substr(0,t_addr2.length-1));
					}
					$('#div_addr2').hide();
				});
				
				$('#chkCancel').click(function(){
					if($(this).prop('checked')){
						for(var k=0;k<q_bbsCount;k++){
							$('#chkCancel_'+k).prop('checked',true);
						}
					}
				});
				
				$('#txtPrice').change(function(){
					sum();
				});
				
				$('#txtWeight').change(function(){
					sum();
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
			
			//addr2控制事件vvvvvv-------------------
			function minus_addr2(seq) {	
				$('#addr2_txtPost2_'+seq).val('');
				$('#addr2_txtAddr2_'+seq).val('');
			}
			
			function readonly_addr2() {
				if(q_cur==1||q_cur==2){
					$('.addr2').removeAttr('disabled');
				}else{
					$('.addr2').attr('disabled', 'disabled');
				}
			}
			
			//addr2控制事件^^^^^^--------------------
			
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'quats':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							//取得報價的第一筆匯率等資料
							var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
							q_gt('quat', t_where, 0, 0, 0, "", r_accy);

							var i, j = 0;
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtUnit,txtPrice,txtMount,txtWeight,txtQuatno,txtNo3', b_ret.length, b_ret, 'productno,product,spec,unit,price,mount,weight,noa,no3', 'txtProductno,txtProduct,txtSpec');
							/// 最後 aEmpField 不可以有【數字欄位】
							sum();
							bbsAssign();
						}
						break;

					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			function browTicketForm(obj) {
				//資料欄位名稱不可有'_'否則會有問題
				if (($(obj).attr('readonly') == 'readonly') || ($(obj).attr('id').substring(0, 3) == 'lbl')) {
					if ($(obj).attr('id').substring(0, 3) == 'lbl')
						obj = $('#txt' + $(obj).attr('id').substring(3));
					var noa = $.trim($(obj).val());
					var openName = $(obj).attr('id').split('_')[0].substring(3).toLowerCase();
					if (noa.length > 0) {
						switch (openName) {
							case 'ordbno':
								q_box("ordb.aspx?;;;charindex(noa,'" + noa + "')>0;" + r_accy, 'ordb', "95%", "95%", q_getMsg("popOrdb"));
								break;
							case 'ordcno':
								q_box("ordc.aspx?;;;noa='" + noa + "';" + r_accy, 'ordc', "95%", "95%", q_getMsg("popOrdc"));
								break;
							case 'quatno':
								q_box("quat.aspx?;;;noa='" + noa + "';" + r_accy, 'quat', "95%", "95%", q_getMsg("popQuat"));
								break;
						}
					}
				}
			}

			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			function q_gtPost(t_name) {
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
								Unlock(1);
								return;
							}
						}else{
							alert('【'+$('#txtCustno').val()+'】客戶不存在!!!');
							Unlock(1);
							return;
						}
						break;
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'orde_ordb':
						var as = _q_appendData("view_orde", "", true);
						var rowslength=document.getElementById("table_ordb").rows.length-1;
						for (var j = 1; j < rowslength; j++) {
							document.getElementById("table_ordb").deleteRow(1);
						}
							
						for (var i = 0; i < as.length; i++) {
							var tr = document.createElement("tr");
							tr.id = "bbs_"+i;
							tr.innerHTML= "<td id='ordb_tdNo2_"+i+"'><input id='ordb_txtNo2_"+i+"' type='text' value='"+as[i].no2+"' style='width: 45px' disabled='disabled' /><input id='ordb_txtNoa_"+i+"' type='text' value='"+as[i].noa+"' style='width: 45px;display:none' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdProdcut_"+i+"'><input id='ordb_txtProdcut_"+i+"' type='text' value='"+as[i].product+"' style='width: 200px' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdMount_"+i+"'><input id='ordb_txtMount_"+i+"' type='text' value='"+as[i].mount+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdSafemount_"+i+"'><input id='ordb_txtSafemount_"+i+"' type='text' value='"+dec(as[i].safemount)+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdStmount_"+i+"'><input id='ordb_txtStmount_"+i+"' type='text' value='"+as[i].stmount+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdOcmount_"+i+"'><input id='ordb_txtOcmount_"+i+"' type='text' value='"+dec(as[i].ocmount)+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							//庫存-訂單數量>安全量?不需請購:abs(安全量-(庫存-訂單數量))
							tr.innerHTML+="<td id='ordb_tdObmount_"+i+"'><input id='ordb_txtObmount_"+i+"' type='text' value='"+(q_sub(dec(as[i].stmount),dec(as[i].mount))>as[i].safemount?0:Math.abs(q_sub(dec(as[i].safemount),q_sub(dec(as[i].stmount),dec(as[i].mount)))))+"' class='num' style='width: 80px;text-align: right;' /></td>";
							tr.innerHTML+="<td id='ordb_tdTggno_"+i+"'><input id='ordb_txtTggno_"+i+"' type='text' value='"+as[i].tggno+"' style='width: 150px'  /><input id='ordb_txtTgg_"+i+"' type='text' value='"+as[i].tgg+"' style='width: 200px' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdInprice_"+i+"'><input id='ordb_txtInprice_"+i+"' type='text' value='"+(dec(as[i].tggprice)>0?as[i].tggprice:as[i].inprice)+"' class='num' style='width: 80px;text-align: right;' /></td>";
								
							var tmp = document.getElementById("ordb_close");
							tmp.parentNode.insertBefore(tr,tmp);
						}
						$('#lblOrde2ordb').text(q_getMsg('lblOrde2ordb'));
						$('#div_ordb').show();
						
						var SeekF= new Array();
						$('#table_ordb td').children("input:text").each(function() {
							if($(this).attr('disabled')!='disabled')
								SeekF.push($(this).attr('id'));
						});
						
						SeekF.push('btn_div_ordb');
						$('#table_ordb td').children("input:text").each(function() {
							$(this).keydown(function(event) {
								if( event.which == 13) {
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
								}
							});
						});
						
						$('#table_ordb td .num').each(function() {
							$(this).keyup(function() {
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						});
						
						refresh(q_recno);
						q_cur=2;
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
					case 'msg_stk':
						var as = _q_appendData("stkucc", "", true);
						var stkmount = 0;
						t_msg = '';
						for (var i = 0; i < as.length; i++) {
							stkmount = q_add(stkmount, dec(as[i].mount));
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
								wcost_price = round(q_div(q_add(q_add(q_add(dec(as[0].costa), dec(as[0].costb)), dec(as[0].costc)), dec(as[0].costd)), dec(as[0].mount)), 0)
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
					case 'quat':
						var as = _q_appendData("quat", "", true);
						if (as[0] != undefined) {
							$('#txtPaytype').val(as[0].paytype);
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
							$('#txtContract').val(as[0].contract);
							$('#cmbTrantype').val(as[0].trantype);
							$('#txtTel').val(as[0].tel);
							$('#txtFax').val(as[0].fax);
							$('#txtPost').val(as[0].post);
							$('#txtAddr').val(as[0].addr);
							$('#txtPost2').val(as[0].post2);
							$('#txtAddr2').val(as[0].addr2);
							$('#cmbTaxtype').val(as[0].taxtype);
							sum();
						}
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case 'btnModi':
						var as = _q_appendData("view_vccs", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_mount = parseFloat(as[i].mount.length == 0 ? "0" : as[i].mount);
								if (t_mount != 0)
									z_msg += String.fromCharCode(13) + '出貨單號【' + as[i].noa + '】 ' +as[i].product+" "+ FormatNumber(t_mount);
							}
							if (z_msg.length > 0) {
								alert('已出貨:' + z_msg);
								Unlock(1);
								return;
							}
						}
						
						_btnModi();
						Unlock(1);
						$('#txtOdate').focus();
						$('#txtApv').val('');
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'^^";
							q_gt('cust', t_where, 0, 0, 0, "custgetaddr");
						}
						break;
					case 'btnDele':
						var as = _q_appendData("view_vccs", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_mount = parseFloat(as[i].mount.length == 0 ? "0" : as[i].mount);
								if (t_mount != 0)
									z_msg += String.fromCharCode(13) + '出貨單號【' + as[i].noa + '】 ' +as[i].product+" "+ FormatNumber(t_mount);
							}
							
							if (z_msg.length > 0) {
								alert('已出貨:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnDele();
						Unlock(1);
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

			function btnQuat() {
				var t_custno = trim($('#txtCustno').val());
				var t_where = '';
				if (t_custno.length > 0) {
					t_where = "noa+'_'+no3 not in (select isnull(quatno,'')+'_'+isnull(no3,'') from view_ordes" + r_accy + " where noa!='" + $('#txtNoa').val() + "' ) and isnull(enda,0)=0 and isnull(cancel,0)=0"
					t_where = t_where + ' and ' + q_sqlPara("custno", t_custno)+" and datea>='"+$('#txtOdate').val()+"'";
				}else {
					alert(q_getMsg('msgCustEmp'));
					return;
				}
				q_box("quat_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'quats', "95%", "95%", $('#btnQuat').val());
			}
			
			var check_custstatus=false;
			function btnOk() {
				Lock(1, {
                    opacity : 0
                });
				t_err = '';
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtCustno', q_getMsg('lblCustno')], ['txtCno', q_getMsg('btnAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					Unlock(1);
					return;
				}
				
				if(!check_custstatus){
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('cust', t_where, 0, 0, 0, "getcuststatus");
					return;
				}
				check_custstatus=false;
				
				for(var k=0;k<q_bbsCount;k++){
					if(emp($('#txtDatea_'+k).val()))
						$('#txtDatea_'+k).val(q_cdn($.trim($('#txtOdate').val()),15))	
				}
				
				//重新編號
				var maxno2='001';
				for (var j = 0; j < q_bbsCount; j++) {
					if((!emp($('#txtProductno_'+j).val())) || (!emp($('#txtProduct_'+j).val()))){
						$('#txtNo2_'+j).val(maxno2);
						maxno2=('000'+(dec(maxno2)+1)).substr(-3);
					}
					if(emp($('#txtProductno_'+j).val()) && emp($('#txtProduct_'+j).val())){
						$('#txtNo2_'+j).val('');
					}
				}
				
				//1030419 當專案沒有勾 BBM的取消和結案被打勾BBS也要寫入
				if(!$('#chkIsproj').prop('checked')){
					for (var j = 0; j < q_bbsCount; j++) {
						if($('#chkEnda').prop('checked'))
							$('#chkEnda_'+j).prop('checked','true');
						if($('#chkCancel').prop('checked'))
							$('#chkCancel_'+j).prop('checked','true')
					}
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				sum();
				//判斷信用餘額
				q_func('qtxt.query.orde', 'credit.txt,orde,'+ encodeURI($('#txtCustno').val()) + ';' + encodeURI($('#txtNoa').val()));
			}
			
			function save(){
                var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
                if (s1.length == 0 || s1 == "AUTO")/// 自動產生編號
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_orde') + $('#txtOdate').val(), '/', ''));
                else
                    wrServer(s1);
            }
            
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                Unlock(1);
            }
			
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.orde':
                        var as = _q_appendData("tmp0", "", true, true);                     
                        if(as[0]!=undefined){
                            var total = parseFloat(as[0].total.length==0?"0":as[0].total);
                            var credit = parseFloat(as[0].credit.length==0?"0":as[0].credit);
                            var gqb = parseFloat(as[0].gqbMoney.length==0?"0":as[0].gqbMoney);
                            var vcc = parseFloat(as[0].vccMoney.length==0?"0":as[0].vccMoney);
                            var orde = parseFloat(as[0].ordeMoney.length==0?"0":as[0].ordeMoney);
                            var umm = parseFloat(as[0].ummMoney.length==0?"0":as[0].ummMoney);
                            var curorde = 0;
                            var curtotal = 0;
                            
                            for(var i=0;i<q_bbsCount;i++){
                                curorde = q_add(curorde,q_float('txtTotal_'+i));                     
                            }
                            curtotal = credit - gqb - vcc -orde - umm - curorde;
                            if(curtotal<0){
                                var t_space = '          ';
                                var msg = as[0].custno+'-'+as[0].cust+'\n'
                                +' 基本額度：'+(t_space+q_trv(credit)).replace(/^.*(.{20})$/,'$1')+'\n'
                                +'-應收票據：'+(t_space+q_trv(gqb)).replace(/^.*(.{20})$/,'$1')+'\n'
                                +'-應收帳款：'+(t_space+q_trv(vcc)).replace(/^.*(.{20})$/,'$1')+'\n'
                                +'-未出訂單：'+(t_space+q_trv(orde)).replace(/^.*(.{20})$/,'$1')+'\n'
                                +'-預收貨款：'+(t_space+q_trv(umm)).replace(/^.*(.{20})$/,'$1')+'\n'
                                +'-本張訂單：'+(t_space+q_trv(curorde)).replace(/^.*(.{20})$/,'$1')+'\n'
                                +'----------------------------'+'\n'
                                +'額度餘額：'+(t_space+q_trv(curtotal)).replace(/^.*(.{20})$/,'$1');
                                alert(msg);
                                Unlock(1);
                                return;
                            }                 
                        }
                        save();
                        break;
                    case 'qtxt.query.apv':
                        var as = _q_appendData("tmp0", "", true, true);
                        if(as[0]!=undefined){
                            var err = as[0].err;
                            var msg = as[0].msg;
                            var ordeno = as[0].ordeno;  
                            var userno = as[0].userno;  
                            var namea = as[0].namea;
                            if(err=='1'){
                                $('#txtApv').val(namea);
                                for(var i=0;i<abbm.length;i++){
                                    if(abbm[i].noa==ordeno){
                                        abbm[i].apv=namea;
                                        break;
                                    }
                                }
                            }else{
                                alert(msg); 
                            }
                        }
                        Unlock(1);
                        break;
                }
            }

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('orde_s.aspx', q_name + '_s', "500px", "450px", q_getMsg("popSeek"));
			}

			function combPaytype_chg() {
				var cmb = document.getElementById("combPaytype");
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
						
						$('#txtLengthc_'+j).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccstdmount_"+n, r_accy);
							}
						});
						
						$('#btnProductno_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							pop('ucc');
						});
						$('#txtProductno_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							//q_change($(this), 'ucc', 'noa', 'noa,product,unit');
						});

						$('#txtUnit_' + j).focusout(function() {
							sum();
						});
						
						$('#txtWeight_' + j).focusout(function () { 
							sum(); 
						});
						
						$('#txtPrice_' + j).focusout(function() {
							sum();
						});
						
						$('#txtMount_'+j).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if (!emp($('#txtProductno_' + n).val())) {
								var t_where = "where=^^ noa='" + $('#txtProductno_' + n).val() + "' ^^ stop=1";
								q_gt('ucc', t_where, 0, 0, 0, "uccuweight_"+n, r_accy);
							}
						});
						
						$('#txtWeight_' + i).change(function() {
							sum();
						});
						
						$('#txtMount_' + j).focusout(function() {
							sum();
						});
						$('#txtTotal_' + j).focusout(function() {
							sum();
						});

						$('#txtMount_' + j).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//庫存
									var t_where = "where=^^ ['" + q_date() + "','','"+$('#txtProductno_' + b_seq).val()+"')  ^^";
									q_gt('calstk', t_where, 0, 0, 0, "msg_stk", r_accy);
								}
							}
						});
						$('#txtPrice_' + j).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//金額
									var t_where = "where=^^ noa='" + $('#txtProductno_' + b_seq).val() + "' ^^ stop=1";
									q_gt('ucc', t_where, 0, 0, 0, "msg_ucc", r_accy);
								}
							}
						});

						$('#btnBorn_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "noa='" + $('#txtNoa').val() + "' and no2='" + $('#txtNo2_' + b_seq).val() + "'";
							q_box("z_born.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'born', "95%", "95%", q_getMsg('lblBorn'));
						});
						$('#btnNeed_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "productno='" + $('#txtProductno_'+ b_seq).val() + "' and product='" + $('#txtProduct_' + b_seq).val() + "'";
							q_box("z_vccneed.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'Need', "95%", "95%", q_getMsg('lblNeed'));
						});

						$('#btnVccrecord_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "custno='" + $('#txtCustno').val() + "' and comp='" + $('#txtComp').val() + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' and product='" + $('#txtProduct_' + b_seq).val() + "'";
							q_box("z_vccrecord.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vccrecord', "95%", "95%", q_getMsg('lblRecord_s'));
						});
						
						$('#btnScheduled_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (!emp($('#txtProductno_' + b_seq).val())) {
								t_where = "noa='"+$('#txtProductno_' + b_seq).val()+"' and product='"+$('#txtProduct_' + b_seq).val()+"' ";
								q_box("z_scheduled.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'scheduled', "95%", "95%", q_getMsg('PopScheduled'));
							}
						});
						
						$('#btnOrdemount_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "title='本期訂單' and bdate='"+q_cdn(q_date(),-61)+"' and edate='"+q_cdn(q_date(),+61)+"' and noa='"+$('#txtProductno_' + b_seq).val()+"' and product='"+$('#txtProduct_' + b_seq).val()+"' ";
							q_box("z_workgorde.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'scheduled', "95%", "95%", q_getMsg('PopScheduled'));
						});
						
						$('#btnS1_'+j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#txtProduct_'+b_seq).val()+'∮');
						});
					}
				}
				_bbsAssign();
				HiddenTreat();
				if (q_cur<1 && q_cur>2) {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtDatea_'+j).datepicker( 'destroy' );
					}
				} else {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtDatea_'+j).removeClass('hasDatepicker')
						$('#txtDatea_'+j).datepicker();
					}
				}
			}

			function btnIns() {
				_btnIns();
				$('#chkIsproj').attr('checked', true);
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtOdate').val(q_date());
				$('#txtOdate').focus();
				$('#cmbTaxtype').val('1');

				var t_where = "where=^^ 1=1 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				$('#combAddr').text('');
				q_cmbParse("combAddr", ' @ ');
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
					
				//檢查是否已出貨
				Lock(1, {
					opacity : 0
				});
				
				if(q_getPara('sys.project').toUpperCase()!='YC'){
					var t_where = " where=^^ ordeno='" + $('#txtNoa').val() + "'^^";
					q_gt('view_vccs', t_where, 0, 0, 0, 'btnModi');
				}else{
					_btnModi();
					Unlock(1);
					$('#txtOdate').focus();
					$('#txtApv').val('');
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'  ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'^^";
						q_gt('cust', t_where, 0, 0, 0, "custgetaddr");
					}
				}
				
			}

			function btnPrint() {
                q_box("z_ordep_yc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa:trim($('#txtNoa').val())}), '', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				xmlSql = '';
				if (q_cur == 2)
					xmlSql = q_preXml();

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
				as['odate'] = abbm2['odate'];

				if (!emp(abbm2['datea']))
					as['datea'] = abbm2['datea'];

				as['custno'] = abbm2['custno'];
				as['comp'] = abbm2['comp'];

				if (!as['enda'])
					as['enda'] = 'N';
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
				$('input[id*="txt"]').click(function() {
					browTicketForm($(this).get(0));
				});
				$('#div_addr2').hide();
				HiddenTreat();
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
					$('#combAddr2').attr('disabled', 'disabled');
					$('#txtOdate').datepicker( 'destroy' );
					$('#btnApv').removeAttr('disabled');
					
					$('#div_row').hide();
		            $('#div_assm').hide();
		            //恢復滑鼠右鍵
		            document.oncontextmenu = function () {
		                return true;
		            }
				} else {
					$('#combAddr').removeAttr('disabled');
					$('#combAddr2').removeAttr('disabled');
					$('#txtOdate').datepicker();
					$('#btnApv').attr('disabled', 'disabled');
					
					//防滑鼠右鍵
		            document.oncontextmenu = function () {
		                return false;
		            }
				}	
				
				$('#div_addr2').hide();
				readonly_addr2();
				HiddenTreat();
			}
			
			function HiddenTreat() {
				var hasStyle = q_getPara('sys.isstyle');
				var isStyle = (hasStyle.toString()=='1'?$('.isStyle').show():$('.isStyle').hide());
				var hasSpec = q_getPara('sys.isspec');
				var isSpec = (hasSpec.toString()=='1'?$('.isSpec').show():$('.isSpec').hide());
				
				if (q_getPara('sys.project').toUpperCase()!='YC'){
					$('.islengthc').hide();
				}
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
				Lock(1, {
					opacity : 0
				});
				//_btnDele();
				
				var t_where = " where=^^ ordeno='" + $('#txtNoa').val() + "'^^";
				q_gt('view_vccs', t_where, 0, 0, 0, 'btnDele', r_accy);
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
				t_money=q_sub(t_money,q_float('txtWeight'));
				
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
				$('#txtTotal').val(FormatNumber(t_total));
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
			.tbbm td input[type="button"] {
				width: auto;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.dbbs {
				width: 100%;
			}
			.tbbs a {
				font-size: medium;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 48%;
				float: left;
			}
			.txt.c3 {
				width: 50%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 95%;
				float: left;
			}
			.num {
				text-align: right;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
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
		<!--#include file="../inc/toolbar.inc"-->
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
		<div id="div_ordb" style="position:absolute; top:180px; left:20px; display:none; width:1020px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_ordb" style="width:100%;" border="1" cellpadding='2' cellspacing='0'>
				<tr>
					<td style="width:45px;background-color: #f8d463;" align="center">訂序</td>
					<td style="width:200px;background-color: #f8d463;" align="center">品名</td>
					<td style="width:80px;background-color: #f8d463;" align="center">訂單數量</td>
					<td style="width:80px;background-color: #f8d463;" align="center">安全庫存</td>
					<td style="width:80px;background-color: #f8d463;" align="center">庫存數量</td>
					<td style="width:80px;background-color: #f8d463;" align="center">在途數量</td>
					<td style="width:80px;background-color: #f8d463;" align="center">採購數量</td>
					<td style="width:200px;background-color: #f8d463;" align="center">供應商</td>
					<td style="width:80px;background-color: #f8d463;" align="center">進貨單價</td>
				</tr>
				<tr id='ordb_close'>
					<td align="center" colspan='9'>
						<input id="btnClose_div_ordb" type="button" value="確定">
						<input id="btnClose_div_ordb2" type="button" value="取消">
					</td>
				</tr>
			</table>
		</div>
		
		<div id="div_addr2" style="position:absolute; top:244px; left:500px; display:none; width:530px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_addr2" style="width:100%;" border="1" cellpadding='2' cellspacing='0'>
				<tr>
					<td style="width:30px;background-color: #f8d463;" align="center">
						<input class="btn addr2" id="btnAddr_plus" type="button" value='＋' style="width: 30px" />
					</td>
					<td style="width:70px;background-color: #f8d463;" align="center">郵遞區號</td>
					<td style="width:430px;background-color: #f8d463;" align="center">指送地址</td>
				</tr>
				<tr id='addr2_close'>
					<td align="center" colspan='3'>
						<input id="btnClose_div_addr2" type="button" value="確定">
					</td>
				</tr>
			</table>
		</div>
		<div id='dmain' style="overflow:hidden;width: 1260px;">
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:25%"><a id='vewOdate'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='odate'>~odate</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='custno comp,4'>~custno ~comp,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm" style="width: 872px;">
					<tr class="tr1" style="height: 0px">
						<td class="td1" style="width: 108px;"> </td>
						<td class="td2" style="width: 108px;"> </td>
						<td class="td3" style="width: 108px;"> </td>
						<td class="td4" style="width: 108px;"> </td>
						<td class="td5" style="width: 108px;"> </td>
						<td class="td6" style="width: 108px;"> </td>
						<td class="td7" style="width: 108px;"> </td>
						<td class="td7" style="width: 108px;"> </td>
					</tr>
					<tr class="tr1">
						<td class="td1"><span> </span><a id='lblOdate' class="lbl"> </a></td>
						<td class="td2"><input id="txtOdate" type="text" class="txt c1"/></td>
						<td class="td3"><span> </span><a id='lblStype' class="lbl"> </a></td>
						<td class="td4"><select id="cmbStype" class="txt c1"> </select></td>
						<td class="td5"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td6" colspan="2"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr2">
						<td class="td1"><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCno" type="text" class="txt c1"/></td>
						<td class="td3" colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td class="td5" ><span> </span><a id='lblContract' class="lbl"> </a></td>
						<td class="td6"colspan="2"><input id="txtContract" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr3">
						<td class="td1"><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCustno" type="text" class="txt c1"/></td>
						<td class="td3" colspan="2"><input id="txtComp" type="text" class="txt c1"/></td>
						<td class="td5"><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td class="td6"><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td class="td7">
							<select id="combPaytype" class="txt c1" onchange='combPaytype_chg()' > </select>
						</td>
						<td class="td8" align="center"><input id="btnCredit" type="button" value='' /></td>
					</tr>
					<tr class="tr4">
						<td class="td1"><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td class="td2" colspan='3'><input id="txtTel" type="text" class="txt c1"/></td>
						<td class="td5"><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td class="td6" colspan="2"><input id="txtFax" type="text" class="txt c1" /></td>
						<td class="td8" align="center">
							<input id="btnQuat" type="button" value='' />
						</td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td class="td2"><input id="txtPost" type="text" class="txt c1"/></td>
						<td class="td3"colspan='4'>
							<input id="txtAddr" type="text" class="txt c1" style="width: 412px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td class="td7"><span> </span><a id='lblCustorde' class="lbl"> </a></td>
						<td class="td8"><input id="txtCustorde" type="text" class="txt c1"/></td>
						<!--<td class="td7"><span> </span><a id='lblOrdbno' class="lbl"> </a></td>
						<td class="td8"><input id="txtOrdbno" type="text" class="txt c1"/></td>-->
					</tr>
					<tr class="tr6">
						<td class="td1"><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td class="td2"><input id="txtPost2" type="text" class="txt c1"/></td>
						<td class="td3" colspan='4'>
							<input id="txtAddr2" type="text" class="txt c1" style="width: 412px;"/>
							<select id="combAddr2" style="width: 20px" onchange='combAddr2_chg()'> </select>
						</td>
						<td class="td7"><input id="btnAddr2" type="button" value='...' style="width: 30px;height: 21px" /> <!--<span> </span><a id='lblOrdcno' class="lbl"> </a>--></td>
						<!--<td class="td8"><input id="txtOrdcno" type="text" class="txt c1"/></td>-->
					</tr>
					<tr class="tr7">
						<td class="td1"><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td class="td2" colspan="2">
							<select id="cmbTrantype" class="txt c1" name="D1" > </select>
						</td>
						<td class="td4"><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td class="td5" colspan="2">
							<input id="txtSalesno" type="text" class="txt c2"/>
							<input id="txtSales" type="text" class="txt c3"/>
						</td>
						<td class="td4" colspan="2" style="text-align: right;" >
							<a id='lblPrice' class="lbl" style="float:none"> </a>
							<input id="txtPrice"  type="text" class="txt num c1" style="float:none;width: 25%"/>
							<a id='lblPer' class="lbl" style="float:none"> </a>
							<a id='lblWeight' class="lbl" style="float:none"> </a>
							<input id="txtWeight"  type="text" class="txt num c1" style="float:none;width: 25%"/>
						</td>
					</tr>
					<tr class="tr8">
						<td class="td1"><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtMoney" type="text" class="txt c1" style="text-align: center;"/></td>
						<td class="td4"><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td class="td5"><input id="txtTax" type="text" class="txt num c1"/></td>
						<td class="td6"><select id="cmbTaxtype" class="txt c1" onchange='sum()' > </select></td>
						<td class="td7"><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td class="td8"><input id="txtTotal" type="text" class="txt num c1"/></td>
					</tr>
					<tr class="tr10">
						<td class="td1"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtWorker" type="text" class="txt c1" /></td>
						<td class="td4"><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td class="td6" colspan='2'><input id="txtWorker2" type="text" class="txt c1" /></td>
						<td colspan="2">
							<input id="chkIsproj" type="checkbox"/>
							<span> </span><a id='lblIsproj'> </a>
							<input id="chkEnda" type="checkbox"/>
							<span> </span><a id='lblEnda'> </a>
							<input id="chkCancel" type="checkbox"/>
							<span> </span><a id='lblCancel'> </a>
						</td>
					</tr>
					<tr class="tr11">
						<td class="td1"><span> </span><a id='lblMemo' class='lbl'> </a></td>
						<td class="td2" colspan='5'>
							<textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
						</td>
						<td><input id="btnApv" type="button" style="width:70%;float:right;" value="核准"/></td>
                        <td><input id="txtApv" type="text" class="txt c1" disabled="disabled"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1880px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:45px;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:200px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:250px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:95px;" class="isStyle"><a id='lblStyle'> </a></td>
					<td align="center" style="width:55px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:80px;" class="islengthc"><a>箱數</a></td>
					<td align="center" style="width:85px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:85px;"><a id='lblWeights'> </a></td>
					<td align="center" style="width:85px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:115px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblscut_st'> </a></td>
					<td align="center" style="width:85px;"><a id='lblGemounts'> </a></td>
					<td align="center" style="width:175px;"><a id='lblMemos'> </a></td>
					<td align="center" style="width:85px;"><a id='lblDateas'> </a></td>
					<td align="center" style="width:40px;"><a id='lblEndas'> </a></td>
					<td align="center" style="width:40px;"><a id='lblCancels'> </a></td>
					<td align="center" style="width:40px;"><a id='lblBorn'> </a></td>
					<td align="center" style="width:40px;"><a id='lblNeed'> </a></td>
					<td align="center" style="width:40px;"><a id='lblVccrecord'> </a></td>
					<td align="center" style="width:40px;"><a id='lblOrdemount'> </a></td>
					<td align="center" style="width:40px;"><a id='lblScheduled'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUno'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center">
						<input class="txt c6" id="txtProductno.*" maxlength='30'type="text" style="width:98%;" />
						<input class="btn" id="btnProduct.*" type="button" value='...' style=" font-weight: bold;" />
						<input class="txt c6" id="txtNo2.*" type="text" />
					</td>
					<td>
						<input class="txt c7" id="txtProduct.*" type="text" />
						<input id="txtSpec.*" type="text" class="txt c1 isSpec"/>
						<input class="btn" id="btnS1.*" type="button" value='∮' style="font-size: 10px;" />
					</td>
					<td class="isStyle"><input id="txtStyle.*" type="text" class="txt c1 isStyle"/></td>
					<td align="center"><input class="txt c7" id="txtUnit.*" type="text"/></td>
					<td class="islengthc"><input id="txtLengthc.*" type="text" class="txt num c7"/></td>
					<td><input class="txt num c7" id="txtMount.*" type="text" /></td>
					<td><input class="txt num c7" id="txtWeight.*" type="text" /></td>
					<td><input class="txt num c7" id="txtPrice.*" type="text" /></td>
					<td><input class="txt num c7" id="txtTotal.*" type="text" /></td>
					<td align="center"><input id="chkCut.*" type="checkbox"/></td>
					<td>
						<input class="txt num c1" id="txtC1.*" type="text" />
						<input class="txt num c1" id="txtNotv.*" type="text" />
					</td>
					<td>
						<input class="txt c7" id="txtMemo.*" type="text" />
						<input class="txt" id="txtQuatno.*" type="text" style="width: 70%;" />
						<input class="txt" id="txtNo3.*" type="text" style="width: 20%;"/>
						<input id="recno.*" type="hidden" />
					</td>
					<td><input class="txt c7" id="txtDatea.*" type="text" /></td>
					<td align="center"><input id="chkEnda.*" type="checkbox"/></td>
					<td align="center"><input id="chkCancel.*" type="checkbox"/></td>
					<td align="center"><input class="btn" id="btnBorn.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnNeed.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnVccrecord.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnOrdemount.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnScheduled.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td><input id="txtUno.*" type="text" class="txt c7"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>