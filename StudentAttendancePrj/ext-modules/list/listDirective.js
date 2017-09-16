angular.module("list")
    .directive("list",function () {

        return{
            restrict:'AE',
            replace:true,
            transclude:true,
            controller:'listController',
            templateUrl:'ext-modules/list/listTemplate.html'
        };
    })