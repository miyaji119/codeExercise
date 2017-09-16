angular.module("framework")
    .directive("framework",function () {

        return{
            restrict:'AE',
            scope:{
                appTitle:"@",
                logo:"@"
            },
            replace:true,
            transclude:true,
            controller:'frameworkController',
            templateUrl:'ext-modules/framework/frameworkTemplate.html'
        };
    })