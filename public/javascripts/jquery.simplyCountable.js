(function($){
 
  $.fn.simplyCountable = function(options){
    
    options = $.extend({
      counter: '#counter',
      countType: 'characters',
      maxCount: 160,
      countDirection: 'down',
      safeClass: 'safe',
      overClass: 'over'
    }, options);
    
    var countable = this;
    
    var countCheck = function(){
           
      if (options.countType === 'words'){
        var count = options.maxCount - countable.val().split(/[\s]+/).length;
        if (countable.val() === '') count += 1;
      }
      else var count = options.maxCount - countable.val().length;
      
      if (!$(options.counter).hasClass(options.safeClass) && !$(options.counter).hasClass(options.overClass)){
        if (count < 0) $(options.counter).addClass(options.overClass);
        else $(options.counter).addClass(options.safeClass);
      }
      else if (count < 0 && $(options.counter).hasClass(options.safeClass)){
        $(options.counter).removeClass(options.safeClass).addClass(options.overClass);
      }
      else if (count >= 0 && $(options.counter).hasClass(options.overClass)){
        $(options.counter).removeClass(options.overClass).addClass(options.safeClass);
      }
      
      if (options.countDirection === 'up'){
        count = count - (count*2) + options.maxCount;
      }
      
      $(options.counter).text(count);
    };
    countCheck();
    
    countable.keyup(countCheck);
    
  };
 
})(jQuery);
