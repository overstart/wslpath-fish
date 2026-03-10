function convert_path --description "Auto-detect and convert between Windows and WSL paths"
    set -l input (string trim $argv[1])

    if string match -rq '^/mnt/[a-z]/' $input
        # WSL path -> Windows path
        to_windows $input
    else if string match -rq '^[A-Za-z]:' $input
        # Windows path -> WSL path
        to_wsl $input
    else
        echo "Path format not recognized. Expected C:\\... or /mnt/c/..." >&2
        return 1
    end
end