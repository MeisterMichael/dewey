# CLAUDE.md - Dewey Engine

## Purpose

Dewey is a course management engine providing courses with cohort-based enrollment, time-release content scheduling, sequential/non-sequential content flow, and integration with the Pulitzer CMS engine for course page content. Supports physical and digital course types with on-demand or scheduled start dates.

**Version:** 3.0.2

## Key Models

### Dewey::Course

The central model. Includes `CourseConcern`.

**Enums:**
- `status`: `trash: -100`, `not_available: -50`, `wait_listed: -1`, `draft: 0`, `active: 1`
- `availability`: `anyone: 1`, `enrolled: 2`, `invite_only: 3`, `authorized_users: 100`
- `course_type`: `physical: 1`, `digital: 2`
- `course_content_schedule`: `binged_course_content: 1`, `time_released_course_content: 2`
- `course_content_flow`: `sequential_course_content: 1`, `non_sequential_course_content: 2`
- `start_schedule`: `on_demand_start: 1`, `scheduled_start: 2`

**Associations:**
- `belongs_to :course_page` (optional, Dewey::CoursePage) - main landing page
- `belongs_to :completed_course_page` (optional, Dewey::CoursePage) - completion page
- `belongs_to :instructor` (optional, User)
- `has_many :course_cohorts`
- `has_many :enrollments, through: :course_cohorts`
- `has_many :users, through: :enrollments`

**Features:** FriendlyId slugs with history, ActiveStorage attachments (avatar, cover, embedded, other), duration tracking with `duration_humanize`, `published` scope, `page_meta` for SEO.

### Dewey::CourseCohort

Enrollment window/group within a course.

- `belongs_to :course`, `belongs_to :instructor` (optional), `has_many :enrollments`
- Key attributes: starts_at, ends_at, enrollment_starts_at, enrollment_ends_at
- Scopes: `open_ended_enrollment`, `open_for_enrollment`
- Methods: `open_ended_enrollment?`, `open_for_enrollment?`

### Dewey::Enrollment

User's enrollment in a specific cohort. Includes `EnrollmentConcern`.

- `belongs_to :user`, `belongs_to :course_cohort`, `has_many :enrollment_course_contents`
- `before_create :set_started_at` (on-demand uses Time.now, scheduled uses cohort's start_at)
- Delegates `course` through course_cohort

### Dewey::CoursePage

Extends `Pulitzer::Media` (STI). Includes `CoursePageConcern`.

- `after_create :add_content_section` - creates default content section
- `before_create :set_default_values` - sets availability to authorized_users
- Custom `course` method traverses parent hierarchy to find owning course

### Dewey::EnrollmentCoursePage

- `enum status`: `started: 1`, `completed: 100`

## Controllers

### Public

- **`CoursesController`** - Lists published courses (`index`), shows individual course with open cohorts (`show`)
- **`EnrollmentsController`** - `new` (select cohort), `create` (enroll), `index` (list user enrollments), `show` (enrollment detail with course pages). Requires authentication except `new`.
- **`CoursePagesController`** - Renders course page content via `pulitzer_render` with prev/next navigation

### Admin

- **`CourseAdminController`** - Full CRUD. Creates courses with auto-generated course_page and completed_course_page. Supports filtering, sorting, preview, empty_trash.
- **`CoursePageAdminController`** - CRUD for course pages with Pulitzer content editing
- **`CourseCohortAdminController`** - CRUD for cohorts

## Configuration

```ruby
Dewey.configure do |config|
  config.courses_path = '/courses'        # default
  config.enrollments_path = '/myclasses'  # default
end
```

## Dependencies

- `rails` >= 5.2.0
- `acts-as-taggable-array-on` - Array-based tagging
- `devise` - Authentication
- `friendly_id` >= 5.1.0 - URL slugs with history

## Integration

- **Pulitzer** - CoursePage inherits from `Pulitzer::Media`; uses content sections, templates, layouts, nested page hierarchies
- **Bunyan** - Event logging via `log_event()` calls (pageview, enrolled events)
