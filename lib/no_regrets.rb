require 'fileutils'
require 'digest'
require 'launchy'
require_relative "no_regrets/image_diff"

class NoRegrets

  class ScreenshotMismatchError < StandardError
  end

  def self.check_screenshot_for_regressions(screenshot_name)
    new(screenshot_name).check_screenshot_for_regressions
  end

  def check_screenshot_for_regressions
    path = Capybara.current_session.save_screenshot("#{screenshot_name}.png")
    sha1 = Digest::SHA1.hexdigest(File.read(path))
    if !File.exists?(cache_file_path(sha1))
      FileUtils.mkdir_p(cache_dir)
      FileUtils.cp(path, cache_file_path(sha1))
    end

    if old_sha1 && old_sha1 != sha1
      raise_error(path, sha1)
    end

    FileUtils.rm(path)
    if !fingerprints[screenshot_name]
      puts "Saving a new screenshot fingerprint for \"#{screenshot_name}\" in #{fingerprint_file_path}"
    end
    fingerprints[screenshot_name] = sha1

    write_fingerprints_file(fingerprints)
  end

  def initialize(screenshot_name)
    @screenshot_name = screenshot_name
  end

  private

  attr_reader :screenshot_name

  def fingerprints
    @fingerprints ||= File.exists?(fingerprint_file_path) ? YAML.load(File.read(fingerprint_file_path)) : {}
  end

  def raise_error(new_screenshot_path, new_sha1)
    error_message = <<~ERROR_MESSAGE
      The screenshot \"#{screenshot_name}\" has changed.
      You can view the new screenshot by opening #{new_screenshot_path}.

      If this was expected, you can remove this line:
      #{screenshot_name}: #{fingerprints[screenshot_name]}
      from the file #{fingerprint_file_path}, run this test again, and commit the result.
    ERROR_MESSAGE

    if diffable?(new_sha1)
      error_message << "You can see the diff"

      diff_path = "#{diff_dir}/#{screenshot_name}.png"
      FileUtils.mkdir_p(diff_dir)
      ImageDiff.generate_diff(
        cache_file_path(old_sha1),
        cache_file_path(new_sha1),
        diff_path
      )
      Launchy.open(diff_path)
    end

    raise ScreenshotMismatchError, error_message
  end

  def old_sha1
    fingerprints[screenshot_name]
  end

  def write_fingerprints_file(fingerprints)
    dirname = File.dirname(fingerprint_file_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
    File.write(fingerprint_file_path, fingerprints.to_yaml)
  end

  def fingerprint_file_path
    'spec/support/no_regret_fingerprints.yml'
  end

  def diffable?(new_sha1)
    File.exists?(cache_file_path(old_sha1)) && File.exists?(cache_file_path(new_sha1))
  end

  def cache_file_path(sha1)
    "#{cache_dir}/#{sha1}.png"
  end

  def cache_dir
    "#{Capybara.save_path.to_s}/no_regrets"
  end

  def diff_dir
    "#{cache_dir}/diffs"
  end

end
