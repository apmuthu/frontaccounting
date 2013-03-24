<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Dashboard application
// Free software under GNU GPL
***********************************************************************/

class dashboard_app extends application
{
    var $widgets;
    var $apps;

	function dashboard_app()
	{
		$this->application("Dashboard", _($this->help_context = "&Dashboard"));

        //$this->add_module(_("Dashboard"));
        $this->widgets = array();
        $this->add_extensions();

        $this->apps = array("orders"=>_("Sales"),
                        "AP"=>_("Purchases"),
                        "stock"=>_("Items and Inventory"),
                        "manuf"=>_("Manufacturing"),
                        "GL"=>_("Banking and General Ledger"),
                        "Dashboard"=>_("Dashboard"));
	}

      function add_widget($name,$title,$path="",$access='SA_OPEN')
      {
          $widget = new widget($name,$title,$path,$access);
          $this->widgets[] = $widget;
          return $widget;
      }

      function get_widget($name)
      {
            foreach ($this->widgets as $widget)
            {
                if ($widget->name == $name)
                  return $widget;
            }
            return null;
      }

      function get_widget_list()
      {

          $list = array();
          foreach ($this->widgets as $widget)
          {
                if ($_SESSION["wa_current_user"]->can_access_page($widget->access))
                {
                    $list[$widget->name] = $widget->title;
                }
          }
          return $list;
      }

	  function render_index()
	  {
	  		global $path_to_root;

            echo '<div id="console" ></div>';

            $userid = $_SESSION["wa_current_user"]->user;
            $sql = "SELECT DISTINCT column_id FROM ".TB_PREF."dashboard_widgets"
                    ." WHERE user_id =".db_escape($userid)
                    ." AND app='$this->id'"
                    ." ORDER BY column_id";
            $columns=db_query($sql);
            while($column=db_fetch($columns))
            {
                  echo '<div class="column" id="column'.$column['column_id'].'" >';
                  $sql = "SELECT * FROM ".TB_PREF."dashboard_widgets"
                        ." WHERE column_id=".db_escape($column['column_id'])
                        ." AND user_id = ".db_escape($userid)
                        ." AND app='$this->id'"
                        ." ORDER BY sort_no";
                  $items=db_query($sql);
                  while($item=db_fetch($items))
                  {
                      $widgetData = $this->get_widget($item['widget']);
                      echo '
                      <div class="dragbox" id="item'.$item['id'].'">
                          <h2>'.$item['description'].'</h2>
                              <div id="widget_div_'.$item['id'].'" class="dragbox-content" ';
                      if ($item['collapsed']==1)
                          echo 'style="display:none;" ';
                      echo '>';
                      if ($widgetData != null) {
                          if ($_SESSION["wa_current_user"]->can_access_page($widgetData->access))
                          {
                              include_once ($path_to_root . $widgetData->path);
                              $className = $widgetData->name;
                              $widgetObject = new $className($item['param']);
                              $widgetObject->render($item['id'],$item['description']);
                          } else {
                              echo "<center><br><br><br><b>";
                              echo _("The security settings on your account do not permit you to access this function");
                              echo "</b>";
                              echo "<br><br><br><br></center>";
                          }
                      }
                      echo '</div></div>';
                  }
                  echo '</div>';
            }
      }

}

class widget
{
    var $name;
    var $app;
    var $title;
    var $path;
    var $access;

    function widget($name,$title,$path,$access='SA_OPEN')
    {
        $this->name = $name;
        $this->title = $title;
        $this->path = $path;
        $this->access = $access;
    }

    function render($id, $title)
    {
      // override this function to prepare the widget for display
      // $id is the database id of the row in dashboard_widgets table
      // and should be used to identify the div containing this iteration of the widget
      // $title is the widget title retrieved from dashboard_widgets
    }

    function edit_param()
    {
      // override this function to display the form to collect the parameters that
      // will be passed to the iteration of the widget to be displayed
    }

    function validate_param()
    {
      // override this function to validate the widget's parameters into
      // a json string and save in database row
    }

    function save_param()
    {
      // override this function to format the widget's parameters into
      // a json string and save in database row
    }
}

?>