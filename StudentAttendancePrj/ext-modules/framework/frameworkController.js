"user strict";

angular.module('framework').controller('frameworkController',
    ['$scope','$window',
        function ($scope,$window) {

            $scope.stuNo = null;
            $scope.stuPwd = null;
            $scope.newStu = null;

            $scope.isListVisible = false;
            $scope.isLogin = false;

            $scope.listButtonClicked = function () {
                $scope.isListVisible = !$scope.isListVisible;
            };

            $scope.login = function () {
                //用户信息验证
                //
                //
                $scope.isLogin = true;
            };
        }
    ]);