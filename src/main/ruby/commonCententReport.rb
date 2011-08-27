def check_usage
  unless ARGV.length == 2
    scriptName = File.basename($0)
    puts "Usage: #{scriptName} <branch 1>  <branch 2>"
    exit
  end
end

def reportInvalidBranchSpec(check_value,branch_value)
  unless check_value 
    puts " invalid git branch specification :#{branch_value}"
  end
end

def isValidCommit(branch) 
  command = "git rev-parse --verify #{branch} >/dev/null  2>1"
  junk= %x(#{command})
  return ($?.to_i == 0)
end

def check_branches(branch_alpha, branch_beta)
  checkAlpha = isValidCommit(branch_alpha)
  checkBeta = isValidCommit(branch_beta)
  
  reportInvalidBranchSpec(checkAlpha,branch_alpha)
  reportInvalidBranchSpec(checkBeta ,branch_beta)

  unless checkAlpha && checkBeta
    exit
  end
end

def identify_common_commits(branch_alpha, branch_beta)
  command = "git cherry #{branch_alpha}  #{branch_beta} | awk ' $1~/-/ { print $2} '"

  cmd_result =%x[#{command}]

  unless ($?.to_i == 0) 
    puts "error:"
    exit
  end

  common_commits = cmd_result.split

  return common_commits

end


if $0 == __FILE__
  check_usage
  check_branches(ARGV[0], ARGV[1])
  identify_common_commits(ARGV[0], ARGV[1])
end

