function init_page(first_load)
{
    $("#Errors").hide();
    var table_id = "test_results";
    var result;
    
    var projects = get_projects();
    var test_case_types = get_testcase_types();
    var test_datas = {
                      'projects'      : projects[ 'get_projects' ], 
                      'testcasetypes' : test_case_types[ 'get_testcasetypes' ],
    };
    //SCREENSHOTS = get_screenshots_by_version();
    set_rows_in_table_by_projectname( projects[ 'get_projects' ] , table_id );  
    set_columns_in_table_by_testcaseypename( test_case_types[ 'get_testcasetypes' ], table_id );    
    
    set_testinfos_in_result_table(test_datas, first_load);
    $( "#progressbar" ).hide();
    
}

function progress_bar(){
	$( function() {
	    $( "#progressbar" ).progressbar({
	      value: 50
	    });
	  } );
	$( function() {
	    $( "#progressbar2" ).progressbar({
	      value: 50
	    });
	  } );
}

function create_dialog()
{
    $(document).ready(function() {
        $("#testcases").dialog({
            width: 650,
            height: 900,
            autoOpen: false,
            position: [0, 100],
        }).dialog("open");
    });
}

function get_projects()
{
    var ret_val = new Object();
    
    ret_val['get_projects'] = 1; 
    
    push_cmd("get_projects", JSON.stringify({
        'get': '1'  
    }));

    processor( send_cmd( ), ret_val );
    
    return ret_val;
}

function get_testcase_types()
{
    var ret_val = new Object();
    
    ret_val['get_testcasetypes'] = 1; 
    
    push_cmd("get_testcasetypes", JSON.stringify({
        'get': '1'  
    }));

    processor( send_cmd( ), ret_val );
    
    return ret_val;
}

function get_test_all()
{
    var ret_val = new Object();
    
    ret_val['get_tests_all'] = 1; 
    
    push_cmd("get_tests_all", JSON.stringify({
        'get': '1'  
    }));

    processor( send_cmd(), ret_val );
    
    return ret_val;
}

function create_h6(p_data)
{
    var p = document.createElement("h6");create_dialog
    
    p.id = p_data["id"];
    p.setAttribute("class", p_data["class"]);
    p.innerHTML = p_data['text'];
    
    return p;
}

function set_rows_in_table_by_projectname( projects, table_id )
{
    var table = document.getElementById(table_id);
    var row;
    var actual_cell;
    var project_name; 
    
    for (var idx in projects ) 
    {
        project_name = projects[ idx ][ 'ProjectName' ];
        insert_row_to_table( table_id,  project_name );
    } 
    
    row = table.insertRow( table );
    row.id = "row_0";
}

function set_columns_in_table_by_testcaseypename( testcasetype, table_id )
{
    /* Set column 0, empty cell*/
    insert_cell("row_0", "-1", "");
    
    for (var idx in testcasetype ) 
    {
        /* Set column 0 with testcasetype names*/
        insert_cell("row_0", "-1", testcasetype[ idx ][ 'TestCaseTypeName' ] );
    } 
}

function insert_row_to_table( table_id, project_name )
{
    var table = document.getElementById(table_id);
    var row;
    
    if (table == null) {
        return false;
    }
    
    row = table.insertRow( "row_0" );   
    row.id   = project_name;
    $( "#" + project_name ).text( project_name );
        
}

function get_all_testcases_by_type( cell_infos )
{
    var ret_val = new Object();
    
    ret_val['all_testcases_by_testcasetypeid'] = 1; 
    
    push_cmd("all_testcases_by_testcasetypeid", JSON.stringify({
        'function': 'all_testcases',
        'params'  : {
            'testcasetype_id' : cell_infos[ 'test_case_type' ],
        },   
    }));
    
    processor( send_cmd(), ret_val );
    
    return ret_val['all_testcases_by_testcasetypeid']['count( * )'];
}

function get_test_infos(cell_infos)
{
	var ret_val = new Object();
    
    ret_val['get_datas_by_act_cell'] = 1; 
    
    push_cmd("get_datas_by_act_cell", JSON.stringify({
        'cell_infos': cell_infos,
    }));
    
    processor( send_cmd(), ret_val );
    
    return ret_val['get_datas_by_act_cell'];
}


function set_testinfos_in_result_table(test_datas, first_load)
{   
    var cell_infos   = new Object();
    var all_runnings = new Array() ;
    var all_test_cases_by_type_cnt ;
    var test_infos;
    var datas_object = new Array();
    
    for( var idx in test_datas[ 'projects' ] )
    {
        for( var i in test_datas[ 'testcasetypes' ] )
        {
        	if( test_datas[ 'projects' ][ idx ][ 'ProjectName' ] == "Omni" && test_datas[ 'testcasetypes' ][ i ][ 'TestCaseTypeName' ] == "System_Test" ){
                if( i == 0 )
                 {
                     cell_infos[ 'project' ]     = test_datas[ 'projects' ][ idx ][ 'ProjectID' ] ;
                     cell_infos[ 'projectname' ] = test_datas[ 'projects' ][ idx ][ 'ProjectName' ];
                 }
             
                 cell_infos[ 'test_case_type' ]      = test_datas[ 'testcasetypes' ][ i ][ 'TestCaseTypeID' ];
                 cell_infos[ 'test_case_type_name' ] = test_datas[ 'testcasetypes' ][ i ][ 'TestCaseTypeName' ];
                 
                 
                 if( ( i == 0 && idx == 0 && first_load ) ){
                     test_infos = get_test_infos( cell_infos );
                	 fill_html_with_datas( test_infos, cell_infos, i, first_load );
                	 all_test_cases_by_type_cnt = count_all_testcases( test_infos, cell_infos, idx );
                 }else{
                	fill_html_with_datas( {
                		"all runnings": "loading",
                	    "all testcases": "loading",
                	    "latest gui version": "loading",
                	    "latest sys version": "loading",
                	    "passed testcases": "loading",
                	}, cell_infos, i, first_load );
                
                	all_test_cases_by_type_cnt = count_all_testcases( {
                		"all runnings": "loading",
                	    "all testcases": "loading",
                	    "latest gui version": "loading",
                	    "latest sys version": "loading",
                	    "passed testcases": "loading",
                	}, cell_infos, idx );
                 }
                 
                 if( idx == 0 )
                 {
                     all_runnings.push(all_test_cases_by_type_cnt);
                 }       		
             		
             		
             }
        	

        }
    }
    get_last_row_element(all_runnings);
}

function count_all_testcases( test_infos,cell_infos )
{
    var all_test_cases_by_type_cnt = new Object();
    var arr                        = new Array();

    all_test_cases_by_type_cnt  =
    {
        'cnt'  : test_infos[ 'all runnings' ], 
        'type' : cell_infos[ 'test_case_type_name' ]  , 
    };  

    return all_test_cases_by_type_cnt;
}

function fill_html_with_datas( infos, cell_infos, i, first_load)
{   
    var actual_cell, cell_text, passed_fail_ratio, div, div_id, percentage;
    
    if( ( infos[ 'all testcases' ] == 0 ) || ( infos[ 'all testcases' ] == undefined ) )
    {
        cell_text = "no testcases yet";
    }else{
        passed_fail_ratio = infos[ 'passed testcases' ]/infos[ 'all testcases' ];
        percentage = round_it( infos[ 'passed testcases' ], infos[ 'all testcases' ] );
        
        cell_text = "System version: " + infos[ 'latest sys version' ] + "<br />" + "GUI version: " + infos[ 'latest gui version' ] + "<br />" + "<br />" + "all testcases : " + infos[ 'all testcases' ] + "<br />" + "passed testcases : " + infos[ 'passed testcases' ] + "<br />" + "Passed/Failed : " + percentage.toFixed(2) + "%";            
        //cell_text = "System version: " + infos[ 'latest sys version' ] + "<br />" + "GUI version: " + infos[ 'latest gui version' ] + "<br />" + "<br />" + "all testcases : " + "357" + "<br />" + "passed testcases : " + "357" + "<br />" + "Passed/Failed : " + "100" + "%";            

    }

    actual_cell = insert_cell( cell_infos['projectname'], i, "", cell_infos[ 'test_case_type_name' ] );

    /* Set CSS for div inside the actual cell element. Color depends on the passed/failed ratio*/           
    if( passed_fail_ratio != undefined )
    {
        //cell_class      = get_class_for_cell_from_pass_fail_ratio( passed_fail_ratio );   
        cell_class      = get_class_for_cell_from_pass_fail_ratio( passed_fail_ratio ); 
        //cell_class = 'perfect';
        
        div_id          = "div_" + i;
        div             = create_div( div_id, cell_class, cell_text );
        
        if( cell_class == 'perfect' )
        {
            set_perfect_pic( div );     
        }
        div.onclick = show_dialog;
        //div.onmouseout  = close_dialog;           
        
        actual_cell.appendChild(div);   
        cell_infos[ 'cell_id' ] = div_id;
        
        if(first_load){
            /* get testcases by ProjectID and VersionID for actual cell, dialog*/
            TESTCASES_BY_CELL_ID[ div_id ] = get_testcases_by_projectID_testcasetypeID(cell_infos);
            if( TESTCASES_BY_CELL_ID[ div_id ] != null ){
                TESTCASES_BY_CELL_ID[ div_id ][ 'ProjectName' ]      = cell_infos['projectname'];
                TESTCASES_BY_CELL_ID[ div_id ][ 'TestCaseTypeName' ] = cell_infos[ 'test_case_type_name' ];
            }        	
        }
    }
    
    
    return cell_infos;
}

function set_perfect_pic( div )
{
    var img = create_img(div);
    img.src = "http://172.30.108.105/testresults/js/img/well_done.png";
    img.height = '200';
    img.width  = '200';
    div.appendChild(img);
}

function create_img(img_id)
{
    var img  = document.createElement("img");
    img.id   = "perfect" + img_id.id;

    return img;
}

function get_screenshots_by_version()
{
    var ret_val = new Object();
    
    ret_val['get_screenshots_by_version'] = 1; 
    
    push_cmd("get_screenshots_by_version", JSON.stringify({
        'get': 1,
    }));
    
    processor( send_cmd(), ret_val );
    
    return ret_val['get_screenshots_by_version'];
}

function get_testcases_by_projectID_testcasetypeID(cell_infos)
{
    var ret_val = new Object();
    
    ret_val['get_testcases_by_projectID_testcasetypeID'] = 1; 
    
    push_cmd("get_testcases_by_projectID_testcasetypeID", JSON.stringify({
        'cell_infos': cell_infos,
    }));
    
    processor( send_cmd(), ret_val );
    
    return ret_val['get_testcases_by_projectID_testcasetypeID'];
}

function get_last_row_element(arr)
{
    var table = document.getElementById("test_results"); 
    var cells = table.getElementsByTagName("tr"); 
    var cnt;
    
    for (var i = 0; i < cells.length; i++) { 
        
        if( i == (cells.length-1) )
        {
            var status = cells[i]; 
        }
    }
    
    for( var idx in status.childNodes )
    {
        if( status.childNodes[ idx ].id   )
        {
            cnt = get_all_testcases_cnt( status.childNodes[ idx ].id, arr );    
            set_li_to_cell(status.childNodes[ idx ], cnt);
        }
    }
}

function get_all_testcases_cnt( id, arr )
{
    for( var item in arr)
    {
        if( arr[ item ]['type'] == id )
        {
            return arr[ item ]['cnt'];
        }
    }
}

function set_li_to_cell(act_cell, cnt)
{
    var li;
    var txt = "All runnings:\n " + cnt;
    li = create_li(act_cell.id);

    act_cell.appendChild(li);
    $( "#" + li.id ).text( txt );
}

function get_class_for_cell_from_pass_fail_ratio( percent )
{
    /* under 50 % is red the cell*/
    if( percent < 0.50 )
    {
        return 'red';
    }
    /* between 50 - 75 % is yellow the cell*/
    else if( (percent >= 0.50) && (percent < 0.76) )
    {
        return 'yellow';
    }
    /* between 75 - 100 % is dark green the cell*/
    else if( (percent >= 0.75) && (percent < 1.00) )
    {
        return 'green';
    }   
    /* by perfect ratio is green the cell*/
    else if( percent == 1.00 )
    {
        return 'perfect';
    }
}

function insert_cell(row_id, column, text, cell_id )
{
    var row     = document.getElementById(row_id);
    var x       = row.insertCell(column);
    x.innerHTML = text;    
    x.id        = cell_id;  
    
    return x;
}

function create_div(div_id, classs, text )
{
    var div         = document.createElement("div");
    div.id          = div_id;
    div.innerHTML   = text  ;
    div.setAttribute("class", classs );

    return div;
}

function show_dialog()
{
    create_dialog();
    set_dialog_title( this.id );
    fill_testcases_list( TESTCASES_BY_CELL_ID[ this.id ] );
    $("progressbar2").hide();
}

function set_dialog_title(cell_id)
{
    var dialog_title;
    
    for( var item in TESTCASES_BY_CELL_ID )
    {
        if( item == cell_id )
        {
            dialog_title = TESTCASES_BY_CELL_ID[ item ][ 'ProjectName' ] + ": " + TESTCASES_BY_CELL_ID[ item ][ 'TestCaseTypeName' ] ;
        }
    }
    $('#testcases').dialog('option', 'title', dialog_title);
}

/* at this moment not used*/
function close_dialog()
{
    //$('#testcases').dialog("close");
}

function create_li(id) 
{
    var li   = document.createElement("li");
    li.id    = "counter_" + id;
    
    return li;
}

function create_select_list(name, id, list, func) {
    var arr = [];
	var sel, tc_name, link;
    var i = 0;
    sel = document.getElementById(id);
    if (sel == null) {
        sel = document.createElement('select');
        sel.name = name;
        sel.id = id;
    } else {
        document.getElementById(id).innerHTML = "";
    }

    sel.addEventListener('click', function(){
    	arr = document.getElementById("testcases_list").value.split(":");;
    	tc_name = arr[0];
    	//create_screenshot_div( search_in_array(SCREENSHOTS,tc_name), tc_name );
    });
    
    for (var idx = 0; idx < list.length; idx++) {
       sel.options[i] = new Option( list[idx]['TestCaseName'] + ": " + list[idx]['ResultName'] );
       sel.options[i].value = list[idx]['TestCaseName'] + ": " + list[idx]['ResultName'];       
       
       if( list[idx]['ResultName'] === 'Failed' ){
    	   sel.options[i].style.color = 'red';
       }
       i++;
    }
    sel.multiple = "multiple";
    return sel;
}

function create_screenshot_div(list, screenshot_name){
	var index = 0;
	var div;
	
    $(document).ready(function() {
    	$("#screenshots").dialog({
            width: 500,
            height: 600,
            maxWidth: 600,
            maxHeight: 700,
            autoOpen: false,
        }).dialog("open");
    	$('#screenshots').dialog('option', 'title', screenshot_name);
    });
    
    div = create_div( 'a', '', '' );
    document.getElementById("screenshots").innerHTML = "";
    document.getElementById('screenshots').appendChild(div);
    
    for(index in list){
    	div.appendChild(create_links(list[index]));
    	div.appendChild(document.createElement("br"));
    }
}

function create_links(scr_shot){
	var div = document.createElement( 'div' );
	div.appendChild( create_link({"link" : scr_shot['diff_link'], "text" : scr_shot['src_name'], "res" : scr_shot['result'] }) );
	div.appendChild( create_link({"link" : scr_shot['ref_link'], "text" : "reference" }) );
	div.appendChild( create_link({"link" : scr_shot['act_link'], "text" : "actual" }) );
	div.style.border = '1px solid black';  
	div.style.borderWidth = "auto";
	
	return div;
}

function create_link(data){
	var link = document.createElement( 'a' );
	
	link.setAttribute( 'href', data['link'] );
	link.setAttribute( 'target', '_blank' );	
	link.innerHTML = data['text'];
	link.style.marginRight = "5px";
	link.style.textDecoration = "none";
	
	if(data["res"] !== "undefined" && data["res"] === "Failed"){
		link.style.color = "red";
	}else if(data["res"] !== "undefined" && data["res"] === "Passed"){
		link.style.color = "green";
	}else{
		link.style.color = "blue";
	}
	
	return link;
}

function create_ref_img_link(link){
	var a = document.createElement( 'a' );
	a.setAttribute( 'href', link );
	a.setAttribute( 'target', '_blank' );	
	a.innerHTML = "reference";
	
	return a;
}

function search_in_array(array,id){
	   var idx = 0;
		var screenshots_by_tc = [];
		var element = {};
		for( idx in array ){
			if( array[idx]['TestCaseName'] == id ){
				element = {
					"src_name"  : array[idx]['ScreenName'],
					"result"    : array[idx]['ResultName'],
					"diff_link" : get_diff_link(array[idx]['FeatureID'], array[idx]['Path']),
					"ref_link"  : get_ref_link(array[idx]['FeatureID'], array[idx]['Path']),
					"act_link"  : get_act_link(array[idx]['FeatureID'], array[idx]['Path'])
 				};
				screenshots_by_tc.push(element);
			}
		}
		return screenshots_by_tc;    	
}

function get_act_link(fea_id, path){
	return "http://172.30.108.105/system_testeditor/omni/feature_" + fea_id + "/actual_images/" + path.replace( /(^.+)(\w\d+\w)(.+$)/i,'$2') + ".png";
}

function get_ref_link(fea_id, path){
	return "http://172.30.108.105/system_testeditor/omni/feature_" + fea_id + "/refimages/" + path.replace( /(^.+)(\w\d+\w)(.+$)/i,'$2') + ".png";
}

function get_diff_link(fea_id, path){
	return "http://172.30.108.105/system_testeditor/differences.html?act_img=" + "/home/deveushu/OmniBB/TESTS/SYSTEM_TEST/feature_" + fea_id + "/actual_images/" + path.replace( /(^.+)(\w\d+\w)(.+$)/i,'$2') + ".png&ref_img=" + "/home/deveushu/OmniBB/TESTS/SYSTEM_TEST/feature_" + fea_id + "/refimages/" + path.replace( /(^.+)(\w\d+\w)(.+$)/i,'$2') + ".png&feature=" + fea_id;
}

function fill_testcases_list( testcases ) {
    
    var testcases_list = create_select_list('testcases', 'testcases_list', testcases, null);
    
    document.getElementById("testcases").innerHTML = "";
    document.getElementById("testcases").appendChild(testcases_list);
}