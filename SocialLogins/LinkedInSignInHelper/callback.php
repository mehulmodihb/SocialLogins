<?php
ob_start();
function curPageURL() {
            $pageURL = 'http';
            if(isset($_SERVER["HTTPS"]))
            if ($_SERVER["HTTPS"] == "on") {
                $pageURL .= "s";
            }
            $pageURL .= "://";
            if ($_SERVER["SERVER_PORT"] != "80") {
                $pageURL .= $_SERVER["SERVER_NAME"] . ":" . $_SERVER["SERVER_PORT"] . $_SERVER["REQUEST_URI"];
            } else {
                $pageURL .= $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"];
            }
            return $pageURL;
        }
        curPageURL();
        $appUrl = str_replace("http://localhost:8080/", "oauth-linkedin://", curPageURL());
        header("HTTP/1.1 301 Moved Permanently");
        header("Location: ".$appUrl);
?>