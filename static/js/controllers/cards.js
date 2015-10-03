pomodoroApp.controller('CardsCtrl', ["$scope", "$http", "$interval", "$mdDialog", function ($scope, $http, $interval, $mdDialog) {
$scope.showDialog = function ($event) {
    var parentEl = angular.element(document.body);
    $mdDialog.show({
      parent: parentEl,
      targetEvent: $event,
      template:
      '<md-dialog aria-label="List dialog">' +
        '  <md-dialog-content>'+
        '   <h5>Создать карточку</h5>'+
        '<md-input-container md-no-float class="md-input-has-placeholder md-default-theme">'+
        '<label>Color</label>'+
        '<input type="text" ng-model="title" required>'+
        '</md-input-container>'+
        '  </md-dialog-content>' +
        '  <div class="md-actions">' +
        '    <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="" ng-click="createCard()">' +
        '      Создать' +
        '      </a>' +
        '    ' +
        '    <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="" ng-click="closeDialog()">' +
        '      Закрыть' +
        '    </a>' +
        '  </div>' +
        '</md-dialog>',
      locals: {
        items: [1,2,3,4,5]
      },
      controller: function ($scope, $mdDialog, items) {
        $scope.items = items;
        $scope.closeDialog = function() {
          $mdDialog.hide();
        };
        $scope.createCard = function(){
          console.log('Create card ' + $scope.title);
        };
      }
    });
  };
}]);
