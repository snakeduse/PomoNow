pomodoroApp.controller('LoginCtrl', ["$scope", "$http", function ($scope, $http, $interval) {
  $scope.isLoading = false;

  $scope.auth = function(){
    $scope.isLoading = true;
    $http.post('/auth',{email: $scope.email, password: $scope.password})
      .success(function (response, status, headers, config) {
        if(response.result){
          window.location = "app";
        } else {
          console.log(response.error);
        }
        $scope.isLoading = false;
      })
      .error(function (data, status, headers, config) {
        $scope.isLoading = false;
        console.log(data);
      });
  };
}]);
