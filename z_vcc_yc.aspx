<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="/../script/jquery.min.js" type="text/javascript"></script>
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
			aPop = new Array(['txtYcustno', '', 'cust', 'noa,comp', 'txtYcustno', 'cust_b.aspx']);
            var acompItem = '';
            var uccgaItem = '';
            var partItem = '';
            var issale = '0';
            var job = '';
            var sgroup = '';
            var isinvosystem = '';

            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;100";
            }
            
            $(document).ready(function() {
                q_getId();
      			q_gt('acomp', '', 0, 0, 0, "");
      			
      			$('#q_report').click(function(e) {
					if(isinvosystem=='2'){//沒有發票系統
	                	$('#Xshowinvono').hide();
	                }
				});
            });
            
            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'acomp':
                        var as = _q_appendData("acomp", "", true);
                        acompItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            acompItem = acompItem + (acompItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].acomp;
                        }
                        q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");
                        break;
					case 'ucca_invo':
						var as = _q_appendData("ucca", "", true);
						if (as[0] != undefined) {
							isinvosystem = '1';
						} else {
							isinvosystem = '2';
						}
						q_gt('uccga', '', 0, 0, 0, "");
						break;
                    case 'uccga':
                        var as = _q_appendData("uccga", "", true);
                        uccgaItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            uccgaItem = uccgaItem + (uccgaItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].namea;
                        }
                        q_gt('part', '', 0, 0, 0, "");
                        break;
                     case 'part':
                        var as = _q_appendData("part", "", true);
                        partItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            partItem = partItem + (partItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].part;
                        }
                        q_gt('sss', "where=^^noa='" + r_userno + "'^^", 0, 0, 0, "");
                        break;  
                    case 'sss':
                        var as = _q_appendData("sss", "", true);
                        if (as[0] != undefined) {
                            issale = as[0].issales;
                            job = as[0].job;
                            sgroup = as[0].salesgroup;
                        }
                        q_gf('', 'z_vcc_yc');
                        break; 
                }
            }
            
            function q_gfPost() {
            	var ucctype=q_getPara('ucc.typea') + ',' + q_getPara('uca.typea');
	            var vccstype=q_getPara('vcc.stype');
	            
                $('#q_report').q_report({
                    fileName : 'z_vcc_yc',
                    options : [{
                        type : '0', //[1] 
                        name : 'accy',
                        value : q_getId()[4]
                    }, {
                        type : '0', //[2] //判斷vcc是內含或應稅
                        name : 'vcctax',
                        value : q_getPara('sys.d4taxtype')
                    }, {
                        type : '0', //[3] //判斷顯示小數點
                        name : 'acomp',
                        value : q_getPara('sys.comp')
                    }, {
                        type : '1', //[4][5]//1
                        name : 'date'
                    }, {
                        type : '1', //[6][7]//2
                        name : 'mon'
                    }, {
                        type : '2', //[8][9]//4
                        name : 'cust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {
                        type : '2', //[10][11]//8
                        name : 'sales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }, {
                        type : '2', //[12][13]//10
                        name : 'product',
                        dbf : 'ucaucc',
                        index : 'noa,product',
                        src : 'ucaucc_b.aspx'
                    },{
                        type : '2', //[14][15]//原廠//20
                        name : 'tggno',
                        dbf : 'tgg',
                        index : 'noa,comp',
                        src : 'tgg_b.aspx'
                    },{
                        type : '5',
                        name : 'xtype', //[16]//40
                        value : [q_getPara('report.all')].concat(ucctype.split(','))
                    },{
                        type : '5', //[17]//80
                        name : 'xgroupano',
                        value : uccgaItem.split(',')
                    }, {
                        type : '5',
                        name : 'xstype', //[18]//100
                        value : [q_getPara('report.all')].concat(vccstype.split(','))
                    }, {
                        type : '6', //[19]//200
                        name : 'salesgroup'
                    }, {
                        type : '5',
                        name : 'vcctypea', //[20]//400
                        value : [q_getPara('report.all')].concat(q_getPara('vcc.typea').split(','))
                    },{
                        type : '5', //[21]//800
                        name : 'xpartno',
                        value : partItem.split(',')
                    },{
                        type : '8', //[22]//顯示發票號碼//1000
                        name : 'xshowinvono',
                        value : "1@顯示發票資料".split(',')
                    },{
						type : '0',//[23]
						name : 'mountprecision',
						value : q_getPara('vcc.mountPrecision')
					},{
						type : '0',//[24]
						name : 'weightprecision',
						value : q_getPara('vcc.weightPrecision')
					},{
						type : '0',//[25]
						name : 'priceprecision',
						value : q_getPara('vcc.pricePrecision')
					}, {//以下為客戶請款單參數
                        type : '1', //[26][27]//2000
                        name : 'vmon'
                    }, {
                        type : '1', //[28][29]//4000
                        name : 'vdate'
                    }, {
                        type : '1', //[30][31]//8000
                        name : 'udate'
                    }, {
                        type : '6', //[32]//10000
                        name : 'odate'
                    }, {
                        type : '6', //[33]//20000
                        name : 'ctitle'
                    },{
						type : '0',//[34]
						name : 'worker',
						value : r_name
					},{
                        type : '5', //[35]//40000
                        name : 'xcno',
                        value : acompItem.split(',')
                    },{
						type : '0',//[36]
						name : 'xproject',
						value : q_getPara('sys.project').toUpperCase()
					}, {
						type : '6', //[37]//80000
						name : 'xyear'
					},{
                        type : '8', //[38]//顯示箱數 //100000
                        name : 'xshowlengthc',
                        value : "1@顯示箱數".split(',')
                    }, {
                        type : '6', //[39]//200000
                        name : 'ycustno'
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();

                $('#txtDate1').mask('999/99/99');
                $('#txtDate1').datepicker();
                $('#txtDate2').mask('999/99/99');
                $('#txtDate2').datepicker();
                $('#txtXyear').mask('999');
				
				$('#txtXyear').val(r_accy.substring(0,3));
                var t_date, t_year, t_month, t_day;
                t_date = new Date();
                t_date.setDate(1);
                t_year = t_date.getUTCFullYear() - 1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtDate1').val(t_year + '/' + t_month + '/' + t_day);

                t_date = new Date();
                t_date.setDate(35);
                t_date.setDate(0);
                t_year = t_date.getUTCFullYear() - 1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                
                $('#txtDate2').val(t_year + '/' + t_month + '/' + t_day);
                $('#txtMon1').val(r_accy + '/01').mask('999/99');
                $('#txtMon2').val(r_accy + '/12').mask('999/99');
                $('#txtXbmon1').val(r_accy + '/01').mask('999/99');
                $('#txtXbmon2').val(r_accy + '/12').mask('999/99');
                $('#txtXemon1').val(r_accy + '/01').mask('999/99');
                $('#txtXemon2').val(r_accy + '/12').mask('999/99');
                $('#Xmemo').removeClass('a2').addClass('a1');
                $('#txtXmemo').css('width', '85%');
                $('#Xgroupano select').css('width', '150px');
                $('.q_report .report').css('width', '420px');
                $('.q_report .report div').css('width', '200px');
                
                $('#Xshowinvono').css('width', '300px').css('height', '30px');
                $('#Xshowinvono .label').css('width','0px');
                $('#chkXshowinvono').css('width', '220px').css('margin-top', '5px');
                $('#chkXshowinvono span').css('width','180px')
                
                $('#txtVmon1').mask('999/99');
                $('#txtVmon2').mask('999/99');
                $('#txtVmon1').val(q_date().substr(0,6));
                $('#txtVmon2').val(q_date().substr(0,6));
                $('#txtVdate1').mask('999/99/99');
                $('#txtVdate1').datepicker();
                $('#txtVdate2').mask('999/99/99');
                $('#txtVdate2').datepicker();              
                $('#txtUdate1').mask('999/99/99');
                $('#txtUdate1').datepicker();
                $('#txtUdate2').mask('999/99/99');
                $('#txtUdate2').datepicker();
                $('#txtOdate').mask('999/99/99');
                $('#txtOdate').datepicker();
                
                if(isinvosystem=='2'){//沒有發票系統
	                $('#Xshowinvono').hide();
				}
				
				$('#btnUcf').click(function() {
					q_box('ucf.aspx' + "?;;;;" + r_accy, '', "450px", "200px", $('#btnUcf').val());
				});
            }

            function q_boxClose(s2) {
            }
            
			//交換div位置
			var exchange = function(a,b){
				try{
					var tmpTop = a.offset().top;
					var tmpLeft = a.offset().left;
					a.offset({top:b.offset().top,left:b.offset().left});
					b.offset({top:tmpTop,left:tmpLeft});
				}catch(e){
				}
			};
			
            
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
				<input type="button" id="btnUcf" value="成本結轉" style="font-weight: bold;font-size: medium;color: red;">
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>