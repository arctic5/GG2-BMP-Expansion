
//// Heavy's stuffs, contains a whole lotta stuffs.
object_event_add(Heavy,ev_create,0,"
leftCharge=0
rightCharge=0
charging=false
chargeVelocity=5
chargeBox=-1
buttSlamming=false
soundLength=24/global.delta_factor
dist=0
alarmSet=false
")

object_event_add(Heavy,ev_alarm,11,"
if!charging{
leftCharge=0
rightCharge=0
}
else{
charging=false
leftCharge=0
rightCharge=0
loopsoundstop(expansion.HeavyDashSnd)
}
if buttSlamming{

    runPower=0.9
    jumpStrength=8
    dist=0
    currentWeapon.readyToFire=true
buttSlamming=false
alarmSet=false
}
")

object_event_add(Heavy,ev_step,ev_step_begin,"
    charSetSolids()
    if(!taunting && !omnomnomnom)&& !place_free(x,y+1)
    ||(place_meeting(x,y+1,DropdownPlatform) 
    && !place_meeting(x,y,DropdownPlatform))
    {
        if((pressedKeys) & $40)
        {
        alarm[11]=5/global.delta_factor
        rightCharge=0
            if leftCharge<1{
            leftCharge+=1
            }else{
            if !charging{
            hspeed=-chargeVelocity
            loopsoundstart(x,y,expansion.HeavyDashSnd)
            alarm[11]=soundLength
            }
            charging=true
            }
        }
        if((pressedKeys) & $20)
        {
        leftCharge=0
        alarm[11]=20/global.delta_factor
            leftCharge=0
            if rightCharge<1{
            rightCharge+=1
            }else{
            if !charging{
            hspeed=chargeVelocity
            loopsoundstart(x,y,expansion.HeavyDashSnd)
            alarm[11]=soundLength
            }
            charging=true
            }
        }
    }
    charUnsetSolids()
    
    if charging 
    &&((sign(image_xscale)!=sign(hspeed) 
    || (!(keyState & $40 && image_xscale<0) && !(keyState & $20 && image_xscale>0)) 
    || taunting 
    || omnomnomnom 
    || abs(hspeed)<5) 
    || (keyState & $10)
    ||player.humiliated
    ) {
    charging=false
    rightCharge=0
    leftCharge=0
    }

if charging{
animationImage+=0.5*global.delta_factor
    if player.team=TEAM_RED{
        spriteRun=expansion.HeavyRedChargeS
    }else{
        spriteRun=expansion.HeavyBlueChargeS;
    }
    jumpStrength=3
    currentWeapon.visible=false
if chargeBox=-1{
chargeBox=instance_create(x,y,expansion.ChargeBox)
chargeBox.owner=id
chargeBox.image_xscale=image_xscale
chargeBox.ownerPlayer=player
}


/////////////////////////////BREAK FOR INHERITED EVENT
}
event_inherited()


if !taunting && !omnomnomnom{
charSetSolids()
if (pressedKeys | keyState) & $02 &&(place_free(x,y+1)) or (place_meeting(x,y+1,DropdownPlatform) and !place_meeting(x,y,DropdownPlatform)){
    if (moveStatus = 0 || moveStatus = 4){
    vspeed=10
    charging=false
    rightCharge=0
    leftCharge=0
    buttSlamming=true
    dist=0
    }
    }
charUnsetSolids()
}
if buttSlamming{
dist+=5
dist=min(dist,100)
currentWeapon.readyToFire=false
}
charSetSolids()
if !(place_free(x,y+1)) or (place_meeting(x,y+1,DropdownPlatform) and !place_meeting(x,y,DropdownPlatform)){
    if buttSlamming{
        with Character{
            if place_meeting(other.x,y,other) && team!=other.team && ubered=false{
                if!(place_free(x,y+1)) or (place_meeting(x,y+1,DropdownPlatform) and !place_meeting(x,y,DropdownPlatform)){
                    if abs(x-other.x)<other.dist*2{
                        hspeed=0
                        moveStatus=3
                        vspeed=-3
                    }
                }
            }
        }
    
    if !alarmSet{
    alarm[11]=5/global.delta_factor
    alarmSet=true
    playsound(x,y,expansion.HeavyButtSlamSnd)
    }
    moveStatus=0
    hspeed=0
    jumpStrength=0
    currentWeapon.readyToFire=false
    }
    
}
charUnsetSolids()

if !buttSlamming{
if charging{
    if player.team=TEAM_RED{
        spriteRun=expansion.HeavyRedChargeS
        spriteJump=expansion.HeavyRedChargeS
    }else{
        spriteRun=expansion.HeavyBlueChargeS;
        spriteJump=expansion.HeavyBlueChargeS
    }
    jumpStrength=0
    currentWeapon.visible=false

    hspeed=chargeVelocity*image_xscale


     if !variable_local_exists(global.motionBlurParticleTypeString)
    {
        motionBlurParticleType = part_type_create();
        part_type_sprite(motionBlurParticleType,expansion.HeavyNoColorChargeS,true,false,true);
        part_type_alpha3(motionBlurParticleType,1,0.5,0.1);
        part_type_life(motionBlurParticleType,2,5);
        part_type_scale(motionBlurParticleType,image_xscale,1);
    }else{
    part_type_destroy(motionBlurParticleType)
    motionBlurParticleType = part_type_create();
        part_type_sprite(motionBlurParticleType,expansion.HeavyNoColorChargeS,true,false,true);
        part_type_alpha3(motionBlurParticleType,1,0.5,0.1);
        part_type_life(motionBlurParticleType,2,5);
        part_type_scale(motionBlurParticleType,image_xscale,1);
    }
    
    if !variable_global_exists(global.motionBlurParticleSystemString)
    {
        global.motionBlurParticleSystem = part_system_create();
        part_system_depth(global.motionBlurParticleSystem, 2);
    }
    
    if(global.particles == PARTICLES_NORMAL)

    if(global.particles == PARTICLES_NORMAL or global.particles == PARTICLES_ALTERNATIVE)
    {
        
            part_particles_create(global.motionBlurParticleSystem,x,y,motionBlurParticleType,1);
    }
    }else{
if player.team=TEAM_RED{
        spriteRun=HeavyRedRunS
        spriteJump=HeavyRedJumpS
    }else{
        spriteRun=HeavyBlueRunS;
        spriteJump=HeavyBlueJumpS;
    }
    currentWeapon.visible=true
    jumpStrength=8
 loopsoundstop(expansion.HeavyDashSnd)
}
}else if buttSlamming{

animationImage=0
    if player.team=TEAM_RED{
        spriteRun=expansion.HeavyRedButtslamS
        spriteJump=expansion.HeavyRedButtslamS;
    }else{
        spriteRun=expansion.HeavyBlueButtslamS;
        spriteJump=expansion.HeavyBlueButtslamS;
    }
    vspeed=10
    currentWeapon.visible=false
    moveStatus=3
if chargeBox=-1{
chargeBox=instance_create(x,y,expansion.ButtBox)
chargeBox.owner=id
chargeBox.image_xscale=image_xscale
chargeBox.ownerPlayer=player
}
}
")
object_event_clear(Heavy,ev_step,ev_step_normal)
object_event_add(Heavy,ev_step,ev_step_normal,"

    if(keyState & $10) {
        runPower = 0.3;
    } else {
        runPower = 0.8;
    }

//////////BREAK FOR INHERITED EVENT
event_inherited()
if charging{
    if player.team=TEAM_RED{
        spriteRun=expansion.HeavyRedChargeS
    }else{
        spriteRun=expansion.HeavyBlueChargeS;
    }
    jumpStrength=3
    currentWeapon.visible=false

}else if !buttSlamming{
if player.team=TEAM_RED{
        spriteRun=HeavyRedRunS
    }else{
        spriteRun=HeavyBlueRunS;
    }
    currentWeapon.visible=true
}
if buttSlamming{

animationImage=0
    if player.team=TEAM_RED{
        spriteRun=expansion.HeavyRedButtslamS
        spriteJump=expansion.HeavyRedButtslamS;
    }else{
        spriteRun=expansion.HeavyBlueButtslamS;
        spriteJump=expansion.HeavyBlueButtslamS;
    }
    vspeed=10
    currentWeapon.visible=false
    moveStatus=3
if chargeBox=-1{
chargeBox=instance_create(x,y,ButtBox)
chargeBox.owner=id
chargeBox.image_xscale=image_xscale
chargeBox.ownerPlayer=player
}
}
charSetSolids()
if !(place_free(x,y+1)) or (place_meeting(x,y+1,DropdownPlatform) and !place_meeting(x,y,DropdownPlatform)){
    if buttSlamming{
    if !alarmSet{
    alarm[11]=5/global.delta_factor
    alarmSet=true
    playsound(x,y,expansion.HeavyButtSlamSnd)
    }
    moveStatus=0
    runPower=0
    jumpStrength=0
    currentWeapon.readyToFire=false
    }
    
}
charUnsetSolids()
")

object_event_add(expansion.ChargeBox,ev_create,0,"
visible=false
hitDamage=25
")
object_event_add(expansion.ChargeBox,ev_destroy,0,"
if instance_exists(owner){
owner.chargeBox=-1
}
"
)
object_event_add(expansion.ChargeBox,ev_step,ev_step_begin,"
if instance_exists(owner){
if owner.charging{
x=owner.x
y=owner.y
}else instance_destroy()
}else instance_destroy()
")
object_event_add(expansion.ChargeBox,ev_step,ev_step_normal,"
if instance_exists(owner){
if owner.charging{
x=owner.x
y=owner.y
}else instance_destroy()
}else instance_destroy()
")
object_event_add(expansion.ChargeBox,ev_step,ev_step_end,"
if instance_exists(owner){
if owner.charging{
x=owner.x
y=owner.y
}else instance_destroy()
}else instance_destroy()
")
object_event_add(expansion.ChargeBox,ev_collision,Obstacle,"
if instance_exists(owner){
with owner{
moveStatus=3
rightCharge=0
leftCharge=0
vspeed=-3
hspeed=image_xscale*-7
charging=false
playsound(x,y,expansion.HeavyCrashSnd)
}
}
instance_destroy()
")
object_event_add(expansion.ChargeBox,ev_collision,Character,"
     if (other.team != ownerPlayer.team  && other.hp > 0 && other.ubered == 0)
    {
        damageCharacter(ownerPlayer, other.id, hitDamage);
       playsound(x,y,expansion.HeavyLaunchSnd)
        if (other.lastDamageDealer != ownerPlayer and other.lastDamageDealer != other.player)
        {
            other.secondToLastDamageDealer = other.lastDamageDealer;
            other.alarm[4] = other.alarm[3]
        }
        other.alarm[3] = ASSIST_TIME;
        other.lastDamageDealer = ownerPlayer;
        other.lastDamageSource = WEAPON_MINIGUN;
        
        var blood;
        if(global.gibLevel > 0)
        {
            blood = instance_create(x,y,Blood);
            blood.direction = direction-180;
        }
        dealFlicker(other.id);
        with(other)
        {
            vspeed=-8
            moveStatus=3
            hspeed=10*other.image_xscale
        }
      instance_destroy()
      owner.charging=false  
    }else if (other.team != ownerPlayer.team  && other.hp > 0 && other.ubered == 1){
    if instance_exists(owner){
with owner{
moveStatus=3
rightCharge=0
leftCharge=0
vspeed=-3
hspeed=image_xscale*-7
charging=false
playsound(x,y,expansion.HeavyCrashSnd)
}
}
instance_destroy()
    }
")
object_event_add(Sentry,ev_step,ev_step_normal,"
// Limit speed to prevent obstacle penetration
// (each dimension separately to avoid one vector affecting the other)
hspeed = min(abs(hspeed), 15) * sign(hspeed);
vspeed = min(abs(vspeed), 15) * sign(vspeed);

// Run movement solver if necessary
yprevious = y;
xprevious = x;
y_previous = y;
x_previous = x;
allSetSolids();
if(!place_free(x+hspeed, y+vspeed))
    characterHitObstacle();
else
{
    x += hspeed * global.delta_factor;
    y += vspeed * global.delta_factor;
    x -= hspeed;
    y -= vspeed;
}

allUnsetSolids();

hspeed*=0.8
if hspeed<0.2 hspeed=0;
")
object_event_add(expansion.ChargeBox,ev_collision,Sentry,"
if other.team!= ownerPlayer.team{
    damageSentry(ownerPlayer, other.id, hitDamage);
    other.lastDamageDealer = ownerPlayer;
    other.lastDamageSource = WEAPON_MINIGUN;
   playsound(x,y,expansion.HeavyLaunchSnd)
    with(other)
        {
            vspeed=-8
            hspeed=10*other.image_xscale
        }
}
")
object_event_add(Heavy,ev_other,ev_user12,"
event_inherited()
if(global.updateType == QUICK_UPDATE or global.updateType == FULL_UPDATE) {
		write_ubyte(global.serializeBuffer, charging);
        write_ubyte(global.serializeBuffer, dist);
        write_ubyte(global.serializeBuffer, buttSlamming);
    }
")
object_event_add(Heavy,ev_other,ev_user13,"
event_inherited()
if(global.updateType == QUICK_UPDATE) or (global.updateType == FULL_UPDATE) {
		receiveCompleteMessage(global.serverSocket,3,global.deserializeBuffer);
        charging = read_ubyte(global.deserializeBuffer);
        dist = read_ubyte(global.deserializeBuffer);
        buttSlamming = read_ubyte(global.deserializeBuffer);
       }
")