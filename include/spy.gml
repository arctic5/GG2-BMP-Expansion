globalvar DisguiseOverlay;
DisguiseOverlay = object_add();
object_set_parent(DisguiseOverlay,InGameMenuController);  
object_set_depth(DisguiseOverlay,-130000);

object_event_add(DisguiseOverlay, ev_create, 0, "
    selectedTeam=!global.myself.team
    done = false;
    disguise=1
    b = buffer_create();
");
object_event_add(DisguiseOverlay, ev_step, ev_step_normal, "
    if(done or global.myself.class!=CLASS_SPY)
        instance_destroy()
");

/*object_event_add(DisguiseOverlay, ev_other, ev_user0, "
    if(not done)
    {
        disguise = disguise+10*(selectedTeam)
        clearbuffer(global.sendBuffer);
        writebyte(expansion.disguiseEvent,global.sendBuffer);
        writebyte(disguise,global.sendBuffer);
        sendmessage(global.serverSocket, 0, 0, global.sendBuffer);
    }
    done = true;
");*/

object_event_add(DisguiseOverlay, ev_keypress, ord("1"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SCOUT);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("2"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_PYRO);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("3"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SOLDIER);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("4"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_HEAVY);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("5"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_MEDIC);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("6"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_DEMOMAN);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("7"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_ENGINEER);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("8"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SPY);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("9"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SNIPER);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("Q"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_QUOTE);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("0"),'
    buffer_destroy(b);
    instance_destroy();
');
object_event_add(DisguiseOverlay, ev_keypress, vk_escape,'
    buffer_destroy(b);
    instance_destroy();
');

object_event_add(PlayerControl, ev_step, ev_step_normal, "
    xmid = view_wview[0]/2 + view_xview[0];
    ymid = view_hview[0]/2 + view_yview[0];

    if (keyboard_check_pressed(ord("B")))
    {
        instance_create(xmid, ymid, DisguiseOverlay);
    }
");