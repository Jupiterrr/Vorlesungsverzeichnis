# This file is used by Rack-based servers to start the application.
require 'unicorn/worker_killer'

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (245*(1024**2)), (270*(1024**2))

# GC_FREQUENCY = 5
# require 'unicorn/oob_gc'
# GC.disable # Don't run GC during requests
# use Unicorn::OobGC, GC_FREQUENCY # Only GC once every GC_FREQUENCY requests

require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Deflater
run KITBox::Application
