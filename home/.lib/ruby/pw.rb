require 'io/console'
require 'fileutils'
require 'optparse'
require 'securerandom'
require 'gpgme'

class PW
  class KeyExists < Exception; end

  RECIPIENTS = %w(lewis@lmars.net)

  def initialize(argv, db_dir)
    @argv   = argv
    @db_dir = db_dir
  end

  def run
    parse!

    case @action
    when :list
      $stdout.puts keys.join("\n")
    when :get
      $stdout.puts get(@key)
    when :set
      set(@key, @secret)
      $stdout.puts "OK"
    end
  end

  private
  def parse!
    OptionParser.new { |opts|
      opts.on('-g', '--generate', 'Generate a random secret') do
        @generate = true
      end

      opts.on('-f', '--force', 'Force setting of the secret') do
        @force = true
      end
    }.parse!(@argv)

    @db, @key, @secret = @argv.shift(3)

    if @secret || @key && @generate
      @action = :set
    elsif @key
      @action = :get
    else
      @action = :list
    end
  end

  def db_path
    "#{@db_dir}/#{@db}"
  end

  def crypto
    GPGME::Crypto.new(
      :passphrase_callback => method(:get_passphrase)
    )
  end

  def get_passphrase(obj, uid_hint, passphrase_info, prev_was_bad, fd)
    if prev_was_bad == 1
      $stderr.puts "Invalid passphrase, please try again"
    end

    $stderr.print %{Passphrase for #{uid_hint}: }
    $stderr.flush

    io = IO.for_fd(fd, 'w')
    io.puts $stdin.noecho(&:gets)
    io.flush

    $stderr.puts
  end

  def get(key)
    key_path = "#{db_path}/#{key}.gpg"

    crypto.decrypt File.open(key_path)
  end

  def set(key, secret)
    key_path = "#{db_path}/#{key}.gpg"

    if File.exists?(key_path) && !@force
      raise KeyExists
    end

    secret ||= SecureRandom.hex

    FileUtils.mkdir_p db_path

    file = File.open(key_path, 'w')

    begin
      crypto.encrypt(
        secret,
        :always_trust => true,
        :output       => file,
        :recipients   => RECIPIENTS
      )
    rescue Exception => e
      file.close
      File.delete(file.path)
      raise e
    end
  end

  def keys
    Dir["#{db_path}/*.gpg"].map { |k| File.basename(k, '.gpg') }.sort
  end
end
