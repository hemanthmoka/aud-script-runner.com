<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
  $arg1 = $_POST["arg1"];
  $arg2 = $_POST["arg2"];

  $command = "sh Build.sh \"$arg1\"";
  $command2="echo "ssh \"$arg2\" > \"$arg2\".command ;chmod +x \"$arg2\".command;open \"$arg2\".command"
  #$command2="osascript -e "tell application \"Terminal\" to do script \"ssh \"$arg2\"\"
  if (!empty($arg2)) {
    foreach ($arg2 as $option) {
      $command = "$command2 \"$option\"";
    }
  }

  // Execute the shell script with the arguments
  $output = shell_exec($command);

  // Display the output
  echo "<pre>$output</pre>";
}
?>

