<?php
  // Set up

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_USERPWD, 'purchasing' . ":" . 'lastordersplease');
  curl_setopt($ch, CURLOPT_VERBOSE, true);

  // Create the order

  $order = array('order' => array('name' => 'A brand new order',
                                  'order_type' => 'preorder'));

  $endpoint = 'http://localhost:5000/api/orders.json';
  curl_setopt($ch, CURLOPT_URL, $endpoint);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($order));

  $output = json_decode(curl_exec($ch));
  $order_id = $output->id;

  $line_items = array(array('internal_sku' => '12345-123',
                            'cost' => 12.34,
                            'discount' => 5.0,
                            'drop_date' => '2015-12-25'),
                      array('internal_sku' => '123456-1234',
                            'cost' => 121.34,
                            'discount' => 15.0,
                            'drop_date' => '2015-12-24'));

  $order = array('order' => array('line_items_attributes' => $line_items));

  $endpoint = "http://localhost:5000/api/orders/{$order_id}.json";
  curl_setopt($ch, CURLOPT_URL, $endpoint);
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PATCH');
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($order));

  $output = json_decode(curl_exec($ch));

  var_dump($output);

  curl_close($ch);
?>
