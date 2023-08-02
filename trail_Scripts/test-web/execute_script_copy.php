<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
  $arg1 = $_POST["arg1"];
  $arg2 = $_POST["arg2"];

  $command = "sh Build.sh \"$arg1\"";
  if (!empty($arg2)) {
    foreach ($arg2 as $option) {
      $command .= " \"$option\"";
    }
  }

  // Execute the shell script with the arguments
  $output = shell_exec($command);

  // Display the output
  echo "<pre>$output</pre>";
}
?>
