 module DataManager
  #--------------------------------------------------------------------------
  # ● 读取普通的数据库
  #--------------------------------------------------------------------------
  def self.load_normal_database()
    $data_actors        = load_data("Data/Actors.rvdata2")
    $data_classes       = load_data("Data/Classes.rvdata2")
    $data_skills        = load_data("Data/Skills.rvdata2")
    $data_items         = load_data("Data/Items.rvdata2")
    $data_weapons       = load_data("Data/Weapons.rvdata2")
    $data_armors        = load_data("Data/Armors.rvdata2")
    $data_enemies       = load_data("Data/Enemies.rvdata2")
    $data_troops        = load_data("Data/Troops.rvdata2")
    $data_states        = load_data("Data/States.rvdata2")
    $data_animations    = load_data("Data/Animations.rvdata2")
    $data_tilesets      = load_data("Data/Tilesets.rvdata2")
    $data_common_events = load_data("Data/CommonEvents.rvdata2")
    $data_system        = load_data("Data/System.rvdata2")
    $data_mapinfos      = load_data("Data/MapInfos.rvdata2")
    
    $scripts=load_data("Data/Scripts.rvdata2")
  end
  def self.save_normal_database()
    save_data($data_actors            ,"Data/Actors.rvdata2")
    save_data($data_classes           ,"Data/Classes.rvdata2")
    save_data($data_skills            ,"Data/Skills.rvdata2")
    save_data($data_items             ,"Data/Items.rvdata2")
    save_data($data_weapons           ,"Data/Weapons.rvdata2")
    save_data($data_armors            ,"Data/Armors.rvdata2")
    save_data($data_enemies           ,"Data/Enemies.rvdata2")
    save_data($data_troops            ,"Data/Troops.rvdata2")
    save_data($data_states            ,"Data/States.rvdata2")
    save_data($data_animations        ,"Data/Animations.rvdata2")
    save_data($data_tilesets          ,"Data/Tilesets.rvdata2")
    save_data($data_common_events     ,"Data/CommonEvents.rvdata2")
    save_data($data_system            ,"Data/System.rvdata2")
    save_data($data_mapinfos          ,"Data/MapInfos.rvdata2")
  end
 end