#!/bin/bash

# Export all variables and functions
set -a

MODULE_MARKERS="-+?#"

if ! [[ -v MODULE_LIST_FILE ]]; then
    MODULE_LIST_FILE="$EVERYTHING_PATH/modules.list"
fi

if ! [[ -v MODULE_VERIFY ]]; then
    MODULE_VERIFY=1
fi

if ! [[ -v MODULE_IGNORE_ERRORS ]]; then
    MODULE_IGNORE_ERRORS=0
fi

function module_script { module=$1; script=$2
    if ! [[ -x "$EVERYTHING_PATH/modules/$module/$script.sh" ]]; then
        echo_error "Could not find module: $module/$script"
        return 1
    fi
    output=$( cd "$EVERYTHING_PATH/modules/$module"; ./$script.sh )
    result=$?
    if [[ -n $output ]]; then
        echo_verbose "$module/$script output: $output"
    fi
    echo_debug "$module/$script result: $result"
    return $result
}

function module_update_line { module=$1; marker=$2
    sed -i --follow-symlinks "s/^[$MODULE_MARKERS]*$module$/$marker$module/g" "$EVERYTHING_PATH/modules.list"
}

function module_verify { module=$1; marker=$2
    module_script $module "verify"
    result=$?
    if [[ $result == $RESULT_ENABLED ]]; then
        if [[ $# == 2 && $marker == [-#] ]]; then
            echo_warning "$module reports being enabled, but should be disabled"
            return 1
        else
            echo_info "$module reports being enabled"
        fi
    elif [[ $result == $RESULT_DISABLED ]]; then
        if [[ $# == 2 && $marker != [-#] ]]; then
            echo_warning "$module reports being disabled, but should be enabled"
            return 1
        else
            echo_info "$module reports being disabled"
        fi
    elif [[ $result == $RESULT_ERROR ]]; then
        echo_error "$module reports error"
        module_update_line $module "?"
        return 1
    else
        echo_error "$module reports unexpected return code"
        module_update_line $module "?"
        return 1
    fi
}

function module_enable { module=$1
    module_script $module "enable"
    module_update_line $module ""
}

function module_verify_enable { module=$1
    module_script $module "enable"
    if [[ $? -ne 0 ]]; then
        module_update_line $module "?"
        return 1
    fi
    module_script $module "verify"
    if [[ $? -ne $RESULT_ENABLED ]]; then
        module_update_line $module "?"
        return 1
    fi
    module_update_line $module ""
}

function module_disable { module=$1
    module_script $module "disable"
    module_update_line $module "#"
}

function module_verify_disable { module=$1
    module_script $module "disable"
    if [[ $? -ne 0 ]]; then
        module_update_line $module "?"
        return 1
    fi
    module_script $module "verify"
    if [[ $? -ne $RESULT_DISABLED ]]; then
        module_update_line $module "?"
        return 1
    fi
    module_update_line $module "#"
}

function module_process_line {
    marker=${module_line::1}
    if [[ $marker == [$MODULE_MARKERS] ]]; then
        module=${module_line:1}
    else
        module=$module_line
    fi
    if [[ $marker == '+' ]]; then
        if [[ $MODULE_VERIFY ]]; then
            module_verify_enable $module
        else
            module_enable $module
        fi
    elif [[ $marker == '-' ]]; then
        if [[ $MODULE_VERIFY ]]; then
            module_verify_disable $module
        else
            module_disable $module
        fi
    elif [[ $marker == '?' ]]; then
        echo_warning "Module requires manual attention (skipping): $module"
        return 1
    fi
    if [[ $MODULE_VERIFY ]]; then
        module_verify $module $marker
    fi
}

function module_get_lines { modules=$@
    if [[ -z $modules ]]; then
        # Include all non '#' lines by default
        match="^[^#]"
    else
        # Select exact matching module lines including -+?# markers
        match="(.^"
        for module in $modules; do
            match+="|^[$MODULE_MARKERS]?$module$"
        done
        match+=")"
    fi
    egrep $match "$MODULE_LIST_FILE" | xargs
}

function module_sync { modules=$@
    for module_line in $(module_get_lines $modules)
    do
        echo_subheading "Synchronising module: $module_line"
        module_process_line $module_line
        if [[ $? != 0 && $MODULE_IGNORE_ERRORS != 1 ]]; then
            echo_error "Sync aborted by failed module: $module_line"
            return 1
        fi
    done
}

set +a

