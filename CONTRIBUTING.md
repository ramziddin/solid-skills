# Contributing to Solid Skills

Thank you for your interest in contributing to Solid Skills! This document provides guidelines and instructions for contributing.

## How to Contribute

### Reporting Issues

If you find a bug, have a suggestion, or want to request a feature:

1. Check if the issue already exists in the [Issues](https://github.com/ramziddin/solid-skills/issues) section
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Any relevant context

### Submitting Pull Requests

1. **Fork the repository** and clone your fork
2. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the project's coding standards
4. **Test your changes** to ensure they work correctly
5. **Commit your changes** with clear, descriptive commit messages:
   ```bash
   git commit -m "Add: description of your change"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request** on GitHub with:
   - Clear title and description
   - Reference any related issues
   - Explain what changes you made and why

## Contribution Guidelines

### Code Quality Standards

This project follows SOLID principles, TDD, and clean code practices. When contributing:

- **Write tests first** (TDD approach)
- **Follow SOLID principles** in all code
- **Keep functions small** (< 10 lines when possible)
- **Keep classes focused** (< 50 lines when possible)
- **Use meaningful names** that express intent
- **Avoid code smells** (see `skills/solid/references/code-smells.md`)

### Documentation Standards

- Use clear, concise language
- Provide examples when adding new concepts
- Keep documentation up-to-date with code changes
- Follow the existing documentation structure

### Skill Format

Skills follow the [Agent Skills](https://github.com/anthropics/agent-skills) format:

- Each skill has a `SKILL.md` file with frontmatter metadata
- Reference documentation goes in `references/` subdirectory
- Use clear headings and structure
- Include practical examples

### Commit Message Format

Use clear, descriptive commit messages:

- **Add:** for new features
- **Fix:** for bug fixes
- **Update:** for improvements to existing features
- **Refactor:** for code refactoring
- **Docs:** for documentation changes

Example:
```
Add: CONTRIBUTING.md with contribution guidelines
```

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/ramziddin/solid-skills.git
   cd solid-skills
   ```

2. Set up upstream remote:
   ```bash
   git remote add upstream https://github.com/ramziddin/solid-skills.git
   ```

3. Create your feature branch and start contributing!

## Questions?

If you have questions about contributing, feel free to:
- Open an issue with the `question` label
- Check existing issues and discussions

Thank you for contributing to Solid Skills! 🎉
