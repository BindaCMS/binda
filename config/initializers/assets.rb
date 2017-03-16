# Make fonts available to pipeline
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "fonts")
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/