# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.scss, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )


# scssファイルおよびcoffeeファイルをcssファイル、jsファイルに変換する方法
# Rails.application.config.assets.precompile += %w( coffeeファイル名.js scssファイル名.css )
# でscssファイルおよびcoffeeファイルをcssファイル、jsファイルに変換することができる。
# (拡張子が変換後のjs、cssであることに注意すること)
Rails.application.config.assets.precompile += %w( posts_index.js posts_index.css )
# この一文はposts_indexファイルが元からjs、cssファイルでも必要な模様