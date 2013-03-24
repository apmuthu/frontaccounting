<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
/*
	This file contains templates for all country specific functions.
	If your locale needs special functionality provided by hook functions
	copy this file to respective lang/xx_XX directory and edit templates below.
	You can safely remove not used function templates.
	
	Name it after language code e.g. hooks_en_US
*/

function numar($s, $z) {
    switch($z) {
	case 1:
    	    switch($s) {
        	case 1: $numar = "o "; break;
                case 2: $numar = "doua "; break;
                case 3: $numar = "trei "; break;
                case 4: $numar = "patru "; break;
                case 5: $numar = "cinci "; break;
                case 6: $numar = "sase "; break;
                case 7: $numar = "sapte "; break;
                case 8: $numar = "opt "; break;
                case 9: $numar = "noua ";
            }
            break;
        case 2:
            switch($s) {
                case 1: $numar = "zece"; break;
                case 2: $numar = "doua"; break;
                case 3: $numar = "trei"; break;
                case 4: $numar = "patru"; break;
                case 5: $numar = "cinci"; break;
                case 6: $numar = "sai"; break;
                case 7: $numar = "sapte"; break;
                case 8: $numar = "opt"; break;
                case 9: $numar = "noua";
            }
            break;
        case 3:
    	    switch($s) {
                case 1: $numar = "unu "; break;
                case 2: $numar = "doi "; break;
                case 3: $numar = "trei "; break;
                case 4: $numar = "patru "; break;
                case 5: $numar = "cinci "; break;
                case 6: $numar = "sase "; break;
                case 7: $numar = "sapte "; break;
                case 8: $numar = "opt "; break;
                case 9: $numar = "noua ";
            }
    	    break;
        case 4:
            switch($s) {
        	case 1: $numar = "un"; break;
                case 2: $numar = "doi"; break;
                case 3: $numar = "trei"; break;
                case 4: $numar = "pai"; break;
                case 5: $numar = "cinci"; break;
                case 6: $numar = "sai"; break;
                case 7: $numar = "sapte"; break;
                case 8: $numar = "opt"; break;
                case 9: $numar = "noua";
            }
            break;
    }
    return $numar;
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
function number_to_words($nr) {
    global $thoseps, $decseps;

    $tsep = $thoseps[$_SESSION["wa_current_user"]->prefs->tho_sep()];
    $dsep = $decseps[$_SESSION["wa_current_user"]->prefs->dec_sep()];

    $bnr=split($dsep, $nr);
    $cstr="";

    //process before dsep, aka $bnr[0]
    $i = 0;
    $nr=str_replace(array($tsep,"."), "", $bnr[$i]);
    $sute="";
    $zeci="";
    $uni="";
    $un = array("miliard ", "miliarde ", "milion ", "milioane ", "mie ", "mii ", "", "");
    $sir = "";
    $s = "1";
    $num = 4;
    while ($s != "") {
    	$s = substr($nr, -3);
        if ($s=="") break;
        $nr = (strlen($nr)-3>0)?substr($nr, 0, strlen($nr)-3):"";
        $ss = "";
        if ($s!="") {
    	    switch(strlen($s)) {
            	case 3:
            	    $sute = substr($s, 0, 1);
                    $zeci = substr($s, 1, 1);
                    $uni = substr($s, 2, 1);
                    $ss = numar($sute, 1) . (($sute==1)?"suta ":(($sute>1)?" sute ":""));
                    if ($zeci==1 && $uni!=0)
                        $ss=$ss.numar($uni, 4)."sprezece ".$un[$num*2];
                    else if ($zeci==1 && $uni==0)
                        $ss="zece ".$un[$num*2];
                    else {
                        $ss=$ss.numar($zeci, 2) . (($zeci!=0)?"zeci ":"") . (($uni!="0") ? "si ".numar($uni,3):"") . (($s!="000")?$un[$num*2-1]:"");
                    }
                    $sir = $ss . $sir;
                    break;
            	case 2:
            	    $sute = 0;
                    $zeci = substr($s, 0, 1);
                    $uni = substr($s, 1, 1);
                    if ($zeci == 1 && $uni != 0)
                        $ss = $ss . numar($uni, 4) . "sprezece " . $un[$num*2-1];
                    else if ($zeci == 1 && $uni == 0)
                        $ss = "zece " . $un[$num * 2];
                    else
                        $ss = $ss . numar($zeci, 2) . (($zeci!=0)?"zeci ":"") . (($uni!="0")?"si ".numar($uni,3):"") . $un[$num*2-1];
                    $sir = $ss . $sir;
                    break;
                case 1:
            	    $sute = 0;
                    $zeci = 0;
                    $uni = substr($s, 0, 1);
                    $sir = numar($uni, ($num==3)?1:3) . (($uni==1)?$un[($num-1)*2]:$un[($num-1)*2+1]) . $sir;
                    break;
            }
            $num--;
        }
    }

//    if ($i==0)
//           $cstr.=$sir." lei si ";
//        else if ($i==1)
//    	    $cstr.=$sir." bani";

    if ($bnr[1] == "") {
        $bnr[1] = "00";
    }

//    return "";
    return $sir . 'si ' . $bnr[1] . ' bani';
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
class hooks_ro_RO extends hooks {

	//
	// Price in words. $doc_type is set to document type and can be used to suppress 
	// price in words printing for selected document types.
	// Used instead of built in simple english price_in_words() function.
	//
	//	Returns: amount in words as string.
	
	function price_in_words($amount, $doc_type) {
		return number_to_words($amount);
	}

/*
	//
	// Exchange rate currency $curr as on date $date.
	// Keep in mind FA has internally implemented 3 exrate providers
	// If any of them supports your currency, you can simply use function below
	// with apprioprate provider set, otherwise implement your own.
	// Returns: $curr value in home currency units as a real number.
	
	function retrieve_ex_rate($curr, $date)
	{
	 	$provider = 'ECB'; // 'ECB', 'YAHOO' or 'GOOGLE'
		return get_extern_rate($curr, $provider, $date);
	}
*/
/*
	// Generic function called at the end of Tax Report (report 709)
	// Can be used e.g. for special database updates on every report printing
	// or to print special tax report footer 
	//
	// Returns: nothing
	function tax_report_done()
	{
	}
*/
}
?>