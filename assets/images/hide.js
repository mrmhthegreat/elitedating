
console.log(document.querySelectorAll('[data-test="app-sign-in-icon"]').length>=1);
if (document.querySelectorAll('[data-test="app-sign-in-icon"]').length>=1 || document.querySelectorAll('[data-test="app-sign-in-subtitle"]').length>=1 ){
window.flutter_inappwebview.callHandler('filedownloadfluuter', "Yes");
}else{
window.flutter_inappwebview.callHandler('filedownloadfluuter', "No");
}