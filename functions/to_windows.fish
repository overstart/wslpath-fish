function to_windows --description "Convert WSL path to Windows path"
    set -l input (string trim $argv[1])

    # Check if it's already a Windows path
    if string match -rq '^[A-Za-z]:' $input
        echo $argv[1]
        return 0
    end

    # Check if it's a /mnt/ drive path
    set -l match (string match -r '^/mnt/([a-z])(/.*)?$' $input)
    if test -n "$match"
        set -l drive_letter (string sub -l 1 $match[2] | string upper)
        set -l path_without_mnt (string sub -s 7 -- $input)

        # Convert forward slashes to backslashes
        set -l windows_path "$drive_letter:$path_without_mnt"
        set -l windows_path (string replace -a '/' "\\" $windows_path)

        echo $windows_path
        return 0
    end

    # For other WSL paths, convert to WSL network path format
    # Get the WSL distribution name from environment variable
    set -l distro "$WSL_DISTRO_NAME"
    if test -z "$distro"
        echo "Failed to get WSL distribution name. Please set WSL_DISTRO_NAME environment variable." >&2
        return 1
    end

    # Remove leading slash
    set -l path_without_slash (string sub -s 2 $input)
    # Convert forward slashes to backslashes
    set -l windows_path "\\\\wsl.localhost\\$distro\\$path_without_slash"
    set -l windows_path (string replace -a '/' "\\" $windows_path)

    echo $windows_path
end