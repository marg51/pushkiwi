# Push Kiwi

![](http://i.uto.io/TQyMT)


## [Pushbullet](https://www.pushbullet.com) desktop application

_This is mainly a work in progress_

![](http://i.uto.io/jk5MA)

## What can I do ?

- look at your pushes (notes, links, files, images, addresses, checklists)
- look at your sent pushes
- delete any push
- update checklists

***

- send pushes to your contacts (notes, links, addresses, checklists)
- you only can send files URL, not upload them yet
- send pushes to many contacts at once


## How does it work ?

It uses the undocumented and not finished pushbullet API V2.

It uses [node-webkit](https://github.com/rogerwang/node-webkit) and [AngularJS](angularjs.org)

## It's WIP

It was just a try at first, inside another node-webkit/angularJS project. That's why it needs **a lot of refactorization**, and **unit tests**

## roadmap


#### Soon 

- **refactor**
 - use Angular's $http instead of NodeJS'
 - merge _main.coffee into others files
 - We can be notified from pushbullet when there is an update (new push is an update, deleting a push leads to an update, etc.), but it does not tell anything else. We need to find a way to discover what happened. (diff ?)
 	- as soon as we know what is updated, uses natives notifications systems
- **Unit tests**
 - TDR (test driven refactoring) sounds really cool
- **improve load time**
 - pushbullet isn't really fast so far, we need to cache as many requests as we can, including `GET /contacts` and `GET /pushes`
- **update files**
 - would be nice to choose where (which server) to upload the files
- **Design**
 - something clean


#### Later

- build a better (more robust) pushbullet API client, and outsource it
- Allow to update a file/note/email... right from the desktop via right click ( not a clue how to do that, but MacVim do it, should be fun )
