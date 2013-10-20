angular.module("app").controller "UsersIndexController", [
  "$scope",
  "User",
  ($scope, User)->

    updateUsers = ()->
      User.all().then (users)->
        $scope.users = users

    updateUsers()

    $scope.add = ()->
      view = new steroids.views.WebView "/views/users/new.html"
      steroids.layers.push view

    $scope.show = (user)->
      view = new steroids.views.WebView "/views/users/show.html?id=#{user.id}"
      steroids.layers.push view

    document.addEventListener "visibilitychange", ()->
      updateUsers() if document.visibilityState is "visible"

    steroids.view.navigationBar.show "Users"
]

angular.module("app").controller "UsersShowController", [
  "$scope",
  "User",
  ($scope, User)->

    loadUser = ()->
      User.get(steroids.view.params.id).then (user)->
        $scope.user = user
    loadUser()

    document.addEventListener "visibilitychange", ()->
      loadUser() if document.visibilityState is "visible"

    $scope.edit = (user)->
      view = new steroids.views.WebView "/views/users/edit.html?id=#{user.id}"
      steroids.layers.push view

    $scope.remove = (user)->
      User.destroy(user.id).then ()-> steroids.layers.pop()

]

angular.module("app").controller "UsersNewController", [
  "$scope",
  "User",
  ($scope, User)->
    $scope.user = {}
    $scope.buttonText = "Create"
    $scope.save = ()->
      User.create($scope.user).then ()-> steroids.layers.pop()

    steroids.view.navigationBar.show "New user"
]

angular.module("app").controller "UsersEditController", [
  "$scope",
  "User",
  ($scope, User)->
    $scope.buttonText = "Update"

    loadUser = ()->
      User.get(steroids.view.params.id).then (user)->
        $scope.user = user
    loadUser()

    $scope.save = ()->
      User.update($scope.user).then ()-> steroids.layers.pop()

    steroids.view.navigationBar.show "Edit user"
]