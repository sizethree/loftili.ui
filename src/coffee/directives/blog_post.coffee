lft.directive 'lfBlogPost', ['$sce', ($sce) ->

  lfBlogPost =
    replace: true
    templateUrl: 'directives.blog_post'
    scope:
      post: '='
    link: ($scope, $element, $attrs) ->
      console.log $scope.post

      $scope.title = () ->
        $sce.trustAsHtml $scope.post.title

]

