mkdir ~/mwgrinpool
 
cd ~/mwgrinpool
 
apt-get update
 
sudo apt-get install -y curl git cmake make zlib1g-dev pkgconf ncurses-dev libncursesw5-dev linux-headers-generic g++ libssl-dev
 
curl https://sh.rustup.rs -sSf | sh
 
source $HOME/.cargo/env
 
git clone https://github.com/mimblewimble/grin-miner.git
cd grin-miner
git submodule update --init
 
cat /proc/cpuinfo | grep avx2 | wc -l
 
sed -i 's/^plugin_name =.*/plugin_name = "cuckaroo_cpu_avx2_29"/' grin-miner.toml
 
cargo build --release
 
sed -i 's/stratum_server_addr.*/stratum_server_addr = "stratum.mwgrinpool.com:3333"/' grin-miner.toml
 
printf "\nUsername: " && read username && sed -i 's/.*stratum_server_login.*/stratum_server_login = "'$username'"/' grin-miner.toml
 
printf "\nPassword: " && read password && sed -i 's/.*stratum_server_password.*/stratum_server_password = "'$password'"/' grin-miner.toml
 
grep -c ^processor /proc/cpuinfo
 
printf "\nNumber of Processors: " && read nthreads && sed -i 's/^nthreads.*/nthreads = '$nthreads'/' grin-miner.toml
 
./target/release/grin-miner
