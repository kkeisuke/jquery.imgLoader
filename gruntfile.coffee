module.exports = (grunt)->
    grunt.initConfig
        coffee:
            compile:
                files:
                    "js/jquery.imgLoader.js": ["coffee/jquery.imgLoader.coffee"]
                    "js/spec/jquery.imgLoaderSpec.js": ["coffee/spec/jquery.imgLoaderSpec.coffee"]
                options:
                    bare: true
        jshint:
            all: ["js/**/*.js"]
        jasmine:
            src: "js/*.js"
            options:
                specs: "js/spec/*Spec.js"
                vendor: "vender/jquery.min.js"
        watch:
            files: ["sass/**/*.sass", "coffee/**/*.coffee"]
            tasks: ["coffee", "jshint", "jasmine"]

    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-jshint"
    grunt.loadNpmTasks "grunt-contrib-jasmine"
    grunt.loadNpmTasks "grunt-contrib-watch"

    grunt.registerTask "default", ["watch"]