# permet de définir les options d'URL pour Active Storage, 
# ce qui est nécessaire pour générer des URL pour les fichiers stockés.

Rails.application.config.after_initialize do
    ActiveStorage::Current.url_options = {
      host: 'localhost', 
      port: 3000,        
      protocol: 'http'   
    }
end
  