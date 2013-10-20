# super simple model service for local storage
angular.module("app").service "User", [
  "$q",
  "LocalStorageFactory",
  ($q, LocalStorageFactory)->
    localStorageInstance = new LocalStorageFactory model: "User"
]