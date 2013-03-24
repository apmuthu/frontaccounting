<?php
include_once($path_to_root . "/modules/textcart/includes/utilities.inc");
define ('INSERT_MODE', 1);
define ('UPDATE_MODE', 2);
define ('DELETE_MODE', 3);
define ('PARAM_REG', '+|[@#]|\(.*\)');
define('NORMAL_LINE', 0);
define('RAW_LINE', 1);
define('TEMPLATE_LINE', 2);

class TextCartManager {
  var $mode_map = array (
    '+' => INSERT_MODE
   ,'=' => UPDATE_MODE
    ,'-' => DELETE_MODE
    ,'' => 0
  );

  // should be a constant but array are not allowed
  var $line_mode_map = array (
    '!' => RAW_LINE
    ,':' => TEMPLATE_LINE
    ,'' => NORMAL_LINE
  );

  var $cart_mode = null;

  function handle_post_request() {
    // Process textcart if needed
    // we need the cart to be already loaded so we can modify it before displaying it
    if (isset($_POST['ReplaceTextCart'])) {
      $_POST['_tabs_sel'] = 'classic_cart'; // Don't display the textcart
      $this->handle_textcart(true, INSERT_MODE );
    }
    if (isset($_POST['ModifyTextCart'])) {
      $_POST['_tabs_sel'] = 'classic_cart'; // Don't display the textcart
      $this->cart_mode = 'classic_cart'; // Don't display the textcart
      $this->handle_textcart(false, INSERT_MODE);
    }

    if (isset($_POST['UpdateTextCart'])) {
      $_POST['_tabs_sel'] = 'classic_cart'; // Don't display the textcart
      $this->cart_mode = 'classic_cart'; // Don't display the textcart
      $this->handle_textcart(false, UPDATE_MODE);
    }

    if (isset($_POST['CancelTextCart'])) {
      $_POST['_tabs_sel'] = 'classic_cart'; // Don't display the textcart
    }
  }

  function tab_display($title, $cart, $display_classic_cart) {
    tabbed_content_start('tabs', array(
      'classic_cart' => array(_('&Cart'), true),
      'textcart' => array(_('&Text'), true),
    ));
    switch(get_post('_tabs_sel')) {
    default:
    case 'classic_cart':
      $display_classic_cart($title, $cart);
      break;
    case 'textcart':
      $this->display_textcart($title, $cart);
      break;
    }
    tabbed_content_end();
  }

  function display_textcart($title, $cart) {
    div_start('textcart');	
    display_heading($title);
    start_table(TABLESTYLE, "width=100%");
    textarea_cells("", "textcart", $this->cart_to_text($cart), 100, 25, $title);
    end_table();
    //submit_center("Name", "Value", true, "title", "ajaxsubmit");
    submit_center_first("ReplaceTextCart", "Replace");
    submit("ModifyTextCart", "Insert");
    submit("UpdateTextCart", "Update");
    submit_center_last("CancelTextCart", "Cancel");
    div_end();
  }                                       

  var $cart_key = "Items"; // key of the cart in the $POST
  var $doc_text = "-- This is a comment -- it will be skipped and not processed 
-- structure of a line (every fields are optional apart from stock_name)
-- stock_name optionals fields |  description 
-- fields could be :
--   integer or +number : quantity
--   float or \$nubmer  : price
--   number%            :discount
--   date or ^date      :date
-- at the beginning of a line 
-- : start a template line
-- ! raw line (not preproceseed)
-- before stock name
-- + add an item
-- - suppress the line from the cart
-- = update the line if exists
-- place holder               :
-- @ : the default value of the corresponding field
-- # : the template or line value of the corresponding field
-- ( ...  ) : arithmetical expression between () would be evaluated
";
  var $use_price=true;
  var $use_date=false;

  function cart_to_text($cart) {
    $text = $this->doc_text."



"; // empty line are important
    return $text.$this->cart_to_text_v($cart);
  }

  function item_to_text($item, $user_price_dec) {
      $dec = get_unit_dec($item->stock_id);
      // dodgy format excel compatible
      return sprintf("$item->stock_id\t+ %.${dec}f\t\$ %0.${user_price_dec}f\t%0.1f %%%s\r\n"
        ,$item->quantity
        ,$item->price
        ,$item->discount_percent*100
        ,$item->item_description ? "\t| \"$item->item_description\"" : ""
      );
  }

  function cart_to_text_v($cart)  {
    $text = "";
    $user_price_dec = user_price_dec();

    foreach ($cart->line_items as $item) {
      $text .= $this->item_to_text($item, $user_price_dec);
    }

    return $text;
  }

  function handle_textcart($clear_cart=false, $default_mode=null) {
    if (!isset($_POST['textcart'])) {
      return;
    }
    $cart = $_SESSION[$this->cart_key];
    $text = $_POST['textcart'];
    if ($clear_cart) {
      // check that the cart can be deleted
      foreach($cart->line_items as $line_no => $line) {
        if($this->unmodifiable_quantity($cart, $line_no> 0)) {
          display_error("Cannot clear current cart, because some items have been alread delivered or invoiced. Please use Update instead of Replace. ");
          return;
        }
      }
      $cart->line_items = array();
    } // clear_items doesn't work, can't update the price if we are using it
    $this->process_textcart($cart, $text, $default_mode);
  }

  function clear_cart($cart) {
    $cart->line_items = array();  // clear_items doesn't work, can't update the price if we are using it
  }
  function process_textcart($cart, $textcart, $default_mode) {
    $template_line = null;
    foreach (explode("\n", $textcart) as $line) {
      # remove comments
      $line = preg_replace('/--.*/', "", $line);
      # decide which type of line is
      # ! raw line, no processing
      # : template line
      preg_match('/([!:]?)(.*)/', $line, $matches);
      $line = $matches[2];
      $line_mode = $this->line_mode_map[$matches[1]];

      $attributes = $this->parse_line($line);

      if ($line_mode == TEMPLATE_LINE) {
        $template_line = $attributes ? $attributes : array();
        continue;
      }

      if (!$attributes) continue;
      if ($line_mode == NORMAL_LINE) {
        $stock_code = expand_template($template_line['stock_code'], $attributes['stock_code']);
        $mode = $attributes['mode'];
        $quantity =  expand_template($template_line['quantity'], $attributes['quantity'], 1);
        if($this->use_price ) {
          $price = expand_template($template_line['price'], $attributes['price'], 
            $this->get_default_price($cart, $stock_code));
          //$price = round2($price, $attributes['price'], user_price_dec());
          $discount = $attributes["discount"];
          $discount =  expand_template($template_line['discount'], $attributes['discount'], 0);
        }
        else {
          $price = 0;
          $discount = 0;
        }
        if($this->use_date)  {
          $date = expand_template($template_line['date'], $attributes['date'], 
          $this->get_default_date($cart, $stock_code));
        }
        $description =  expand_template($template_line['description'], $attributes['description'], get_kit_description($stock_code));
      }
      else {
        $stock_code = $attributes["stock_code"];
        $mode = $attributes['mode'];
        $quantity = $attributes["quantity"];
        $price = $attributes["price"];
        $discount = $attributes["discount"];
        $description = $attributes["description"];

      }

      #echo "Stock Code : $stock_code</br><ul>";
      #echo "<li>mode : $mode</li>";
      #echo "<li>quantity : $quantity</li>"   ;
      #echo "<li>price : $price</li>";
      #echo "<li>discount : $discount</li>";
      #echo "<li>description : $description</li>";
      #echo "</ul>";

      // Checking that product exists, to not process dodgy one
      $kit = get_item_kit($stock_code);
      $number = db_num_rows($kit);
      if ($number == 0) {
        display_error("Product '$stock_code' doesn't exist");
        display_error("Line '$line' skipped");
      }
      db_free_result($kit);

      if(!$mode) { $mode = $default_mode; }
      switch ($mode) {
      case UPDATE_MODE:
        // we modifidy the first element, we can't use the attributes as criteria as 
        // they are the new value
        $line_no = $this->find_line_number($cart, $stock_code);
        if (!isset($line_no)) { return; }
        $this->update_cart_item($cart, $line_no, $stock_code, $quantity, $price, $discount, $date, $description);
        break;
      case DELETE_MODE:
        $line_no = $this->find_line_number($cart, $stock_code, $quantity, $price, $discount, $description);
        #echo "deleting $line_no";
        if (!isset($line_no)) { return; }
        $this->remove_from_cart($cart, $line_no, $stock_code);
        break;
      case INSERT_MODE:
        if (!$quantity) $quantity = 1;
        #echo "price before $price";
        //if ($this->use_price && !$price) {
          //$price = round2($this->get_default_price($cart, $stock_code), user_price_dec());
        //}
        #echo "price after $price";
        $this->add_to_order($cart, $stock_code, $quantity, $price, $discount, $date, $description );
      }
    }
  }

  function remove_from_cart($cart, $line_no, $stock_code) {
    if($this->unmodifiable_quantity($cart, $line_no) > 0)
      display_error("'$stock_code' can not be deleted because some of it has already been dispatched or invoiced");
    else
        $cart->remove_from_cart($line_no);
  }

  function update_cart_item($cart, $line_no, $stock_code, $quantity, $price, $discount, $date, $description) {
    if($this->unmodifiable_quantity($cart, $line_no) > $quantity)
      display_error("'$stock_code' can not be updated because some of it has already been dispatched or invoiced");
    else
        $cart->update_cart_item($line_no, $quantity, $price, $discount, $description);
  }

  function add_to_order($cart, $stock_code, $quantity, $price, $discount, $date, $description ) {
    if ($quantity>0)
        add_to_order($cart, $stock_code, $quantity, $price, $discount, $description );
    else 
      display_error("$stock_code qty $quantity negative quantity not allowed");
  }

  function find_line_number($cart, $stock_code, $quantity=null, $price=null, $discount=null,  $description=null) {
    foreach ($cart->line_items as $line_no => $line) {
      if ($line->stock_id == $stock_code 
        //&& match_criteria($line->quantity, $quantity)
        //&& match_criteria($line->price , $price)
        //&& match_criteria($line->discount_percent , $discount)
        //&& match_criteria($line->item_description, $description)
      ) {
          return $line_no;

        }
    }
    display_error("Can't find line details with ".join(", ",array($stock_code, $quantity, $price, $discount, $description)));
    return null;
  }
  function parse_line($line) {
    global $mode_map;
    #echo "parsing : $line<br/>";
    // TODO create global variable
    $line = trim($line);
    $stock_code = "";
    $quantity = "";
    $price = "";
    $discount = "";
    $date=null;
    $description = "";


    if(!$line) {
      // empty line, skip
      return;
    }
    // extract SKU and descriptions
    if (!preg_match('/^([+\-=])?\s*([^\s,;]+)(?:([^|]*)(?:\|\s*(.*)\s*)?)?/', 
      htmlspecialchars_decode($line), $matches)) {
        display_error("error parsing '$line'");
        return;
      }
      $mode = $this->mode_map[$matches[1]];
      $stock_code =  $matches[2];
      $fields_str = $matches[3];
      $description = trim($matches[4], '" ');

      # Hack to allow spaces between attribute qualifier
      $fields_str = preg_replace('/([+$^])\s*/', '\1' , $fields_str);
      $fields_str = preg_replace('/\s*(%)/', '\1' , $fields_str);
    $fields = preg_split("/[\s,;]+/", $fields_str);

      // TODO refactore using an array
    foreach ($fields as $field) {
      # quantity are integer or preceeded by a +
      if (preg_match('/^(-?\d+'.PARAM_REG.')$/', $field, $matches)) {
        if($quantity) {
          display_error("quantity already set for line '$line'");
          return;
        };
        $quantity = $matches[1];
      }
      elseif (preg_match('/^\+(-?\d*(?:\.\d+)?'.PARAM_REG.')$/', $field, $matches)) {
        if($quantity) {
          display_error("quantity already set for line '$line'");
          return;
        };
        $quantity = $matches[1];
      }
      # price are float or integer preceeded by a $
      elseif (preg_match('/^(?:(\d+\.\d+)|\$(\d+(?:\.\d+)?'.PARAM_REG.'))$/', $field, $matches)) {
        if($price) {
          display_error("price already set for line '$line'");
          return;
        };
        $price = $matches[1] . $matches[2];//  ack to get first match or the second one
      }
      elseif (preg_match('/^(\d+(?:.\d+)?'.PARAM_REG.')%$/', $field, $matches)) {
        if($discount) {
          display_error("discount already set for line '$line'");
          return;
        };
        $discount = $matches[1];
      }
      elseif (preg_match('/^\^?(\d+[-\/]\d+[-\/]\d+'.PARAM_REG.')$/', $field, $matches)) {
        #echo "date = $date";
        if($date) {
          display_error("date already set for line '$line'");
          return;
        };
        $date_php = date_parse($matches[1]);
        if($date_php) {
          $date=__date($date_php['year'], $date_php['month'], $date_php['day']);
        }
        else {
          display_error("wrong date format for line '$line'");
          return;
        }
      }

      }
    #echo "Stock Code : $stock_code</br><ul>";
    #echo "<li>quantity : $quantity</li>"   ;
    #echo "<li>price : $price</li>";
    #echo "<li>discount : $discount</li>";
    #echo "<li>date : $date</li>";
    #echo "<li>description : $description</li>";
    #echo "</ul>";

    return array(
      "mode" => $mode
      ,"stock_code" => $stock_code
      ,"quantity" => $quantity
      ,"price" => $price
      ,"discount" => $discount/100.0
      ,"description" => $description
      ,"date" => $date
    );

  }
  function get_default_price($cart, $stock_code) {
    return get_standard_cost($stock_code);
  }

  function get_default_date($cart, $stock_code) {
    return add_days(Today(), 10);
  } 

  function unmodifiable_quantity($cart, $line_no) {
    return 0;
  }
}

class SalesTextCartManager extends TextCartManager {

  function get_default_price($cart, $stock_code) {
            return get_kit_price($stock_code, $cart->customer_currency,
              $cart->sales_type, $cart->price_factor);
  }
  function unmodifiable_quantity($cart, $line_no) {
    return $cart->line_items[$line_no]->qty_done;
  }
}

class POTextCartManager extends TextCartManager {
  var $cart_key = "PO";
  var $use_date = true;
   
  function add_to_order($cart, $stock_code, $quantity, $price, $discount, $date, $description ) {
    if ($quantity>0)
        $cart->add_to_order(count($cart->line_items), $stock_code, $quantity,
          $description, $price , '',
					$date, 0, 0);
    else 
      display_error("$stock_code qty $quantity negative quantity not allowed");
  }

  function remove_from_cart($cart, $line_no, $stock_code) {
        $cart->remove_from_order($line_no);
  }
  function update_cart_item($cart, $line_no, $stock_code, $quantity, $price, $discount, $date, $description) {
    if($this->unmodifiable_quantity($cart, $line_no) > $quantity)
      display_error("'$stock_code' can not be updated because some of it has already been dispatched or invoiced");
    else
        $cart->update_order_item($line_no, $quantity, $price, $discount, $date, $description);
  }
  function unmodifiable_quantity($cart, $line_no) {
    $line = $cart->line_items[$line_no];
    return max($line->qty_inv, $line->qty_received);
  }
  function get_default_price($cart, $stock_code) {
    return get_purchase_price($_POST['supplier_id'], $stock_code);
  }
  function item_to_text($item, $user_price_dec) {
      $dec = get_unit_dec($item->stock_id);
      // dodgy format excel compatible
      return sprintf("$item->stock_id\t+ %.${dec}f\t\$ %0.${user_price_dec}f\t^ %s%s\r\n"
        ,$item->quantity
        ,$item->price
        ,$item->req_del_date
        ,$item->item_description ? "\t| \"$item->item_description\"" : ""
      );
  }
}

class ItemsTextCartManager extends TextCartManager {
  function cart_to_text_v($cart) {
    if (count($cart->line_items) == 0) {
      return $this->stock_to_text($this->get_location());
    } 
    else {
      return parent::cart_to_text_v($cart);
    }
  }

  function stock_to_text($location) {
    $text = "";
    $sql = "SELECT mv.stock_id , SUM(qty) AS quantity, description FROM ".TB_PREF."stock_moves mv
      JOIN ".TB_PREF."stock_master USING(stock_id)
     WHERE  mv.loc_code = '$location'
     GROUP BY mv.stock_id
     having quantity > 0";

    $result = db_query($sql, "No transactions were returned");
    while($move=db_fetch($result)) {
      $dec = get_unit_dec($move['stock_id']);
      $description = $move['description'];
      $text.= sprintf("${move['stock_id']}\t+ %.${dec}f%s\r\n"
        , $move['quantity']
      ,$description ? "\t| \"$description\"" : "");
    }

    return $text;
  }
}
class ItemsAdjTextCartManager extends ItemsTextCartManager {
  var $cart_key = "adj_items";
  var $doc_text = "-- This is a comment -- it will be skipped and not processed 
-- structure of a line (every fields are optional apart from stock_name)
-- stock_name optionals fields |  description 
-- fields could be :
--   integer or +number : quantity
-- at the beginning of a line 
-- : start a template line
-- ! raw line (not preproceseed)
-- before stock name
-- + add an item
-- - suppress the line from the cart
-- = update the line if exists
-- place holder               :
-- @ : the default value of the corresponding field
-- # : the template or line value of the corresponding field
-- ( ...  ) : arithmetical expression between () would be evaluated

-- *** Quantity should be negative for negative adjustement ***
-- *** and positive for positive adjustement ***
-- *** Wrong signed quantity will be filtered
-- uncomment the following line to invert the sign of every lines
-- :# +(-#)
";

  function get_location() {
    return $_POST['StockLocation'];
  }

  function add_to_order($cart, $stock_code, $quantity, $price, $discount, $date, $description ) {
    # filter quantity depending of the Mode
    $mode = $_POST['Increase'];
    if ($_POST['Increase']==1) {
      if ($quantity>0) 
        add_to_order($cart, $stock_code, $quantity, $price);
      else if ($quantity<0)
        display_error(_($stock_code)." qty $quantity <0 ");
    }
    else {
      if ($quantity>0) 
        display_error(_($stock_code)." qty $quantity >0 ");
      else if ($quantity<0)
        add_to_order($cart, $stock_code, -$quantity, $price);
    }
  }

  function item_to_text($item) {
      $dec = get_unit_dec($item->stock_id);
      // dodgy format excel compatible
      return sprintf("$item->stock_id\t+ %.${dec}f\t%s\r\n"
        , $_POST['Increase']==1 ?  $item->quantity  : -$item->quantity
        ,$item->item_description ? "\t| \"$item->item_description\"" : ""
      );
  }
}

class ItemsTransTextCartManager extends ItemsTextCartManager {
  var $cart_key = "transfer_items";
  var $doc_text = "-- This is a comment -- it will be skipped and not processed 
-- structure of a line (every fields are optional apart from stock_name)
-- stock_name optionals fields |  description 
-- fields could be :
--   integer or +number : quantity
-- at the beginning of a line 
-- : start a template line
-- ! raw line (not preproceseed)
-- before stock name
-- + add an item
-- - suppress the line from the cart
-- = update the line if exists
-- place holder               :
-- @ : the default value of the corresponding field
-- # : the template or line value of the corresponding field
-- ( ...  ) : arithmetical expression between () would be evaluated
";
  var $use_price = false;
  function item_to_text($item) {
      $dec = get_unit_dec($item->stock_id);
      // dodgy format excel compatible
      return sprintf("$item->stock_id\t+ %.${dec}f\t%s\r\n"
        ,$item->quantity
        ,$item->item_description ? "\t| \"$item->item_description\"" : ""
      );
  }

  function get_location() {
    return $_POST['FromStockLocation'];
  }
}
?>
