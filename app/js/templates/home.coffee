{R, rx, bind, $, _} = require "../deps.coffee"
{AppContext} = require '../contexts.coffee'
{ROUTES} = urls = require "../urls.coffee"
{PostsListView} = require "./posts-list.coffee"
{DemoView} = require "./demo.coffee"

exports.MainView = ({appContext}) ->
  console.log "Loading MainView"
  R.div {class: 'container'}, [
    R.div {class: 'header'}, [
      R.h1 {}, "Reactive Coffee Web Starter"
    ]
    R.div {class: 'body'}, [
      R.div {id: 'page-content'}, bind -> [
        navMenu({appContext})
        switch appContext?.mode.get()
          when AppContext.INTRODUCTION
            R.div {}, [
              R.h3 {}, "Welcome to the Reactive Coffee Web Starter demo."
            ]
          when AppContext.POSTS_LIST
            PostsListView({context: AppContext.postListContext})
          when AppContext.DEMO
            DemoView({context: AppContext.demoContext})
          else
            R.div {}, [
              R.a {href: urls.urlFor ROUTES.INTRODUCTION}, "Introduction"
              R.a {href: urls.urlFor ROUTES.POSTS_LIST}, "Loading Data"
              R.a {href: urls.urlFor ROUTES.DEMO}, "Reactive Demo"
            ]
        ]
      ]
    ]

navMenu = ({appContext}) ->
  R.ul {class: "nav nav-pills"}, [
    R.li {class: bind -> if appContext.mode.get()==AppContext.INTRODUCTION then "active" else ""},
      R.a {href: urls.urlFor ROUTES.INTRODUCTION}, "Introduction"
    R.li {class: bind -> if appContext.mode.get()==AppContext.POSTS_LIST then "active" else ""},
      R.a {href: urls.urlFor ROUTES.POSTS_LIST}, "Loading Data"
    R.li {class: bind -> if appContext.mode.get()==AppContext.DEMO then "active" else ""},
      R.a {href: urls.urlFor ROUTES.DEMO}, "Reactive Demo"
  ]
