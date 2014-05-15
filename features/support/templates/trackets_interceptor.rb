require 'sham_rack'

ShamRack.at("trackets.com") do |env|
  File.open(Rails.root.join("request_log.txt"), "w") { |f| f.puts(env.to_json) }

  ["200 OK", { "Content-type" => "text/json" }, [{
      hello: "something"
    }]]
end
