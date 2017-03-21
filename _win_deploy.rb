absolute_path = File.expand_path(File.dirname(__FILE__))

require "#{absolute_path}/deploy"
#
# This allows to have realtime puts output when running from c# program
#
$stdout.sync = true

puts "------------------------------------"
system('powershell', '-ExecutionPolicy', 'RemoteSigned', '-File', "#{absolute_path}/_Start-Ssh.ps1", out: $stdout, err: :out)

puts "STEP 1"

Deploy::deploy()

puts "===================================="
