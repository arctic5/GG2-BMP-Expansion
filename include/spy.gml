globalvar DisguiseOverlay;
DisguiseOverlay = object_add();
object_set_parent(DisguiseOverlay,InGameMenuController);  
object_set_depth(DisguiseOverlay,-130000);
object_set_sprite(DisguiseOverlay,DisguiseOverlayS);

object_event_add(DisguiseOverlay, ev_create, 0, "
    selectedTeam = !global.myself.team;
    b = buffer_create();
");
object_event_add(DisguiseOverlay, ev_step, ev_step_normal, "
    if(global.myself.class!=CLASS_SPY)
        instance_destroy();
");
object_event_add(DisguiseOverlay, ev_keypress, ord("1"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SCOUT);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("2"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_PYRO);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("3"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SOLDIER);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("4"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_HEAVY);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("5"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_MEDIC);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("6"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_DEMOMAN);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("7"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_ENGINEER);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("8"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SPY);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("9"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_SNIPER);
    write_ubyte(b, selectedTeam);
    PluginPacketSend(expansion.packetID, b);
    buffer_destroy(b);
');
object_event_add(DisguiseOverlay, ev_keypress, ord("Q"),'
    write_ubyte(b, expansion.disguiseEvent);
    write_ubyte(b, CLASS_QUOTE);
    write_ubyte(b, selectedTeam);
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
object_event_add(DisguiseOverlay, ev_keypress, ord("B"),'
    selectedTeam = !selectedTeam;
');

object_event_add(PlayerControl, ev_step, ev_step_normal, '
    xmid = view_wview[0]/2 + view_xview[0];
    ymid = view_hview[0]/2 + view_yview[0];

    if (keyboard_check_pressed(ord("B")))
    {
        if(global.myself.class == CLASS_SPY)
            instance_create(xmid, ymid, DisguiseOverlay);
    }
');