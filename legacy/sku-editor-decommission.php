<?php

# SKU EDITOR tool is has now been decommissioned
if (!isset($_REQUEST['legacy'])) {
$pid = '';
if ($_REQUEST['pid']) {
  $pid_param = $_REQUEST['pid'];
  $pid = "<h2><a href='https://www.surfdome.io/admin/products/$pid_param/edit'>Edit Product name in spree</a></h2>";
}
echo <<<EOT
<!DOCTYPE html>
<html>
<head>
  <title>Tool decommissioned</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
</head>
<body style="background-color:rgb(238, 238, 243)">
  <center style="margin-top:100px">
    <h1>
      The SKU Editor tool has now been decommissioned<br>
      Please use the purchasing app to edit/create SKUs instead.
    </h1>
    <hr>
    $pid
  </center>
</body>
</html>
EOT;
exit;
}

