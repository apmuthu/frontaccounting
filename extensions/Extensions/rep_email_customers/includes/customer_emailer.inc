<?php
global $path_to_root;
include_once($path_to_root . "/reporting/includes/pdf_report.inc");

class CustomerEmailer {
	private $customer;
	private $area;
	private $salesman;
	private $pricelist;
	private $email;
	private $email_body;
	private $orientation;


	function __construct($use_global=true) {
		$customer = $_POST['PARAM_0'];
		$subject = $_POST['PARAM_1'];
		$email_body = $_POST['PARAM_2'];
		$email = $_POST['PARAM_3'];
		$area = $_POST['PARAM_4'];
		$use_area = $_POST['PARAM_5'];
		$pricelist = $_POST['PARAM_6'];
		$use_pricelist = $_POST['PARAM_7'];
		$salesman = $_POST['PARAM_8'];

		$fno = explode("-", $from);
		$tno = explode("-", $to);
        
        $this->customer = $customer;
        $this->subject = $subject;
		$this->email = $email;
		$this->email_body = $email_body;
        foreach(array('area', 'pricelist') as $var) {
            $use_var = "use_".$var;
            if($$use_var) {
                $this->$var = $$var;
                }
            }
        $this->salesman = $salesman;
	}

    protected function branches () {
        $sql = "SELECT DISTINCT dm.debtor_no,
                    dm.name  ,
                    cb.branch_code
                FROM ".TB_PREF."debtors_master dm
                JOIN ".TB_PREF."cust_branch  cb
                    ON (dm.debtor_no = cb.debtor_no)
                WHERE dm.inactive = 0
                      AND cb.inactive = 0
                ";

        if($this->customer) 
            $sql .= " AND dm.debtor_no = " . db_escape($this->customer);

        if($this->area)
            $sql .= " AND cb.area = " . db_escape($this->area);

        if($this->pricelist)
            $sql .= " AND dm.sales_type = ". db_escape($this->pricelist);

        if($this->salesman > 0)
            $sql .= " AND cb.salesman = ". db_escape($this->salesman);

        $sql .= " ORDER BY dm.name";
        $query = db_query($sql);
        $customers = array();

        while($row = db_fetch($query)) {
            $customers[$row[0]] = $row;
            }

        return $customers;
    }

    public function printReports() {
        $rep = null;
        foreach($this->branches() as $branchInfo) {
            $contacts = get_branch_contacts($branchInfo['branch_code'],null,  $branchInfo['debtor_no'], false);
            if($this->email == 1) {
                $this->sendEmail($branchInfo, $contacts);
            }
            else {
                if(!$rep) {
                    $rep = new FrontReport(_('Announcement')
                        , "announcement"
                        , user_pagesize()
                        , 9
                        , 'P');
                    $rep->Info();
                    $rep->filename = "email_preview.pdf";
                }
                $this->previewEmail($rep, $branchInfo, $contacts);
            }


        }
        if($rep) $rep->End();
    }



    protected function previewEmail($rep, $branchInfo, $contacts) {
        $name = $branchInfo['name'];
        // $rep->NewPage();
        $rep->TextWrapLines(8, 800, $name);
        $done =  array();
        foreach($contacts as $contact) {
                $email = $contact['email'];
                if(!$email) continue;
                $contact_name = $contact['name'];
                $key = $contact_name ." : ". $email ." [" .$contact['action']."]";
                if(!array_key_exists($key, $done)) {
                    $rep->NewLine();
                    $rep->TextWrapLInes(25,700, $key);
                    $done[$key]=1;
                }
        }
        $rep->NewLine();
    }

    protected function sendEmail($branchInfo, $contacts) {
        $rep = new FrontReport("", "", user_pagesize(), 9, 'P');
        //$rep->company = get_company_prefs();
        $rep->Info();
        $rep->SetCommonData(null, null, null, null, null, $contacts);
        $rep->no_attachment = true;
        $rep->email_body = "Hi [contact]\n\n"
            .  $this->generateEmailBody()
            . "\n\n\n"
            ;
            
        $rep->End(1, $this->subject);
    }

    protected function generateEmailBody($branchInfo) {
        return $this->email_body;
    }



};
