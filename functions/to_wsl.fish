function to_wsl --description "Convert Windows path to WSL path"
    set -l input (string trim $argv[1])

    # Check if it's already a WSL path
    if string match -rq '^/mnt/[a-z]/' $input
        echo $argv[1]
        return 0
    end

    # Extract drive letter (C, D, etc.)
    if not string match -rq '^[A-Za-z]:' $input
        echo "Invalid Windows path format. Expected C:\\..." >&2
        return 1
    end

    set -l drive_letter (string sub -l 1 $input | string lower)
    set -l path_without_drive (string sub -s 3 -- $input)

    # Convert backslashes to forward slashes
    set -l path_without_drive (string replace -a '\\' '/' $path_without_drive)
    set -l wsl_path "/mnt/$drive_letter$path_without_drive"

    echo $wsl_path
end