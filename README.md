#Announcer
Plugin to post Steam group announcements from the comfort of the game chat.

![Example Command](https://bitbucket.org/Polvora/announcer/downloads/example1.png)  
![Example Annoucement](https://bitbucket.org/Polvora/announcer/downloads/example2.png)

### Client Commands
* `sm_an [message]`  Posts an annoucements with the message as title, if a message is not specified it will post the previous annoucement.

### ConVars
####Mandatory
* `an_steamgroupid` ID of the Steam Group where announcements are meant to be posted. [Obtain your group ID here](http://fennec.limetech.org/groupid.php). _(default = "")_

#### Optional
* `an_callerinfo` Displays client profile and Steam ID in the announcement description. _(default = 1)_

* `an_serverinfo`  Displays server name, n° of players and IP in the announcement description. _(default = 1)_

* `an_revealpassword` Displays server password in the annoucement description. _(default = 0)_

* `an_redirecturl` URL pointing to a Steam Browser Protocol forwarder. This allows you to display the "Join Server" link. This is explained in detail below. _(default = "")_

This will help:
![Cvars Explained](https://bitbucket.org/Polvora/announcer/downloads/cvars_explained.png)

### Install
#####Requeriments
* [A working version of Sourcemod](http://www.sourcemod.net/downloads.php).
* [SteamTools extension](https://forums.alliedmods.net/showthread.php?t=170630)
* [SteamCore library plugin](https://bitbucket.org/Polvora/steamcore/overview).

When you fulfill the requirements, just install as any other plugin, copy announcer.smx inside the plugins folder in your sourcemod directory.

### Download
Compiled version: [announcer.smx](https://bitbucket.org/Polvora/announcer/downloads/announcer.smx). Also available in downloads section.  

If you want to compile the code yourself you have to add the include file `steamcore.inc` (from Steam Core, duh) inside `scripting/include` and then compile. _(You can't use includes with the online compiler)_