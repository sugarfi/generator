require "kemal"
require "yaml"
require "./gen"

defs = File.open("defs.yml") do |file|
    YAML.parse(file)["defs"].as_a
end

saved = File.open("gen.yml") do |file|
    kv = YAML.parse(file)
    out = {} of String => Array(String)
    kv.as_h.keys.each do |key|
        out[key.as_s] = kv[key].as_a.map(&.as_s)
    end

    out
end

get "/" do |env|
    send_file env, "public/index.html"
end

get "/gen.yml" do |env|
    env.response.content_type = "text/plain"
    File.read "gen.yml"
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
