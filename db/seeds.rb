# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PermissionRank.create ([
  {id: 1, label: "Player",                badge: "NIL"        },
  {id: 2, label: "Bronze Helper",         badge: "STF_HLP_BRZ"},
  {id: 3, label: "Silver Helper",         badge: "STF_HLP_SLV"},
  {id: 4, label: "Gold Helper",           badge: "STF_HLP_GLD"},
  {id: 5, label: "Moderator",             badge: "STF_MOD"    },
  {id: 6, label: "Senior Moderator",      badge: "STF_MOD_SNR"},
  {id: 7, label: "Administrator",         badge: "STF_ADM"    },
  {id: 8, label: "Senior Administrator",  badge: "STF_ADM_SNR"},
])
