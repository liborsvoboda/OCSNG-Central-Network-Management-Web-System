<?php
//====================================================================================
// OCS INVENTORY REPORTS
// Web: http://www.ocsinventory-ng.org
//
// This code is open source and may be copied and modified as long as the source
// code is always made freely available.
// Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
//====================================================================================
 
 
        print_item_header("Network Printers");
        $form_name="Network_Printers";
        $table_name=$form_name;
        echo "<form name='".$form_name."' id='".$form_name."' method='POST' action=''>";
        $list_fields=array('Username' => 'Username',
                           'Share Name' => 'ShareName',
                           'Share Path' => 'SharePath',
                           'Default Printer' => 'DefaultPrinter',
                           'Share Type' => 'ShareType',
                           'Share Descr' => 'ShareDesc',
                           'Share Comment' => 'ShareComment');
        $list_col_cant_del=$list_fields;
        $default_fields= $list_fields;
        $queryDetails  = "SELECT * FROM Network_Printers WHERE (hardware_id = $systemid)";
        $tab_options['FILTRE']=array_flip($list_fields);
        tab_req($table_name,$list_fields,$default_fields,$list_col_cant_del,$queryDetails,$form_name,80,$tab_options);
        echo "</form>";
?>