# QEMapStats
A tool for mappers to gather and visualize some location-based statistics on the map.
Have people or bots play a deathmatch game and afterwards you can visualize different stats around the map.


Currently it can gather the following statistics:
* Movement
* Jumps
* Attacks
* Deaths

# Grid (Resolution)
Stats are collected and stored in invisible entities. These entities can either be spawned in a radial fashion or grid fashion. Whenever a statistic event occurs, it'll try to locate a stats entity within the valid location. If none exists, a new one is created.

The grid specifies how detailed you gather statistics.

You can modify the grid size the cvar `temp1`. Default is 64. You can also use the following aliases: `stats_grid_32`, `stats_grid_64`, `stats_grid_96`, `stats_grid_128`, `stats_grid_256`.

# Method
Use the following aliases to set the collection method:
* `stats_method_radial`
* `stats_method_grid`

# Visualizing
You can use the alias: `stats_show_<statistic name>`. For example if you want to visualize movement, use: `stats_show_movement`

You'll then see cyclinders or cubes depending on your visualization method. The color will indicate how often the event took place in that area compared to the whole map. If you don't see anything in a specific area, it means that no statistic even took place in that area.

Hide them by using `stats_hide`

**Note that cheats need to be turned on!**

Specify the visualization radius using the cvar `temp3`. Default value is 512.