<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
            aPop = new Array(['txtXpart', '', 'part', 'noa,part', 'txtXpart', "part_b.aspx"]);
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }
            t_isinit = false;
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_umm_yc');

                $('#q_report').click(function(e) {

                });
            });

            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_umm_yc',
                    options : [{
                        type : '0', //[1]
                        name : 'xaccy',
                        value : r_accy
                    }, {
                        type : '0', //[2]
                        name : 'vcctax',
                        value : q_getPara('sys.d4taxtype')
                    }, {
                        type : '0', //[3]
                        name : 'xacomp',
                        value : q_getPara('sys.comp')
                    }, {
                        type : '0', //[4]
                        name : 'xproject',
                        value : q_getPara('sys.project').toUpperCase()
                    },{
						type : '0',//[5]
						name : 'mountprecision',
						value : q_getPara('vcc.mountPrecision')
					},{
						type : '0',//[6]
						name : 'weightprecision',
						value : q_getPara('vcc.weightPrecision')
					},{
						type : '0',//[7]
						name : 'priceprecision',
						value : q_getPara('vcc.pricePrecision')
					}, {
                        type : '6', //[8] //1
                        name : 'xcno'
                    }, {
                        type : '1', //[9][10] //2
                        name : 'xdate'
                    }, {
                        type : '1', //[11][12] //3
                        name : 'xmon'
                    }, {
                        type : '2', //[13][14] //4
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {
                        type : '2', //[15][16] //5
                        name : 'xsales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }, {
                        type : '2', //[17][18] //6
                        name : 'xproduct',
                        dbf : 'ucaucc',
                        index : 'noa,product',
                        src : 'ucaucc_b.aspx'
                    }]
                });
                
                q_popAssign();
                 q_getFormat();
                q_langShow();
                $('#txtXdate1').mask('999/99/99');
                $('#txtXdate2').mask('999/99/99');
                $('#txtXmon1').mask('999/99');
                $('#txtXmon2').mask('999/99');
                
                var t_date, t_year, t_month, t_day;
                t_date = new Date();
                t_date.setDate(1);
                t_year = t_date.getUTCFullYear() - 1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXdate1').val(t_year + '/' + t_month + '/' + t_day);
                $('#txtXmon1').val(t_year + '/' + t_month);
                $('#txtXmon2').val(t_year + '/' + t_month);

                t_date = new Date();
                t_date.setDate(35);
                t_date.setDate(0);
                t_year = t_date.getUTCFullYear() - 1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtXdate2').val(t_year + '/' + t_month + '/' + t_day);
                
            }

            function q_boxClose(s2) {
            }

            function q_gtPost(t_name) {
            }

		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>