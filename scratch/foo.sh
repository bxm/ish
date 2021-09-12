#export WHITE='\033[1;37m'
#export BG_WHITE='\033[1;47m'

source lib/decor.sh
source lib/debug.sh

echo "foo" | colour spot WHITE
