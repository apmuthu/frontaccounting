<?php
require_once('test/helper.php');

class ProcessTest extends PHPUnit_Framework_TestCase {
	protected $cart;
	protected $mgr;

	protected  function setUp() {
		$this->cart = $this->getMock("Cart");
		$this->mgr = $this->getMock("TextCartManager", array(
			'get_default_price'
			,'get_default_discount'
			,'get_kit_description'
			,'check_item_exists'
			,'add_to_order'
		));
	}


	public function processNormalExamples() {
		return array(
/*
							array("A", "A", 1, 5.2, 0.02)
							,array("A 3", "A", 3, 5.2, 0.02)
							,array("A $3", "A", 1, 3, 0.02)
							,array(":# $3\nA", "A", 1, 3, 0.02)
							,array(":# $3\nA $7", "A", 1, 7, 0.02)
							,array(":# $(10*#+@)\nA $7", "A", 1, 75.2, 0.02)
							,array(":# 5%\nA", "A", 1, 5.2, 0.05)
							,array("A 0%", "A", 1, 5.2, 0)
							,array("A 10%", "A", 1, 5.2, 0.1)

							// overriding discount 
							,array(":# 0%\nA 5%", "A", 1, 5.2, 0.05) // line win
							,array(":# 10%\nA 0%", "A", 1, 5.2, 0)
							,array(":# (0)%\nA 0.5%", "A", 1, 5.2, 0) // template win
							,array(":# (10)%\nA 0%", "A", 1, 5.2, 0.1)
							,*/array(":A (10)%\nA ", "A", 1, 5.2, 0.1)
							,array(":# 10%\nA 35 ", "A", 1, 5.2, 0.1)
							);
	}

	/**
 * @dataProvider processNormalExamples
 */
	function testNormalExamples($textcart, $stock_code, $quantity, $price, $discount=null, $description=null) {

		$date = null;
		// Stubbing mgr 
		$this->mgr->expects($this->any())
			->method('get_default_price')
			->will($this->returnValue(5.2));
		$this->mgr->expects($this->any())
			->method('get_default_discount')
			->will($this->returnValue(.02));

	// setting up expectation
	$this->mgr->expects($this->once())
		->method('add_to_order')
		->with($this->equalTo($this->cart)
					,$this->equalTo($stock_code)
					,$this->equalTo($quantity)
					,$this->equalTo($price)
					,$this->equalTo($discount)
					,$this->equalTo($date)
					,$this->equalTo($description));

		
		$this->mgr->process_textcart($this->cart, $textcart, INSERT_MODE);
	}

}
