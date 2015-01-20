#Announcer
Plugin to post Steam group announcements from the comfort of the game chat.

![Example Command](https://bitbucket.org/Polvora/announcer/downloads/example1.png)  
![Example Announcement](https://bitbucket.org/Polvora/announcer/downloads/example2.png)

### Client Commands
* `sm_an [message]`  Posts an announcements with the message as title, if a message is not specified it will post the previous announcement.

### ConVars
####Mandatory
* `an_steamgroupid` ID of the Steam Group where announcements are meant to be posted. [Obtain your group ID here](http://fennec.limetech.org/groupid.php). _(default = "")_

#### Optional
* `an_callerinfo` Displays client profile and Steam ID in the announcement description. _(default = 1)_

* `an_serverinfo`  Displays server name, n° of players and IP in the announcement description. _(default = 1)_

* `an_revealpassword` Displays server password in the announcement description. _(default = 0)_

* `an_redirecturl` URL pointing to a Steam Browser Protocol forwarder. This allows you to display the "Join Server" link. This is explained in detail below. _(default = "")_

##### Legend
![Cvars Explained]    (https://bitbucket.org/Polvora/announcer/downloads/cvars_explained.png)

##### an_redirecturl
Now the redirect URL is just an URL pointing to a site hosting [r.html](https://bitbucket.org/Polvora/announcer/downloads/r.html) which function is to receive the server IP, Port and Password as GET parameters and redirect the user to the server with a Steam Browser Protocol request (steam://connect/...), the reason to do this is because Steam doesn't allow Steam redirects inside its own site, it's dumb i know.  

For example if you host r.html in your dropbox public folder, you would have:

    an_redirecturl "https://dl.dropboxusercontent.com/u/69397859/r.html"

Then in the announcement description the "Click Here to Join" link:

    https://dl.dropboxusercontent.com/u/69397859/r.html?ip=233.143.43.54&port=27015

And finally this page, would redirect you to the server:

    steam://connect/233.143.43.54:27015/

### Install
#####Requirements
* [A working version of Sourcemod](http://www.sourcemod.net/downloads.php).
* [SteamTools extension](https://forums.alliedmods.net/showthread.php?t=170630) (Aleady required by SteamCore)
* [SteamCore library plugin](https://bitbucket.org/Polvora/steamcore/overview).

When you fulfil the requirements, just install as any other plugin, copy announcer.smx inside the plugins folder in your sourcemod directory.

### Download
Compiled version: [announcer.smx](https://bitbucket.org/Polvora/announcer/downloads/announcer.smx). Also available in downloads section.  

If you want to compile the code yourself you have to add the include file `steamcore.inc` (from SteamCore, duh) inside `scripting/include` and then compile. _(You can't use includes with the online compiler)_

###Changelog
> [20/01/2015] v1.0 

> * Initial Release.