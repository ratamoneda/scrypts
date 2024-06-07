#!/bin/bash

cat << "EOF"

                      QQQQQQQQQ       1111111   
                    QQ:::::::::QQ    1::::::1   
                  QQ:::::::::::::QQ 1:::::::1   
                 Q:::::::QQQ:::::::Q111:::::1   
                 Q::::::O   Q::::::Q   1::::1   
                 Q:::::O     Q:::::Q   1::::1   
                 Q:::::O     Q:::::Q   1::::1   
                 Q:::::O     Q:::::Q   1::::l   
                 Q:::::O     Q:::::Q   1::::l   
                 Q:::::O     Q:::::Q   1::::l   
                 Q:::::O  QQQQ:::::Q   1::::l   
                 Q::::::O Q::::::::Q   1::::l   
                 Q:::::::QQ::::::::Q111::::::111
                  QQ::::::::::::::Q 1::::::::::1
                    QQ:::::::::::Q  1::::::::::1
                      QQQQQQQQ::::QQ111111111111
                              Q:::::Q           
                               QQQQQQ  QUILIBRIUM.ONE                                                                                                                                  


============================================================================
                          ✨ gRPC Calls SETUP ✨
============================================================================
This script will edit your .config/config.yml file and setup the gRPC calls.

Follow the Quilibrium Node guide at https://docs.quilibrium.one

Made with 🔥 by LaMat - https://quilibrium.one
============================================================================

Processing... ⏳

EOF

sleep 5  # Add a 7-second delay

# Function to check if a line exists in a file
line_exists() {
    grep -qF "$1" "$2"
}

# Function to add a line after a specific pattern
add_line_after_pattern() {
    sudo sed -i "/^ *$1:/a\  $2" "$3" || { echo "❌ Failed to add line after '$1'! Exiting..."; exit 1; }
}

# Step 1: Enable gRPC and REST
echo "🚀 Enabling gRPC and REST..."
sleep 1
cd "/home/quilibrium/ceremonyclient/node/" || { echo "❌ Failed to change directory to ~/ceremonyclient/node! Exiting..."; exit 1; }

# Delete existing lines for listenGrpcMultiaddr and listenRESTMultiaddr if they exist
sudo sed -i '/^ *listenGrpcMultiaddr:/d' .config/config.yml
sudo sed -i '/^ *listenRESTMultiaddr:/d' .config/config.yml

# Add listenGrpcMultiaddr: "/ip4/127.0.0.1/tcp/8337"
echo "listenGrpcMultiaddr: \"/ip4/127.0.0.1/tcp/8337\"" | sudo tee -a .config/config.yml > /dev/null || { echo "❌ Failed to enable gRPC! Exiting..."; exit 1; }

# Add listenRESTMultiaddr: "/ip4/127.0.0.1/tcp/8338"
echo "listenRESTMultiaddr: \"/ip4/127.0.0.1/tcp/8338\"" | sudo tee -a .config/config.yml > /dev/null || { echo "❌ Failed to enable REST! Exiting..."; exit 1; }

sleep 1

# Step 2: Enable Stats Collection
echo "📊 Enabling Stats Collection..."
if ! line_exists "statsMultiaddr: \"/dns/stats.quilibrium.com/tcp/443\"" .config/config.yml; then
    add_line_after_pattern "engine" "statsMultiaddr: \"/dns/stats.quilibrium.com/tcp/443\"" .config/config.yml
    echo "✅ Stats Collection enabled."
else
    echo "✅ Stats Collection already enabled."
fi

sleep 1

# Step 3: Check and modify listenMultiaddr
echo "🔍 Checking listenMultiaddr..."
if line_exists "listenMultiaddr: /ip4/0.0.0.0/udp/8336/quic" .config/config.yml || line_exists "listenMultiaddr:/ip4/0.0.0.0/udp/8336/quic" .config/config.yml; then
    echo "🛠️ Modifying listenMultiaddr..."
    sudo sed -i -E 's|^ *listenMultiaddr: /ip4/0.0.0.0/udp/8336/quic *$|  listenMultiaddr: /ip4/0.0.0.0/tcp/8336|' .config/config.yml || { echo "❌ Failed to modify listenMultiaddr! Exiting..."; exit 1; }
    echo "✅ listenMultiaddr modified."

    # Double check if the new line exists after the change
    if line_exists "listenMultiaddr: /ip4/0.0.0.0/tcp/8336" .config/config.yml; then
        echo "✅ New listenMultiaddr line found."
    else
        echo "❌ New listenMultiaddr line not found after modification."
    fi
else
    # Double check if the new line exists after the change
    if line_exists "listenMultiaddr: /ip4/0.0.0.0/tcp/8336" .config/config.yml; then
        echo "✅ ListenMultiaddr line already set."
    else
        echo "❌ ListenMultiaddr line not found."
    fi
fi

sleep 1

echo""
echo "✅ gRPC, REST, and Stats Collection setup was successful."
echo""
echo "✅ If you want to check manually just run: cd /home/quilibrium/ceremonyclient/node/.config/ && cat config.yml"
sleep 1

echo "Install firewall"
sudo apt install ufw -y
# Automatically confirm enabling ufw
yes | sudo ufw enable
sleep 10
sudo ufw enable
sleep 5
echo "Setup firewall"
sudo ufw allow 22
sudo ufw allow 8336
sudo ufw allow 443
sudo ufw allow 22/tcp
sudo ufw allow 8336/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/udp
sudo ufw allow 8336/udp
sudo ufw allow 443/udp
sudo ufw allow 22/tcp6
sudo ufw allow 8336/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/udp
sudo ufw allow 8336/udp
sudo ufw allow 443/udp
sleep 15
sudo service ufw restart
sleep 5
echo "Firewall setup done"
echo "Install CPU limiter"
sudo apt-get install gawk -y
sleep 5
sudo apt-get install -y cpulimit
echo "ALL DONE!!!"
