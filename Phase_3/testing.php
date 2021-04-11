<?php include "lib/header.php";
include('lib/init.php'); ?>
<form method="post">
    <input type="submit" name="test" id="test" value="RUN" /><br/>
    <input type="submit" name="test2" id="test2" value="RUN2" /><br/>
</form>

<?php

function testfun()
{
   echo "Your test function on button click is working";
}

function testfun2()
{
   echo "Your test function 2 on button click is working";
}

if(array_key_exists('test',$_POST)){
   testfun();
}else if(array_key_exists('test2',$_POST)){
    testfun2();
}

?>


<?php include "lib/footer.php"; ?>