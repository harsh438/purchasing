<?php
  $opts = array('order' => ['name' => 'A new order',
                            'type' => 'preorder']);

  $endpoint = 'http://localhost:5000/api/orders.json';

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $endpoint);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_USERPWD, 'purchasing' . ":" . 'lastordersplease');
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_VERBOSE, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($opts));
  $output = curl_exec($ch);


  var_dump($output);

  curl_close($ch);
?>
