# Announcer
Plugin to post Steam group announcements from the comfort of the game chat.

![Example Command](https://bitbucket.org/Polvora/announcer/downloads/example1.png)  
![Example Announcement](https://bitbucket.org/Polvora/announcer/downloads/example2.png)

### Client Commands
* `sm_an [message]`  Posts an announcements with the message as title, if a message is not specified it will post the previous announcement.

### ConVars
#### Mandatory
* `an_steamgroupid` ID of the Steam Group where announcements are meant to be posted. [How to get your group ID](https://support.multiplay.co.uk/support/solutions/articles/1000202859-how-can-i-find-my-steam-group-64-id-). _(default = "")_

#### Optional
* `an_uppercase` Changes the announcement title to upper-case. _(default = 0)_

* `an_callerinfo` Displays client profile and Steam ID in the announcement description. _(default = 1)_

* `an_serverinfo`  Displays server name, n° of players and IP in the announcement description. _(default = 1)_

* `an_revealpassword` Displays server password in the announcement description. _(default = 0)_

* `an_redirecturl` URL pointing to a Steam Browser Protocol forwarder. This allows you to display the "Join Server" link. This is explained in detail below. _(default = "")_

* `an_extrainfo` Extra text to add at the start of the announcement description. _(default = "")_

##### Legend
![Cvars Explained]    (https://bitbucket.org/Polvora/announcer/downloads/cvars_explained.png)
![an_extrainfo] (https://bitbucket.org/Polvora/announcer/downloads/an_extrainfo.png)

##### an_redirecturl
Now the redirect URL is just an URL pointing to a site hosting [r.html](https://bitbucket.org/Polvora/announcer/downloads/r.html) which function is to receive the server IP, Port and Password as GET parameters and redirect the user to the server with a Steam Browser Protocol request (steam://connect/...), the reason to do this is because Steam doesn't allow Steam redirects inside its own site, it's dumb i know.  

For example if you host r.html in your dropbox public folder, you would have:

    an_redirecturl "https://dl.dropboxusercontent.com/u/69397859/r.html"

Then in the announcement description the "Click Here to Join" link:

    https://dl.dropboxusercontent.com/u/69397859/r.html?ip=233.143.43.54&port=27015

And finally this page, would redirect you to the server:

    steam://connect/233.143.43.54:27015/

### Install
##### Requirements
* [A working version of Sourcemod](http://www.sourcemod.net/downloads.php).
* [SteamCore library plugin](https://github.com/polvora/SteamCore).

_**DON'T FORGET TO SETUP STEAMCORE**_  
When you fulfil the requirements, just install as any other plugin, copy announcer.smx inside the plugins folder in your sourcemod directory.

### Download
Compiled versions: [announcer.smx](https://github.com/polvora/Announcer/releases).

If you want to compile the code yourself you have to add the include file `steamcore.inc` (from SteamCore, duh) inside `scripting/include` and then compile. _(You can't use includes with the online compiler)_

### Known Bugs
* When a profile name contains a website its not displayed, instead just the profile permalink is displayed. This happens beacuase there can not be an URL inside an URL, and i can't do anything about it.

> ###Changelog
> [04/02/2015] v1.0 

> * Initial Release.

> [05/02/2015] v1.1

> * Added Cvar an_extrainfo.

> [29/03/2015] v1.2

> * **[steamcore]** Fixed critical bug that made announcements stopped working after a few calls.
> * Fixed wrong eror messages being displayed.
> * More detailed information on error messages.
> * Added sm\_announce as an alias for sm\_an.
> * Long profile names are now displayed correctly on the announcements description.

> [08/05/2015] v1.3

> * More detailed response phrases.
> * Added map name and connect command to the announcement description.
> * Fixed error of an invalid client index thrown when client disconnected before receiving the response.

> [12/06/2015] v1.4

> * Added Cvar an_uppercase.

> [02/02/2017] v1.5

> * **[steamcore]** Fixed critical bug caused by outdated method to post announcements.

> [21/08/2017] v1.6

> * Updated to the new SteamCore syntax.
