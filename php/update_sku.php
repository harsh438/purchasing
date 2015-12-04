<?php
  $opts = array('manufacturer_color' => 'Pale Red',
                'barcodes_attributes' => array(array('barcode' => '12345'),
                                               array('barcode' => '54321')));

  $endpoint = 'http://localhost:5000/api/skus/1.json';

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $endpoint);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  // curl_setopt($ch, CURLOPT_USERPWD, 'purchasing' . ":" . 'lastordersplease');
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PATCH');
  curl_setopt($ch, CURLOPT_VERBOSE, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($opts));

  $output = curl_exec($ch);

  var_dump($output);

  curl_close($ch);
?>
