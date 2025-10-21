# XRPN Regression Test Framework

Comprehensive automated testing suite for XRPN to prevent regressions and ensure all commands work correctly.

## Quick Start

Run all tests:
```bash
ruby tests/run_tests.rb
```

Run specific test category:
```bash
ruby tests/run_tests.rb tests/specs/01_basic_arithmetic.yml
```

## Test Framework Architecture

### Components

**run_tests.rb** - Main test runner
- Orchestrates test execution
- Parses YAML test specifications
- Validates outputs
- Reports results

**specs/** - Test specification directory
- YAML files defining test cases
- Organized by command category
- Easy to read and extend

### Test Specification Format

Tests are defined in YAML files in `specs/` directory:

```yaml
---
- name: "Addition: 5 + 3 = 8"
  commands:
    - "5"
    - "3"
    - "+"
  expected:
    x: 8

- name: "With setup"
  setup:
    - "deg"      # Setup commands run first
  commands:
    - "30"
    - "sin"
  expected:
    x: 0.5
```

### Test Fields

**name** (required) - Descriptive test name

**commands** (required) - Array of XRPN commands to execute

**setup** (optional) - Array of commands to run before test

**expected** (required) - Expected results
- `x`: Expected X register value (number)
- `tolerance`: Acceptable error margin (default: 0.0001)
- `contains`: String that should appear in output

**should_error** (optional) - Set to `true` if test should produce error

### Example Tests

Basic arithmetic:
```yaml
- name: "Square root: sqrt(144) = 12"
  commands:
    - "144"
    - "sqrt"
  expected:
    x: 12
```

With setup:
```yaml
- name: "sin(30°) = 0.5"
  setup:
    - "deg"
  commands:
    - "30"
    - "sin"
  expected:
    x: 0.5
```

With tolerance:
```yaml
- name: "Pi approximation"
  commands:
    - "pi"
  expected:
    x: 3.14159
    tolerance: 0.00001
```

Error handling:
```yaml
- name: "Statistics with empty registers"
  setup:
    - "clrg"
  commands:
    - "mean"
  should_error: true
```

## Test Categories

Current test suites:

1. **01_basic_arithmetic.yml** - Math operations (+, -, *, /, sqrt, pow, etc.)
2. **02_stack_operations.yml** - Stack manipulation (enter, swap, drop, etc.)
3. **03_trigonometry.yml** - Trig functions (sin, cos, tan, etc.)
4. **04_logarithms.yml** - Log and exponential functions
5. **05_registers.yml** - Register operations (sto, rcl, indirect, etc.)
6. **06_alpha.yml** - Alpha register and string operations
7. **07_statistics.yml** - Statistical functions (mean, sdev, Σ+, etc.)
8. **08_conditionals.yml** - Conditional tests (x=0?, x>y?, etc.)
9. **09_base_conversion.yml** - Number base conversions
10. **10_flags.yml** - Flag operations (sf, cf, fs?, fc?)

## Adding New Tests

### Create New Test Category

1. Create new YAML file in `tests/specs/`:
```bash
vi tests/specs/11_my_category.yml
```

2. Add test cases:
```yaml
---
# My Category Tests
- name: "My first test"
  commands:
    - "cmd1"
    - "cmd2"
  expected:
    x: 42
```

3. Run tests:
```bash
ruby tests/run_tests.rb
```

### Add Test to Existing Category

Edit the appropriate YAML file in `tests/specs/` and add your test case following the format above.

## How It Works

1. **Test Execution**
   - Reads YAML test specifications
   - Builds command strings with setup + commands + stdout + off
   - Pipes commands to xrpn: `echo "cmd1,cmd2,stdout,off" | xrpn`
   - Captures first line of output (the stdout result)

2. **Validation**
   - Parses numeric output from stdout
   - Compares against expected value within tolerance
   - Reports pass/fail for each test

3. **Output**
   - Clear pass (✓) / fail (✗) indicators
   - Expected vs actual values for failures
   - Summary with total/passed/failed counts

## Best Practices

### Test Naming
- Be descriptive: "sin(30°) = 0.5" not "test sin"
- Include operation and expected result
- Use standard math notation

### Test Organization
- Group related commands in same file
- Use setup for common initialization
- One test per specific behavior

### Tolerances
- Default 0.0001 works for most cases
- Increase for transcendental functions: `tolerance: 0.00001`
- Use exact match for integers (default tolerance fine)

### Edge Cases
- Test boundary conditions
- Test error handling with `should_error: true`
- Test indirect addressing
- Test register overflow/underflow

## Extending the Framework

### Custom Validators

Edit `run_tests.rb` to add custom validation logic:

```ruby
def validate_output(output, expected, test)
  # Add custom validation here
end
```

### Output Formats

Currently validates X register via stdout.
Future: Add alpha, register, flag validation.

### Continuous Integration

Add to CI pipeline:
```bash
#!/bin/bash
cd xrpn
ruby tests/run_tests.rb
exit $?
```

## Troubleshooting

**Tests hang/timeout:**
- Ensure all test programs include implicit "off" (added automatically)
- Check for infinite loops in test commands

**Numeric comparison failures:**
- Increase tolerance if needed
- Check European vs US decimal format (handled automatically)

**Command not found:**
- Verify command exists in `/xcmd/` or `/xlib/`
- Check command spelling in YAML

## Contributing Tests

When adding new XRPN features:

1. Write tests FIRST (TDD approach)
2. Run tests to see them fail
3. Implement feature
4. Run tests to see them pass
5. Commit both feature and tests together

This ensures:
- Features work as intended
- Future changes don't break existing functionality
- Documentation via executable examples

## License

Same as XRPN - Public Domain (Unlicense)
