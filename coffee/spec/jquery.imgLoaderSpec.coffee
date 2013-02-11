(($, window, document)->

    describe "jquery.imgLoader テスト", ->
        $testNode = $ $.parseHTML '<img data-src="http://cdn-ak.f.st-hatena.com/images/fotolife/k/kkeisuke/20121125/20121125000903.jpg" alt="" width="" height="" />'
        imgLoader = new $.imgLoader $testNode
        eventNS = ".imgLoader"
        option =
            pipe:1
            loaded:(flg)->
        imgLoader.setOption option
        imgLoader.init()

        all = [imgLoader]
        controller = new $.imgLoader.Controller $testNode, all, option.pipe

        it "jquery.imgLoader init テスト", ->
            expect(imgLoader.src).toBe $testNode.data "src"
            expect(imgLoader.option.pipe).toBe option.pipe
            expect(imgLoader.eventNS).toBe eventNS
            expect(imgLoader.dfd).toNotBe null
            @

        it "$.imgLoader.Controller プロパティ テスト", ->
            expect(controller.$this).toBe $testNode
            expect(controller.index).toBe 0
            expect(controller.all.length).toBe all.length
            expect(controller.max).toBe all.length
            expect(controller.pipe).toBe option.pipe
            expect(controller.dfd).toNotBe null
            expect(controller.success).toBe null
            @

        it "jquery.imgLoader load テスト", ->
            doneFlg = false
            dfd = controller.load().done ($img, flg)->
                doneFlg = flg
                @
            waitsFor( ->
                dfd.state() == "resolved"
            ,"timeout", 1000)
            runs ->
                expect(imgLoader.src).toBe $testNode.prop "src"
                expect(controller.success).toBe true
                expect(doneFlg).toBe true
                @
            @
        @

) jQuery, @, @document