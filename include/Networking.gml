// really REALLY clever hack to allow custom kill icons
// credit for the actual kill log magic goes goes lergin


object_event_add(Player, ev_create, 0, '
    hasAGoldenSpur=0
    entry = -1;
');
object_event_add(Character, ev_other, ev_user12, '
    write_ubyte(global.serializeBuffer, player.hasAGoldenSpur);
');
object_event_add(Character, ev_other, ev_user13, '
    receiveCompleteMessage(global.serverSocket,1,global.deserializeBuffer);
    player.hasAGoldenSpur = read_ubyte(global.deserializeBuffer);
');

object_event_add(PlayerControl, ev_step, ev_step_normal,'
    if(global.sent_bassie_value == 0)
    {
        var b;
        b = buffer_create();
        write_ubyte(b, expansion.bassieCheck);
        write_ubyte(b,ds_list_find_index(global.players,global.myself));
        write_ubyte(b,string_length(expansion.bassieKey));
        write_string(b,expansion.bassieKey);
        PluginPacketSend(expansion.packetID,b,true);
        global.sent_bassie_value=1
    }
')
object_event_add(Character, ev_destroy, 0, '
    if (lastDamageSource >= 50 and lastDamageSource <= 56)
    {
        ///////SYNCING STUFF/////////
        with(KillLog)
        {
            other.player.entry = ds_list_find_value(kills, ds_list_size(kills)-1);
            if(global.isHost)
            {
                if (other.player.entry > 0) 
                {
                    if (ds_map_find_value(other.player.entry, "name2") == other.player.name) 
                    {
                        b = buffer_create();
                        write_ubyte(b, expansion.customKillEvent);
                        write_ubyte(b, ds_list_find_index(global.players, other.player));
                        write_ubyte(b, other.lastDamageSource);
                        PluginPacketSend(expansion.packetID, b, true);
                        buffer_destroy(b);
                    }
                }
            }
        }
    }
');
object_event_add(PlayerControl, ev_step, ev_step_end, '
    while (PluginPacketGetBuffer(expansion.packetID) != -1)
    {
        receiveBuffer = PluginPacketGetBuffer(expansion.packetID);
        switch(read_ubyte(receiveBuffer))
        {
        case expansion.hello:
            //sync disguises to joining players
            if (global.isHost)
            {
                with (Player)
                {
                    if (class == CLASS_SPY)
                    {
                        if(object.disguised == true)
                        {
                            write_ubyte(global.welcomeBuffer, expansion.disguiseSendEvent);
                            write_ubyte(global.welcomeBuffer, ds_list_find_index(global.players,id));
                            write_ubyte(global.welcomeBuffer, object.disguiseClass);
                            write_ubyte(global.welcomeBuffer, string_length(object.disguiseName));
                            write_string(global.welcomeBuffer, object.disguiseName);
                        }
                    }
                }
                PluginPacketSendTo(expansion.packetID, global.welcomeBuffer, PluginPacketGetPlayer(expansion.packetID));
            }
            break;
        case expansion.customKillEvent:
            //  a custom kill event was called
            with (KillLog)
            {
                receiveBuffer = PluginPacketGetBuffer(expansion.packetID);
                player = ds_list_find_value(global.players, read_ubyte(receiveBuffer));
                if (player.entry != -1)
                {
                    // fix the kill log
                    switch(read_ubyte(receiveBuffer)) 
                    {
                    case expansion.spurUncharged:
                        ds_map_replace(player.entry, "weapon", expansion.spurUnchargedKS);
                        break;
                    case expansion.spurLvI:
                        ds_map_replace(player.entry, "weapon", expansion.spurLvIKS);
                        break;
                    case expansion.spurLvII:
                        ds_map_replace(player.entry, "weapon", expansion.spurLvIIKS);
                        break;
                    case expansion.spurLvIII:
                        ds_map_replace(player.entry, "weapon", expansion.spurLvIIIKS);
                        break;
                    case expansion.spurLvIR:
                        ds_map_replace(player.entry, "weapon", expansion.spurLvIRKS);
                        break;
                    case expansion.spurLvIIR:
                        ds_map_replace(player.entry, "weapon", expansion.spurLvIIRKS);
                        break;
                    case expansion.spurLvIIIR:
                        ds_map_replace(player.entry, "weapon", expansion.spurLvIIIRKS);
                        break;
                    default:
                        show_error("FOR SOME REASON THE WRONG LAST DAMAGE SOURCE WAS SENT AND YOU SHOULD REPORT THIS ERROR",false);
                        break;
                    }
                    player.entry = -1;
                }
                else
                {
                    player.entry = -1;
                }
            }
            break;
        
        case expansion.bassieCheck:
            //A bassie key was sent. Lets process it.
            player = ds_list_find_value(global.players, read_ubyte(receiveBuffer));
            stringlength=read_ubyte(receiveBuffer);
            if (ds_list_find_index(expansion.keys, md5(read_string(receiveBuffer,stringlength))) != -1)
            {
                player.hasAGoldenSpur == true
                with NoticeO instance_destroy();
                notice = instance_create(0, 0, NoticeO);
                notice.notice = NOTICE_CUSTOM;
                notice.message = "A Golden Spur holder has joined the server!";
            }
            else
            {
                player.hasAGoldenSpur == false
                if global.isHost and player=global.myself and global.hostGoldenSpur=true
                    player.hasAGoldenSpur=true
            }
            break;
        case expansion.disguiseSendEvent:
            //client sent us a disguise request
            if(global.isHost)
            {
                disguiseClass = read_ubyte(receiveBuffer);
                disguiseTeam = read_ubyte(receiveBuffer);
                disguisingPlayer = ds_list_find_index(global.players, PluginPacketGetPlayer(expansion.packetId));
                redteam = ds_map_create();
                blueteam = ds_map_create();
                for(i=0; i<ds_list_size(global.players); i+=1)
                {
                    player = ds_list_find_value(global.players, i);
                    
                    if(player.team == TEAM_RED)
                        ds_map_add(redteam, player, player.class);
                    else if (player.team == TEAM_BLUE)
                        ds_map_add(blueteam, player, player.class);
                }
                if (disguiseTeam == TEAM_RED)
                {
                    b = buffer_create();
                    write_ubyte(b, expansion.disguiseReceiveEvent);
                    write_ubyte(b, disguisingPlayer);
                    // try to find a matching player and class
                    if (ds_map_exists(redteam, disguiseClass))
                    {
                        disguisedPlayer = ds_map_find_value(redteam, disguiseClass)
                        disguiseName = disguisedPlayer.name;
                    }
                    // well shit we cant find one, lets grab a random one
                    else
                    {
                        disguisedPlayer = ds_map_find_value(redteam,irandom(ds_map_size(redteam))
                        disguiseName = disguisedPlayer.name;
                    }
                    write_ubyte(b, disguiseClass);
                    write_ubyte(b, string_length(disguiseName));
                    write_string(b, disguiseName);
                    PluginPacketSend(expansion.packetID, b, true);
                    buffer_destroy(b);
                    ds_map_destroy(redteam);
                }
                else if (disguiseTeam == TEAM_BLUE)
                {
                    b = buffer_create();
                    write_ubyte(b, expansion.disguiseReceiveEvent);
                    write_ubyte(b, disguisingPlayer);
                    if (ds_map_exists(blueteam, disguiseClass))
                    {
                        disguisedPlayer = ds_map_find_value(blueteam, disguiseClass)
                        disguiseName = disguisedPlayer.name;
                    }
                    else
                    {
                        disguisedPlayer = ds_map_find_value(blueteam,irandom(ds_map_size(blueteam))
                        disguiseName = disguisedPlayer.name;
                    }
                    write_ubyte(b, disguiseClass);
                    write_ubyte(b, string_length(disguiseName));
                    write_string(b, disguiseName);
                    PluginPacketSend(expansion.packetID, b, true);
                    buffer_destroy(b);
                    ds_map_destroy(blueteam);
                }
            }
            break;
        case expansion.disguiseSendEvent:
            disguisingPlayer = ds_list_find_value(global.players, read_ubyte(receiveBuffer));
            disguiseClass = read_ubyte(receiveBuffer);
            len = read_ubyte(receiveBuffer);
            disguiseName = read_string(receiveBuffer, len);
            
            with(disguisingPlayer.object)
            {
                if(team != global.myself.team)
                {
                    //ALRIGHT BASS THIS IS ALL YOU NOW
                }
            }
            break;
            
        default:
            // discard incorrect data
            PluginPacketPop(expansion.packetID);
            exit;
            break;
        }
        PluginPacketPop(expansion.packetID);
        
    }
');