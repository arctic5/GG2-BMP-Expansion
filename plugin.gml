// So people like Hanako_Ikezawa won't screw up.
// :^)
if (isServerSentPlugin != 1) {
    if (global.serverPluginList != '')
        global.serverPluginList += ',bmp_expansion';
    else
        global.serverPluginList += 'bmp_expansion';
    exit;
}

// <arctic> mod scale plugins are hard holy shit
//Initiation script. When someone told me to keep it short and simple, I told them to suck my dick.

globalvar expansion;
expansion = id;

spriteDirectory = directory + "\Sprites\";
soundDirectory = directory + "\Sounds\";
include = directory + "\include\";

global.jumpFlameParticleTypeString="jumpFlameParticleType"
global.jumpFlameParticleSystemString="jumpFlameParticleSystem"
global.jumpDustParticleTypeString="jumpDustParticleType"
global.jumpDustParticleSystemString="jumpDustParticleSystem"
global.maxAmmoString="maxAmmo"
global.indicatorString="indicator"
global.cloakString="cloak"
global.BassMakesPaste="BassMakesPaste"
global.falconKickParticleTypeString="falconKickParticleType"
global.falconKickParticleSystemString="falconKickParticleSystem"
global.motionBlurParticleTypeString="motionBlurParticleType"
global.motionBlurParticleSystemString="motionBlurParticlesystem"


//Spriteloading.
ScoutRedKickS=sprite_add_sprite(spriteDirectory+"ScoutRedKickS"+".gmspr")
ScoutRedWallS=sprite_add_sprite(spriteDirectory+"ScoutRedWallS"+".gmspr")
ScoutRedFlipS=sprite_add_sprite(spriteDirectory+"ScoutRedFlipS"+".gmspr")
ScoutBlueKickS=sprite_add_sprite(spriteDirectory+"ScoutBlueKickS"+".gmspr")
ScoutBlueWallS=sprite_add_sprite(spriteDirectory+"ScoutBlueWallS"+".gmspr")
ScoutBlueFlipS=sprite_add_sprite(spriteDirectory+"ScoutBlueFlipS"+".gmspr")
ScoutNoColorKickS=sprite_add_sprite(spriteDirectory+"ScoutNoColorKickS"+".gmspr")
ScoutNoColorKick2S=sprite_add_sprite(spriteDirectory+"ScoutNoColorKick2S"+".gmspr")
ScoutNoColorKick3S=sprite_add_sprite(spriteDirectory+"ScoutNoColorKick3S"+".gmspr")
KickBoxS=sprite_add_sprite(spriteDirectory+"KickBoxS"+".gmspr")
RainbowFlameS=sprite_add_sprite(spriteDirectory+"RainbowFlameS"+".gmspr")
HeavyRedButtslamS=sprite_add_sprite(spriteDirectory+"HeavyRedButtslamS"+".gmspr")
HeavyBlueButtslamS=sprite_add_sprite(spriteDirectory+"HeavyBlueButtslamS"+".gmspr")
HeavyRedChargeS=sprite_add_sprite(spriteDirectory+"HeavyRedChargeS"+".gmspr")
HeavyBlueChargeS=sprite_add_sprite(spriteDirectory+"HeavyBlueChargeS"+".gmspr")
HeavyNoColorChargeS=sprite_add_sprite(spriteDirectory+"HeavyNoColorChargeS"+".gmspr")
ChargeBoxS=sprite_add_sprite(spriteDirectory+"ChargeBoxS"+".gmspr")
ButtBoxS=sprite_add_sprite(spriteDirectory+"ButtBoxS"+".gmspr")
CSBloodS=sprite_add_sprite(spriteDirectory+"CSBloodS"+".gmspr")
CSDullImpactS=sprite_add_sprite(spriteDirectory+"CSDullImpactS"+".gmspr")
SingleDot=sprite_add_sprite(spriteDirectory+"SingleDot"+".gmspr")
SpurS=sprite_add_sprite(spriteDirectory+"SpurS"+".gmspr")
GoldenSpurS=sprite_add_sprite(spriteDirectory+"GoldenSpurS"+".gmspr")
SpurShotS=sprite_add_sprite(spriteDirectory+"SpurShotS"+".gmspr")
SpurChargeShotS=sprite_add_sprite(spriteDirectory+"SpurChargeShotS"+".gmspr")
StarExplosionS=sprite_add_sprite(spriteDirectory+"StarExplosionS"+".gmspr")
TinyExplosionS=sprite_add_sprite(spriteDirectory+"TinyExplosionS"+".gmspr")
quoteSmokeS = sprite_add(spriteDirectory+"QuoteSmokeS.png", 7, 1, 0, 8, 8);
quoteExplosionS = sprite_add(spriteDirectory+"QuoteExplosionS.png", 5, 1, 0, 20, 20);
QuoteSymbolsS= sprite_add_sprite(spriteDirectory+"Symbols.gmspr")
QuoteRedNumbersS= sprite_add_sprite(spriteDirectory+"RedNumbers.gmspr")
QuoteHudS= sprite_add_sprite(spriteDirectory+"HudBase.gmspr")
QuoteNumbersS= sprite_add_sprite(spriteDirectory+"Numbers.gmspr")
spurUnchargedKS = sprite_add_sprite(spriteDirectory+"spurLv0S"+".gmspr");
spurLvIKS = sprite_add_sprite(spriteDirectory+"spurLvIS"+".gmspr");
spurLvIIKS = sprite_add_sprite(spriteDirectory+"spurLvIIS"+".gmspr");
spurLvIIIKS = sprite_add_sprite(spriteDirectory+"spurLvIIIS"+".gmspr");
spurLvIRKS = sprite_add_sprite(spriteDirectory+"spurLvIRS"+".gmspr");
spurLvIIRKS = sprite_add_sprite(spriteDirectory+"spurLvIIRS"+".gmspr");
spurLvIIIRKS = sprite_add_sprite(spriteDirectory+"spurLvIIIRS"+".gmspr");

//Soundloading
CSObjectHurtSnd=sound_add(soundDirectory+"CSObjectHurtSnd"+".wav",0,0)
CSQuoteHurtSnd=sound_add(soundDirectory+"CSQuoteHurtSnd"+".wav",0,0)
CSQuoteJumpSnd=sound_add(soundDirectory+"CSQuoteJumpSnd"+".wav",0,0)
CSQuotesplosionSnd=sound_add(soundDirectory+"CSQuotesplosionSnd"+".wav",0,0)
CSSqueakBigSnd=sound_add(soundDirectory+"CSSqueakBigSnd"+".wav",0,0)
CSSqueakMedSnd=sound_add(soundDirectory+"CSSqueakMedSnd"+".wav",0,0)
CSSqueakSmallSnd=sound_add(soundDirectory+"CSSqueakSmallSnd"+".wav",0,0)
CSSpurCharge1Snd=sound_add(soundDirectory+"CSSpurCharge1Snd"+".wav",0,0)
CSSpurCharge2Snd=sound_add(soundDirectory+"CSSpurCharge2Snd"+".wav",0,0)
CSSpurCharge3Snd=sound_add(soundDirectory+"CSSpurCharge3Snd"+".wav",0,0)
CSSpurChargeCompleteSnd=sound_add(soundDirectory+"CSSpurChargeCompleteSnd"+".wav",0,0)
SpurSnd1=sound_add(soundDirectory+"SpurSnd1"+".wav",0,0)
SpurSnd2=sound_add(soundDirectory+"SpurSnd2"+".wav",0,0)
CSSpurChargeShot1Snd=sound_add(soundDirectory+"CSSpurChargeShot1Snd"+".wav",0,0)
CSSpurChargeShot2Snd=sound_add(soundDirectory+"CSSpurChargeShot2Snd"+".wav",0,0)
CSSpurChargeShot3Snd=sound_add(soundDirectory+"CSSpurChargeShot3Snd"+".wav",0,0)
HeavyDashSnd=sound_add(soundDirectory+"HeavyDashSnd"+".wav",0,0)
HeavyCrashSnd=sound_add(soundDirectory+"HeavyCrashSnd"+".wav",0,0)
HeavyLaunchSnd=sound_add(soundDirectory+"HeavyLaunchSnd"+".wav",0,0)
HeavyButtSlamSnd=sound_add(soundDirectory+"HeavyButtSlamSnd"+".wav",0,0)

//Object creation

KickBox=object_add()
object_set_sprite(KickBox,KickBoxS)
ChargeBox=object_add()
object_set_sprite(ChargeBox,ChargeBoxS)
ButtBox=object_add()
object_set_sprite(ButtBox,ButtBoxS)
DustCloud=object_add()
damageCounter=object_add();
Spur=object_add();
object_set_sprite(Spur,SpurS);
object_set_parent(Spur,Weapon);

SpurShot=object_add();
object_set_sprite(SpurShot,SpurShotS);

SpurChargeShotFront=object_add();
object_set_sprite(SpurChargeShotFront,SpurShotS);

SpurChargeShotBack=object_add();
object_set_sprite(SpurChargeShotBack,SpurShotS);

StarPop=object_add();
object_set_sprite(StarPop,StarExplosionS);

TinyExplosion=object_add();
object_set_sprite(TinyExplosion,TinyExplosionS);

IneffectiveExplosion=object_add();
object_set_sprite(IneffectiveExplosion,CSDullImpactS);

HurtBlood=object_add();
object_set_sprite(HurtBlood,CSBloodS);

QuoteSmoke = object_add();
object_set_sprite(QuoteSmoke,quoteSmokeS);

QuoteExplosion = object_add();
object_set_sprite(QuoteExplosion,quoteExplosionS);

global.HealingParticle=object_add()
global.HealingParticleS=sprite_add_sprite(spriteDirectory+"ParticleEffectS.gmspr")
object_set_sprite(global.HealingParticle,global.HealingParticleS)

//VARIABLES

//Events
hello = 101;
customKillEvent = 1;
bassieCheck = 2;
disguiseSendEvent = 3;
disguiseReceiveEvent = 4;

//kill log icons
spurUncharged = 50;
spurLvI = 51;
spurLvII = 52;
spurLvIII = 53;
spurLvIR = 54;
spurLvIIR = 55;
spurLvIIIR = 56;

//misc
global.welcomeBuffer = buffer_create();

ini_open("gg2.ini")
bassieKey=ini_read_string("Plugins","quote_spur_VIPSTATUS","nope.txt")
global.hostGoldenSpur=ini_read_real("Plugins","quote_spur_HOSTVIP","0")
ini_close()
global.sent_bassie_value=0

// include external resources
execute_file(include + "overheal.gml")
execute_file(include + "scout.gml")
execute_file(include + "heavy.gml")
execute_file(include + "quote.gml")
execute_file(include + "spy.gml")
execute_file(include + "Networking.gml");