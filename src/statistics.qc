


__accumulate void() InitializeStatistics =
{
    mapStats.statsSize = cvar(STATS_CVAR_SIZE) ? cvar(STATS_CVAR_SIZE) : 64;
    mapStats.statsClassname = "stat_point";
    mapStats.statsMethod = cvar(STATS_CVAR_METHOD);

    ALIAS("stats_grid_64",STATS_CVAR_SIZE" 64");
    ALIAS("stats_grid_32",STATS_CVAR_SIZE" 32");
    ALIAS("stats_grid_96",STATS_CVAR_SIZE" 96");
    ALIAS("stats_grid_128",STATS_CVAR_SIZE" 128");
    ALIAS("stats_grid_256",STATS_CVAR_SIZE" 256");

    ALIAS("stats_method_radial",STATS_CVAR_METHOD" 0");
    ALIAS("stats_method_grid",STATS_CVAR_METHOD" 1");

    ALIAS("stats_hide","scratch1 0;impulse "STATS_IMPULSE);

    localcmd("sv_cheats 1\n");
}

__accumulate void() Stats_HandleImpulse =
{
    if(self != mapStats.host) {
        sprint(self,"Only the host can use statistics commands\n");
        return;
    }

    local float s = cvar(STATS_CVAR_RENDER);

    if(s == 0) {
        sprint(self,"Disabled stats rendering\n");
        return;
    }
}

entity(vector pos) GetStatisticsMarker =
{
    local entity r;

    if(mapStats.statsMethod == STATS_METHOD_RADIAL) {
        r = findradius(pos,mapStats.statsSize);
    }
    else if(mapStats.statsMethod == STATS_METHOD_GRID) {
        pos_x = floor(pos_x / mapStats.statsSize) * mapStats.statsSize;
        pos_y = floor(pos_y / mapStats.statsSize) * mapStats.statsSize;
        pos_z = floor(pos_z / mapStats.statsSize) * mapStats.statsSize;

        r = findradius(pos,1);
    }

	while(r) {
		if(r.classname == mapStats.statsClassname)
			return r;

		r = r.chain;
	}

    // Couldn't find one. Create it
    r = spawn();
    r.classname = mapStats.statsClassname;
    r.origin = pos;
    r.solid = SOLID_TRIGGER;
    setsize(r,'0 0 0','0 0 0');

    return r;
}

ADD_STATISTIC(1,Deaths,frags,64);
ADD_STATISTIC(2,Movement,walkframe,0);
ADD_STATISTIC(3,Attacks,axhitme,32);
ADD_STATISTIC(4,Jumps,air_finished,32);




void(float stat) Stats_Render =
{
    local float renderingRadius = cvar(STATS_CVAR_RENDER_RADIUS) ? cvar(STATS_CVAR_RENDER_RADIUS) : 512;

    local entity r = findradius(self.origin,renderingRadius);


    local renderingInfo_t renderInfo = Stats_GetRenderingInfo(stat);

    while(r) {

        if(r.classname == mapStats.statsClassname)
        {
            if(r.(renderInfo.field) > 0) {
                local float level = r.(renderInfo.field) / renderInfo.maxValue;
                local float color = renderInfo.color + rint(15 * level);

                if(mapStats.statsMethod == STATS_METHOD_RADIAL) {
                    draw_cylinder(r.origin,mapStats.statsSize / 2,mapStats.statsSize / 2,color,0,TRUE);
                }
                else if(mapStats.statsMethod == STATS_METHOD_GRID) {
                    local vector mins,maxs;

                    mins = r.origin;
                    maxs_x = mins_x + mapStats.statsSize;
                    maxs_y = mins_y + mapStats.statsSize;
                    maxs_z = mins_z + mapStats.statsSize;
                    draw_bounds(mins,maxs,color,0,TRUE);
                }
            }
        }

        r = r.chain;
    }
}






