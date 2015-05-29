#!/bin/bash

fileOutput="/var/www/html/owplot/index.html/$1.php"
str="<html><head><meta charset=\"UTF-8\"><link type=\"text/css\" href=\"/owplot/js/gnuplot_mouse.css\" rel=\"stylesheet\"></head><body oncontextmenu=\"return false;\"><td align=\"center\"><script src=\"/owplot/js/canvastext.js\"></script><script src=\"/owplot/js/gnuplot_common.js\"></script><script src=\"/owplot/js/gnuplot_mouse.js\"></script><script src=\"/owplot/owping/$1/$1.js\"></script><table class=\"plot\"><tbody><tr><td><canvas id=\"gnuplot_canvas\" width=\"1000\" height=\"660\" onkeypress=\"gnuplot.do_hotkey()\" tabindex=\"0\"></canvas><script>gnuplot.grid_lines = true;gnuplot.zoomed = false;gnuplot.active_plot_name =\"gnuplot_canvas\";gnuplot.active_plot = function(){gnuplot_canvas();};if (window.attachEvent) {window.attachEvent('onload', gnuplot.active_plot);}else if (window.addEventListener) {window.addEventListener('load', gnuplot.active_plot, false);}else {document.addEventListener('load', gnuplot.active_plot, false);}</script></td></tr><tr><td><table id=\"gnuplot_mousebox\" class=\"mbunder\"><tbody><tr><td class=\"icon\" onclick=\"gnuplot.toggle_grid();\"><img src=\"/owplot/js/grid.png\" id=\"gnuplot_grid_icon\" alt=\"#\" title=\"toggle grid\"></td><td class=\"icon\" onclick=\"gnuplot.unzoom();\"><img src=\"/owplot/js/previouszoom.png\" id=\"gnuplot_unzoom_icon\" alt=\"unzoom\" title=\"unzoom\"></td>
<td class=\"icon\" onclick=\"gnuplot.rezoom();\"><img src=\"/owplot/js/nextzoom.png\" id=\"gnuplot_rezoom_icon\" alt=\"rezoom\" title=\"rezoom\"></td><td class=\"icon\" onclick=\"gnuplot.toggle_plot(&quot;funcPlot_plot_1&quot;)\"></td>
		    <td class=\"mb0\">x</td>
		    <td class=\"mb1\"><span id=\"gnuplot_canvas_x\"></span></td>
		    <td class=\"mb0\">y</td>
		    <td class=\"mb1\"><span id=\"gnuplot_canvas_y\"></span></td>
	      </tr></tbody></table>
	       Options<br><br>
	      <form action=\"\" method=\"POST\">
		From date:<br>
		<input type=\"text\" name=\"fromdate\" value="">
		<br>
		To date:<br>
		<input type=\"text\" name=\"todate\" value="">
		<br><br>
		 
		Start time:<br>
		<input type=\"text\" name=\"starttime\" value="">
		<br>End time:<br>
		<input type=\"text\" name=\"endtime\" value="">
		<br><br>

		<input type=\"radio\" name=\"option\" value=\"l\"> Owping Loss<br>
                <input type=\"radio\" name=\"option\" value=\"d\"> Owping Delay<br>
		<input type=\"radio\" name=\"option\" value=\"j\"> Owping Jitter<br>
		<br>
		<input type=\"submit\" value=\"Submit\">
	      </form>
		 <?php
		 \$fromdate = \$_POST[\"fromdate\"];
                 \$todate = \$_POST[\"todate\"];
                 \$parsedFromDate = date_parse_from_format(\"n-j-y\",\$fromdate);
                 \$parsedToDate = date_parse_from_format(\"n-j-y\",\$todate);
                 if (\$parsedFromDate[\"error_count\"] == 0 && checkdate(\$parsedFromDate[\"month\"], \$parsedFromDate[\"day\"], \$parsedFromDate[\"year\"]))
		   \$checkedFromDate =  \$fromdate;  
                 if(\$parsedToDate[\"error_count\"] == 0 && checkdate(\$parsedToDate[\"month\"], \$parsedToDate[\"day\"], \$parsedToDate[\"year\"]))
		  \$checkedToDate =  \$todate;
                 \$text = \"\$checkedFromDate~\$checkedToDate\n\";
		 \$file = fopen(\"/etc/owping/$1/outDate.txt\",\"w\") or dieWithError(\"Unable to create file.\");
		 fwrite(\$file, \$text);
		 fclose(\$file);
                 function checktime(\$hour, \$min) {
		   if (\$hour < 0 || \$hour > 23 || !is_numeric(\$hour)) {
		     return false;
		   }
		   if (\$min < 0 || \$min > 59 || !is_numeric(\$min)) {
		     return false;
		   }
		   return true;
		 }
                 \$starttime = \$_POST[\"starttime\"];
                 \$endtime = \$_POST[\"endtime\"];
                 \$parsedStartTime = date_parse_from_format(\"h:i\",\$starttime);
                 \$parsedEndTime = date_parse_from_format(\"h:i\",\$endtime); 
                 if (\$parsedStartTime[\"error_count\"] == 0 && checktime(\$parsedStartTime[\"hour\"], \$parsedStartTime[\"minute\"]))
		   \$checkedStartTime =  \$starttime;  
                 if(\$parsedEndTime[\"error_count\"] == 0 && checktime(\$parsedEndTime[\"hour\"], \$parsedEndTime[\"minute\"]))
		   \$checkedEndTime =  \$endtime;
                 \$text2 =  \"\$checkedStartTime~\$checkedEndTime\n\";
                 \$file2 = fopen(\"/etc/owping/$1/outTime.txt\",\"w\") or dieWithError(\"Unable to create file.\");
		 fwrite(\$file2, \$text2);
		 fclose(\$file2);
                 \$opt = \$_POST[\"option\"];
                 \$text3=\"\$opt\n\";                 
                 \$file3= fopen(\"/etc/owping/$1/outOpt.txt\",\"w\") or dieWithError(\"Unable to create file.\");
		 fwrite(\$file3, \$text3);
		 fclose(\$file3);
                 \$updatetime=date('m/d/Y h:i:s a');
                 \$text4=\"\$updatetime\n\";
                 \$file4= fopen(\"/etc/owping/lastupdated.txt\",\"w\") or dieWithError(\"Unable to create file.\");
		 fwrite(\$file4, \$text4);
		 fclose(\$file4);
                 \$file5= fopen(\"/etc/owping/tk.txt\",\"w\") or dieWithError(\"Unable to create file.\");
		 fwrite(\$file5, \"$1\n\");
                 sleep(10);
		 ?> 
		 <br>Note:
                 <ul><li>(Date format  mm-dd-yy)
                 </li><li>(Time format H:M)
	      </li><li>Zoom using right (Firefox, Konqueror) or center (Opera, Safari) mouse button
		</li><li>Mark point using left mouse button
		</li><li>➀ toggles first plot on/off&nbsp;&nbsp;  # toggles grid on/off
	      </li></ul>
	  </td></tr>
	</tbody>
      </table>
    </td>
  </body>
</html>
"
echo $str>$fileOutput
