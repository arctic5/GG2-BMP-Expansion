// import the disguise menu
execute_file(include + "disguiseMenu.gml");

object_event_add(Character, ev_create, 0, '
    disguised = false;
    disguiseClass = -1;
    disguiseName = '';
');