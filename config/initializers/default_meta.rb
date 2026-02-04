# Initialize default meta tags for the application using values from config/meta.yml

DEFAULT_META = YAML.load_file(Rails.root.join("config/meta.yml"))
