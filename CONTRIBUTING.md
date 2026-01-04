# Contributing to EthioExitExam

Thank you for your interest in contributing to EthioExitExam! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear title and description
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Device/platform information

### Suggesting Features

Feature requests are welcome! Please:
- Check existing issues first
- Provide clear use case
- Explain expected behavior
- Consider implementation complexity

### Code Contributions

1. **Fork the repository**
   ```bash
   git fork https://github.com/petmsyh/exit-exam.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Add comments for complex logic
   - Update documentation if needed

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add: brief description of changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Describe what you changed and why
   - Reference related issues
   - Include screenshots for UI changes

## Code Style

### Dart/Flutter

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Use const constructors where possible
- Prefer single quotes for strings
- Use meaningful variable names

Example:
```dart
// Good
const Text('Hello World')
final userName = 'John Doe';

// Avoid
Text("Hello World")
final un = 'John Doe';
```

### Project Structure

- Models in `lib/models/`
- Screens in `lib/screens/`
- Services in `lib/services/`
- Widgets in `lib/widgets/`
- Utils in `lib/utils/`

### Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Private members: `_leadingUnderscore`

## Testing

### Writing Tests

- Add unit tests for new models
- Add widget tests for new screens
- Test edge cases and error handling

Example:
```dart
test('UserModel fromFirestore creates valid user', () {
  final doc = mockDocumentSnapshot();
  final user = UserModel.fromFirestore(doc);
  expect(user.name, 'John Doe');
});
```

### Running Tests

```bash
# All tests
flutter test

# Specific test
flutter test test/models/user_model_test.dart
```

## Documentation

### Code Documentation

- Add dartdoc comments for public APIs
- Explain complex algorithms
- Document parameters and return values

Example:
```dart
/// Creates a new course in the database.
///
/// [departmentId] must be a valid department reference.
/// [name] is the course display name.
/// [description] provides course details.
///
/// Returns the created course ID.
Future<String> createCourse({
  required String departmentId,
  required String name,
  required String description,
}) async { ... }
```

### User Documentation

- Update README.md for major changes
- Add setup steps to SETUP.md
- Document new features clearly

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
Add: Feature description
Fix: Bug description  
Update: What was updated
Remove: What was removed
Refactor: Code improvement
Docs: Documentation changes
Test: Test additions/changes
```

Examples:
```
Add: Student progress tracking feature
Fix: Department dropdown not loading on registration
Update: Firebase security rules for better performance
Docs: Add troubleshooting section to SETUP.md
```

## Pull Request Process

1. Update documentation
2. Add tests for new features
3. Ensure all tests pass
4. Update CHANGELOG.md
5. Request review from maintainers

### PR Checklist

- [ ] Code follows project style
- [ ] Tests added and passing
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Commits are clear and descriptive

## Review Process

- PRs are reviewed by maintainers
- Address feedback promptly
- Be open to suggestions
- Maintain respectful communication

## Getting Help

- Check [SETUP.md](SETUP.md) for setup issues
- Review [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for architecture
- Ask questions in GitHub Discussions
- Tag maintainers for urgent issues

## Areas That Need Help

- [ ] iOS support
- [ ] Unit tests
- [ ] Widget tests
- [ ] Offline mode
- [ ] Amharic localization
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Admin web dashboard

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for everyone.

### Expected Behavior

- Be respectful and considerate
- Accept constructive criticism
- Focus on what's best for the project
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Public or private harassment
- Publishing others' private information

### Enforcement

Violations may result in:
- Warning
- Temporary ban
- Permanent ban

Report issues to project maintainers.

## Recognition

Contributors will be:
- Listed in README.md
- Credited in release notes
- Given acknowledgment in documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to:
- Open an issue
- Start a discussion
- Contact maintainers

Thank you for contributing! 🙏
