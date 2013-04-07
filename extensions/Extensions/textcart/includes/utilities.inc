<?php

// return if criteria is not set or value match it
function match_criteria($value, $criteria) {
 return ! ( isset($criteria) && $value == $criteria);
}

/* This function replace @ by the default value
  # by the value in the template
  # by the template in the value
  and evaluate what's between ()

  Order of expansion is really important.
  Proirity are : 
    Line value of template
    Expression : # or () over constante

  Example 
   - | 10 => 10
   7 | 10 => 10
   #+3 | 10 => 13
   7 | #+3 => 10
   (7) | 10 => 7 (template is not constant)
   (7) | (10) => 10 (line is not constant either)

 */
function expand_template($template, $value, $default_value=null) {
  # replace # placeholder
  #echo "expandind template=$template value=$value default_value=$default_value<br/>";
  if(isset($value) && $value!="") {
    if($template) {
        if(field_value_is_constant($value) == false) {
          # Value needs to be evaluated (either # or ())
          # done first as value as priority over template
        $value = str_replace('#', $template, $value);
  #echo "   v template=$template value=$value default_value=$default_value<br/>";
      }
      else if (field_value_is_constant($template) == false)  {
        $value = str_replace('#', $value, $template);
  #echo "   t template=$template value=$value default_value=$default_value<br/>";
      }
    }
  }
  elseif (strpos($template, '#') === false)  {
    $value = $template;
  #echo "    null template=$template value=$value default_value=$default_value<br/>";
  }

  if(isset($value) && $value!="")  {
  # now use default value if needed
    $value = str_replace('@', $default_value, $value); 
  #echo "    default template=$template value=$value default_value=$default_value<br/>";

      #evaluate expression 
      if(preg_match('/^\((.*)\)$/', $value, $matches)) {
        // keep only arithmetical expression
        $to_eval =  preg_replace('/[a-zA-Z]*/', "", $matches[1]);
        #echo "eval trimmed '$matches[1]' => '$to_eval' <br/>";
        eval("\$value=$to_eval;");
  #echo "replaced template=$template value=$value default_value=$default_value<br/>";
      }
    return $value;
  }
  else {
  return $default_value;
  }

}

function field_value_is_constant($value) {
  return(!preg_match('/^\(|#/', $value));
}

function get_kit_description($item_code) {
  $db_result = get_item_kit($item_code);
  while($props = db_fetch($db_result)) {
    return $props['description'];

  }

}
?>
