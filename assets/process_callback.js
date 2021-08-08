var process_callback = function() {
    var _clientId = window.document.querySelector("meta[name='naver-login-client-id']")
                        .getAttribute("content");
    var _callbackUrl = window.document.querySelector("meta[name='naver-login-callback-url']")
                        .getAttribute("content");
                        
    var nil = new naver_id_login(_clientId, _callbackUrl);

    nil.init_naver_id_login_callback();  console.log("after init_naver_login_callback");
    nil.get_naver_userprofile("jsCallback()");
}

var jsCallback = function() {
    console.log(nil.getProfileData('age'));

    var opener = window.opener;
    if (opener == null) {
        window.open("http://localhost:10000/#/login", "opener");
    }
    // opener.postMessage(result, "http://localhost:10000/#/login");
    // opener.postMessage(result, "*");
    window.close();
}