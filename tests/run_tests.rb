#!/usr/bin/env ruby
# encoding: utf-8
#
# XRPN Regression Test Framework
# Tests all xrpn commands to prevent regressions
# Usage: ruby tests/run_tests.rb [test_file.yml]

require 'yaml'
require 'json'
require 'fileutils'

class XRPNTestRunner
  attr_reader :passed, :failed, :errors

  def initialize
    @passed = 0
    @failed = 0
    @errors = 0
    @test_results = []
    @xrpn_bin = File.expand_path('../bin/xrpn', __dir__)
  end

  def run_all_tests
    test_dir = File.dirname(__FILE__)
    test_files = Dir["#{test_dir}/specs/*.yml"].sort

    if test_files.empty?
      puts "No test files found in #{test_dir}/specs/"
      puts "Creating test specification directory..."
      FileUtils.mkdir_p("#{test_dir}/specs")
      return
    end

    puts "=" * 60
    puts "XRPN Regression Test Suite"
    puts "=" * 60
    puts

    test_files.each do |file|
      run_test_file(file)
    end

    print_summary
  end

  def run_test_file(file)
    tests = YAML.load_file(file)
    category = File.basename(file, '.yml')

    puts "Testing: #{category}"
    puts "-" * 60

    tests.each do |test|
      run_single_test(test, category)
    end
    puts
  end

  def run_single_test(test, category)
    name = test['name']
    commands = test['commands']
    expected = test['expected'] || {}
    setup = test['setup'] || []

    # Build XRPN program as comma-separated commands
    program = build_program(setup, commands, expected)

    # Write to temp file to avoid shell escaping issues
    temp_file = "/tmp/xrpn_test_#{Process.pid}_#{rand(10000)}.txt"
    File.write(temp_file, program)

    # Run xrpn by piping commands and capture output
    output = `cat #{temp_file} | #{@xrpn_bin} 2>&1`
    exit_code = $?.exitstatus

    # Clean up
    File.delete(temp_file) if File.exist?(temp_file)

    # Parse output and validate
    result = validate_output(output, expected, test)

    if result[:passed]
      @passed += 1
      print "  ✓ #{name}"
      puts " (#{category})"
    else
      @failed += 1
      print "  ✗ #{name}"
      puts " (#{category})"
      puts "    Expected: #{result[:expected]}"
      puts "    Got:      #{result[:actual]}"
      puts "    Output:   #{output.strip}" if test['verbose']
    end

  rescue => e
    @errors += 1
    puts "  ✗ #{name} - ERROR: #{e.message}"
  end

  def build_program(setup, commands, expected)
    lines = []

    # Setup phase
    setup.each { |cmd| lines << cmd }

    # Test commands
    commands.each { |cmd| lines << cmd }

    # If testing alpha, move alpha to X register before stdout
    lines << "asto x" if expected['alpha']

    # Output results for validation using stdout
    lines << "stdout"  # Output X to stdout for capture
    lines << "off"     # Exit cleanly

    lines.join(",")  # Join with commas
  end

  def validate_output(output, expected, test)
    result = { passed: true, expected: {}, actual: {} }

    # Check for error conditions
    if test['should_error']
      if output.include?("Error") || output.include?("ERROR") || output.include?("error")
        return result
      else
        result[:passed] = false
        result[:expected] = "Error condition"
        result[:actual] = "No error"
        return result
      end
    end

    # Parse X register from stdout output (just a number on first line)
    if expected['x']
      # Get first line and convert European decimal format to standard
      first_line = output.split("\n").first.to_s.strip
      clean_output = first_line.gsub(',', '.')
      actual_x = clean_output.to_f rescue nil
      expected_x = expected['x'].to_f

      tolerance = expected['tolerance'] || 0.0001
      if actual_x.nil? || (actual_x - expected_x).abs > tolerance
        result[:passed] = false
        result[:expected]['x'] = expected_x
        result[:actual]['x'] = actual_x
      end
    end

    # Parse Alpha register from stdout output (string on first line)
    if expected['alpha']
      first_line = output.split("\n").first.to_s.strip
      actual_alpha = first_line
      expected_alpha = expected['alpha']

      if actual_alpha != expected_alpha
        result[:passed] = false
        result[:expected]['alpha'] = expected_alpha
        result[:actual]['alpha'] = actual_alpha
      end
    end

    # Parse string in X register (for commands like dechex that put strings in X)
    if expected['x_string']
      first_line = output.split("\n").first.to_s.strip
      actual_string = first_line
      expected_string = expected['x_string']

      if actual_string != expected_string
        result[:passed] = false
        result[:expected]['x_string'] = expected_string
        result[:actual]['x_string'] = actual_string
      end
    end

    # Check for specific output patterns
    if expected['contains']
      unless output.include?(expected['contains'])
        result[:passed] = false
        result[:expected]['output'] = "Contains '#{expected['contains']}'"
        result[:actual]['output'] = "Not found"
      end
    end

    result
  end

  def print_summary
    total = @passed + @failed + @errors

    puts "=" * 60
    puts "Test Results Summary"
    puts "=" * 60
    puts "Total tests:  #{total}"
    puts "Passed:       #{@passed} ✓"
    puts "Failed:       #{@failed} ✗" if @failed > 0
    puts "Errors:       #{@errors} ✗" if @errors > 0
    puts

    if @failed == 0 && @errors == 0
      puts "SUCCESS: All tests passed!"
      exit 0
    else
      puts "FAILURE: #{@failed + @errors} test(s) failed"
      exit 1
    end
  end
end

# Run tests
if __FILE__ == $0
  runner = XRPNTestRunner.new

  if ARGV[0]
    runner.run_test_file(ARGV[0])
    runner.print_summary
  else
    runner.run_all_tests
  end
end
