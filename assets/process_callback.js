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
    var opener = window.opener;
    if (opener == null) {
        window.open("http://localhost:10000/#/login", "opener");
    }

    var result =
    {
        "status": "loggedIn",
        "accessToken": nil.getAccessToken(),
        "expiresAt": nil.oauthParams.expires_in,
        "tokenType": nil.oauthParams.token_type,
        "errorMessage": "",
        "age": nil.getProfileData("age"),
        "birthday": nil.getProfileData("birthday"),
        "email": nil.getProfileData("email"),
        "enc_id": nil.getProfileData("enc_id"),
        "gender": nil.getProfileData("gender"),
        "id": nil.getProfileData("id"),
        "nickname": nil.getProfileData("nickname"),
        "profile_image": nil.getProfileData("profile_image"),
    }
    
    opener.postMessage(result, "http://localhost:10000/#/login");
    // window.close();
}