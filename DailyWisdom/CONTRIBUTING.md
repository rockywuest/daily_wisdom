# Contributing to DailyWisdom

Thank you for your interest in contributing to DailyWisdom! This document provides guidelines and information for contributors.

## Ways to Contribute

### 1. Report Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Your macOS version
- Screenshots if applicable

### 2. Suggest Features

Feature requests are welcome! Please open an issue describing:
- The problem you're trying to solve
- Your proposed solution
- Any alternatives you've considered

### 3. Submit Quotes

We're always looking for high-quality quotes to add to the collection. When submitting quotes:

**Requirements:**
- Quote must be accurately attributed
- Quote must be correctly worded (verify against reliable sources)
- Quote should fit one of our 8 categories
- No duplicates of existing quotes

**Format:**
```json
{
  "id": "unique-id",
  "text": "The quote text exactly as spoken or written.",
  "author": "Full Name",
  "category": "category-name"
}
```

**Categories:**
- `mental-model` – Cognitive frameworks and thinking tools
- `stoicism` – Ancient Stoic philosophy
- `leadership` – Leading teams and organizations
- `focus` – Concentration and prioritization
- `growth` – Learning and self-improvement
- `strategy` – Long-term planning and positioning
- `business` – Entrepreneurship and value creation
- `wisdom` – Timeless universal truths

### 4. Improve Code

Pull requests for bug fixes and improvements are welcome!

**Before starting:**
1. Check existing issues and PRs to avoid duplicate work
2. For significant changes, open an issue first to discuss

**Development setup:**
1. Fork the repository
2. Clone your fork
3. Open `DailyWisdom.xcodeproj` in Xcode 15+
4. Build and run (⌘R)

**Code style:**
- Follow existing code patterns
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small

## Pull Request Process

1. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** with clear, atomic commits

3. **Test thoroughly:**
   - Build succeeds without warnings
   - App functions correctly
   - No regressions in existing features

4. **Update documentation** if needed:
   - README.md for new features
   - CHANGELOG.md for notable changes
   - Code comments for complex logic

5. **Submit your PR:**
   - Clear title describing the change
   - Description of what and why
   - Reference any related issues

6. **Respond to feedback** and make requested changes

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Assume good intentions
- Help others learn and grow

## Questions?

Open an issue or start a discussion on GitHub. We're happy to help!

---

Thank you for helping make DailyWisdom better!
