#pragma dynamic 2048 // Increases stack space to 8kb, needed for saving user announcements

#include <sourcemod>
#include <steamcore>

#define PLUGIN_URL ""
#define PLUGIN_VERSION "1.2"
#define PLUGIN_NAME "Announcer"
#define PLUGIN_AUTHOR "Statik"

public Plugin:myinfo = 
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = "Steam group announcements via game commands.",
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
}

new String:announcements[32][128];
new ReplySource:sources[32];

new Handle:cvarSteamGroupID;
new Handle:cvarCallerInfo;
new Handle:cvarServerInfo;
new Handle:cvarRevealPass;
new Handle:cvarRedirectURL;
new Handle:cvarExtraInfo;

public OnPluginStart()
{
	// Commands
	RegAdminCmd("sm_announcer", cmdAnnounce, ADMFLAG_CONFIG, "Posts a new announcement to a Steam group.");
	RegAdminCmd("sm_an", cmdAnnounce, ADMFLAG_CONFIG, "Posts a new announcement to a Steam group.");
	
	// Convars
	CreateConVar("announcer_version", PLUGIN_VERSION, "Announcer Version", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);
	cvarSteamGroupID = CreateConVar("an_steamgroupid", "", "Steam group community ID to make announcements.", FCVAR_PLUGIN);
	cvarCallerInfo = CreateConVar("an_callerinfo", "1", "Toggles information of caller displayed in announcement body.", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	cvarServerInfo = CreateConVar("an_serverinfo", "1", "Toggles information of server displayed in announcement body.", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	cvarRevealPass = CreateConVar("an_revealpassword", "0", "If set, server password will be shown on server information.", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	cvarRedirectURL = CreateConVar("an_redirecturl", "", "URL to parse HTTP GET requests to Steam requests.", FCVAR_PLUGIN);
	cvarExtraInfo = CreateConVar("an_extrainfo", "", "Extra text to add at the start of the announcement description.", FCVAR_PLUGIN);
}

public Action:cmdAnnounce(client, args)
{
	decl String:steamGroup[65];
	GetConVarString(cvarSteamGroupID, steamGroup, sizeof(steamGroup));
	if (StrEqual(steamGroup, "")) 
	{ 
		ReplyToCommand(client, "\x07FFF047There is no steam group to announce.");
		return Plugin_Handled;
	}
	if (GetCmdArgs() == 0)
	{
		if (strcmp(announcements[client], "") == 0)
		{
			ReplyToCommand(client, "\x07FFF047No previous message set: \x01sm_an [message]");
			return Plugin_Handled;
		}
	}
	else GetCmdArgString(announcements[client], sizeof(announcements[]));
	
	sources[client] = GetCmdReplySource();
	
	decl String:body[2048];
	GetBodySting(client, body, sizeof(body));
	
	SteamGroupAnnouncement(client, announcements[client], body, steamGroup, callback);
	return Plugin_Handled;
}

public callback(client, bool:success, errorCode, any:data)
{
	if (client != 0 && !IsClientInGame(client)) return;

	SetCmdReplySource(sources[client]);
	if (success) ReplyToCommand(client, "\x07FFF047Your announcement was successfully posted.");
	else
	{
		if (errorCode == 0x01) ReplyToCommand(client, "\x07FFF047Server is busy with another task at this time, try again in a few seconds.");
		else if (errorCode == 0x02) ReplyToCommand(client, "\x07FFF047There was a timeout in your request, try again.");
		else if (errorCode == 0x11) ReplyToCommand(client, "\x07FFF047Session expired, retry to reconnect.");
		else ReplyToCommand(client, "\x07FFF047There was an error \x010x%02x \x07FFF047while posting your announcement :(", errorCode);
	}
}

public OnClientDisconnect(client)
{
	strcopy(announcements[client], sizeof(announcements[]), "");
}

GetBodySting(client, String:body[], maxSize)
{
	strcopy(body, maxSize, "");
	decl String:buffer[1024];
	
	GetConVarString(cvarExtraInfo, buffer, sizeof buffer);
	if (!StrEqual(buffer, ""))
	{
		StrCat(body, maxSize, buffer);
		StrCat(body, maxSize, "\n");
	}
	
	if (client == 0)
	{
		StrCat(body, maxSize, "\n");
		return;
	}
	
	if (GetConVarBool(cvarCallerInfo))
	{
		decl String:clientName[64]; 
		decl String:clientCommunityID[32];
		decl String:clientSteamID[32];
		
		GetClientName(client, clientName, sizeof(clientName));
		GetClientAuthId(client, AuthId_SteamID64, clientCommunityID, sizeof(clientCommunityID));
		GetClientAuthId(client, AuthId_Steam2, clientSteamID, sizeof(clientSteamID));
		
		String_ToUpper(clientName, clientName, sizeof(clientName));
		
		Format(buffer, sizeof(buffer), "[b][url=http://steamcommunity.com/profiles/%s]%s[/url][/b]", clientCommunityID, clientName);
		StrCat(body, maxSize, buffer);
		Format(buffer, sizeof(buffer), " - [i]%s[/i]", clientSteamID);
		StrCat(body, maxSize, buffer);
		
		StrCat(body, maxSize, "\n");
	}
	if (IsClientInGame(client))
	{
		decl String:IP[32];
		decl String:PORT[16];
		decl String:pw[32];
		decl String:map[64];
		
		GetServerIP(IP, sizeof(IP));
		GetConVarString(FindConVar("hostport"), PORT, sizeof(PORT));
		GetConVarString(FindConVar("sv_password"), pw, sizeof(pw));
		GetCurrentMap(map, sizeof map);
		
		if (GetConVarBool(cvarServerInfo))
		{
			decl String:hostname[64];
			GetConVarString(FindConVar("hostname"), hostname, sizeof(hostname));
			
			Format(buffer, sizeof(buffer), "[b]%s[/b] (%i/%i) - [i]@%s[/i]", hostname, GetClientCount(), MaxClients, map);
			StrCat(body, maxSize, buffer);
			StrCat(body, maxSize, "\n");
		}
		decl String:redirectURL[128];
		GetConVarString(cvarRedirectURL, redirectURL, sizeof(redirectURL));
		if (StrEqual(redirectURL, ""))
			return;
		
		decl String:finalRedirectURL[128];
		Format(finalRedirectURL, sizeof(finalRedirectURL), "%s?ip=%s&port=%s", redirectURL, IP, PORT);
		
		if (GetConVarBool(cvarRevealPass) && !StrEqual(pw, ""))
		{
			Format(buffer, sizeof(buffer), "&pw=%s", pw);
			StrCat(finalRedirectURL, sizeof(finalRedirectURL), buffer);
		}
		
		if (!GetConVarBool(cvarRevealPass) || StrEqual(pw, ""))
			Format(buffer, sizeof(buffer), "[i]connect [b]%s:%s[/b][/i]", IP, PORT);
		else
			Format(buffer, sizeof(buffer), "[i]connect [b]%s:%s[/b]; password [b]%s[/b][/i]", IP, PORT, pw);
		StrCat(body, maxSize, buffer);
		StrCat(body, maxSize, "\n");
		
		Format(buffer, sizeof(buffer), "[url=%s][h1][b][u][Join Server][/u][/b][/h1][/url]", finalRedirectURL);
		StrCat(body, maxSize, buffer);
		StrCat(body, maxSize, "\n");
	}
}

/*======================================
================EXTRAS==================
======================================*/

/**
 * Converts the whole String to upper case.
 * Only works with alphabetical characters (not öäü) because Sourcemod suxx !
 * The Output String can be the same as the Input String.
 *
 * @param input                         Input String.
 * @param output                        Output String.
 * @param size                          Max Size of the Output string
 * @noreturn
 */
stock String_ToUpper(const String:input[], String:output[], size) // SMLib
{
        size--;

        new x=0;
        while (input[x] != '\0') {
                
                if (IsCharLower(input[x])) {
                        output[x] = CharToUpper(input[x]);
                }
                else {
                        output[x] = input[x];
                }

                x++;
        }

        output[x] = '\0';
}

stock GetServerIP(String:buffer[], maxSize) // https://forums.alliedmods.net/archive/index.php/t-56987.html
{
	new pieces[4];
	new longip = GetConVarInt(FindConVar("hostip"));

	pieces[0] = (longip >> 24) & 0x000000FF;
	pieces[1] = (longip >> 16) & 0x000000FF;
	pieces[2] = (longip >> 8) & 0x000000FF;
	pieces[3] = longip & 0x000000FF;

	FormatEx(buffer, maxSize, "%d.%d.%d.%d", pieces[0], pieces[1], pieces[2], pieces[3]);
}



