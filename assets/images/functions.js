
function my(){
    var a=document.querySelectorAll('[data-test="app-sign-in-subtitle"]');
    var aa=document.querySelectorAll('[data-test="app-sign-in-icon"]');
    if (a.length>=1 || aa.length>=1 ){
    window.flutter_inappwebview.callHandler('filedownloadfluuter', "Yes");
    }else{
    window.flutter_inappwebview.callHandler('filedownloadfluuter', "No");
    }}
    