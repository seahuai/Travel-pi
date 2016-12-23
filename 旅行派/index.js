/**
 * Created by zhangsihuai on 16/12/21.
 */
window.onload = function(){
    var images = document.getElementsByTagName("img");
    for(var i=0;i<images.length;i++){
        var img = images[i];
        img.id = i;
        img.onLongPress = function () {
            window.location.href = 'zsh:///longPressImage'
        };
    }
};
