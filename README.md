![image](https://cloud.githubusercontent.com/assets/1545348/9282296/5d1ad892-4299-11e5-9379-5b593bc8c3bf.png)

[![Build Status](https://travis-ci.org/loftili/ui.svg?branch=master)](https://travis-ci.org/loftili/ui)

The loftili ui (LFTUI) is the browser-side application that is the most user-facing side of the loftili platform. It is the source code in this repository that the user is ultimately interacting with on [loftili.com](https://loftili.com). The code is structured around [angularjs](https://angularjs.org).

## building

The source code for LFTUI is split into three different languages - `sass`, `jade`, and `coffeescript` - with each having their own directory in the [src](https://github.com/loftili/ui/tree/master/src) directory. Each of these languages gets compiled into their final form - `css`, `html` and `javascript`, respectively. The compilation of these assets requires [nodejs](http://nodejs.org) to run. To get up an running, you need to take care of a few things first:


### 1. download and install [node](https://nodejs.org/download/)

The version of node does not matter too much - it is only required for the compilation of the assets. If you are planning on working on the [api](https://github.com/loftili/api) and the ui at the same time however, it would be wise to check out the README in that project for more specific instructions.


### 2. install the [grunt-cli](https://github.com/gruntjs/grunt-cli) and [bower](https://github.com/bower/bower) command line tools

[Grunt](http://gruntjs.com) is very similar to [rake](https://github.com/ruby/rake), [make](https://www.gnu.org/software/make/) or other build utility programs. It uses the [Gruntfile.js](https://github.com/loftili/ui/blob/master/Gruntfile.js) file to read in all of the user-configured buid tasks and targets, executing the ones the user requested. From gruntjs.com:

> The Grunt ecosystem is huge and it's growing every day. With literally hundreds of plugins to choose from, you can use Grunt to automate just about anything with a minimum of effort. If someone hasn't already built what you need, authoring and publishing your own Grunt plugin to npm is a breeze. 

[Bower](http://bower.io/) is like the browser-side equivalent of npm. It uses the [bower.json](https://github.com/loftili/ui/blob/master/bower.json) to maintain a record of libraries and frameworks the application depends on. Ultimately, these libraries will end up in the user's browser, most likely though a [concatenation](https://github.com/loftili/ui/blob/master/Gruntfile.js#L167-L178) build step. This is where you will find [angular](https://github.com/loftili/ui/blob/master/bower.json#L18-L20) listed.

Both of these packages can be installed globally:

```
$ sudo npm install bower -g
$ sudo npm install grunt-cli -g
```
This will allow you to run the `grunt` and `bower` commands anywhere. If they are not installed globally, they might be usable via the local `./node_modules/.bin` directory.

### 3. install npm and bower packages

Now that bower is installed, you'll want to install *both* the npm packages as well as the bower packages. This looks like:

```
$ npm install
$ bower install
```

The packages installed during `npm install` are mostly grunt-specific packages that are used during the build process, mainly:

1. [grunt-contrib-coffee](https://github.com/gruntjs/grunt-contrib-coffee) - compiles the coffeescript to javascript
2. [grunt-angular-templates](https://github.com/ericclemmons/grunt-angular-templates) - compiles the `.jade` files to a single `.js` file that is usable by angular. each `jade` file turns into a block that looks like:
  ```
  angular.module("directives.edit_field", []).run(["$templateCache", function($templateCache) {
    $templateCache.put("directives.edit_field",
      "<div ng-click=\"toggle($event)\" ng-class=\"{editing:editing}\" class=\"edit-field\">\n" +
      "  <div ng-transclude=\"ng-transclude\" class=\"content\"></div>\n" +
      "</div>");
  }]);
  ```
3. [grunt-contrib-jade](https://github.com/gruntjs/grunt-contrib-jade) - compiles the `index.jade` into `index.html`
4. [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch) - re-runs tasks based on source changes
5. [node-sass](https://github.com/sass/node-sass) - instead of using the [grunt-contrib-sass](https://github.com/gruntjs/grunt-contrib-sass) task, we've rolled [our own](https://github.com/loftili/ui/blob/master/Gruntfile.js#L271-L325), which uses a native port of sass to compile our styles.

### 4. run grunt

At this point, you are able to run grunt and compile the source into it's final form:

![image](https://cloud.githubusercontent.com/assets/1545348/9306518/d80de84e-44c6-11e5-902d-048afd31061f.gif)

### 6. setup an `app.conf.json` file

In order to leave environment-specific configuration information out of the application source code, one of the first things the application does it [load in](https://github.com/loftili/ui/blob/master/src/coffee/app.coffee#L5-L17) an `app.conf.json` file. This file contains important information, namely the location of the [api](https://github.com/loftili/api). It also contains a url for the blog, which is used to pull in the static content for some of the pages. This can be set to `http://blog.loftili.com/wp-json/`, which points at the production wordpress blog instance, which as the [WP-API](https://github.com/WP-API/WP-API) extension instaleld.

```
{
  urls: {
    api: "http://127.0.0.1:1337",
    blog: "http://blog.loftili.com/wp-json/"
  },
  socket: {
    host: "127.0.0.1:1337",
    path: "/sock"
  },
  google: {
    tracking: "UA-XXXXXXX-X"
  }
}
```

### 5. run an http server from the public directory

At this point, you have plenty of options for "running" the code. All of the source has now been compiled into the `public` directory (which is ignored from git):

```
$ ls -lah ./public
total 32
drwxr-xr-x  11 dadley  staff   374B Aug 17 09:59 .
drwxr-xr-x  24 dadley  staff   816B Aug 17 10:01 ..
-rw-r--r--   1 dadley  staff   409B Jan 26  2015 .htaccess
-rw-r--r--   1 dadley  staff   130B Dec  8  2014 app.conf.example
-rw-r--r--   1 dadley  staff   210B Jun  3 16:56 app.conf.json
drwxr-xr-x   3 dadley  staff   102B Aug 17 09:58 css
drwxr-xr-x   4 dadley  staff   136B Aug 17 09:59 img
-rw-r--r--   1 dadley  staff   1.4K Aug 17 09:58 index.html
drwxr-xr-x   4 dadley  staff   136B Aug 17 09:59 js
drwxr-xr-x   7 dadley  staff   238B Jul 21 14:23 swf
drwxr-xr-x   4 dadley  staff   136B Feb 22 17:31 vendor
```

#### 5a. [http-server](https://github.com/indexzero/http-server) - a command line http server

This is by far the simplest approach, and after installing, getting up and running is as simple as:

```
$ cd ./public/
$ http-server
```

#### 5b. apache virtual host

```
<VirtualHost *:80>
  SSLProxyEngine On
  DocumentRoot "/your/source/directory/loftili/ui/public"
  ServerName local-ui.loftili.com
  ProxyPass /api/ http://localhost:1337/
</VirtualHost>
```


#### 5c. nginx server


```
server {
  listen 80;
  server_name localhost local-ui.loftili.com;
  client_max_body_size 200M;

  root /your/source/directory/loftili/ui/public;
  index index.html;

  location / {
    rewrite .* /index.html break;
  }

  location /api {
    client_max_body_size 200M;
    rewrite ^/api/(.*) /$1 break;
    proxy_redirect off;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_pass http://127.0.0.1:1337
  }
}
```

## contributing

Contributions are very welcome, and anyone interested in contributing to LFTAPI should follow the guide published by [github](https://guides.github.com/activities/contributing-to-open-source/), and [create an issue](https://github.com/loftili/api/issues), or just fork the repository, make your change, and open a [pull request](https://github.com/loftili/api/pulls).

## license 

Please see [LICENSE.txt](https://github.com/loftili/api/blob/master/LICENSE.txt)
