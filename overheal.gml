
object_event_add(global.HealingParticle,ev_create,0,"
alpha=0.9
")
object_event_add(global.HealingParticle,ev_step,ev_step_begin,"
if owner!=-1 && instance_exists(owner){

}
")
object_event_add(Character,ev_create,0,"
overhealHp=0
overhealed=false
overhealMaxHp=floor(maxHp/2)
overhealies=0
")
object_event_add(Character,ev_destroy,0,"
with global.HealingParticle{
if owner=other.id owner=-1
}
")
object_event_add(global.HealingParticle,ev_step,ev_step_begin,"
if owner!=-1 && instance_exists(owner){
y=owner.y+floor(yoffset)
x=owner.x+xoffset
}else{
owner=-1
}
yoffset+=0.5/global.delta_factor
alpha*=0.95*global.delta_factor
if alpha<0.02 instance_destroy();
")
object_event_add(Character, ev_step, ev_step_normal,"
if healer=-1 or !instance_exists(healer){
	if global.game_fps=30{
		overhealHp-=min(overhealHp,0.1)
	}else if global.game_fps=60{
		overhealHp-=min(overhealHp,0.05)
	}
}else if hp=maxHp{
	overhealed=true
}
")
object_event_add(Character, ev_alarm, 11,"

")

object_event_add(Character, ev_step, ev_step_end,"


if overhealHp<=0{
	overhealed=false
	overhealHp=0
}

if overhealHp>0{
if (global.particles=PARTICLES_NORMAL or global.particles=PARTICLES_ALTERNATIVE){
if random((30*overhealMaxHp/overhealHp)/global.delta_factor)<10{
xr=round(x)
yr=round(y)
xh=random_range(-10,10);
yh=random_range(-6,3);
healie=instance_create(xh+xr,yh+yr,global.HealingParticle)
healie.owner=id
healie.xoffset=xh
healie.yoffset=yh
healie.depth=choose(2,-2)
}
}
}

if overhealHp>overhealMaxHp{
	overhealHp=overhealMaxHp
}
")

object_event_add(Medigun,ev_other,ev_user1,"
    if(instance_exists(healTarget)) {
        if(healTarget.object != -1){ 
            if (healTarget.object.hp>=healTarget.object.maxHp){
            if(point_distance(x,y,healTarget.object.x, healTarget.object.y)<=maxHealDistance) {
                if(collision_line(x,y, healTarget.object.x, healTarget.object.y, Obstacle, true, true)<0) {
                    healedThisStep = true;
                    var healthGained;
			healTarget.overhealed=true
                    healthGained = healAmount * calculateHealingFactor(healTarget.object.timeUnscathed);
                    if(healTarget.object.hp > healTierHealth)
                        healthGained *= healTierAmount;
                    healTarget.object.overhealHp = min(healTarget.object.overhealHp + healthGained * global.delta_factor, healTarget.object.overhealMaxHp);
                } else {
                    healTarget.object.healer = -1;
                    healTarget = noone;
                }
            } else {
                healTarget.object.healer = -1;
                healTarget = noone;
            }
        }
        } else {
            healTarget = noone;
        
    }
    
  }")
global.dealDamageFunction+="
if argument1.object_index!=Sentry and argument1.object_index!=GeneratorRed and argument1.object_index!=GeneratorBlue{
	if argument1.overhealed && argument1.overhealHp>0{
		argument1.overhealHp-=argument2
		argument1.hp=min(argument1.maxHp,argument1.maxHp+argument1.overhealHp)
}
}
"
object_event_add(Character,ev_other,ev_user12,"
if(global.updateType == QUICK_UPDATE or global.updateType == FULL_UPDATE) {
        write_byte(global.serializeBuffer, overhealHp);
        write_ubyte(global.serializeBuffer, overhealed);        
}
")
object_event_add(Character,ev_other,ev_user13,"
    if(global.updateType == QUICK_UPDATE) or (global.updateType == FULL_UPDATE) {
receiveCompleteMessage(global.serverSocket,2,global.deserializeBuffer);
        overhealHp = read_byte(global.deserializeBuffer);
        overhealed = read_ubyte(global.deserializeBuffer);

    }
")
object_event_add(HealthHud,ev_draw,0,"

xsize = view_wview[0];
ysize = view_hview[0];

if(global.myself.team == TEAM_BLUE) {
    image_index = global.myself.class + 10;
} else {
    image_index = global.myself.class;
}

if(global.myself.object == -1) {
    instance_destroy();
    exit; 
}
if global.myself.object.overhealed=true && global.myself.object.overhealHp>0{
var xoffset, yoffset, xsize, ysize, xpos, ypos, hp, maxHp;
xoffset = view_xview[0];
yoffset = view_yview[0];
xsize = view_wview[0];
ysize = view_hview[0];

xpos = 45;
ypos = ysize-53;
hp = global.myself.object.overhealHp
maxHp = global.myself.object.overhealMaxHp

draw_set_valign(fa_center);
draw_set_halign(fa_center);
draw_set_alpha(1);
draw_healthbar(xoffset+xpos, yoffset+ypos, xoffset+xpos+42, yoffset+ypos+37, hp*100/maxHp, c_green, c_teal, c_blue, 3, true, false);

var hpText,hpColor;
    hpColor = c_white;


hpText = string(ceil(min(max(hp+global.myself.object.hp,0),maxHp+global.myself.object.maxHp)));

draw_text_color(xoffset+xpos+24, yoffset+ypos+18, hpText, hpColor, hpColor, hpColor, hpColor, 1);
draw_sprite_ext(sprite_index, image_index, view_xview[0]+5, view_yview[0]+ysize-75, 2, 2, 0, c_white, 1);
}
")
/////////////I ADDED THESE IN SO I WOULDN'T HAVE TO MAKE EVERYTHING ELSE INCOMPATIBLE. ITEMSERVER, ETC.
object_event_add(Scout,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Pyro,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Heavy,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Soldier,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Medic,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Engineer,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Demoman,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Sniper,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Spy,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")
object_event_add(Quote,ev_draw,0,"
event_inherited()
if (distance_to_point(xoffset+xsize/2,yoffset+ysize/2) > 800)
    exit;

var xr, yr;
xr = round(x);
yr = round(y);



if (invisible)
    exit;

if (team == global.myself.team and (player != global.myself or global.showHealthBar))
{
if overhealed=true && overhealHp>0{
    draw_set_alpha(1);
    draw_healthbar(xr-10, yr-30, xr+10, yr-25,overhealHp*100/overhealMaxHp,c_green,c_teal,c_blue,0,true,true);
}
}")