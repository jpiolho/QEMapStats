// Which impulse number should be used to trigger certain statistics command
#define STATS_IMPULSE "80"
#define STATS_CVAR_RENDER "scratch1"
#define STATS_CVAR_SIZE "temp1"
#define STATS_CVAR_METHOD "temp2"
#define STATS_CVAR_RENDER_RADIUS "temp3"

// Define an alias with localcmd
#define ALIAS(_name,_command) localcmd("alias \""_name"\" \""_command"\"\n")

// Adds a new statistic into the game
#define ADD_STATISTIC(_num,_name,_field,_color) var float max_##_name = 0;\
void(vector pos) Stats_Increase##_name =\
{\
    local entity marker = GetStatisticsMarker(pos);\
    max_##_name = math_max(++marker.##_field,max_##_name);\
};\
__accumulate renderingInfo_t(float stat) Stats_GetRenderingInfo =\
{\
    if(stat == ##_num) {\
        local renderingInfo_t info;\
        info.field = ##_field;\
        info.maxValue = max_##_name;\
        info.color = ##_color;\
        return info;\
    }\
}\
__accumulate void() InitializeStatistics =\
{\
    ALIAS("stats_show_"#_name,"scratch1 "#_num";impulse "STATS_IMPULSE);\
}\
__accumulate void() Stats_HandleImpulse =\
{\
    if(cvar(STATS_CVAR_RENDER) == _num)\
    {\
        mapStats.statsRender = _num;\
        sprint(self,"Stats rendering: "#_name"\n");\
        return;\
    }\
}

// Increases the statistic value
#define INCREASE_STATISTIC(_name,_pos) Stats_Increase##_name(_pos)


enum {
    STATS_METHOD_RADIAL,
    STATS_METHOD_GRID
};

typedef struct {
    float statsSize;
    string statsClassname;
    entity host;
    float statsRender;
    float statsMethod;
    float renderDistance;
} mapstats_t;

typedef struct {
    .float field;
    float maxValue;
    float color;
} renderingInfo_t;

mapstats_t mapStats;