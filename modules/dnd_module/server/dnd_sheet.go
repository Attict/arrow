package dnd_module;

import (
  "encoding/json"
  "fmt"
  "html/template"
  "log"
  "math"
  "net/http"
  "strings"

  "github.com/go-pg/pg"

  "../../core_module/server"
)

func (c DndCharacter) GetItems() template.HTML {
  result := "<ul>"
  for _, v := range c.Items {
    result += fmt.Sprintf("<li>%s</li>", v.Name)
  }
  result += "</ul>"

  return template.HTML(result)
}

func (c DndCharacter) GetFeats() template.HTML {
  result := "<ul>"
  for _, v := range c.Feats {
    result += fmt.Sprintf("<li><strong>%s:</strong>%s</li>", v.Name, v.Desc)
  }
  result += "</ul>"
  return template.HTML(result)
}

func (c DndCharacter) GetProfs() template.HTML {
  result := ""
  language := []*DndProficiency{}
  item := []*DndProficiency{}

  for _, v := range c.Proficiencies {
    if v.Type == ProficiencyType_Language {
      language = append(language, v)
    } else {
      item = append(item, v)
    }
  }

  result += "<h4>Language</h4><ul>"
  for _, v := range language {
    result += fmt.Sprintf("<li>%s</li>", v.Name)
  }
  result += "</ul><h4>Item</h4><ul>"
  for _, v := range item {
    result += fmt.Sprintf("<li>%s</li>", v.Name)
  }
  result += "</ul>"

  return template.HTML(result)
}

func (c DndCharacter) GetWeaponName(i int) string {
  if c.Weapons != nil && len(c.Weapons) > i && c.Weapons[i] != nil {
    return c.Weapons[i].Item.Name;
  }
  return ""
}

func (c DndCharacter) GetWeaponHit(i int) string {
  if c.Weapons != nil && len(c.Weapons) > i && c.Weapons[i] != nil {
    v := c.GetProf()
    if c.Weapons[i].ModType == Type_STR {
      v += c.GetMod("str")
    } else if c.Weapons[i].ModType == Type_DEX {
      v += c.GetMod("dex")
    }
    if v >= 0 {
      return fmt.Sprintf("+%d", v)
    } else {
      return fmt.Sprintf("%d", v)
    }
  }
  return ""
}

func (c DndCharacter) GetWeaponDamage(i int) string {
  if c.Weapons != nil && len(c.Weapons) > i && c.Weapons[i] != nil {
    v := int8(0)
    if c.Weapons[i].ModType == Type_STR {
      v += c.GetMod("str")
    } else if c.Weapons[i].ModType == Type_DEX {
      v += c.GetMod("dex")
    }
    var t string
    switch c.Weapons[i].DmgType {
    case WeaponDamage_Piercing:
      t = "Piercing"
      break
    case WeaponDamage_Slashing:
      t = "Slashing"
      break
    default:
      t = "Bludgeoning"
    }
    return fmt.Sprintf(
      "%dd%d+%d (%s)", c.Weapons[i].MinDmg, c.Weapons[i].MaxDmg, v, t)
  }
  return ""
}

func (c DndCharacter) GetRaceName() string {
  if c.Race != nil {
    return c.Race.Name
  }
  return ""
}
func (c DndCharacter) GetClassName() string {
  if c.Class != nil {
    return c.Class.Name
  }
  return ""
}
func (c DndCharacter) GetBackgroundName() string {
  if c.Background != nil {
    return c.Background.Name
  }
  return ""
}

func (c DndCharacter) GetAttr(mod string) int8 {
  var v int8
  switch (mod) {
  case "str":
    v += c.STR
    for _, m := range c.Mods {
      if m.Type == ModType_ATTR && m.Subtype == Type_STR {
        v += int8(m.Value)
      }
    }
    if c.Race != nil {v += c.Race.STR}
  case "dex":
    v += c.DEX
    for _, m := range c.Mods {
      if m.Type == ModType_ATTR && m.Subtype == Type_DEX {
        v += int8(m.Value)
      }
    }
    if c.Race != nil {v += c.Race.DEX}
  case "con":
    v += c.CON
    for _, m := range c.Mods {
      if m.Type == ModType_ATTR && m.Subtype == Type_CON {
        v += int8(m.Value)
      }
    }
    if c.Race != nil {v += c.Race.CON}
  case "int":
    v += c.INT
    for _, m := range c.Mods {
      if m.Type == ModType_ATTR && m.Subtype == Type_INT {
        v += int8(m.Value)
      }
    }
    if c.Race != nil {v += c.Race.INT}
  case "wis":
    v += c.WIS
    for _, m := range c.Mods {
      if m.Type == ModType_ATTR && m.Subtype == Type_WIS {
        v += int8(m.Value)
      }
    }
    if c.Race != nil {v += c.Race.WIS}
  case "cha":
    v += c.CHA
    for _, m := range c.Mods {
      if m.Type == ModType_ATTR && m.Subtype == Type_CHA {
        v += int8(m.Value)
      }
    }
    if c.Race != nil {v += c.Race.CHA}
  }
  return v
}

func (c DndCharacter) GetLevel() string {
  if c.Level > 0 {
    return fmt.Sprintf("%d", c.Level)
  }
  return ""
}

func (c DndCharacter) GetMod(mod string) int8 {
  v := c.GetAttr(mod)
  f := int8(math.Floor(float64((int(v) - 10) / 2)))
  return f
}

func (c DndCharacter) GetModStr(mod string) string {
  v := c.GetMod(mod)
  if v > 0 {
    return fmt.Sprintf("+%d", v)
  }
  return fmt.Sprintf("%d", v)
}

func (c DndCharacter) GetSpeedStr() string {
  if c.Race != nil {
    v := c.Race.Speed
    if c.Armor != nil && c.GetAttr("str") < int8(c.Armor.ReqSTR) {
      v -= 10
    }
    return fmt.Sprintf("%dft.", v)
  }
  return ""
}

func (c DndCharacter) GetAC() int8 {
  ac := int8(10)
  mod := c.GetMod("dex")
  if c.Armor != nil {
    if !c.Armor.DEXMod {
      mod = 0
    }
    if c.Armor.DEXModMax > 0 && mod > int8(c.Armor.DEXModMax) {
      mod = int8(c.Armor.DEXModMax)
    }
    ac = int8(c.Armor.AC)
  }
  return mod + ac
}

func (c DndCharacter) GetHitDiceStr() string {
  if c.Class != nil {
    return fmt.Sprintf("1d%d", c.Class.Hp)
  }
  return ""
}

func (c DndCharacter) GetACStr() string {
  return fmt.Sprintf("%d", c.GetAC())
}

func (c DndCharacter) GetMaxHpStr() string {
  return ""
}

///
/// GetSkillsHtml
///
/// This may be a better way to handle most of this information,
/// to avoid extra processing where repeating loops are happening.
///
/// This will just get the entire list of skills, and loop through each
/// to determine what the HTML should come out as.
///
func (c DndCharacter) GetSkillsHtml() template.HTML {
  result := ""
  prof := c.GetProf()

  for _, s := range skills {
    // Basic info for filling
    value := c.GetMod(s.Mod)
    filled := ""
    isProf := false

    // Check for proficiency
    for _, sid := range c.SkillIDs {
      if s.ID == sid {
        isProf = true
      }
    }
    if !isProf && c.Background != nil {
      for _, sid := range c.Background.SkillIDs {
        if s.ID == sid {
          isProf = true
        }
      }
    }

    // Add Proficiency and set the bubble for fill
    if isProf {
      value += prof
      filled = " filled"
    }

    // Use lowercase and hypens over spaces for class name
    lname := strings.Replace(s.Name, " ", "-", -1)
    lname = strings.ToLower(lname)

    // Add this span to the result
    result += fmt.Sprintf(
      "<span class=\"page-1__%s page-1__skill%s\">%d</span>",
      lname,
      filled,
      value,
    )

    // Update passive perception here to avoid duplicate loop
    if s.Name == "Perception" {
      result += fmt.Sprintf(
        "<span class=\"page-1__passive-perception\">%d</span>",
        value,
      )
    }
  }
  return template.HTML(result)
}

func (c DndCharacter) GetSavesHTML() template.HTML {
  result := ""          // final result
  p := c.GetProf()      // proficiency
  var f string          // filled
  var v int8            // value

  all := []string{"str", "dex", "con", "int", "wis", "cha"}
  var allSave []bool
  if c.Class != nil {
    allSave = []bool{
      c.Class.SaveSTR,
      c.Class.SaveDEX,
      c.Class.SaveCON,
      c.Class.SaveINT,
      c.Class.SaveWIS,
      c.Class.SaveCHA,
    }
  }

  for i, m := range all {
    v = c.GetMod(m)
    f = ""
    if allSave != nil && allSave[i] {
      v += p
      f = " filled"
    }
    result += fmt.Sprintf(
      "<span class=\"page-1__saving-%s page-1__saving-throw%s\">%d</span>",
      m,
      f,
      v,
    )
  }
  return template.HTML(result)
}

func (c DndCharacter) HasSaveProf(mod string) bool {
  return c.Class.SaveSTR && mod == "str" ||
    c.Class.SaveDEX && mod == "dex" ||
    c.Class.SaveCON && mod == "con" ||
    c.Class.SaveINT && mod == "int" ||
    c.Class.SaveWIS && mod == "wis" ||
    c.Class.SaveCHA && mod == "cha"
}

func (c DndCharacter) GetSave(mod string) int8 {
  v := c.GetMod(mod)
  p := c.GetProf()
  if c.HasSaveProf(mod) {
    v += p
  }
  return v
}

func (c DndCharacter) GetProf() int8 {
  if c.Level > 16 {
    return 6
  } else if c.Level > 12 {
    return 5
  } else if c.Level > 8 {
    return 4
  } else if c.Level > 4 {
    return 3
  }
  return 2
}

///
/// character
///
/// Generates a character sheet with the incoming JSON data.
///
/// Generates with `template/character.html`
///
func characterSheet(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Allow", "*")
  w.Header().Set("Access-Control-Allow-Methods", "*")
  w.Header().Set("Access-Control-Allow-Origin", "*")
  w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")

  var c DndCharacter
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&c)

  // Get the race
  if c.RaceID != 0 {
    race := &DndRace{ID: c.RaceID}
    err = core_module.Db.Model(race).WherePK().Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Race not found!",
      })
      log.Println(err)
      return
    }
    c.Race = race
  }

  if c.ClassID != 0 {
    class := &DndClass{ID: c.ClassID}
    err = core_module.Db.Model(class).WherePK().Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Class not found!",
      })
      log.Println(err)
    }
    c.Class = class
  }

  if c.BackgroundID != 0 {
    background := &DndBackground{ID: c.BackgroundID}
    err = core_module.Db.Model(background).WherePK().Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Background not found!",
      })
      log.Println(err)
    }
    c.Background = background
  }

  feats := []*DndFeat{}
  profIds := []uint{}
  if c.Race != nil {
    for _, v := range c.Race.Feats {
      feats = append(feats, &v)
    }
    for _, v := range c.Race.ProficiencyIDs {
      profIds = append(profIds, v)
    }
  }
  if c.Class != nil {
    for _, v := range c.Class.Feats {
      feats = append(feats, &v)
    }
    for _, v := range c.Class.ProficiencyIDs {
      profIds = append(profIds, v)
    }
  }
  c.Feats = feats
  if len(profIds) > 0 {
    profs := []*DndProficiency{}
    err = core_module.Db.Model(&profs).Where("id in (?)", pg.In(profIds)).Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Proficiencies not found!",
      })
      log.Println(err)
    }
    c.Proficiencies = profs
  }


  if c.EquipmentArmor != 0 {
    armor := &DndArmor{ID: c.EquipmentArmor}
    err = core_module.Db.Model(armor).WherePK().Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Armor not found!",
      })
      log.Println(err)
    }
    c.Armor = armor
  }

  if c.EquipmentWeapons != nil && len(c.EquipmentWeapons) > 0 {
    weapons := []*DndWeapon{}
    err = core_module.Db.Model(&weapons).Where("id in (?)", pg.In(c.EquipmentWeapons)).Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Weapons not found!",
      })
      log.Println(err)
    }
    c.Weapons = weapons
  }

  // Items
  items := []*DndItem{}
  if c.WeaponIDs != nil && len(c.WeaponIDs) > 0 {
    weapons := []*DndWeapon{}
    err = core_module.Db.Model(&weapons).Where("id in (?)", pg.In(c.WeaponIDs)).Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Weapons not found!",
      })
      log.Println(err)
    }
    for _, v := range weapons {
      items = append(items, &v.Item)
    }
  }
  if c.ArmorIDs != nil && len(c.ArmorIDs) > 0 {
    armors := []*DndArmor{}
    err = core_module.Db.Model(&armors).Where("id in (?)", pg.In(c.ArmorIDs)).Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Armors not found!",
      })
      log.Println(err)
    }
    for _, v := range armors {
      items = append(items, &v.Item)
    }
  }
  if c.ItemIDs != nil && len(c.ItemIDs) > 0 {
    i := []*DndItem{}
    err = core_module.Db.Model(&i).Where("id in (?)", pg.In(c.ItemIDs)).Select()
    if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(&core_module.CoreException{
        Message: "Items not found!",
      })
      log.Println(err)
    }
    for _, v := range i {
      items = append(items, v)
    }
  }
  c.Items = items

  t, err := template.ParseFiles("templates/character.html")
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not parse template!",
    })
    log.Println(err)
  }
  err = t.Execute(w, c)
  if err != nil {
    log.Println(err)
  }
}
