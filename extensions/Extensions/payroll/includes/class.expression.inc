<?php

/*
================================================================================

expression - PHP Class to safely evaluate math expressions
Copyright (C) 2005 Miles Kaufmann <http://www.twmagic.com/>
Changes/extensions FrontAccounting 2011.
================================================================================

AUTHOR INFORMATION
    Copyright 2005, Miles Kaufmann.

LICENSE
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are
    met:

    1   Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
    2.  Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
    3.  The name of the author may not be used to endorse or promote
        products derived from this software without specific prior written
        permission.

    THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
    STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.

*/

/*
	Implemented operators with precedence:

17	-			unary (_)
15	* /
14	+ - .
12	< <= > >=
11	== !=
9	^
7	&&
6	||

string constants in single quoted form

TODO:
* parsing doesn't work for expressions containing ';' inside text constant
* establish set of allowed php functions, cleanup in constants
* comments (# or //)
* arrays: defining and indexation
* variable parameters functions
* check order of function arguments
* eval should be superseded by call_user_func()
*/

class expression {

    var $suppress_errors = true;
    var $last_error = null;
	var $result;

    var $v = array(); // variables (and constants)
    var $vb = array(); // constants names
    var $f = array(); // user-defined functions
    var $fb = array(  // built-in functions
);

    function expression() {
		$this->_clean();
    }

    function _clean()
    {
    	$this->f = array();
    	$this->last_error = null;
    	$this->add_var('e', exp(1), true);
    	$this->add_var('pi', pi(), true);
        $funcs = array(
	        'sin','sinh','arcsin','asin','arcsinh','asinh',
    	    'cos','cosh','arccos','acos','arccosh','acosh',
        	'tan','tanh','arctan','atan','arctanh','atanh',
	        'sqrt','abs','log'
	    );

        foreach($funcs as $fun)
        	$this->add_function($fun, 1);

		$this->add_function('if', 3);
		$this->add_function('v', 1);
    }

	function _if($cond, $yes, $no)
	{
		return $cond ? $yes : $no;
	}
	/*
		Returns value of variable. Used for non-standard var names, when direct name cannot be used
	*/
	function _v($var_name)
	{
		if (!isset($this->v[$var_name]))
		{
            $this->_trigger("undefined variable '$var_name'");
            return '';
		}

		return  $this->v[$var_name][0]=='\'' ? substr($this->v[$var_name], 1) : $this->v[$var_name];
	}

	/*
	*	Add builtin function
	*/
    function add_function($function, $args=0)
    {
		$this->fb[$function] = $args;
    }

	/*
	*	Add single variable or constant
	*/
	function add_var($name, $value=0, $const=false)
	{
		$this->v[$name] = $value==(string)(double)$value ? $value : '\''. $value;

		if ($const)
			$this->vb[] = $name;
	}
	/*
	*	Import variables
	*/
	function import_vars($vars)
	{
		foreach($vars as $name => $value)
			if (is_numeric($name))
				$this->add_var($value);
			else
				$this->add_var($name, $value);
	}

    function e($expr) {
        return $this->evaluate($expr);
    }

	function evaluate($expressions) {

        $this->last_error = null;
        $expressions = explode(';', $expressions);
        foreach($expressions as $expr) {
	        $expr = trim($expr);
    	    if (substr($expr, -1, 1) == ';')
        		$expr = substr($expr, 0, strlen($expr)-1); // strip semicolons at the end
        	if ($expr === '') continue;
        //===============
        // is it a variable assignment?
    	    if (preg_match('/^\s*([a-zA-Z]\w*)\s*=\s*(.+)$/', $expr, $matches)) {
	            if (in_array($matches[1], $this->vb)) { // make sure we're not assigning to a constant
                	return $this->_trigger("cannot assign to constant '$matches[1]'");
            	}
        	    if (($tmp = $this->_pfx($this->_nfx($matches[2]))) === false) return false; // get the result and make sure it's good
    	        $this->v[$matches[1]] = $tmp; // if so, stick it in the variable array
	            return $this->v[$matches[1]]; // and return the resulting value
        //===============
        // is it a function assignment?
        	} elseif (preg_match('/^\s*([a-zA-Z]\w*)\s*\(\s*([a-zA-Z]\w*(?:\s*,\s*[a-zA-Z]\w*)*)\s*\)\s*=\s*(.+)$/', $expr, $matches)) {
    	        $fnn = $matches[1]; // get the function name
	            if (in_array($matches[1], $this->fb) || array_key_exists($matches[1], $this->fb)) { // make sure it isn't built in
            	    return $this->_trigger("cannot redefine built-in function '$matches[1]()'");
        	    }
    	        $args = explode(",", preg_replace("/\s+/", "", $matches[2])); // get the arguments
	            if (($stack = $this->_nfx($matches[3])) === false) return false; // see if it can be converted to postfix
            	for ($i = 0; $i<count($stack); $i++) { // freeze the state of the non-argument variables
        	        $token = $stack[$i];
    	            if (preg_match('/^[a-zA-Z]\w*$/', $token) and !in_array($token, $args)) {
	                    if (array_key_exists($token, $this->v)) {
                    	    $stack[$i] = $this->v[$token];
                	    } else {
            	            return $this->_trigger("undefined variable '$token' in function definition");
        	            }
    	            }
	            }
            	$this->f[$fnn] = array('args'=>$args, 'func'=>$stack);
        	//===============
    	    } else 
	        {
            	$this->result = $this->_pfx($this->_nfx($expr)); // straight up evaluation, woo
        	}
        }
        return $this->last_error == null;
    }
    
    function get_vars() {
        $output = array();
        foreach ($this->v as $v=>$dat)
            $output[$v] =  $dat[0]=='\'' ? stripslashes(substr($dat, 1, -1)) : $dat;
        unset($output['pi']);
        unset($output['e']);
        return $output;
    }
    
    function get_funcs() {
        $output = array();
        foreach ($this->f as $fnn=>$dat)
            $output[] = $fnn . '(' . implode(',', $dat['args']) . ')';
        return $output;
    }

    //===================== HERE BE INTERNAL METHODS ====================\\
    /**
    *	Retrieve string constant (in single or double quotes)
    */
	function _get_string($expr, &$index)
	{
	// for both quotes (with quotes) use: "/^(?:(?:\"(?:\\\\\"|[^\"])+\")|(?:'(?:\\\'|[^'])+'))/"
	 	if (preg_match("/^(?:(?:'((?:\\\'|[^'])+)'))/", substr($expr, $index), $match))
	 	{
	 		$index += strlen($match[0]);
	 		return stripslashes($match[1]);
	 	} else
		 	return null;
	}

    // Convert infix to postfix notation
    function _nfx($expr) {

        $index = 0;
        $stack = new expression_stack;
        $output = array(); // postfix form of expression, to be passed to _pfx()
        $expr = trim($expr);

        $ops   = array('+', '-', '*', '/', '^', '_', '<', '>', '>=', '<=', '==', '!=', '&&', '||', '.');
		$ops_r = array('_', // '!', +=, -=...         // right-associative operator
		);
        $ops_p = array(
        	'=='=>11, '!=' => 11,
        	'<'=>12, '>'=>12, '<='=>12, '>='=>12, 
        	'+'=>14, '-'=>14, '.'=>14,
        	'*'=>15, '/'=>15, 
        	'_'=>17, 
        	'^'=>9, 
        	'&&' => 7,
        	'||' => 6
        	); // operator precedence

        $expecting_op = false; // we use this in syntax-checking the expression
                               // and determining when a - is a negation

        if (preg_match("/[^\w\s+*^\/()\.,-<>=!|&']/", $expr, $matches)) { // make sure the characters are all good
            return $this->_trigger("illegal character '{$matches[0]}'");
        }

        while(1) { // 1 Infinite Loop ;)
        	if (in_array(substr($expr, $index, 2), $ops)) // check 2char operators
	        	$op = substr($expr, $index, 2);
	        else
    	        $op = substr($expr, $index, 1); // get the first character at the current index

            // find out if we're currently at the beginning of a number/variable/function/parenthesis/operand/string const
            $ex = preg_match('/^([a-zA-Z]\w*\(?|\d+(?:\.\d*)?|\.\d+|\(|\')/', substr($expr, $index), $match);
            //===============
			if ($op == '-' and !$expecting_op) { // is it a negation instead of a minus?
                $stack->push('_'); // put a negation on the stack
                $index++;
            } elseif ($op == '_') { // we have to explicitly deny this, because it's legal on the stack 
                return $this->_trigger("illegal character '_'"); // but not in the input expression
            //===============
            } elseif ((in_array($op, $ops) or $ex) and $expecting_op) { // are we putting an operator on the stack?
               if ($ex) { // are we expecting an operator but have a number/variable/function/opening parethesis?
                    $op = '*';
                    $index--; // it's an implicit multiplication 
                }
                // heart of the algorithm:
                while(count($stack->stack) > 0 and ($o2 = $stack->last()) and in_array($o2, $ops) 
                	and (in_array($op, $ops_r) ? $ops_p[$op] < $ops_p[$o2] : $ops_p[$op] <= $ops_p[$o2])) {
                    $output[] = $stack->pop(); // pop stuff off the stack into the output
                }
                // many thanks: http://en.wikipedia.org/wiki/Reverse_Polish_notation#The_algorithm_in_detail
                $stack->push($op); // finally put OUR operator onto the stack
                $index+=strlen($op);
                $expecting_op = false;
            //===============
            } elseif ($op == ')' and $expecting_op) { // ready to close a parenthesis?
                while (($o2 = $stack->pop()) != '(') { // pop off the stack back to the last (
                    if (is_null($o2)) return $this->_trigger("unexpected ')' at $index");
                    else $output[] = $o2;
                }
                if (preg_match("/^([a-zA-Z]\w*)\($/", $stack->last(1), $matches)) { // did we just close a function?
                    $fnn = $matches[1]; // get the function name
                    $arg_count = $stack->pop(); // see how many arguments there were (cleverly stored on the stack, thank you)
                    $output[] = $stack->pop(); // pop the function and push onto the output
                    if (in_array($fnn, $this->fb)) { // check the argument count
                        if ($arg_count > 1)
                            return $this->_trigger("too many arguments ($arg_count given, 1 expected)");
                    } elseif (array_key_exists($fnn, $this->f)) {
                        if ($arg_count != count($this->f[$fnn]['args']))
                            return $this->_trigger("wrong number of arguments ($arg_count given, " . count($this->f[$fnn]['args']) . " expected)");
                    } elseif (array_key_exists($fnn, $this->fb)) {
                        if ($arg_count != $this->fb[$fnn])
                            return $this->_trigger("wrong number of arguments ($arg_count given, " . $this->fb[$fnn] . " expected)");
                    } else { // did we somehow push a non-function on the stack? this should never happen
                        return $this->_trigger("internal error [1]");
                    }
                }
                $index++;
            //===============
            } elseif ($op == ',' and $expecting_op) { // did we just finish a function argument?
                while (($o2 = $stack->pop()) != '(') { 
                    if (is_null($o2)) return $this->_trigger("unexpected ',' at $index"); // oops, never had a (
                    else $output[] = $o2; // pop the argument expression stuff and push onto the output
                }
                // make sure there was a function
                if (!preg_match("/^([a-zA-Z]\w*)\($/", $stack->last(1), $matches))
                    return $this->_trigger("unexpected ',' at $index");
                $stack->push($stack->pop()+1); // increment the argument count
                $stack->push('('); // put the ( back on, we'll need to pop back to it again
                $index++;
                $expecting_op = false;
            //===============
            } elseif ($op == '(' and !$expecting_op) {
                $stack->push('('); // that was easy
                $index++;
                $allow_neg = true;
            //===============
            } elseif ($ex and !$expecting_op) { // do we now have a function/variable/number?
                $expecting_op = true;
                $val = $match[1];
                if ($val == '\'') {	// string constant
            		$string = $this->_get_string($expr, $index);
            		if ($string === false)
	            		return $this->trigger("bad formatted string constant");
	            	$output[] = '\''.$string;
        		}
                else
                {
                  if (preg_match("/^([a-zA_Z]\w*)\($/", $val, $matches)) { // may be func, or variable w/ implicit multiplication against parentheses...
                    if (in_array($matches[1], $this->fb) or array_key_exists($matches[1], $this->f) or array_key_exists($matches[1], $this->fb)) {
                    	 // it's a func
                        $stack->push($val);
                        $stack->push(1); // placeholder for number of arguments (plus 1 for '(' )
                        $stack->push('(');
                        $expecting_op = false;
                    } else { // it's a var w/ implicit multiplication
                        $val = $matches[1];
                        $output[] = $val;
                    }
                  } else { // it's a plain old var or num
                    $output[] = $val;
                  }
                  $index += strlen($val);
                }
            //===============
            } elseif ($op == ')') { // miscellaneous error checking
                return $this->_trigger("unexpected ')' at $index");
            } elseif (in_array($op, $ops) and !$expecting_op) {
                return $this->_trigger("unexpected operator '$op' at $index");
			} elseif ($op == '') {
                return $this->_trigger("an unexpected end of expression");
            } else { // I don't even want to know what you did to get here
                return $this->_trigger("an unexpected error occured ($op) at $index");
            }
            if ($index == strlen($expr)) {
                if (in_array($op, $ops)) { // did we end with an operator? bad.
                    return $this->_trigger("operator '$op' lacks operand");
                } else {
                    break;
                }
            }
            while (substr($expr, $index, 1) == ' ') { // step the index past whitespace (pretty much turns whitespace 
                $index++;                             // into implicit multiplication if no operator is there)
            }
        
        } 
        while (!is_null($op = $stack->pop())) { // pop everything off the stack and push onto output
            if ($op == '(') return $this->_trigger("expecting ')'"); // if there are (s on the stack, ()s were unbalanced
            $output[] = $op;
        }
        return $output;
    }

    // evaluate postfix notation
    function _pfx($tokens, $vars = array()) {

        if ($tokens == false) return false;
        $stack = new expression_stack;
        
        foreach ($tokens as $token) { // nice and easy
            // if the token is a binary operator, pop two values off the stack, do the operation, and push the result back on
            if (in_array($token, array('+', '-', '*', '/', '^', '<', '>', '<=', '>=', '==', '!=', '||', '&&', '.'))) {
                if (is_null($op2 = $stack->pop_arg())) return $this->_trigger("internal error [2]");
                if (is_null($op1 = $stack->pop_arg())) return $this->_trigger("internal error [3]");
                switch ($token) {
                    case '+':
                        $stack->push_arg($op1+$op2); break;
                    case '-':
                        $stack->push_arg($op1-$op2); break;
                    case '*':
                        $stack->push_arg($op1*$op2); break;
                    case '/':
                        if ($op2 == 0) return $this->_trigger("division by zero");
                        $stack->push_arg($op1/$op2); break;
                    case '<':
                        $stack->push_arg($op1<$op2 ? '1' : '0'); break;
                    case '>':
                        $stack->push_arg($op1>$op2 ? '1' : '0'); break;
                    case '>=':
                        $stack->push_arg($op1>=$op2 ? '1' : '0'); break;
                    case '<=':
                        $stack->push_arg($op1<=$op2 ? '1' : '0'); break;
                    case '==':
                        $stack->push_arg($op1==$op2 ? '1' : '0'); break;
                    case '!=':
                        $stack->push_arg($op1!=$op2 ? '1' : '0'); break;
                    case '&&':
                        $stack->push_arg($op1&&$op2 ? '1' : '0'); break;
                    case '||':
                        $stack->push_arg($op1||$op2 ? '1' : '0'); break;
                    case '.':
                        $stack->push_arg($op1.$op2); break;
                    case '^':
                        $stack->push_arg($op1^$op2); 
                         break;
                }
            // if the token is a unary operator, pop one value off the stack, do the operation, and push it back on
            } elseif ($token == "_") {
                if (is_null($op = $stack->pop_arg())) return $this->_trigger("internal error [8]");
                $stack->push_arg(-1*$op);
            // if the token is a function, pop arguments off the stack, hand them to the function, and push the result back on
            } elseif (preg_match("/^([a-zA-Z]\w*)\($/", $token, $matches)) { // it's a function!
                $fnn = $matches[1];
                if (in_array($fnn, $this->fb)) { // built-in 1-arg function:
                    if (is_null($op1 = $stack->pop_arg())) return $this->_trigger("internal error [4]");

                   	if ($op1!=(string)(double)$op1)
	                   	$op1 = '\''.strtr($op1, array('\'' => '\\\'', '\\' => '\\\\')). '\'';
                    $fnn = preg_replace("/^arc/", "a", $fnn); // for the 'arc' trig synonyms
                    if (method_exists($this, '_'.$fnn))
                    	$fnn = '$this->_'.$fnn;
                    $stack->push_arg(eval("return $fnn($op1);"));
                } elseif (array_key_exists($fnn, $this->fb)) { // std multiarg function
                    // get args
                    $args = array();
                    for ($i = $this->fb[$fnn]-1; $i >= 0; $i--) {
                    	$arg = $stack->pop_arg();
                        if (is_null($arg)) return $this->_trigger("internal error [9]");
                        // FIXME test below never should not be required
                       	$args[] = $arg == (string)(double)$arg ?
                       		$arg : '\''.strtr($arg, array('\'' => '\\\'', '\\' => '\\\\')). '\'';
					}

	                if (method_exists($this, '_'.$fnn))
    	            	$fnn = '$this->_'.$fnn;
//					$stack->push(call_user_func($fnn, array_reverse($args))); FIXME: shouldbe something like that....
                    $stack->push_arg(eval("return $fnn(".implode(',', array_reverse($args)).");"));
					if ($this->last_error)
						return;
                }  elseif (array_key_exists($fnn, $this->f)) { // user function
                    // get args
                    $args = array();
                    for ($i = count($this->f[$fnn]['args'])-1; $i >= 0; $i--) {
                        if (is_null($args[$this->f[$fnn]['args'][$i]] = $stack->pop())) return $this->_trigger("internal error [5]");
                    }
                    $stack->push($this->_pfx($this->f[$fnn]['func'], $args)); // yay... recursion!!!!
                }
            // if the token is a number or variable, push it on the stack
            } else {
                if ($token==(string)(double)$token) { // numeric
                    $stack->push($token);
                } elseif (array_key_exists($token, $this->v)) {
                    $stack->push($this->v[$token]);
                } elseif (array_key_exists($token, $vars)) {
                    $stack->push($vars[$token]);
                } elseif ($token[0]=='\'') {
                    $stack->push($token);
                } else {
                    return $this->_trigger("undefined variable '$token'");
                }
            }
        }
        // when we're out of tokens, the stack should have a single element, the final result
        if (count($stack->stack) != 1) return $this->_trigger("internal error [6]");
        return $stack->pop_arg();
    }
    
    // trigger an error, but nicely, if need be
    function _trigger($msg) {
        $this->last_error = $msg;
        if (!$this->suppress_errors) {
        	display_error($msg);
        }
        return false;
    }
}

// for internal use
class expression_stack {

    var $stack = array();
    var $count = 0;

    function push($val) {
    	array_unshift($this->stack, $val);
    }

    function pop() {
    	$val =  array_shift($this->stack);
	    return $val;
    }

    function last($n=0) {
	    return @$this->stack[$n];
    }

	// push php formatted value on stack
	function push_arg($arg)
	{
       	$arg = $arg==(string)(double)$arg ? $arg : '\''. $arg;

		$this->push($arg);
	}

	// pop argument from stack as php value
	function pop_arg()
	{
		$val = $this->pop();

        if ($val[0] === '\'')
        	$val = (string)substr($val, 1);
        else
        	$val = (double)$val;	// this is needed by typeaware operators like '^'
		return $val;
	}

}

