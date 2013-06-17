<?php
//require_once('test/helper.php');
require_once('includes/utilities.inc');

class ExpandTest extends PHPUnit_Framework_TestCase {
	/**
	 * @group template
	 * @dataProvider expandables
	 */
	public function testExanpansion($template, $value, $default, $result) {
		$this->assertEquals(expand_template($template, $value, $default), $result);
	}

	public function expandables() {
		return array(
			array(null, '5', null, '5')  /** normal **/
			,array('2', null, null, '2')  /** use template **/

			,array('10', '5', null, '5') /** value override template one **/
			,array('10', '0', 'default', '0') /** value override template one **/
			,array('-#-', '5', 'default', '-5-') /** but not if # in it */
			,array('-@-', '5', 'default', '5') /** value override if formulat use default */
			,array('#-@', '5', 'default', '5-default') /** def can be use in template formula **/
			,array('-@-', null, 'default', '-default-')

			,array('-#-', '<<@>>', 'default', '-<<default>>-') /** ???? */

			,array('10', ':#:', null, ':10:') /** use template in value formula **/
			,array('10', ':#:@', 'default', ':10:default') /** use template  and default in value formula **/

			,array('(10)', '5', null, '10') /** template formula win **/
			,array('(@)', '5', '2+7', '9') /** template formula win **/
			,array('(!@)', '5', '2+7', '2+7') /** don't evaluate the expression **/

			,array(null, 0, 5, 0) /** discount bug **/

	
		);
	}
	
}
?>
