# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Synchronisation des données de référence..."

jobs_data = [
  {
    title: "Gouvernant(e)",
    description: "Superviser le service d'étage et garantir la qualité de nos chambres. Expérience requise."
  },
  {
    title: "Linger(ère)",
    description: "Entretien et gestion du linge de l'hôtel. Rigueur et sens de l'organisation requis."
  },
  {
    title: "Valet/Femme de chambre",
    description: "Nettoyage et entretien des chambres. Dynamisme et souci du détail indispensables."
  },
  {
    title: "Cafetier(ère)",
    description: "Service et préparation de boissons au bar/café. Expérience souhaitée."
  },
  {
    title: "Commis de cuisine",
    description: "Préparation, mise en place et assistance en cuisine. Rigueur, rapidité et esprit d'équipe requis."
  },
  {
    title: "Réceptionniste",
    description: "Accueil des clients, gestion des réservations et coordination avec les équipes. Professionnalisme et courtoisie requis."
  }
]

jobs_data.each do |attributes|
  job = Job.find_or_initialize_by(title: attributes[:title])
  job.assign_attributes(description: attributes[:description])
  job.save!
end
puts "✅ #{jobs_data.size} jobs synchronisés"

services_data = [
  { name: "Nettoyage quotidien", price: 21.0 },
  { name: "Nettoyage en profondeur", price: 35.0 },
  { name: "Service personnalisé", price: 100.0 }
]

services_data.each do |attributes|
  service = Service.find_or_initialize_by(name: attributes[:name])
  service.assign_attributes(price: attributes[:price])
  service.save!
end
puts "✅ #{services_data.size} services synchronisés"

tips_data = [
  {
    title: "Bien nettoyer les vitres de salle de bain",
    intro: "Des vitres sans traces pour une salle de bain impeccable",
    description: "Pour obtenir des vitres parfaitement propres sans traces :\n\n• Utilisez un mélange d'eau tiède et de vinaigre blanc (50/50)\n• Appliquez avec un chiffon microfibre propre\n• Essuyez en mouvements circulaires\n• Terminez par un passage vertical puis horizontal\n• Polissez avec du papier journal pour un résultat sans traces\n\nAstuce pro : Nettoyez vos vitres par temps nuageux pour éviter que le produit ne sèche trop vite.",
    image: "Tips1.JPG",
    tips: "Vinaigre blanc dilué,Chiffon microfibre,Papier journal pour polir,Éviter le plein soleil",
    products: "• Vinaigre blanc blanc classique\n• Eau tiède\n• Chiffon microfibre de haute qualité\n• Papier journal ou journal\n• Vaporisateur ou pulvérisateur",
    usage: "1. Mélangez le vinaigre blanc et l'eau tiède dans un vaporisateur (50/50)\n2. Vaporisez généreusement la surface des vitres\n3. Laissez reposer quelques secondes pour que le produit agisse\n4. Essuyez d'abord en mouvements circulaires avec le chiffon microfibre\n5. Terminez par des passages verticaux puis horizontaux pour un résultat uniforme\n6. Polissez avec du papier journal pour éliminer les traces\n7. Attendez quelques minutes avant de toucher pour éviter les marques",
    results: "✓ Vitres parfaitement claires et transparentes\n✓ Absence totale de traces ou de voile blanc\n✓ Brillance naturelle du verre\n✓ Résultat professionnel et longue durée\n✓ Facilité d'entretien futur des vitres"
  },
  {
    title: "Entretenir les surfaces en inox",
    intro: "Garder l'éclat de vos équipements professionnels",
    description: "L'inox est un matériau noble qui nécessite un entretien adapté :\n\n• Nettoyez dans le sens du grain de l'inox\n• Utilisez un produit spécifique ou du savon doux\n• Rincez abondamment à l'eau claire\n• Séchez immédiatement avec un chiffon doux\n• Polissez avec quelques gouttes d'huile d'olive pour faire briller\n\nÀ éviter : Les éponges abrasives qui rayent la surface.",
    image: "Tips2.JPG",
    tips: "Nettoyer dans le sens du grain,Séchage immédiat,Produits non abrasifs,Polissage régulier",
    products: "• Produit nettoyant spécifique inox OU savon neutre doux\n• Chiffon microfibre doux\n• Huile d'olive ou spray à polir inox\n• Eau distillée (évite les traces minérales)\n• Papier absorbant ou serviette microfibre",
    usage: "1. Appliquez le produit nettoyant dilué en respectant le sens du grain\n2. Frottez délicatement avec un chiffon microfibre mouillé\n3. Rincez abondamment avec de l'eau distillée\n4. Séchez immédiatement avec un papier absorbant\n5. Appliquez quelques gouttes d'huile d'olive sur un chiffon\n6. Polissez en mouvements circulaires légers\n7. Finalisez en suivant à nouveau le sens du grain",
    results: "✓ Brillance intense et uniforme\n✓ Aspect professionnel et haut de gamme\n✓ Pas de rayures ni de marques\n✓ Protection contre l'oxydation\n✓ Facilité de nettoyage futur"
  },
  {
    title: "Désodoriser naturellement les espaces",
    intro: "Une atmosphère fraîche sans produits chimiques",
    description: "Pour maintenir une ambiance agréable naturellement :\n\n• Aérez quotidiennement pendant 15 minutes minimum\n• Placez du bicarbonate de soude dans les zones à problèmes\n• Utilisez des huiles essentielles (lavande, citron)\n• Nettoyez régulièrement les textiles (rideaux, tapis)\n• Utilisez du café moulu pour absorber les odeurs tenaces\n\nBon à savoir : Le bicarbonate absorbe les odeurs et l'humidité.",
    image: "Tips3.JPG",
    tips: "Aération quotidienne,Bicarbonate de soude,Huiles essentielles,Café moulu",
    products: "• Bicarbonate de soude fin\n• Huiles essentielles naturelles (lavande, citron, eucalyptus)\n• Café moulu frais\n• Petits récipients ou soucoupe\n• Vaporisateur pour brume légère",
    usage: "1. Aérez l'espace 15 minutes chaque jour en ouvrant grand les fenêtres\n2. Saupoudrez du bicarbonate de soude dans les coins et zones problématiques\n3. Laissez reposer 30 minutes minimum puis aspirez\n4. Ajoutez 3-5 gouttes d'huile essentielle au bicarbonate pour un parfum naturel\n5. Placez des petits bols de café moulu dans les zones avec odeurs persistantes\n6. Changez le café chaque semaine\n7. Renouvelez l'opération tous les 7-10 jours pour un maintien optimal",
    results: "✓ Odeurs désagréables complètement neutralisées\n✓ Arôme naturel et agréable\n✓ Absence de résidu chimique\n✓ Atmosphère saine et respirable\n✓ Effet durable et écologique"
  }
]

tips_data.each do |attributes|
  tip = Tip.find_or_initialize_by(title: attributes[:title])
  tip.assign_attributes(attributes.except(:title))
  tip.save!
end
puts "✅ #{tips_data.size} astuces synchronisées"

puts "Seed terminé."
