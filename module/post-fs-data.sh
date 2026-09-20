#!/system/bin/sh
MOD_DIR=${0%/*}
LOG=$MOD_DIR/zram_zstd.log

echo "post-fs-data: $(date)" > "$LOG"

if [ -e /sys/block/zram0/comp_algorithm ]; then
    echo "zram exists" >> "$LOG"
    
    old_algo=$(cat "/sys/block/zram0/comp_algorithm" 2>/dev/null | grep -oE '\[[^]]+\]' | tr -d '[]')
    cat /sys/block/zram0/comp_algorithm >> "$LOG"
    cat /proc/swaps >> "$LOG"
    
    echo "zstd" > /sys/block/zram0/comp_algorithm 
    
    new_algo=$(cat "/sys/block/zram0/comp_algorithm" 2>/dev/null | grep -oE '\[[^]]+\]' | tr -d '[]')
    cat /sys/block/zram0/comp_algorithm >> "$LOG"
    cat /proc/swaps >> "$LOG"
    
    if [ "$new_algo" = "zstd" ]; then
        zstd_state="✅"
    else
        zstd_state="❌"
    fi

    STATUS="[ Old Algorithm: ${old_algo}, New Algorithm: ${new_algo} ${zstd_state} ]"
    sed -i "s|^description=.*|description=$STATUS|" "$MOD_DIR/module.prop"
else
    echo "zram does not exist yet" >> "$LOG"
    STATUS="❌ Error Zram NOT found."
    sed -i "s|^description=.*|description=$STATUS|" "$MOD_DIR/module.prop"
fi
