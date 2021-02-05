BEGIN{window=1.0}{
if (NR == 1) 
    {
     first_t=$1; 
     prev_src=$2; 
     prev_dst=$3
     flag_up=0;
     flag_down=0
    };
if ($2==prev_src && $3 == prev_dst && $1 - first_t <=window) 
    {
     current_window[window_index++]=$1" "$2" "$3;
     if ($4 == 0) flag_up = 1;
     if ($4 == 1) flag_down =1;
    } 
else 
    {
     if (flag_up == 1 && flag_down == 1) 
        {
         for (iii in current_window)
            {
             print current_window[iii];
             delete current_window[iii]
            }
        }
     else 
        {
         for (iii in current_window)
            {
             delete current_window[iii]
            }
        }
    prev_src = $2;
    prev_dst = $3;
    first_t = $1;
    flag_up = 0;
    flag_down = 0;
    window_index = 0
    current_window[window_index++]=$1" "$2" "$3;
    if ($4 == 0) flag_up = 1;
    if ($4 == 1) flag_down =1;
    }
}
END{
    if (flag_up == 1 && flag_down == 1) 
    {
     for (iii in current_window)
        {
         print current_window[iii]
        }
    }
}
