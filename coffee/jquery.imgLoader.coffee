(($, window, document)->

    class $.imgLoader

        constructor:($target)->
            @$target = $target
            @dfd = null
            @src = null
            @eventNS = ".imgLoader" # イベント名前空間
            @option =
                pipe:0 # 一度に読み込む画像の数 ($.imgLoader.Controller で使用する)
                loaded:($img)-> # 個々の画像が読み込まれた時のコールバック

        # インスタンスメソッド
        $.extend imgLoader.prototype,
            # オプションを継承
            setOption:(option)->
                if option == undefined
                    return
                $.extend @option, option
                @
            init:->
                @dfd = $.Deferred()
                @dfd.promise()
                @src = @$target.data "src"
                @_on()
                @
            _on:->
                @$target.on "load" + @eventNS, =>
                    @$target.off(@eventNS)
                    @option.loaded.call @$target, true
                    @dfd.resolve @$target
                    @
                @$target.on "error" + @eventNS, =>
                    @$target.off(@eventNS)
                    @option.loaded.call @$target, false
                    @dfd.reject @$target
                    @
            load:->
                @$target.prop "src", @src
                @dfd

        $.fn.imgLoader = (option)->
            all = []
            @each (i)->
                instance = new imgLoader $ @
                instance.setOption option
                instance.init()
                all[i] = instance
                @
            controller = new $.imgLoader.Controller @, all, option.pipe
            controller.load()

    # 複数のローダーを管理するクラス。
    class $.imgLoader.Controller

        constructor:($this, all, pipe)->
            @$this = $this
            @index = 0
            @all = all
            @max = all.length
            @pipe = pipe || @max
            @dfd = null
            @success = null
            @_init()

        _init:->
            @dfd = $.Deferred()
            @dfd.promise()
            @

        load:->
            end = @index + @pipe
            pipes = @all.slice @index, end
            dfds = $.map pipes, (ins)->
                ins.load()
            $.when.apply($, dfds)
            .done(=>
                @dfd.notify (@$this.slice @index, end), true
                @
            ).fail(=>
                @success = false;
                @dfd.notify (@$this.slice @index, end), @success
                @
            ).always =>
                @index += @pipe
                if @index < @max
                    @load()
                else if @success == null
                    @success = true
                    @dfd.resolve @$this, @success
                else
                    @dfd.reject @$this, @success || false
                @
            @dfd

) jQuery, @, @document