# Push Kiwi

![](http://i.uto.io/jk2ND)


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
- send pushes to several contacts at once


## How does it work ?

It uses the undocumented and not finished pushbullet API V2.

[SEE MY NOTES](https://github.com/marg51/pushkiwi/wiki/pushbullet-API-v2:-notes) about API V2

It uses [node-webkit](https://github.com/rogerwang/node-webkit) and [AngularJS](angularjs.org)

## It's WIP

It was just a try at first, inside another node-webkit/angularJS project. That's why it needs **a lot of refactor**, and **unit tests**.

So far, I have tested only with Mac OS X, it propably don't work on Windows or Linux, but it should be easily fixed.

## Install

#### Easy setup (Mac OS X)

```bash
git clone https://github.com/marg51/pushkiwi.git
cd pushkiwi
make
make start
```
**read _Makefile_ for more infos**

If everything is ok, the app should ask an API_KEY, this is the one you can find in [your profile](https://www.pushbullet.com/account)

_It uses node-webkit v0.8.6 (NodeJS 0.10.22) because v0.9.2 (NodeJS 0.11.9) may be incompatible with some NodeJS modules, but I didn't see any problem with push-kiwi so far_

#### OS X notifier

You have to install [node-osx-notifier](https://github.com/azoff/node-osx-notifier) so that you can have notifications.

```
[sudo] npm install -g node-osx-notifier
# We call it from the port 1337
# If you want to change it, you'll have to change the port in `coffee/controller.coffee`
node-osx-notifier 1337
```

## Roadmap


#### Soon 

- **refactor**
 - [x] use Angular's $http instead of NodeJS'
 - [ ] merge _main.coffee into others files
 - [x] We can be notified from pushbullet when there is an update (new push is an update, deleting a push leads to an update, etc.), but it does not tell anything else. We need to find a way to discover what happened. (diff ?)
 	- as soon as we know what is updated, uses natives notifications systems (Mac OS X: ok)
- **Unit tests**
 - [ ] TDR (test driven refactoring) sounds really cool
- **form validation**
 - [ ] So far, there is no validation at all
- **improve load time**
 - [x] pushbullet isn't really fast so far, we need to cache as many requests as we can, including `GET /contacts` and `GET /pushes`
- **upload files**
 - [ ] would be nice to choose where (which server) to upload the files
- **Design**
 - [ ] something clean


#### Later

- [ ] build a better (more robust) pushbullet API client, and outsource it
- [ ] Allow to upload a file/note/email/... from anywhere on the desktop via right click ( not a clue how to do that, but MacVim do it, should be fun )
