# Regenerates resume.md from _data/resume.json.
#
#   ruby scripts/resume_md.rb

require "json"

ROOT = File.expand_path("..", __dir__)
MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

def format_date(date)
  year, month = date.split("-")
  month ? "#{MONTHS[month.to_i - 1]} #{year}" : year
end

def period(start_date, end_date)
  return format_date(start_date) if start_date == end_date

  "#{format_date(start_date)} – #{end_date ? format_date(end_date) : "Present"}"
end

def link(text, url)
  url ? "[#{text}](#{url})" : text
end

resume = JSON.parse(File.read(File.join(ROOT, "_data/resume.json")))
basics = resume.fetch("basics")
location = basics.fetch("location")
out = []

out << "# #{basics["name"]}" << ""
out << "**#{basics["label"]}**  "
out << "#{location["city"]}, #{location["region"]}, France" << ""
basics["profiles"].each { |p| out << "- #{p["network"]}: #{link(p["url"].sub(%r{\Ahttps?://(www\.)?}, "").chomp("/"), p["url"])}" }
out << "" << "## Summary" << ""
out << basics["summary"].gsub("\n", "  \n") << ""
out << "Core skills: #{basics["coreSkills"].join(" · ")}" << "" if basics["coreSkills"]

out << "## Experience" << ""
resume["work"].each do |job|
  out << "### #{link(job["name"], job["url"])} — #{job["position"]}"
  out << ["*#{period(job["startDate"], job["endDate"])}*", job["location"]].compact.join(" · ") << ""
  out << job["summary"] << "" if job["summary"]
  job.fetch("highlights", []).each { |h| out << "- #{h}" }
  out << "" << "Stack: #{job["keywords"].join(", ")}" if job["keywords"]
  out << ""
end

out << "## Skills" << ""
resume.fetch("skills", []).each { |s| out << "- **#{s["name"]}:** #{s["keywords"].join(", ")}" }
out << ""

projects = resume.fetch("projects", [])
out << "## Open Source" << "" << "Author:" << ""
projects.select { |p| p["roles"].include?("Author") }.each do |p|
  stats = p["stats"] ? " (#{p["stats"]})" : ""
  out << "- #{link(p["name"], p["url"])}: #{p["description"].chomp(".")}#{stats}"
end
out << "" << "Contributor:" << ""
projects.select { |p| p["roles"].include?("Contributor") && p["url"] }.each do |p|
  stats = p["stats"] ? " (#{p["stats"]})" : ""
  out << "- #{link(p["name"], p["url"])}: #{p["description"].chomp(".")}#{stats}"
end
projects.select { |p| p["type"] == "contributions" }.each do |p|
  repos = p["repositories"].map { |repo| link(repo.split("/").last, "https://github.com/#{repo}") }
  out << "- #{p["name"]}: #{repos.join(", ")}"
end
out << ""

out << "## Education" << ""
resume.fetch("education", []).each do |e|
  out << "### #{[e["institution"], e["location"]].compact.join(", ")}"
  out << "#{[e["studyType"], e["area"]].compact.join(" · ")} · *#{period(e["startDate"], e["endDate"])}*" << ""
end

out << "## Languages" << ""
resume.fetch("languages", []).each { |l| out << "- #{l["language"]} — #{l["fluency"]}" }

if resume["interests"]
  out << "" << "## Interests" << ""
  out << resume["interests"].map { |i| i["name"] }.join(" · ")
end

File.write(File.join(ROOT, "resume.md"), out.join("\n") + "\n")
puts "Wrote resume.md"
