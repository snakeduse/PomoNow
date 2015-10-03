var pomodoroApp = angular.module('pomodoroApp', ['ngMaterial'])
      .config(function($mdThemingProvider) {
        $mdThemingProvider.theme('default')
          .primaryPalette('light-green')
          .accentPalette('orange');
      });
