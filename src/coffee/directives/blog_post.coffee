lft.directive 'lfBlogPost', ['$sce', ($sce) ->

  lfBlogPost =
    replace: true
    templateUrl: 'directives.blog_post'
    scope:
      post: '='
    link: ($scope, $element, $attrs) ->

]

