
(function($, window, document) {
  $.imgLoader = (function() {

    function imgLoader($target) {
      this.$target = $target;
      this.dfd = null;
      this.src = null;
      this.eventNS = ".imgLoader";
      this.option = {
        pipe: 0,
        loaded: function($img) {}
      };
    }

    $.extend(imgLoader.prototype, {
      setOption: function(option) {
        if (option === void 0) {
          return;
        }
        $.extend(this.option, option);
        return this;
      },
      init: function() {
        this.dfd = $.Deferred();
        this.dfd.promise();
        this.src = this.$target.data("src");
        this._on();
        return this;
      },
      _on: function() {
        var _this = this;
        this.$target.on("load" + this.eventNS, function() {
          _this.$target.off(_this.eventNS);
          _this.option.loaded.call(_this.$target, true);
          _this.dfd.resolve(_this.$target);
          return _this;
        });
        return this.$target.on("error" + this.eventNS, function() {
          _this.$target.off(_this.eventNS);
          _this.option.loaded.call(_this.$target, false);
          _this.dfd.reject(_this.$target);
          return _this;
        });
      },
      load: function() {
        this.$target.prop("src", this.src);
        return this.dfd;
      }
    });

    $.fn.imgLoader = function(option) {
      var all, controller;
      all = [];
      this.each(function(i) {
        var instance;
        instance = new imgLoader($(this));
        instance.setOption(option);
        instance.init();
        all[i] = instance;
        return this;
      });
      controller = new $.imgLoader.Controller(this, all, option.pipe);
      return controller.load();
    };

    return imgLoader;

  })();
  return $.imgLoader.Controller = (function() {

    function Controller($this, all, pipe) {
      this.$this = $this;
      this.index = 0;
      this.all = all;
      this.max = all.length;
      this.pipe = pipe || this.max;
      this.dfd = null;
      this.success = null;
      this._init();
    }

    Controller.prototype._init = function() {
      this.dfd = $.Deferred();
      this.dfd.promise();
      return this;
    };

    Controller.prototype.load = function() {
      var dfds, end, pipes,
        _this = this;
      end = this.index + this.pipe;
      pipes = this.all.slice(this.index, end);
      dfds = $.map(pipes, function(ins) {
        return ins.load();
      });
      $.when.apply($, dfds).done(function() {
        _this.dfd.notify(_this.$this.slice(_this.index, end), true);
        return _this;
      }).fail(function() {
        _this.success = false;
        _this.dfd.notify(_this.$this.slice(_this.index, end), _this.success);
        return _this;
      }).always(function() {
        _this.index += _this.pipe;
        if (_this.index < _this.max) {
          _this.load();
        } else if (_this.success === null) {
          _this.success = true;
          _this.dfd.resolve(_this.$this, _this.success);
        } else {
          _this.dfd.reject(_this.$this, _this.success || false);
        }
        return _this;
      });
      return this.dfd;
    };

    return Controller;

  })();
})(jQuery, this, this.document);
