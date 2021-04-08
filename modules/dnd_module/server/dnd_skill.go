package dnd_module;

type Skill struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc"`
  Mod                   string              `json:"mod"` // lowercase 3 letter
}

var skills = []*Skill{
  &Skill{
    ID: 1,
    Name: "Acrobatics",
    Desc: "Abilitiy to jump around.",
    Mod: "dex",
  },
  &Skill{
    ID: 2,
    Name: "Animal Handling",
    Desc: "Ability to handle animals.",
    Mod: "wis",
  },
  &Skill{
    ID: 3,
    Name: "Arcana",
    Desc: "Understanding of arcane magic.",
    Mod: "int",
  },
  &Skill{
    ID: 4,
    Name: "Athletics",
    Desc: "How physically fit you are.",
    Mod: "str",
  },
  &Skill{
    ID: 5,
    Name: "Deception",
    Desc: "Ability to deceive other people.",
    Mod: "cha",
  },
  &Skill{
    ID: 6,
    Name: "History",
    Desc: "Understanding of events in the past.",
    Mod: "int",
  },
  &Skill{
    ID: 7,
    Name: "Insight",
    Desc: "How well you understand what is really going on?",
    Mod: "wis",
  },
  &Skill{
    ID: 8,
    Name: "Intimidation",
    Desc: "How well you are able to intimidate others into doing something.",
    Mod: "cha",
  },
  &Skill{
    ID: 9,
    Name: "Investigation",
    Desc: "How well you can find what you are looking for.",
    Mod: "int",
  },
  &Skill{
    ID: 10,
    Name: "Medicine",
    Desc: "Ability to care for others, by tending their wounds.",
    Mod: "wis",
  },
  &Skill{
    ID: 11,
    Name: "Nature",
    Desc: "How well you understand nature, and the wilderness.",
    Mod: "int",
  },
  &Skill{
    ID: 12,
    Name: "Perception",
    Desc: "Abillity to perceive things around you.",
    Mod: "wis",
  },
  &Skill{
    ID: 13,
    Name: "Performance",
    Desc: "Ability to perform in front of others.",
    Mod: "cha",
  },
  &Skill{
    ID: 14,
    Name: "Persuasion",
    Desc: "Ability to persuade others into doing something.",
    Mod: "cha",
  },
  &Skill{
    ID: 15,
    Name: "Religion",
    Desc: "How much you know about different religions.",
    Mod: "int",
  },
  &Skill{
    ID: 16,
    Name: "Sleight of Hand",
    Desc: "Ability to conceal something small in your hands.",
    Mod: "dex",
  },
  &Skill{
    ID: 17,
    Name: "Stealth",
    Desc: "Ability to hide yourself from others sight.",
    Mod: "dex",
  },
  &Skill{
    ID: 18,
    Name: "Survival",
    Desc: "How well you can survive in the wilderness.",
    Mod: "wis",
  },
}
