!function(){function o(){var o=$footer.outerHeight(),e=$(window).height();if(e>o){$("body").css("margin-bottom",o);var r=$(window).scrollTop()+e,t=r-($(document).outerHeight(!0)-o);$footer.addClass("fixed"),t>=0?$footer.removeClass("transparent"):$footer.addClass("transparent")}else $footer.removeClass("fixed").removeClass("transparent"),$("body").css("margin-bottom",0)}$footer=$("footer"),$(window).scroll(o),$(window).resize(o),o()}($);