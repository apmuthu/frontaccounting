<?php
require_once('test/helper.php');

class ParseTest extends PHPUnit_Framework_TestCase {
	protected $cart;
	protected $mgr;

	protected  function setUp() {
		$this->cart = array("mock");
		$this->mgr = new TextCartManager();
	}


	public function parseNormalExamples() {
		return array(
							/*** parse quantity ***/
							array("A", "A", null, null, 0)
							,array("A 1 ", "A", '1', null, 0)
							,array("A 17 ", "A", '17', null, 0)
							,array("A +1.7 ", "A", '1.7', null, 0)
							,array("A 1.7 ", "A", null, '1.7', 0)
							,array("A $17 ", "A", null, '17', 0)
							,array("A 2 7.0 ", "A", '2', '7.0', 0)
							,array("A 7.0 2 ", "A", '2', '7.0', 0)
							,array("A + 7.0 $ 2 ", "A", '7.0', '2', 0)
							/** formula (stuff between parenthesis) needs to stay between parenthesis
							 * so the manager knows they are formula (this change the priority) */
							,array("A $(7) 2 ", "A", '2', '(7)', 0)
							,array("A 7.0 +(2.1) ", "A", '(2.1)', '7.0', 0)
							,array("A 7.0 ((@+.1)*#) ", "A", '((@+.1)*#)', '7.0', 0)
							/*** test comment and spaces ***/
							,array("    A + 7.0 $ 2 ", "A", '7.0', '2', 0)
							,array("    A + 7.0 $ 2 | this a description    ", "A", '7.0', '2', 0, "this a description")
							,array("    A + 7.0 $ 2 | this a description", "A", '7.0', '2', 0, "this a description")
							);
	}
/**
 * @group normal
 * @dataProvider parseNormalExamples
 */
    public function testNormal($line, $stock_code, $quantity, $price, $discount=null, $description=null)
    {
			$this->assertParse($line, NORMAL_LINE,  $stock_code, $quantity, $price, $discount, $description, null);
		}

	public function parseDatedExamples() {
		return array(
							array("A 10 ^2013/03/01", "A", '10', null, null, null, 'Date: 2013/3/1')
							,array("A ^2013/03/01 10", "A", '10', null, null, null, 'Date: 2013/3/1')
							,array("A 2013/03/01 10", "A", '10', null, null, null, 'Date: 2013/3/1')
							/*** Everything is passed ***/
							,array("A 10 5.0 3% ^2013/03/01 | hello", "A", '10', '5.0', 3, "hello", 'Date: 2013/3/1')
							,array("A 3% 10 5.0 ^2013/03/01 | hello", "A", '10', '5.0', 3, "hello", 'Date: 2013/3/1')
		);
	}
/**
 * @group dated
 * @dataProvider parseDatedExamples
 */
    public function testDated($line, $stock_code, $quantity, $price, $discount=null, $description=null, $date=null)
    {
			$this->assertParse($line, NORMAL_LINE,  $stock_code, $quantity, $price, $discount, $description, $date);
		}

		public function parseAdvanced() {
			return array(
								array("A 10 ", NORMAL_LINE, "A", '10', null)
								,array("+A 10 ", INSERT_MODE, "A", '10', null)
								,array("=A 10 ", UPDATE_MODE, "A", '10', null)
								,array("-A 10 ", DELETE_MODE, "A", '10', null)
			);
		}

		/**
		 * @dataProvider parseAdvanced
		 */
    public function testAdvanced($line, $mode,  $stock_code, $quantity, $price, $discount=null, $description=null, $date=null) {
			$this->assertParse($line, $mode,  $stock_code, $quantity, $price, $discount, $description, $date);
		}

    public function assertParse($line, $mode,  $stock_code, $quantity, $price, $discount=null, $description=null, $date=null)
    {
			$data = $this->mgr->parse_line($line);
			$this->assertEquals($data, array(
      "mode" => $mode
      ,"stock_code" => $stock_code
      ,"quantity" => $quantity
      ,"price" => $price
      ,"discount" => $discount
      ,"description" => $description
      ,"date" => $date
				)
			);
    }
 
} 
