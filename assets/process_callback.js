var _clientId = window.document.querySelector("meta[name='naver-login-client-id']")
                    .getAttribute("content");
var _callbackUrl = window.document.querySelector("meta[name='naver-login-callback-url']")
                    .getAttribute("content");
var nil = new naver_id_login(_clientId, _callbackUrl);

var process_callback = function() {
    nil.init_naver_id_login_callback();  console.log("after init_naver_login_callback");
    nil.get_naver_userprofile("jsCallback()");
}

var jsCallback = function() {
    console.log(nil.getProfileData('age'));

    var opener = window.opener;
    if (opener == null) {
        window.open("http://localhost:10000/#/login", "opener");
    }
    
    var result = {
        "status": nil.getOauthStatus(),
        "accessToken": nil.getAccessToken(),
        "errorMessage": nil.getOauthMessage(),
        "account": nil.inner_profileParams,
        // {
            // "age": nil.getProfileData("age"),
            // "birthday": nil.getProfileData("birthday"),
            // "email": nil.getProfileData("email"),
            // "enc_id": nil.getProfileData("enc_id"),
            // "gender": nil.getProfileData("gender"),
            // "id": nil.getProfileData("id"),
            // "nickname": nil.getProfileData("nickname"),
            // "profile_image": nil.getProfileData("profile_image"),
        // },
    }
    
    opener.postMessage(result, "http://localhost:10000/#/login");
    // opener.postMessage(result, "*");
    // window.close();
}