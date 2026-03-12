function convert_path --description "Auto-detect and convert between Windows and WSL paths"
    set -l input (string trim $argv[1])

    if string match -rq '^/mnt/[a-z]/' $input
        # WSL /mnt/ path -> Windows path
        to_windows $input
    else if string match -rq '^/' $input
        # WSL internal path -> Windows network path
        to_windows $input
    else if string match -rq '^[A-Za-z]:' $input
        # Windows path -> WSL path
        to_wsl $input
    else
        echo "Path format not recognized. Expected C:\\..., /mnt/c/..., or /path/to/file" >&2
        return 1
    end
end