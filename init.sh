#!/bin/bash

if ! [ "$FROM_SYNC" = "1" ]; then
    echo -e "\033[36m Don't run this script directly. Instead run './everything.sh init'.\033[0m\n"
    exit 1
fi

mkdir -p $HOME_PATH/bin
echo "#!/bin/bash" > $HOME_PATH/bin/everything
echo "cd $EVERYTHING_PATH; exec ./everything.sh \"\$@\"" >> $HOME_PATH/bin/everything
chmod +x $HOME_PATH/bin/everything

