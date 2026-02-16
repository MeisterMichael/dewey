# Dewey

A Rails engine for online course management with cohort-based enrollment, time-release content, and CMS integration.

See [CLAUDE.md](CLAUDE.md) for detailed architecture documentation.

## Features

- Course creation with configurable content scheduling (binge or time-released)
- Sequential and non-sequential content flow options
- Cohort-based enrollment with configurable enrollment windows
- On-demand or scheduled course start dates
- Physical and digital course types
- Course page management built on Pulitzer CMS
- FriendlyId slugs with history for SEO-friendly URLs
- ActiveStorage attachments (avatar, cover, embedded, other)
- Duration tracking with humanized display
- Instructor assignment at course and cohort level

## Models

| Model | Description |
|-------|-------------|
| `Course` | Core course model with enums for status, availability, type, content schedule, content flow, start schedule |
| `CourseCohort` | Enrollment windows with start/end dates and enrollment open/close dates |
| `Enrollment` | User enrollment in a specific cohort, tracking start, completion, and score |
| `CoursePage` | Course content pages, extends `Pulitzer::Media` via STI |
| `EnrollmentCoursePage` | Tracks individual page progress (started/completed) |

## Configuration

```ruby
Dewey.configure do |config|
  config.courses_path = '/courses'
  config.enrollments_path = '/myclasses'
end
```

## Dependencies

- `rails` >= 5.2.0
- `acts-as-taggable-array-on` - Array-based tagging
- `devise` - Authentication
- `friendly_id` >= 5.1.0 - URL slugs with history

## Integration

- **Pulitzer** - CoursePage inherits from `Pulitzer::Media`, providing content sections, templates, layouts, and nested page hierarchies
- **Bunyan** - Event logging for pageview and enrollment tracking

## License

MIT
