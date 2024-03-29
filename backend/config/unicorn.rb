
app_path = "/var/www/study-share/backend"

worker_processes 1

working_directory "#{app_path}/current/backend"

listen "#{app_path}/shared/tmp/sockets/unicorn.sock"

pid "#{app_path}/shared/tmp/pids/unicorn.pid"

stderr_path "#{app_path}/shared/log/unicorn.stderr.log"

stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

timeout 60

preload_app true
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

before_fork do |server, worker|
  stdout_logger = Logger.new("#{app_path}/shared/log/unicorn.stdout.log")
  stderr_logger = Logger.new("#{app_path}/shared/log/unicorn.stderr.log")


  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      stderr_logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end

