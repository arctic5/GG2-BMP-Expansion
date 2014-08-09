object_event_clear(Quote,ev_collision,HealingCabinet)
object_event_add(Quote,ev_collision,HealingCabinet,"
if (!global.mapchanging) {
    if (hp < maxHp or nutsNBolts < 100 or !canEat)
    {
        playsound(x,y,CbntHealSnd);
        hp = maxHp;
        nutsNBolts = maxNutsNBolts;
        alarm[6] = 0
        canEat = true;
    }
    if (burnIntensity > 0 or burnDuration > 0)
    {
        burnIntensity = 0;
        burnDuration = 0;
        burnedBy = -1;
        afterburnSource = -1;
    }
    //ammo stuffs
    if instance_exists(currentWeapon) {
        if(currentWeapon.ammoCount < currentWeapon.maxAmmo) {
            switch(currentWeapon.object_index) {
            case Medigun:
            case Minigun:
            case Flamethrower:
            case quote_spur.Spur:
                if (currentWeapon.ammoCount / currentWeapon.maxAmmo < 5/6)
                    playsound(x,y,PickupSnd);
                break;
            default:
                playsound(x,y,PickupSnd);
                break;
            }
            currentWeapon.ammoCount = currentWeapon.maxAmmo;
            switch(currentWeapon.object_index) {
            case Rocketlauncher:
            case Scattergun:
            case Shotgun:
            case Revolver:
            case Medigun:
                currentWeapon.alarm[5] = -1;
                break;
            }
        }
    }
}")

// cmon bass, stepitup
object_event_add(Quote,ev_create,0,"
    with(currentWeapon) {instance_destroy();}
    currentWeapon = instance_create(x,y,quote_spur.Spur);
");

//Gives querly the spur

//////////////SPUR WEAPON OBJECT//////////////////////////
object_event_add(quote_spur.Spur,ev_create,0,"

recoilTime=0
depth=1
{
    xoffset = 2;
    yoffset = 4;
    hitDamage = 8;
    maxAmmo = 60;
    refireTime = 2;
    reloadBuffer = 12;
    reloadRate = 5;
    reloadTime = 8;
    shotLife = 20;
    //The damage per level
    chargeHitDamage[0]=0
    chargeHitDamage[1]=4
    chargeHitDamage[2]=8
    chargeHitDamage[3]=16
frameskip=false

    chargeLevel=0
    chargePerNext=60
    chargeToPer=10
    playedSound=false
    ammoCount = maxAmmo;
event_inherited()
}")
object_event_add(quote_spur.Spur,ev_destroy,0,"
with (BladeB)
    if (ownerPlayer == other.ownerPlayer)
        instance_destroy();
")
object_event_add(quote_spur.Spur,ev_alarm,5,"
if ammoCount < maxAmmo {
    ammoCount+=2.5;
}
else if ammoCount < maxAmmo{
    ammoCount=maxAmmo
}
if ammoCount < maxAmmo {
    alarm[5] = reloadTime / global.delta_factor;
}

")
object_event_add(quote_spur.Spur,ev_step,ev_step_begin,"
if ownerPlayer.hasAGoldenSpur=true{
normalSprite = quote_spur.GoldenSpurS
recoilSprite = quote_spur.GoldenSpurS
sprite_index = quote_spur.GoldenSpurS
}else{
normalSprite = quote_spur.SpurS
recoilSprite = quote_spur.SpurS
sprite_index = quote_spur.SpurS
}
")
object_event_add(quote_spur.Spur,ev_other,ev_user1,"

    if(readyToShoot and ammoCount>=1.5)
    {
        ammoCount-=1.5;  
        playsound(x,y,quote_spur.SpurSnd1);
        shot = instance_create(x+lengthdir_x(5, owner.aimDirection), y+lengthdir_y(5, owner.aimDirection), quote_spur.SpurShot);
        instance_create(x+lengthdir_x(5, owner.aimDirection), y+lengthdir_y(5, owner.aimDirection), quote_spur.StarPop);
        shot.direction = owner.aimDirection;
        shot.speed = 16*global.delta_factor
        shot.owner = owner;
        shot.ownerPlayer = ownerPlayer;
        shot.team = owner.team;
        shot.hitDamage = hitDamage;
        alarm[0] = refireTime/global.delta_factor
        shot.alarm[0] = shotLife/global.delta_factor
        shot.weapon = quote_spur.spurUncharged;
        with(shot)
        justShot = true;
        readyToShoot = false;
    }
    alarm[5] = (reloadBuffer + reloadTime)/ global.delta_factor;
")
object_event_add(quote_spur.Spur,ev_other,ev_user2,"
")

object_event_add(quote_spur.Spur,ev_other,ev_user3,"
if global.game_fps=60 && frameskip==true{
frameskip=false
exit;
}else if global.game_fps=60{
frameskip=true
}if chargeToPer<=0{
if ammoCount>=0.4{
if chargePerNext>0{
switch(chargeLevel){
case 0:
playsound(x,y,quote_spur.CSSpurCharge1Snd)
break;
case 1:
playsound(x,y,quote_spur.CSSpurCharge2Snd)

break;
case 2:
playsound(x,y,quote_spur.CSSpurCharge3Snd)
break;
}
chargePerNext-=4
if chargeLevel<3{
ammoCount-=0.35

}
}
if chargeLevel<3&&chargePerNext<=0{
chargeLevel+=1
chargePerNext=60+(60)*(chargeLevel)
if chargeLevel=3&&!playedSound{
playsound(x,y,quote_spur.CSSpurChargeCompleteSnd)

playedSound=true
}
}
ammoCount-=0.12
alarm[5] = (reloadBuffer + reloadTime)/global.delta_factor;
}else{event_user(4)}}else{chargeToPer-=1}
")

object_event_add(quote_spur.Spur,ev_other,ev_user4,"

if chargeLevel>0{
    shot = instance_create(x+lengthdir_x(5, owner.aimDirection), y+lengthdir_y(5, owner.aimDirection), quote_spur.SpurChargeShotFront);
    instance_create(x+lengthdir_x(5, owner.aimDirection), y+lengthdir_y(5, owner.aimDirection), quote_spur.StarPop);
    shot.base=instance_create(shot.x,shot.y,quote_spur.SpurChargeShotBack)
    shot.direction = owner.aimDirection;
    shot.speed=16*global.delta_factor
    playedSound=false
    shot.owner = owner;
    shot.ownerPlayer = ownerPlayer;
    shot.team = ownerPlayer.team;
    shot.hitDamage = chargeHitDamage[chargeLevel];
    shot.level=chargeLevel
    alarm[0] = refireTime / global.delta_factor;
    shot.lifetime = shotLife*3 / global.delta_factor;
    //shot.weapon = WEAPON_BLADE;
    
    if ownerPlayer.hasAGoldenSpur{
        shot.golden=true
        switch(chargeLevel){
        case 1:
            playsound(x,y,quote_spur.CSSpurChargeShot1Snd)
            shot.weapon = quote_spur.spurLvIR;
            break;
        case 2:
            playsound(x,y,quote_spur.CSSpurChargeShot2Snd)
            shot.weapon = quote_spur.spurLvIIR;
            break;
        case 3:
            playsound(x,y,quote_spur.CSSpurChargeShot3Snd)
            shot.weapon = quote_spur.spurLvIIIR;
            break;
    }
    }else{
    switch(chargeLevel){
        case 1:
            playsound(x,y,quote_spur.CSSpurChargeShot1Snd)
            shot.weapon = quote_spur.spurLvI;
            break;
        case 2:
            playsound(x,y,quote_spur.CSSpurChargeShot2Snd)
            shot.weapon = quote_spur.spurLvII;
            break;
        case 3:
            playsound(x,y,quote_spur.CSSpurChargeShot3Snd)
            shot.weapon = quote_spur.spurLvIII;
            break;
    }
    }
}
chargeToPer=10
chargePerNext=60
chargeLevel=0
")
object_event_add(quote_spur.Spur,ev_other,ev_user5,"
chargeToPer=10
chargeToNext=60
chargeLevel=0
playedSound=false
")
object_event_add(quote_spur.Spur,ev_other,ev_user12,"
event_inherited()
write_ubyte(global.serializeBuffer, ammoCount/4);
write_ubyte(global.serializeBuffer, chargeLevel);
write_ubyte(global.serializeBuffer, chargePerNext);
")
object_event_add(quote_spur.Spur,ev_other,ev_user13,"
event_inherited()
receiveCompleteMessage(global.serverSocket, 3, global.deserializeBuffer);
ammoCount = read_ubyte(global.deserializeBuffer)*4;
chargeLevel = read_ubyte(global.deserializeBuffer);
chargePerNext = read_ubyte(global.deserializeBuffer);
")


////////SPUR NON-CHARGE SHOT (NEW OBJECT)///////////////////
object_event_add(quote_spur.SpurShot,ev_create,0,"
{
    originx=x;
    originy=y;
    pushScale = 0.1
}
")
object_event_add(quote_spur.SpurShot,ev_alarm,0,"
instance_destroy()
instance_create(x,y,quote_spur.StarPop)
")
object_event_add(quote_spur.SpurShot,ev_step,ev_step_normal,"
{
    image_angle=direction;
}
")
object_event_add(quote_spur.SpurShot,ev_collision,Obstacle,"
{
    var imp;
  gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    instance_destroy();
}
")
object_event_add(quote_spur.SpurShot,ev_collision,Character,"
    if(other.id != ownerPlayer.object and other.player.team != ownerPlayer.team  && other.hp > 0 && other.ubered == 0) {
       

           damageCharacter(ownerPlayer, other.id, hitDamage);
            if (other.lastDamageDealer != ownerPlayer && other.lastDamageDealer != other.player){
                other.secondToLastDamageDealer = other.lastDamageDealer;
                other.alarm[4] = other.alarm[3]
            }
            other.alarm[3] = ASSIST_TIME;
            other.lastDamageDealer = ownerPlayer;
            other.lastDamageSource = weapon;
            with(other) {
                motion_add(other.direction, other.speed*other.pushScale);
                dealFlicker(id);   
                }
                
                

            
        instance_destroy();
        }

")
object_event_add(quote_spur.SpurShot,ev_collision,TeamGate,"
if !global.mapchanging{
    var imp;
    gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    instance_destroy();
}
")
object_event_add(quote_spur.SpurShot,ev_collision,ControlPointSetupGate,"
gunSetSolids();
if ControlPointSetupGate.solid=true{
    var imp;
    really_move_contact_solid(direction, speed);   
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    instance_destroy();
}
gunUnsetSolids();
")
object_event_add(quote_spur.SpurShot,ev_collision,Sentry,"
if(other.team != team) {
    /* FALL OFF
    if (distance_to_point(originx,originy)<=(maxdist/2)){
                hitDamage = ((0.25*baseDamage)*((0.5*maxdist - distance_to_point(originx,originy))/(0.5*maxdist)))+baseDamage;
                }
                else hitDamage = (((maxdist - distance_to_point(originx,originy))/(maxdist/2))*(0.75*baseDamage))+(0.25*baseDamage);
                */
    damageSentry(ownerPlayer, other.id, hitDamage);
    other.lastDamageDealer = ownerPlayer;
    other.lastDamageSource = weapon;
    instance_destroy();
    }
")
object_event_add(quote_spur.SpurShot,ev_collision,BulletWall,"
{
    var imp;
    gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    instance_destroy();
}
")
object_event_add(quote_spur.SpurShot,ev_collision,Generator,"
if(other.team != team) {
    damageGenerator(ownerPlayer, other.id, hitDamage);
    instance_destroy();

    instance_destroy();
}
")

object_event_add(quote_spur.SpurShot,ev_draw,0,"
draw_sprite_ext(sprite_index,team,x,y,image_xscale,image_yscale,direction,c_white,1)
")
////////////////////SPUR CHARGE SHOT(2 NEW OBJECTS/////////////////////////////////




//////////////FRONT OF SHOT///////////////////////
object_event_add(quote_spur.SpurChargeShotFront,ev_create,0,"
{
    originx=x;
    originy=y;
    pushScale = 0.1
    length=0
    level=0
    stopped=false
    collideOkay=0
    golden=false
}
")
object_event_add(quote_spur.SpurChargeShotFront,ev_alarm,0,"
stopped=true
")

object_event_add(quote_spur.SpurChargeShotFront,ev_step,ev_step_normal,"
    //For the line growing and shrinking, then moving once it's at 180px
    if !instance_exists(base)
    {
        instance_destroy()
    }
    else
    {
        length=point_distance(x,y,base.x,base.y)
        if stopped
        {
            speed=0
            base.speed=16*global.delta_factor
            base.direction=direction
            if place_meeting(x,y,base)
            {
                instance_destroy()
            }
        }
        if length>=180&&!stopped
        {
            base.speed=16*global.delta_factor
            base.direction=direction
        }
        //Collision with damageable objects.
        with Player
        {
            if collision_line(other.x,other.y,other.base.x,other.base.y,object,1,0)
            {
                if other.collideOkay<=0 && other.ownerPlayer!=id
                {
                    instance_create(object.x,object.y,quote_spur.TinyExplosion)
                }
                if instance_exists(object)&&object!=-1
                {
                    if object.hp>0
                    {
                        if(id != other.ownerPlayer and other.ownerPlayer.team!=team and object != -1 &&!object.ubered)
                        {
                            if global.game_fps=30
                            {
                                damageCharacter(other.ownerPlayer, object, other.hitDamage);
                            }
                            else if global.game_fps=60
                            {
                                damageCharacter(other.ownerPlayer, object, other.hitDamage/2);
                            }
                            dealFlicker(object);

                            if (object.lastDamageDealer != other.ownerPlayer && object.lastDamageDealer != object.player)
                            {
                                object.secondToLastDamageDealer = object.lastDamageDealer;
                                object.alarm[4] = object.alarm[3]
                            }
                            object.cloakAlpha = min(object.cloakAlpha + 0.3, 1);
                            object.alarm[3] = ASSIST_TIME;
                            object.lastDamageDealer = other.ownerPlayer;
                            object.lastDamageSource=other.weapon
                        }
                    }
                }
            }
            if sentry!=-1
            {
                if collision_line(other.x,other.y,other.base.x,other.base.y,sentry,1,0)
                {
                    if other.ownerPlayer!=id && other.ownerPlayer.team!=team
                    {
                        if other.collideOkay<=0
                        {
                            instance_create(sentry.x,sentry.y,quote_spur.TinyExplosion)
                        }
                       
                            damageSentry(other.ownerPlayer, sentry.id, other.hitDamage*global.delta_factor);
                        
                        sentry.lastDamageDealer = other.ownerPlayer;
                        sentry.lastDamageSource=other.weapon
                    }

                }
            }
        }
        with Generator{
            if(other.ownerPlayer.team != team) {
            if collision_line(other.x,other.y,other.base.x,other.base.y,id,1,0){
                    
                        damageGenerator(other.ownerPlayer, id, other.hitDamage*global.delta_factor);
                   

                    if other.collideOkay<=0{
                        instance_create(x,y,quote_spur.TinyExplosion)
                    }
                }
            }
        }
    }
    if collideOkay<=0{
        collideOkay=random(1)+2
        if stopped{
            instance_create(x,y,quote_spur.TinyExplosion)
        }
    }
    collideOkay-=1
")



object_event_add(quote_spur.SpurChargeShotFront,ev_collision,Obstacle,"
{
    var imp;
  gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    stopped=true
}")
object_event_add(quote_spur.SpurChargeShotFront,ev_collision,Obstacle,"
{
    var imp;
  gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    stopped=true
}")

object_event_add(quote_spur.SpurChargeShotFront,ev_collision,TeamGate,"
if !global.mapchanging{
    var imp;
  gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    stopped=true
}")

object_event_add(quote_spur.SpurChargeShotFront,ev_collision,BulletWall,"
{
    var imp;
  gunSetSolids();
    really_move_contact_solid(direction, speed);
    gunUnsetSolids();
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    stopped=true
}")
object_event_add(quote_spur.SpurChargeShotFront,ev_collision,ControlPointSetupGate,"
gunSetSolids();
if (ControlPointSetupGate.solid){
    var imp;
    really_move_contact_solid(direction, speed);
    instance_create(x,y,quote_spur.IneffectiveExplosion)
    stopped=true
}
 gunUnsetSolids();
")
object_event_add(quote_spur.SpurChargeShotFront,ev_draw,0,"
if instance_exists(base){
if!stopped{
if golden
draw_sprite_general(quote_spur.SpurChargeShotS,level-1+3*team,180-point_distance(x,y,base.x,base.y),0,point_distance(x,y,base.x,base.y),8,base.x,base.y,1,1,direction,make_color_hsv(random(255),255,255),make_color_hsv(random(255),255,255),make_color_hsv(random(255),255,255),make_color_hsv(random(255),255,255),1);
else
draw_sprite_general(quote_spur.SpurChargeShotS,level-1+3*team,180-point_distance(x,y,base.x,base.y),0,point_distance(x,y,base.x,base.y),8,base.x,base.y,1,1,direction,c_white,c_white,c_white,c_white,1);
}else{
if golden
draw_sprite_general(quote_spur.SpurChargeShotS,level-1+3*team,0,0,point_distance(x,y,base.x,base.y),8,base.x,base.y,1,1,direction,make_color_hsv(random(255),255,255),make_color_hsv(random(255),255,255),make_color_hsv(random(255),255,255),make_color_hsv(random(255),255,255),1);
else
draw_sprite_general(quote_spur.SpurChargeShotS,level-1+3*team,0,0,point_distance(x,y,base.x,base.y),8,base.x,base.y,1,1,direction,c_white,c_white,c_white,c_white,1);
}
}")
//////////////////////////////////////REAR OF SHOT////////////////////////////////////////////////
object_event_add(quote_spur.SpurChargeShotBack,ev_create,0,"
visible=false
")
object_event_add(quote_spur.SpurChargeShotBack,ev_collision,Obstacle,"
instance_destroy()
")
object_event_add(quote_spur.SpurChargeShotBack,ev_collision,TeamGate,"
instance_destroy()
")
object_event_add(quote_spur.SpurChargeShotBack,ev_collision,BulletWall,"
instance_destroy()
")
object_event_add(quote_spur.SpurChargeShotBack,ev_collision,ControlPointSetupGate,"
if ControlPointSetupGate.solid=true{
instance_destroy()
}
")
object_event_add(quote_spur.SpurChargeShotBack,ev_other,ev_outside,"
instance_destroy()
")







////////////////////INPUT CHANGES IN CHARACTER BEGIN STEP (NOT CHANGES YET)////////////////////////////
object_event_clear(Character,ev_step,ev_step_begin)
object_event_add(Character,ev_step,ev_step_begin,"

// Apply afterburn
if (burnDuration > 0)
{
    if(hp > 0)
    {   // Don't count if someone else already finished him off, to prevent afterburn from stealing sticky kills (Bug #1021989)
        if (lastDamageDealer != burnedBy and lastDamageDealer != player)
        {
            secondToLastDamageDealer = lastDamageDealer;
            alarm[4] = alarm[3] / global.delta_factor;
        }
        alarm[3] = ASSIST_TIME / global.delta_factor;
        lastDamageDealer = burnedBy;
        lastDamageSource = afterburnSource;
        dealDamage(lastDamageDealer, id, burnIntensity / 30);
    }
    burnDuration -= durationDecay * global.delta_factor;

}
if (alarm[0] == -1 && burnIntensity > 0) burnIntensity -= intensityDecay;
if (burnDuration <= 0 || burnIntensity <= 0)
{
    burnDuration = 0;
    burnIntensity = 0;
    burnedBy = -1;
    afterburnSource = -1;
}
// Handle input
if(player.queueJump)
{
    if (pressedKeys & $80)
        wantToJump = true;
    else if (releasedKeys & $80)
        wantToJump = false;
}

///////////////////////////BEGIN CHANGES//////////////////////////////////////////////

//ejaculate chargebeam if taunting to prevent that horrible glitch where I would run around taunting and then shoot people with a fully charged beam
if currentWeapon.object_index=quote_spur.Spur && taunting{
if !player.humiliated{
with(currentWeapon){event_user(4)}
}
}
if(!taunting and !omnomnomnom)
{
if currentWeapon.object_index=quote_spur.Spur{

//Left click tap for quotes
if(((pressedKeys) & $10) and !player.humiliated){
with (currentWeapon){event_user(1)}
}
//Left click hold for quotes
if(((keyState) & $10) and !player.humiliated){
with(currentWeapon){event_user(3)}
}else if !player.humiliated{
with(currentWeapon){event_user(4)}
}
}else{
//Left click hold and tap for everyone else
if(!player.humiliated and (keyState | pressedKeys) & $10)
with(currentWeapon) event_user(1);
}





////////////////////////////////END CHANGES//////////////////////////////////////



    if(!player.humiliated and pressedKeys & $01)  {
        if (!invisible && cloakAlpha == 1)
            taunting=true;
        if (team==TEAM_RED) {
            tauntindex=0;
            tauntend=tauntlength-1;
        }
        else if (team==TEAM_BLUE) {
            tauntindex=tauntlength;
            tauntend=tauntlength*2-1;
        }
        image_speed=tauntspeed;
    } 
    
    if(pressedKeys & $80 or (player.queueJump and wantToJump))
    {
        charSetSolids();
        if ((!place_free(x, y+1) and place_free(x, y))
            or (place_meeting(x, y+1, DropdownPlatform) and !place_meeting(x, y, DropdownPlatform)))
        {
            if(not stabbing)
            {
                doublejumpUsed = 0;
                wantToJump = false;
                if player.class!=CLASS_QUOTE{
                playsound(x,y,JumpSnd);
                }else{
                playsound(x,y,quote_spur.CSQuoteJumpSnd)
                }
                vspeed = min(vspeed, -jumpStrength);
                onground = false;
            }
        }
        else if(canDoublejump and !doublejumpUsed and vspeed > -jumpStrength)
        {
            wantToJump = false;
            vspeed = -jumpStrength;
                if player.class!=CLASS_QUOTE{
                playsound(x,y,JumpSnd);
                }else{
                playsound(x,y,quote_spur.CSQuoteJumpSnd)
                }
            doublejumpUsed = 1;
            moveStatus = 0;
        }
        charUnsetSolids();
    }
}
// Right click
if (!player.humiliated and ((keyState | pressedKeys) & $08)
    and (!taunting or player.class == CLASS_DEMOMAN) and !omnomnomnom)
{
    with(currentWeapon)
        event_user(2);
}

// Cloak
if (!player.humiliated && (pressedKeys & $08)
    && canCloak && ((cloakAlpha == 1 and !cloak) or cloak)
    && !intel  && !taunting)
{
    if(currentWeapon.readyToStab) {
        if (cloak) { // stop spies immediately picking up intel after uncloaking
            canGrabIntel = false;
            alarm[1] = max(alarm[1], 25 / global.delta_factor); // avoid decreasing the alarm on accident
        }
        cloak = !cloak;
    }
}

switch(moveStatus) // moveStatus is reset in collision with ceilings (including doors if they reject you)
{
case 1: //If I am rocketing/mining myself
    controlFactor = 0.65;
    frictionFactor = 1;
    break;
case 2: //If I am rocketing/mining an enemy
    controlFactor = 0.45;
    frictionFactor = 1.05;
    break;
case 3: //Airblast
    controlFactor = 0.35;
    frictionFactor = 1.05;
    break;
case 4: //If I am rocketing/mining a teamate
    controlFactor = baseControl;
    frictionFactor = 1;
    break;
default:
    if (player.humiliated)
        controlFactor = baseControl-0.2;
    else if (intel)
        controlFactor = baseControl-0.1;
    else
        controlFactor = baseControl;
    frictionFactor = baseFriction;
}

if(moveStatus == 1 or moveStatus == 2 or moveStatus == 4 and global.run_virtual_ticks)
{
    if !variable_local_exists(global.jumpFlameParticleTypeString)
    {
        jumpFlameParticleType = part_type_create();
        part_type_sprite(jumpFlameParticleType,FlameS,true,false,true);
        part_type_alpha2(jumpFlameParticleType,1,0.3);
        part_type_life(jumpFlameParticleType,2,5);
        part_type_scale(jumpFlameParticleType,0.7,-0.65);
    }
    vspeed -= 0.06 * global.delta_factor;
    
    if !variable_global_exists(global.jumpFlameParticleSystemString)
    {
        global.jumpFlameParticleSystem = part_system_create();
        part_system_depth(global.jumpFlameParticleSystem, 10);
    }
    
    if(global.particles == PARTICLES_NORMAL)
    {
        if(random(1) > (controlFactor+frictionFactor)/2)
        {
            effect_create_below(ef_smoke,x-hspeed*1.2,y-vspeed*1.2+20,0,c_gray);
        }
    }
    if(global.particles == PARTICLES_NORMAL or global.particles == PARTICLES_ALTERNATIVE)
    {
        if(random(7) < 5)
        {
            part_particles_create(global.jumpFlameParticleSystem,x,y+19,jumpFlameParticleType,1);
        }
    }
}
if(spinjumping)
{
    
    if !variable_local_exists(global.jumpDustParticleTypeString)
    {
        jumpDustParticleType = part_type_create();
        part_type_sprite(jumpDustParticleType,SpeedBoostS,false,false,true);
        part_type_alpha3(jumpDustParticleType,0.7,0.5,0);
        part_type_life(jumpDustParticleType,15,30);
        part_type_scale(jumpDustParticleType,1,1);
        part_type_orientation(jumpDustParticleType, -90, -90, 0, 0, 0);
    }
    if !variable_global_exists(global.jumpDustParticleSystemString)
    {
        global.jumpDustParticleSystem = part_system_create();
        part_system_depth(global.jumpDustParticleSystem, 10);
    }
    
    if(global.particles == PARTICLES_NORMAL or global.particles == PARTICLES_ALTERNATIVE)
    {
        if(random(4) < 4)
        {
            if(sign(_last_hspeed) > 0)
                part_particles_create(global.jumpDustParticleSystem,bbox_right+1,bbox_bottom-4,jumpDustParticleType,1);
            else
                part_particles_create(global.jumpDustParticleSystem,bbox_left +2,bbox_bottom-4,jumpDustParticleType,1);
        }
    }
}

controlling = false;
repeat(global.frameskip)
{
    // Do movement
    if(!taunting && !omnomnomnom)
    {
        if((keyState|pressedKeys) & $40 and hspeed >= -basemaxspeed)
        {
            hspeed -= runPower*controlFactor * global.skip_delta_factor;
            controlling = true;
        }
        if((keyState|pressedKeys) & $20 and hspeed <= basemaxspeed)
        {
            hspeed += runPower*controlFactor * global.skip_delta_factor;
            controlling = !controlling; // cancel out 'controlling' if both buttons are pressed
        }
    }
    // divide friction as normal if going way too fast
    if(abs(hspeed) > basemaxspeed * 2 or
       ((keyState|pressedKeys) & $60 and abs(hspeed) < basemaxspeed))
        hspeed /= delta_mult_skip(baseFriction);
    else //otherwise divide by the moveStatus's friction
        hspeed /= delta_mult_skip(frictionFactor);
}

if(pressedKeys & $04) {
    setChatBubble(player, 45);
}
    
pressedKeys = 0;
releasedKeys = 0;

// flame bubble
if burnDuration>0 && player.class != CLASS_PYRO and random(80) <= 1 {
    setChatBubble(player, 49);
}

// stop players who are moving too slowly (avoid ice skating)
if (abs(hspeed) < 0.195 * global.delta_factor and !controlling)
{
    hspeed=0;
    animationImage=0;
    still = true;
}
else
    still = false;

charSetSolids();

if(place_free(x,y+1)) // no obstacle ground below us
{
    vspeed += 0.6 * global.delta_factor;
    if(vspeed > 10)
        vspeed = 10;
    
    // standing on a dropdown platform
    if (place_meeting(x, y+1, DropdownPlatform) and !place_meeting(x, y, DropdownPlatform) and vspeed >= 0)
    {
        onground = true;
    }
    else // NOT standing on one
    {
        animationImage = 1;
        onground = false;
    }
}
else // obstacle ground below us
{
    if(place_free(x, y) or (place_meeting(x, y+1, DropdownPlatform) and !place_meeting(x, y, DropdownPlatform)) and vspeed >= 0)
    {
        onground = true;
        doublejumpUsed = 0;
        moveStatus = 0;
    }
}

if (intel)
{ 
    if (global.run_virtual_ticks)
    {
        if (speed > 0.195)
        {
            if (random(1) > 0.90)
            {
                var sheet;
                sheet = instance_create(x,y-11+random(9),LooseSheet);
                sheet.hspeed = hspeed;
            }
        }
        else if (random(1) > 0.975)
        {
            var sheet;
            sheet = instance_create(x,y-11+random(9),LooseSheet);
            sheet.hspeed = hspeed;
        }
    }
    if (cloak)
    {
        cloak=false;
        cloakAplha=1;
    }
    if (!omnomnomnom) // Do not recharge intel timer if eating
        intelRecharge = min(INTEL_MAX_TIMER, // Cap timer charge at the intel timer's length (bandwidth)
                            intelRecharge + global.delta_factor * // ...After adding some value to it 
                            INTEL_MAX_TIMER/((3+abs(min(hspeed, 7))/3.5)*30)); // ...Which starts at a rate of full charge per three seconds, and reduces linearly with speed, down to full charge per five seconds with a scout's max speed
}
var sprite_length;
if(player.class == CLASS_QUOTE or sprite_special or zoomed)
    sprite_length = 2;
else
    sprite_length = CHARACTER_ANIMATION_LEN;

if (player.humiliated)
{
    if (!place_free(x,y+1) && hspeed == 0)
        animationImage = 0;
    else if place_free(x,y+1)
        animationImage = 2;
    if (!place_free(x,y+1) && hspeed != 0)
        animationImage = 1+
        ((animationImage-1+
          min(abs(hspeed), 8)
          *global.delta_factor/20) mod 
         2);
}
else
{
    if (place_free(x,y+1) and hspeed != 0 and player.class == CLASS_QUOTE)
    {
        animationImage = 1;
    }
    else
    {
        animationImage = (animationImage+
         min(abs(hspeed)*sign(hspeed), 8)
         *image_xscale*global.delta_factor/20)
        mod sprite_length;
    }
    // ensure positive animationImage
    animationImage = (animationImage+sprite_length) mod sprite_length;
}

charUnsetSolids();

// drop intel if ubered or round is over
if (intel and (ubered or global.mapchanging) and global.isHost) {
    sendEventDropIntel(player);
    doEventDropIntel(player);
}

//gotta regenerate some nuts
nutsNBolts = min(nutsNBolts+(0.1 * global.delta_factor), maxNutsNBolts);

//ubered max out ammo and extinguish flames
if ubered {
    if (burnIntensity > 0 || burnDuration > 0)
    {
        burnIntensity = 0;
        burnDuration = 0;
        burnedBy = -1;
    }
    if instance_exists(currentWeapon) {
        with(currentWeapon) {
            if(variable_local_exists(global.maxAmmoString)) {
                ammoCount = maxAmmo;
            }
            alarm[5] = -1;
        }
    }
}

//give max ammo for players on the winning team
var arenaRoundEnd;
arenaRoundEnd = true;
if instance_exists(ArenaHUD) { 
    if(ArenaHUD.endCount!=0) 
        arenaRoundEnd=true;
    else arenaRoundEnd=false;
}

if (arenaRoundEnd and global.mapchanging and !player.humiliated) {
    if instance_exists(currentWeapon) {
        with(currentWeapon){
            if(variable_local_exists(global.maxAmmoString)) {
                ammoCount = maxAmmo;
            }
            alarm[5] = -1;
        }
    }
}

//drop cloak and unscope if on losing team or stalemate
if (player.humiliated)
{
    if (zoomed)
        toggleZoom(id);
    if (!stabbing)
        cloak = false;
}

// Determine if the character is capturing a CP, and which
var zone;
zone = collision_point(x,y,CaptureZone,0,0);

if(zone >= 0 and !cloak and cloakAlpha == 1)
    cappingPoint = zone.cp;
else
    cappingPoint = noone;
")


/////////////////////COSMETICS////////////////////////
object_event_add(quote_spur.damageCounter,ev_create,0,"
damage=0
target=noone
alarm[0]=10/global.delta_factor
active=true
visible=false
yoffset=0
following=true
")
object_event_add(quote_spur.damageCounter,ev_destroy,0,"
if instance_exists(target){
target.indicator=id{
target.indicator=-1
}
}
")
object_event_add(quote_spur.damageCounter,ev_step,ev_step_begin,"
if instance_exists(target) && target!=noone{
with Character{
    if cloak && other.target=id{
        other.following=false
    }else if !cloak && other.target=id{
        other.following=true
    }
}
if following{
x=target.x+16
y=target.y-32 
}
}

")
object_event_add(quote_spur.damageCounter,ev_step,ev_step_normal,"
if instance_exists(target) && target!=noone{
if following{
x=target.x+16
y=target.y-32 
}
}
")
object_event_add(quote_spur.damageCounter,ev_step,ev_step_end,"
if instance_exists(target) && target!=noone{
if following{
x=target.x+16
y=target.y-32 
}
if damage=0 ||target.indicator!=id{
 instance_destroy();
}
}
")
object_event_add(quote_spur.damageCounter,ev_alarm,0,"
alarm[1]=30/global.delta_factor
active=true
if yoffset>8{yoffset-=1/global.delta_factor}
if yoffset<8 yoffset=8;
visible=true
")
object_event_add(quote_spur.damageCounter,ev_alarm,1,"
active=false
show=true
alarm[2]=8/global.delta_factor
vspeed=0
disappearing=true
")
object_event_add(quote_spur.damageCounter,ev_alarm,2,"
instance_destroy()
")
object_event_add(quote_spur.damageCounter,ev_draw,0,"
damage_number=string(floor(damage))
damage_number=string_digits(damage_number)
damage_length=string_length(damage_number)
i=damage_length
if active=true{
if real(damage_number)>0{
draw_sprite_ext(quote_spur.QuoteSymbolsS, 1,x-8*(damage_length),y+yoffset, 1, 1, 0, c_white, 1);
while i>0{   
    draw_sprite_ext(quote_spur.QuoteRedNumbersS, real(string_char_at(damage_number,i)), x+8*(i-damage_length),y+yoffset, 1, 1, 0, c_white, 1);
    i-=1
}
}
}else if active=false{
draw_sprite_part_ext(quote_spur.QuoteSymbolsS, 1,0,(8/global.delta_factor)-alarm[2],8,(8/global.delta_factor)-alarm[2],x-8*(damage_length),y+yoffset, 1, 1, c_white,1);
if real(damage_number)>0{
while i>0{
draw_sprite_part_ext(quote_spur.QuoteRedNumbersS, real(string_char_at(damage_number,i)),0,(8/global.delta_factor)-alarm[2],8,8-((8/global.delta_factor)-alarm[2]), x+8*(i-damage_length),y+yoffset, 1, 1, c_white,1);
    i-=1
}
}
}
")
object_event_add(quote_spur.StarPop,ev_other,ev_animation_end,"
instance_destroy()
")
object_event_add(quote_spur.TinyExplosion,ev_other,ev_animation_end,"
instance_destroy()
")
object_event_add(quote_spur.IneffectiveExplosion,ev_other,ev_animation_end,"
instance_destroy()
")

object_event_add(quote_spur.HurtBlood,ev_create,0,"
direction=random(360)
speed=random(10)
")
object_event_add(quote_spur.HurtBlood,ev_other,ev_animation_end,"
instance_destroy()
")
object_event_add(Character,ev_destroy,0,"
        if player.class=CLASS_QUOTE{
            with DeadGuy{if (alarm[0] == 300/global.delta_factor && point_distance(x,y,other.x,other.y) < 50) {
        instance_destroy()
        instance_create(x,y,quote_spur.QuoteExplosion);
          playsound(x,y+30,quote_spur.CSQuotesplosionSnd)
        
        instance_destroy()
        for(i = 0; i <= 360; i+=random_range(14,18)) {
            smoke = instance_create(x+(random_range(-10,10)),y+30+(random_range(-10,10)),quote_spur.QuoteSmoke);
            smoke.direction=(random_range(i-45,i+45));


            }}
              
        }
}
")
object_event_add(quote_spur.QuoteSmoke,ev_step,0,'hspeed /= (13.5/random_range(8,10)); vspeed /= (13.5/random_range(8,10));');
object_event_add(quote_spur.QuoteSmoke,ev_create,0,'image_speed = 0.3*10/random_range(5,10);
image_index = 0;
image_speed=0.5
image_xscale = 2;
image_yscale = 2;
hspeed = random_range(7, 25);
vspeed = random_range(4, 16);
depth = random(1);');
object_event_add(quote_spur.QuoteSmoke,ev_other,ev_animation_end,'instance_destroy()')

object_event_add(quote_spur.QuoteExplosion,ev_other,ev_animation_end,'instance_destroy()')

global.dealDamageFunction+="if argument0.class=CLASS_QUOTE{
if argument1!=global.myself{
repeat(3){
instance_create(argument1.x,argument1.y,quote_spur.HurtBlood)
}
}

if ((argument1 = global.myself.object) || argument0 = global.myself) {
    {
        with argument1{
            if !variable_local_exists(global.indicatorString){
                indicator=-1
            }
        }
        
        if argument1.indicator=-1{
            argument1.indicator=instance_create(argument1.x+8,argument1.y,quote_spur.damageCounter)
            argument1.indicator.target=argument1
        }
        if !argument1.indicator.active{
            with argument1.indicator{instance_destroy()}
            argument1.indicator=instance_create(argument1.x+8,argument1.y,quote_spur.damageCounter)
            argument1.indicator.target=argument1
        }
            with argument1.indicator{
                if !visible{
                    alarm[0]=10/global.delta_factor
                }else{
                    alarm[1]=30/global.delta_factor
                }
            }
        argument1.indicator.damage+=argument2
        
        
        
    }
}
if argument1.object_index!=Sentry and argument1.object_index!=GeneratorRed and argument1.object_index!=GeneratorBlue{
   selectSound=-1
     var selectSound;
            if (argument1.player.class = CLASS_SCOUT ||
            argument1.player.class = CLASS_SPY ||
            argument1.player.class = CLASS_SNIPER)
                selectSound=quote_spur.CSSqueakSmallSnd;
            if (argument1.player.class = CLASS_PYRO ||
            argument1.player.class = CLASS_ENGINEER ||
            argument1.player.class = CLASS_MEDIC)
               selectSound=quote_spur.CSSqueakMedSnd;
            if (argument1.player.class = CLASS_SOLDIER||
            argument1.player.class = CLASS_DEMOMAN ||
            argument1.player.class = CLASS_HEAVY)
                selectSound=quote_spur.CSSqueakBigSnd;       
           
            if (argument1.player.class = CLASS_QUOTE)
                selectSound=quote_spur.CSQuoteHurtSnd;

              if selectSound=-1 selectSound=quote_spur.CSObjectHurtSnd;        
             playsound(argument1.x,argument1.y,selectSound)
     }

if argument1.object_index=Sentry or argument1.object_index=GeneratorRed or argument1.object_index=GeneratorBlue{
    playsound(argument1.x,argument1.y,quote_spur.CSObjectHurtSnd)

}

}"