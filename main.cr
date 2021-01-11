require "kemal"
require "yaml"
require "./gen"

defs = File.open("defs.yml") do |file|
    YAML.parse(file)["defs"].as_a
end

saved = {} of String => Array(String)

get "/" do |env|
    send_file env, "public/index.html"
end

get "/api/def" do |env|
    d = defs.sample(1)[0].as_s
    saved[d] ||= [] of String
    d.to_json
end

post "/api/generate" do |env|
    words = env.params.json["words"].as(Array(JSON::Any)).map(&.as_s)
    d = env.params.json["def"].as String
    gen = Language::Generator.generate words
    saved[d] << gen
    gen.to_json
end

spawn do
    loop do
        sleep 5.minutes
        puts "[DEBUG] Syncing saved words to file"
        File.open("gen.yml", "w") { |file| file << saved.to_yaml }
    end
end

Kemal.run
