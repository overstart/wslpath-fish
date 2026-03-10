function to_windows --description "Convert WSL path to Windows path"
    set -l input (string trim $argv[1])

    # Check if it's already a Windows path
    if string match -rq '^[A-Za-z]:' $input
        echo $argv[1]
        return 0
    end

    # Extract drive letter from /mnt/c/ pattern
    set -l match (string match -r '^/mnt/([a-z])(/.*)?$' $input)
    if test -z "$match"
        echo "Invalid WSL path format. Expected /mnt/c/..." >&2
        return 1
    end

    set -l drive_letter (string sub -l 1 $match[2] | string upper)
    set -l path_without_mnt (string sub -s 7 -- $input)

    # Convert forward slashes to backslashes
    set -l windows_path "$drive_letter:$path_without_mnt"
    set -l windows_path (string replace -a '/' "\\" $windows_path)

    echo $windows_path
end