import 'package:maple_daily_tracker/models/maple-class.dart';

class ImageHelper {
  static String classToImage(MapleClass? classId) {
    if (classId == null || classId == MapleClass.None)
      return '';

    final imagePath = 'assets/classes/Class_';

    var className = '';
    switch (classId) {
      case MapleClass.Beginner:
        className = 'Beginner';
        break;

      // ARCHERS
      case MapleClass.Bowmaster:
      case MapleClass.Marksman:
      case MapleClass.WindArcher:
        className = 'Bowman';
        break;

      // WARRIORS
      case MapleClass.Hero:
      case MapleClass.Paladin:
      case MapleClass.DarkKnight:
      case MapleClass.DawnWarrior:
        className = 'Warrior';
        break;

      // MAGES
      case MapleClass.FirePoison:
      case MapleClass.IceLightning:
      case MapleClass.Bishop:
      case MapleClass.BlazeWizard:
        className = 'Magician';
        break;

      // THIEVES
      case MapleClass.NightLord:
      case MapleClass.Shadower:
      case MapleClass.NightWalker:
        className = 'Thief';
        break;

      // PIRATES
      case MapleClass.Buccaneer:
      case MapleClass.Corsair:
      case MapleClass.ThunderBreaker:
        className = 'Pirate';
        break;

      // CUSTOMS
      case MapleClass.Pathfinder:
        className = 'Pathfinder';
        break;
      case MapleClass.DualBlade:
        className = 'Dual_Blade';
        break;
      case MapleClass.Cannoneer:
        className = 'Cannoneer';
        break;
      case MapleClass.Jett:
        className = 'Jett';
        break;
      case MapleClass.Mihile:
        className = 'Mihile';
        break;
      case MapleClass.Evan:
        className = 'Evan';
        break;
      case MapleClass.Mercedes:
        className = 'Mercedes';
        break;
      case MapleClass.Phantom:
        className = 'Phantom';
        break;
      case MapleClass.Luminous:
        className = 'Luminous';
        break;
      case MapleClass.Shade:
        className = 'Shade';
        break;
      case MapleClass.Blaster:
        className = 'Blaster';
        break;
      case MapleClass.BattleMage:
        className = 'Battle_Mage';
        break;
      case MapleClass.WildHunter:
        className = 'Wild_Hunter';
        break;
      case MapleClass.Mechanic:
        className = 'Mechanic';
        break;
      case MapleClass.Xenon:
        className = 'Xenon';
        break;
      case MapleClass.DemonSlayer:
        className = 'Demon_Slayer';
        break;
      case MapleClass.DemonAvenger:
        className = 'Demon_Avenger';
        break;
      case MapleClass.Kaiser:
        className = 'Kaiser';
        break;
      case MapleClass.AngelicBuster:
        className = 'Angelic_Buster';
        break;
      case MapleClass.Cadena:
        className = 'Cadena';
        break;
      case MapleClass.Kain:
        className = 'Kain';
        break;
      case MapleClass.Illium:
        className = 'Illium';
        break;
      case MapleClass.Ark:
        className = 'Ark';
        break;
      case MapleClass.Adele:
        className = 'Adele';
        break;
      case MapleClass.Hayato:
        className = 'Hayato';
        break;
      case MapleClass.Kanna:
        className = 'Kanna';
        break;
      case MapleClass.Hoyoung:
        className = 'Hoyoung';
        break;
      case MapleClass.Lara:
        className = 'Lara';
        break;
      case MapleClass.Chase:
        className = 'Chase';
        break;
      case MapleClass.Zero:
        className = 'Zero';
        break;
      case MapleClass.Kinesis:
        className = 'Kinesis';
        break;
      case MapleClass.MoXuan:
        className = 'Mo_Xuan';
        break;
      case MapleClass.Aran:
        className = 'Aran';
        break;
      case MapleClass.None:
        break;
    }

    return '${imagePath}$className.png';
  }
}