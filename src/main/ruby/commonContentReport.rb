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

  #TODO  Check that the branches don't point to the same commit
  #TODO  Check that neither branch is an immediate ancestor of the other
  unless checkAlpha && checkBeta
    exit
  end
end

def identify_common_commits(branch_alpha, branch_beta)
  command = "git cherry #{branch_alpha}  #{branch_beta} | awk ' $1~/-/ { print $2} '"

  cmd_result = %x[#{command}]

  unless ($?.to_i == 0) 
    puts "error:"
    exit
  end

  common_commits = cmd_result.split

  return common_commits

end


def subjectReports(commits)
  
  commits.each { |commit|
    command = "GIT_PAGER= git log -1 --pretty='%h %s'  #{commit}"
    cmd_result =%x(#{command})
    puts "\t#{cmd_result}"
  }

end

class CommonContentReport
  def initialize(branch_alpha, branch_beta)
    @branch1 =branch_alpha
    @branch2 =branch_beta
    @common_patches = Hash.new{|h,k| h[k] = []}
  end

  def processCommits(commits)
    commits.each { |commit|
      command = " git show #{commit} | git patch-id "
      cmd_result = %x[#{command}]
      
      if ($?.to_i == 0)
        parts=cmd_result.split
        if (parts.length == 2) 
          @common_patches[parts[0]] =  @common_patches[parts[0]] + [parts[1]]
        end
      end
    }
  end
  

  def report 
    puts " number of common patches #{@common_patches.length} "
    @common_patches.each { |key,commits|
      puts " #{key} "
      subjectReports(commits)
    }
  end

  def process
    commits1 =identify_common_commits(@branch1, @branch2)
    processCommits(commits1)
    commits2 =identify_common_commits(@branch2, @branch1)
    processCommits(commits2)
  end
end

if $0 == __FILE__
  check_usage
  check_branches(ARGV[0], ARGV[1])
  ccReport =CommonContentReport.new(ARGV[0], ARGV[1])
  ccReport.process
  ccReport.report
end

