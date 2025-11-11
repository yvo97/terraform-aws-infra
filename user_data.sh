#!/bin/bash
# Script d'initialisation pour les instances EC2

# Mettre à jour le système
yum update -y

# Installer Apache
yum install -y httpd

# Démarrer et activer Apache
systemctl start httpd
systemctl enable httpd

# Créer une page HTML personnalisée
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to $(hostname -f)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .info { background: #f5f5f5; padding: 15px; border-radius: 3px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to $(hostname -f)</h1>
        <div class="info">
            <h2>Instance Information:</h2>
            <p><strong>Hostname:</strong> $(hostname -f)</p>
            <p><strong>Environment:</strong> ${environment}</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>
            <p><strong>Local IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>
        </div>
        <p>Server time: $(date)</p>
    </div>
</body>
</html>
EOF

# Configurer les permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Redémarrer Apache pour appliquer les changements
systemctl restart httpd

# Journaliser la configuration
echo "Instance configuration completed at $(date)" >> /var/log/user-data.log