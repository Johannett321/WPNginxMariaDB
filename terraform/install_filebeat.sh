#Installing FileBeat:
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install filebeat
sudo sed -i '/^output.elasticsearch/,/^$/ s/^\(\s*\)hosts: \["localhost:9200"\]/\1#hosts: \["localhost:9200"\]/' /etc/filebeat/filebeat.yml
sudo sed -i 's/^output.elasticsearch/#output.elasticsearch/' /etc/filebeat/filebeat.yml
sudo sed -i 's/^#output.logstash/output.logstash/' /etc/filebeat/filebeat.yml
sudo sed -i 's/#hosts: \["localhost:5044"\]/hosts: \["212.162.146.164:5044"\]/' /etc/filebeat/filebeat.yml
#sudo vi /etc/filebeat/filebeat.yml
sudo filebeat modules enable system
sudo filebeat setup --pipelines --modules system
sudo systemctl start filebeat
sudo systemctl enable filebeat
echo "Done installing filebeat"