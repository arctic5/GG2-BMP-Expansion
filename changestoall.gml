
////Fast-fall for characters who are not Heavy, Soldier, or Scout

object_event_add(Character,ev_step,ev_step_begin,"
if !taunting && !omnomnomnom{
if player.class!=CLASS_SCOUT 
&& player.class!=CLASS_HEAVY 
&& player.class!=CLASS_SOLDIER{
if (pressedKeys | keyState) & $02{
    if (moveStatus = 0 || moveStatus = 4){
    vspeed=10
    }
}
}

if (player.class!=CLASS_SCOUT && !(keyState & $80) && (moveStatus=0 || moveStatus=4) && vspeed<0)
    {

        {
            if not stabbing
            {
                vspeed=vspeed/1.5
            }
        }
       
    }
    if (player.class=CLASS_SCOUT && !(keyState & $80) && (moveStatus=0 || moveStatus=4) && vspeed<0)
    {

        {
            if not stabbing &&!rebounding &&!kicking &&!huggingWall
            {
                vspeed=vspeed/1.5
            }
        }
       
    }
}
")