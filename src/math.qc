float(float a,float b) math_max =
{
    return a > b ? a : b;
}

float(float a,float b) math_min =
{
    return a < b ? a : b;
}


float(float val,float flag) math_toggleflag =
{
    return val & flag ? val - flag : val + flag;
}