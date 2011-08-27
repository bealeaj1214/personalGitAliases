def check_usage
  unless ARGV.length == 2
    scriptName = File.basename($0)
    puts "Usage: #{scriptName} <branch 1>  <branch 2>"
    exit
  end
end

def identify_common_commits(branch_alpha, branch_beta)
  command = "git cherry #{branch_alpha}  #{branch_beta} | awk ' $1~/-/ { print $2} '"

  puts "#{command}"
end


if $0 == __FILE__
  check_usage
  identify_common_commits(ARGV[0], ARGV[1])
end

