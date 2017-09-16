angular.module("list")
    .directive("listItem",function () {

        return{
            restrict:'AE',
            require:'^list',
            scope:{
                label:"@",
                icon:"@",
                route:"@"
            },
            replace:true,
            templateUrl:'ext-modules/list/listItemTemplate.html'
        };
    })