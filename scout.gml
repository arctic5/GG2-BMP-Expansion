global.doEventKick="
//argument0: aimDirection; argument1: image_xscale; argument2: hspeed;
aim=argument0;
xscale=argument1;
movement=argument2
down=270
if xscale>0{

    if movement<=0{
        return down;
    }

    if movement>0 && movement<6.5{
        if (aim>down && aim<down+45.1){
            return aim;
        } else if (aim>=down+45.1) or (aim>=down+89 or aim<=60.1){
            return down+45.1;
        } else if (aim<=down and aim>60.1){
            return down;
        }
    }
if movement>=6.5{
    if (aim>down && aim<down+60.1){
        return aim;

        
    } else if (aim>=down+60.1) or (aim>=down+89 or aim<=60.1){
        return down+60.1;

    } else if (aim<=down && aim>60.1){
        return down;
    }

}
} else if xscale<0{

    if movement=0{
        return down;
    }

    if movement>0 && movement<6.5{
        if (aim<down && aim>down-45.1){
        return aim;
    } else if (aim<=down-45.1) and (aim>=down-150){
        return down-45.1;
    } else if (aim<=down && aim>135){
        return down;
    }

    }
if movement>=6.5{
 if (aim<down && aim>down-60.1){
            return aim;
        } else if (aim<=down-60.1) and (aim>=down-150){
            return down-60.1;
        } else if (aim<=down && aim>down-135){
            return down;
        }
}
}else{
return down;
}
return down;


"
global.setKickSprite="
if argument0=270{
return 0;
}

if argument1>0{
if argument0<=300.1 && argument0 !=270{
return 1;
}
if argument0>300.1{
return 2;
}
}
if argument1<0{
if argument0>=239.9 && argument0 !=270{
return 1;
}
if argument0<239.9{
return 2;
}
}



"
////Scout's stuffs, contains a whole lotta stuffs.
object_event_add(Scout,ev_create,0,"
hasCanceledFlip=0
huggingWall=0
kicking=0
airControl=1
setHspeed=0
setVspeed=0
setScale=0
cc=0
canKick=true
rebounding=false
kickPower=16
flameSprite=FlameS
blurSprite[0]=expansion.ScoutNoColorKickS
blurSprite[1]=expansion.ScoutNoColorKick2S
blurSprite[3]=expansion.ScoutNoColorKick3S
")
object_event_add(Scout,ev_alarm,11,"
canKick=true
")
object_event_add(Scout,ev_step,ev_step_begin,"
if player.name=global.BassMakesPaste{
flameSprite=expansion.RainbowFlameS
}
if rebounding or kicking currentWeapon.readyToFire=false;
event_inherited()
if (pressedKeys | keyState) & $02 && !kicking && airControl=true{
    huggingWall=false
    vspeed=10
    if player.team=TEAM_RED
                sprite_index=ScoutRedS;
            else sprite_index=ScoutBlueS;
    charSetSolids();    
    if kicking=false && canKick=true && player.humiliated=false&& place_free(x,y+1){
            airControl=false
            kicking=true
            if player.team=TEAM_RED
                sprite_index=expansion.ScoutRedKickS;
            else sprite_index=expansion.ScoutBlueKickS;
            sprite_special=true
            currentWeapon.readyToShoot=false
            currentWeapon.visible=false
            
        
            
    kickDir=270
    animationImage=0
    animationOffset=0
    motion_set(270,kickPower)
    
    setHspeed=hspeed
    setVspeed=vspeed
    setScale=image_xscale
    kickmask=instance_create(x,y,expansion.KickBox)
    kickmask.owner=id
    kickmask.ownerPlayer=player
    kickmask.image_xscale=image_xscale
    }
    charUnsetSolids(); 
    }

if(!taunting and !omnomnomnom)
{
    if(!player.humiliated and (keyState | pressedKeys) & $10)&&!kicking &&!rebounding&&!huggingWall{
        airControl=true
            currentWeapon.visible=true
            setHspeed=0
            sprite_special=false
            hasCanceledFlip=true
            cc=0
            if player.team=TEAM_RED
                sprite_index=ScoutRedS;
            else sprite_index=ScoutBlueS;
            }
    if(!player.humiliated and pressedKeys & $01)&&!kicking  {
        if (!invisible && cloakAlpha == 1){
            
            if player.class=CLASS_SCOUT{
        airControl=true
            currentWeapon.visible=true
            setHspeed=0
            sprite_special=false
            hasCanceledFlip=true
            cc=0
            huggingWall=false
            }
            }
    }
    //}
if (doublejumpUsed){
  if player.class=CLASS_SCOUT{
    if (!huggingWall && !kicking &&((keyState & $40 && hspeed<0)||(keyState & $20 && hspeed>0))&& hasCanceledFlip=false)||rebounding=true{
        if cc<5/global.delta_factor{ cc+=1/global.delta_factor;
        }else{
            if airControl=true{
            setHspeed=hspeed
            setScale=image_xscale
            }
            airControl=false
            currentWeapon.visible=false
            
            if team=TEAM_RED sprite_index=expansion.ScoutRedFlipS;
            else{ sprite_index=expansion.ScoutBlueFlipS};
            animationOffset+=1*global.delta_factor*(sign(hspeed*image_xscale))
            if animationOffset<0 animationOffset=7;
            sprite_special=true
                animationImage=0
            }

    }else if !kicking && !rebounding &&!huggingWall{
            airControl=true
            currentWeapon.visible=true
            setHspeed=0
            sprite_special=false
            hasCanceledFlip=true
            cc=0
            }  
            }
}
}
charSetSolids();
    if!(place_free(x,y+1)){
if (place_meeting(x, y+1, DropdownPlatform) and !place_meeting(x, y, DropdownPlatform) and vspeed >= 0)
    {
        airControl=true
            currentWeapon.visible=true
            setHspeed=0
            sprite_special=false
            hasCanceledFlip=false
            if kicking{ y+=8 currentWeapon.alarm[0] = currentWeapon.refireTime / global.delta_factor;
            kicking=false
            cloud=instance_create(x,y+5,expansion.DustCloud)
        cloud.image_xscale=1
        cloud.hspeed=10
        cloud=instance_create(x,y+5,expansion.DustCloud)
        cloud.hspeed=-10
        cloud.image_xscale=-1
            }
            if rebounding{ currentWeapon.alarm[0] = currentWeapon.refireTime / global.delta_factor;
            rebounding=false
            }
            cc=0
            if player.team=TEAM_RED
                sprite_index=ScoutRedS;
            else sprite_index=ScoutBlueS;
            huggingWall=false
    }
     airControl=true
            currentWeapon.visible=true
            setHspeed=0
            sprite_special=false
            hasCanceledFlip=false
            if kicking{
             y+=8 currentWeapon.alarm[0] = currentWeapon.refireTime / global.delta_factor;
            kicking=false
            cloud=instance_create(x,y+5,expansion.DustCloud)
        cloud.image_xscale=1
        cloud.hspeed=10
        cloud=instance_create(x,y+5,expansion.DustCloud)
        cloud.hspeed=-10
        cloud.image_xscale=-1
            }
            if rebounding{
             currentWeapon.alarm[0] = currentWeapon.refireTime / global.delta_factor;
            rebounding=false
            }
            cc=0
            huggingWall=false
            if player.team=TEAM_RED
                sprite_index=ScoutRedS;
            else sprite_index=ScoutBlueS;
            
    }
charUnsetSolids();
    if airControl=false&&huggingWall=false{
    hspeed=setHspeed
    image_xscale=setScale
    }
charSetSolids(); 
if (!player.humiliated and ((pressedKeys | keyState) & $02)and !taunting && canKick=true) &&place_free(x,y+1){
    if airControl=false{
        if kicking=false{
            kicking=true
            if player.team=TEAM_RED
                sprite_index=expansion.ScoutRedKickS;
            else sprite_index=expansion.ScoutBlueKickS;
        
            
            kickDir=execute_string(global.doEventKick,aimDirection,image_xscale,hspeed*sign(image_xscale))
            animationImage=execute_string(global.setKickSprite,kickDir,image_xscale)
    animationOffset=0
    motion_set(kickDir,kickPower)
    currentWeapon.readyToShoot=false
    
    setHspeed=hspeed
    setVspeed=vspeed
    setScale=image_xscale
    kickmask=instance_create(x,y,expansion.KickBox)
    kickmask.owner=id
    kickmask.ownerPlayer=player
    kickmask.image_xscale=image_xscale
    }
    
    }
}
charUnsetSolids();
if kicking{
if player.team=TEAM_RED
        sprite_index=expansion.ScoutRedKickS;
    else sprite_index=expansion.ScoutBlueKickS;

image_xscale=setScale
animationOffset=0


animationImage=execute_string(global.setKickSprite,kickDir,image_xscale)

}
charSetSolids();
if !place_free(x+sign(setScale),y)&&airControl=false{
    if kicking{
    currentWeapon.alarm[0] = currentWeapon.refireTime / global.delta_factor;
        kicking=false
        cloud=instance_create(x,y+5,expansion.DustCloud)
        cloud.direction=90
        cloud.image_xscale=setScale
        cloud.vspeed=-10
        cloud=instance_create(x,y+5,expansion.DustCloud)
        cloud.direction=270
        cloud.vspeed=10
        cloud.image_xscale=-setScale
    }
    
    if rebounding{
    currentWeapon.alarm[0] = currentWeapon.refireTime / global.delta_factor;
    rebounding=false
    }
    
    if ((setHspeed<0&&!place_free(x-1,y))||(setHspeed>0&&!place_free(x+1,y))){
        huggingWall=true
        currentWeapon.visible=true
        if player.team=TEAM_RED
            sprite_index=expansion.ScoutRedWallS;
        else sprite_index=expansion.ScoutBlueWallS;
        stickyX=round(x)
    }
}

if huggingWall{
x=stickyX
vspeed/=2
if player.team=TEAM_RED
            sprite_index=expansion.ScoutRedWallS;
        else sprite_index=expansion.ScoutBlueWallS;
if setScale<0{
if(((aimDirection+270) mod 360)>180) {
    animationOffset=0;
} else {
    animationOffset=1
}
}
if setScale>0{
if(((aimDirection+270) mod 360)>180) {
    animationOffset=1;
} else {
    animationOffset=0
}
}
if (setScale<0 && (keyState & $20)) or (setScale>0&&(keyState & $40)){
huggingWall=false

hspeed=-8*setScale
vspeed=-8
rebounding=true
setScale=-setScale
currentWeapon.readyToShoot=false

}
if place_free(x+sign(setScale),y){
huggingWall=false
airControl=true
if player.team=TEAM_RED
                sprite_index=ScoutRedS;
            else sprite_index=ScoutBlueS;
            currentWeapon.visible=true
            setHspeed=0
            sprite_special=false
            hasCanceledFlip=true
            cc=0
}
animationImage=0

}

if place_free(x,y+1){
if rebounding || kicking{
setVspeed += 0.6 * global.delta_factor;
}
if kicking&&setVspeed>10{
i=setVspeed+sign(setVspeed)
while place_free(x,y+sign(setVspeed)) && i>=0{
 y+=sign(setVspeed)
 i-=1
 
 }
}

}
i=0

charUnsetSolids();

if(kicking)
{
    if !variable_local_exists(global.falconKickParticleTypeString)
    {
        falconKickParticleType = part_type_create();
    
	part_type_sprite(falconKickParticleType,flameSprite,true,false,true)
        part_type_alpha2(falconKickParticleType,1,0.3);
        part_type_life(falconKickParticleType,2,5);
        part_type_scale(falconKickParticleType,1,1);
    }
    
    if !variable_global_exists(global.falconKickParticleSystemString)
    {
        global.falconKickParticleSystem = part_system_create();
        part_system_depth(global.falconKickParticleSystem, -2);
    }
    
    if(global.particles == PARTICLES_NORMAL or global.particles == PARTICLES_ALTERNATIVE)
    {
       repeat(3){
 if(1=1){
            
	part_particles_create(global.falconKickParticleSystem,x+random_range(-10,10),y+19,falconKickParticleType,1);
        }
	}
    }
     if !variable_local_exists(global.motionBlurParticleTypeString)
    {
        motionBlurParticleType = part_type_create();
        part_type_sprite(motionBlurParticleType,blurSprite[animationOffset],false,false,false);
	part_type_alpha3(motionBlurParticleType,1,0.5,0.1);
        part_type_life(motionBlurParticleType,2,5);
        part_type_scale(motionBlurParticleType,setScale,1);
    }else{
    part_type_destroy(motionBlurParticleType)
    motionBlurParticleType = part_type_create();
        
        part_type_sprite(motionBlurParticleType,blurSprite[animationOffset],false,false,false);
       
	part_type_alpha3(motionBlurParticleType,1,0.5,0.1);
        part_type_life(motionBlurParticleType,2,5);
        part_type_scale(motionBlurParticleType,setScale,1);
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
}
")
object_event_add(Scout,ev_step,ev_step_normal,"
event_inherited()
if huggingWall{
x=stickyX
}
")
object_event_add(Scout,ev_step,ev_step_end,"
event_inherited()
if airControl=false||huggingWall=true{
image_xscale=setScale
}
if huggingWall{
x=stickyX
if player.team=TEAM_RED
                sprite_index=expansion.ScoutRedWallS;
            else sprite_index=expansion.ScoutBlueWallS;
}
")

object_event_add(expansion.KickBox,ev_create,0,"
hitDamage=25
visible=false
")
object_event_add(expansion.KickBox,ev_step,ev_step_begin,"
if instance_exists(owner){
if owner.kicking{
x=owner.x
y=owner.y
}else instance_destroy()
}else instance_destroy()
")
object_event_add(expansion.KickBox,ev_step,ev_step_normal,"
if instance_exists(owner){
if owner.kicking{
x=owner.x
y=owner.y
}else instance_destroy()
}else instance_destroy()
")
object_event_add(expansion.KickBox,ev_step,ev_step_end,"
if instance_exists(owner){
if owner.kicking{
x=owner.x
y=owner.y
}else instance_destroy()
}else instance_destroy()
")

object_event_add(expansion.KickBox,ev_collision,Character,"
    if(other.id != ownerPlayer.object){
     instance_destroy();
    if instance_exists(owner){
with owner{
kicking=false
rebounding=true
motion_set(kickDir+180*setScale,kickPower)
setHspeed=hspeed
alarm[11]=45
canKick=false
}


    if (other.team != ownerPlayer.team  && other.hp > 0 && other.ubered == 0)
    {
        damageCharacter(ownerPlayer, other.id, hitDamage);
        if (other.lastDamageDealer != ownerPlayer and other.lastDamageDealer != other.player)
        {
            other.secondToLastDamageDealer = other.lastDamageDealer;
            other.alarm[4] = other.alarm[3]
        }
        other.alarm[3] = ASSIST_TIME;
        other.lastDamageDealer = ownerPlayer;
        other.lastDamageSource = WEAPON_FLARE;
        if ownerPlayer.name=global.BassMakesPaste
	other.lastDamageSource = WEAPON_REFLECTED_ROCKET;
        var blood;
        if(global.gibLevel > 0)
        {
            blood = instance_create(x,y,Blood);
            blood.direction = direction-180;
        }
        dealFlicker(other.id);
        with(other)
        {
            motion_add(other.owner.kickDir,15);
        }
        
    }
   
    }
    }
")
object_event_add(expansion.KickBox,ev_collision,Sentry,"
with owner{
kicking=false
rebounding=true
motion_set(kickDir+180*setScale,kickPower)
setHspeed=hspeed
alarm[11]=45
canKick=false
}
instance_destroy()
if other.team!= ownerPlayer.team{
    damageSentry(ownerPlayer, other.id, hitDamage);
    other.lastDamageDealer = ownerPlayer;
    other.lastDamageSource = WEAPON_FLARE;
}
")
object_event_add(Scout,ev_other,ev_user12,"
event_inherited()
if(global.updateType == QUICK_UPDATE or global.updateType == FULL_UPDATE) {
        write_ubyte(global.serializeBuffer, kicking);
        write_ubyte(global.serializeBuffer, rebounding);
        write_ubyte(global.serializeBuffer, airControl);
        write_ubyte(global.serializeBuffer, huggingWall);
        write_ubyte(global.serializeBuffer, canKick);
        write_byte(global.serializeBuffer, setHspeed);
        write_byte(global.serializeBuffer, setScale);  
        write_byte(global.serializeBuffer, setVspeed); 
    }
")
object_event_add(Scout,ev_other,ev_user13,"
event_inherited()
if(global.updateType == QUICK_UPDATE) or (global.updateType == FULL_UPDATE) {
        receiveCompleteMessage(global.serverSocket,8,global.deserializeBuffer);
         kicking = read_ubyte(global.deserializeBuffer);
         rebounding = read_ubyte(global.deserializeBuffer);
         airControl = read_ubyte(global.deserializeBuffer);
         huggingWall = read_ubyte(global.deserializeBuffer);
         canKick = read_ubyte(global.deserializeBuffer);
        setHspeed = read_byte(global.deserializeBuffer)
        setScale = read_byte(global.deserializeBuffer)
        setVspeed = read_byte(global.deserializeBuffer)
       }")