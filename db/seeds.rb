# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Nettoyage de la base de données..."
Job.destroy_all
Service.destroy_all

puts "Création des jobs..."
Job.create!(
  title: "Gouvernant(e)",
  description: "Superviser le service d'étage et garantir la qualité de nos chambres. Expérience requise."
)

Job.create!(
  title: "Linger(ère)",
  description: "Entretien et gestion du linge de l'hôtel. Rigueur et sens de l'organisation requis."
)

Job.create!(
  title: "Valet/Femme de chambre",
  description: "Nettoyage et entretien des chambres. Dynamisme et souci du détail indispensables."
)

Job.create!(
  title: "Cafetier(ère)",
  description: "Service et préparation de boissons au bar/café. Expérience souhaitée."
)

puts "✅ #{Job.count} jobs créés avec succès!"

puts "Création des services..."
Service.create!(
  name: "Nettoyage quotidien",
  price: 45.0
)

Service.create!(
  name: "Nettoyage en profondeur",
  price: 75.0
)

Service.create!(
  name: "Service personnalisé",
  price: 60.0
)

puts "✅ #{Service.count} services créés avec succès!"
