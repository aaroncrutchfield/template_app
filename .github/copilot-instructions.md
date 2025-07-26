# Consolidated Coding Assistant Instructions

This document consolidates all individual instruction files into a single reference for the coding assistant.

## Table of Contents
1. [Very Good Engineering Philosophy](#very-good-engineering-philosophy)
2. [Very Good Architecture Principles](#very-good-architecture-principles)
3. [Barrel Files Guidelines](#barrel-files-guidelines)
4. [State Handling Guidelines](#state-handling-guidelines)
5. [Bloc Event Transformers Guidelines](#bloc-event-transformers-guidelines)
6. [Testing Guidelines](#testing-guidelines)
7. [Widgetbook Use-Case Generation Instructions](#widgetbook-use-case-generation-instructions)
8. [Package README Format Guidelines](#-package-readme-format-guidelines)

---
# Very Good Engineering Philosophy

## Overview
Very Good Ventures has consolidated popular coding practices into "Very Good Architecture," an opinionated approach that enables "ship fast and ship safe" development practices.

## Core Qualities
A good software architecture should be:
- 💪 **Consistent**: Strong opinions on complex problems (state management, testing, etc.)
- 🧘‍♀️ **Flexible**: Easy to refactor or replace features
- 🤓 **Approachable**: Enables rapid onboarding for all developers
- 🧪 **Testable**: Supports automated testing and 100% code coverage
- 🏎️ **Performant**: Executes quickly by default
- 📱 **Multiplatform**: Works across all platforms

## Key Principles

### 🏁 Building for Success
- Focus on making individual development steps as simple as possible
- Break down complex tasks into manageable pieces
- Prioritize engineering process improvements

### 🍰 Layered Architecture
- Three main layers: presentation, business logic, and data
- Clear architectural boundaries
- Reduced cognitive load through separation of concerns
- Enables individual layer testing

### 🤖 Keep It Simple — for the Humans
- Create minimal, readable code that models the problem space correctly
- Balance between code quantity, readability, and correctness
- Leverage:
  - Declarative code
  - Thoughtful naming
  - Object-oriented design patterns
  - Tests

### 📜 Declarative Programming
- Focus on declaring what the code should be, not how it should happen
- Prefer declarative over imperative approaches
- Example:
  ```dart
  // Declarative (preferred)
  return Visualizer(
    children: [
      VisualElement(),
    ],
  );

  // Imperative (avoid)
  final visualizer = Visualizer();
  final text = VisualElement();
  visualizer.add(text);
  return visualizer;
  ```

### 🧨 Reactive Programming
- Use cautiously, primarily at repository layer
- Focus on data transformation plumbing
- Avoid complex data transformations
- Be mindful of unintended coupling
- Treat reactive programming like glue - powerful but can be messy if not careful

### 💪 Consistency
- Strong opinions on:
  - Tests
  - Dependency injection
  - State management
  - Business logic organization
- Familiar structure across projects
- Reduced learning curve for developers

### 🧘‍♀️ Flexibility
- Support rapid requirement changes
- Enable quick refactoring
- Maintain high code quality
- Create consistent patterns between features

### 🤓 Approachability
- Accept some boilerplate for clarity
- Prioritize code understanding
- Enable quick refactoring
- Support efficient developer onboarding

### 🏎️ Performance
- Leverage machine code compilation where possible
- Mindful of algorithmic complexity
- Careful selection of third-party libraries
- Informed decisions based on extensive experience

### 📱 Multiplatform
- Maintain single high-quality codebase
- Leverage Flutter for cross-platform development
- Benefits:
  - Single codebase for iOS, Android, Web, Linux, macOS, Windows
  - Mature ecosystem with 45,000+ packages
  - Excellent developer experience
  - Hot reload and extensive widget library

## Best Practices
1. Write declarative code that clearly expresses intent
2. Maintain clear architectural boundaries
3. Prioritize code readability and maintainability
4. Focus on testability and test coverage
5. Keep implementation details hidden
6. Use reactive programming judiciously
7. Maintain consistent patterns across the codebase
8. Consider performance implications
9. Leverage cross-platform capabilities

## File Pattern
*.dart 

---
# Very Good Architecture Principles

## Overview
This rule file implements Very Good Ventures' layered architecture principles, which create highly scalable, maintainable, and testable applications. The architecture consists of four distinct layers with clear responsibilities and boundaries between them.

## Layered Architecture

### Data Layer
- **Purpose**: Retrieve raw data from external sources (APIs, databases, local storage, etc.)
- **Responsibility**: Fetch data without applying domain-specific logic
- **Guidelines**:
  - Should be free of any business logic
  - Implementations should be reusable across different projects
  - Data clients should focus on a single data source
  - Often encapsulated within specialized handlers or services

### Repository Layer
- **Purpose**: Compose data clients and apply business rules to the data
- **Responsibility**: Fetch data from one or more data sources, apply domain-specific logic
- **Guidelines**:
  - Create separate repositories for each domain (UserRepository, WeatherRepository, etc.)
  - Should not import Flutter dependencies
  - Should not depend on other repositories
  - Considered the "product" layer where business rules are enforced
  - Use interface-based design with abstract classes defining the contract
  - Implement concrete repositories (e.g., OfflineFirstRepository) that follow the interface
  - Throw specific, well-documented exceptions for error cases

### Domain Layer
- **Purpose**: Define core business models, utilities, and interfaces
- **Responsibility**: Provide foundation for business logic implementation
- **Guidelines**:
  - Contain pure Dart code with no framework dependencies
  - Define data models, enums, and value objects
  - Include utility classes that encapsulate specific functionality
  - Define interfaces for services that may have multiple implementations
  - Keep code in this layer highly reusable and well-tested

### Business Logic Layer
- **Purpose**: Implement feature-specific logic using repositories
- **Responsibility**: Implement the bloc pattern to manage state for features
- **Guidelines**:
  - No dependencies on Flutter SDK
  - No direct dependencies on other business logic components
  - Retrieve data from repositories and provide state to the presentation layer
  - Considered the "feature" layer that implements specific functionality
  - Example: `onboarding_bloc.dart`, `onboarding_event.dart`, `onboarding_state.dart`

### Presentation Layer
- **Purpose**: Display UI elements and handle user interactions
- **Responsibility**: Build widgets and manage their lifecycle
- **Guidelines**:
  - No business logic should exist in this layer
  - Only interact with the business logic layer
  - Considered the "design" layer focused on user experience
  - Example: `onboarding_page.dart`, `onboarding_controls.dart`, `onboarding_progress.dart`

## Project Organization

The recommended folder structure is:

```
my_app/
├── lib/
│   └── feature_name/              # e.g., onboarding/
│       ├── bloc/                  # Business logic components
│       │   ├── onboarding_bloc.dart
│       │   ├── onboarding_event.dart
│       │   └── onboarding_state.dart
│       ├── models/                # Feature-specific data models
│       │   ├── models.dart        # Barrel file
│       │   └── onboarding_info.dart
│       ├── view/                  # Main feature screens
│       │   ├── onboarding_page.dart
│       │   └── view.dart
│       └── widgets/               # Reusable UI components
│           ├── widgets.dart       # Barrel file
│           ├── onboarding_controls.dart
│           └── onboarding_progress.dart
├── packages/
│   ├── user_repository/           # Repository package example
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── domain/        # Domain-specific utilities and interfaces
│   │   │   │   │   ├── domain.dart
│   │   │   │   │   └── file_handler.dart
│   │   │   │   ├── model/         # Data models and exceptions
│   │   │   │   │   ├── models.dart
│   │   │   │   │   └── exception.dart
│   │   │   │   ├── user_repository.dart        # Interface definition
│   │   │   │   └── offline_first_user_repository.dart  # Implementation
│   │   │   └── user_repository.dart  # Main barrel file exposing public API
│   │   └── test/
│   │       ├── src/
│   │       │   └── user_repository_test.dart
│   │       └── user_repository_test.dart
│   ├── api_client/                # API client package example
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   └── api_client.dart
│   │   │   └── api_client.dart
│   │   └── test/
│   │       └── api_client_test.dart
│   ├── analytics_service/         # Service package example
│       ├── lib/
│       │   ├── src/
│       │   │   ├── domain/
│       │   │   ├── model/
│       │   │   ├── analytics_service.dart       # Interface definition
│       │   │   └── firebase_analytics_service.dart  # Implementation
│       │   └── analytics_service.dart
│       └── test/
└── test/
    └── feature_name/
        ├── bloc/
        ├── models/
        ├── view/
        └── widgets/
```

Key Structure Guidelines:
- Presentation layer and business logic reside in the project's `lib` directory
- Data layer, repository layer, and other service layers are separate packages in the `packages` directory
- Feature-specific code is organized in dedicated directories
- Models directory contains feature-specific data structures and transformations
- Widgets directory contains reusable UI components specific to the feature
- Tests mirror the structure of implementation code

## Local Package Organization

The layered architecture principles apply to all local packages, not just repositories. Each package should have a clear responsibility and follow the same structural patterns.

A typical local package should follow this structure:

```
package_name/
├── lib/
│   ├── package_name.dart          # Main barrel file exposing public API
│   └── src/
│       ├── domain/                # Domain-specific utilities and interfaces
│       │   ├── domain.dart        # Barrel file for domain exports
│       │   └── utility_classes.dart # Utilities like handlers or services
│       ├── model/                 # Data models and exceptions
│       │   ├── model.dart         # Barrel file for model exports
│       │   ├── entities.dart      # Data entities
│       │   └── exceptions.dart    # Custom exceptions
│       ├── package_interface.dart # Interface definition
│       └── implementation.dart    # Concrete implementation
```

### Interface-Based Design Pattern

This pattern applies to all types of packages, including services, utilities, and data sources:

```dart
/// Abstract interface class defining the contract
abstract interface class ServiceName {
  /// Factory constructor that returns the default implementation
  factory ServiceName(
    Dependencies dependencies,
  ) = DefaultImplementation;

  /// Method signature with clear documentation
  Future<ReturnType> methodName(Parameters parameters);
}

/// Concrete implementation of the interface
class DefaultImplementation implements ServiceName {
  const DefaultImplementation(this._dependencies);
  
  final Dependencies _dependencies;
  
  @override
  Future<ReturnType> methodName(Parameters parameters) async {
    // Implementation details
  }
}
```

### Common Package Types

1. **Repository Packages**: Manage data from multiple sources with domain-specific rules
2. **API Client Packages**: Handle communication with specific external APIs
3. **Service Packages**: Provide specific functionality like analytics, logging, or authentication
4. **Utility Packages**: Offer shared utilities across the application
5. **Feature Packages**: Encapsulate complete features that can be shared across applications

## Layer Responsibilities

- **lib/**: Contains the presentation layer and business logic layer
  - **bloc/**: Feature-specific business logic components
    - Example: `onboarding_bloc.dart`, `onboarding_event.dart`, `onboarding_state.dart`
  - **models/**: Feature-specific data models and transformations
    - Example: `onboarding_info.dart`
  - **view/**: Main feature pages and views
    - Example: `onboarding_page.dart`
  - **widgets/**: Reusable UI components for the feature
    - Example: `onboarding_controls.dart`, `onboarding_progress.dart`, `page_content.dart`
- **packages/**: Contains domain, data, repository, and service layers as separate packages
  - **domain/**: Core business models and utilities
  - **model/**: Data structures, entities, and exceptions
  - **interface.dart**: Contract for implementations
  - **implementation.dart**: Specific implementation of the interface
- **test/**: Contains tests for all components

## Feature Example: Onboarding

A typical feature like onboarding would include:

1. **Business Logic (bloc/)**
   - `onboarding_bloc.dart`: Manages the state of the onboarding process
   - `onboarding_event.dart`: Defines events like next page, skip, complete
   - `onboarding_state.dart`: Defines states like in-progress, completed

2. **Models (models/)**
   - `models.dart`: Barrel file exporting all models
   - `onboarding_info.dart`: Contains data structures for onboarding content

3. **View (view/)**
   - `view.dart`: Barrel file exporting all views
   - `onboarding_page.dart`: Main page that orchestrates the onboarding flow

4. **Widgets (widgets/)**
   - `widgets.dart`: Barrel file exporting all widgets
   - `onboarding_controls.dart`: Navigation buttons (next, back, skip)
   - `onboarding_progress.dart`: Indicators showing progress through onboarding
   - `page_content.dart`: Content displayed on each onboarding page

## Data Flow and Dependencies
- Data should only flow upward through the layers
- Each layer can only access the layer directly beneath it
- Implementation details should not leak between layers
- Examples of proper dependencies:
  - Presentation layer (UI) → Business Logic layer (BLoC)
  - Business Logic layer (BLoC) → Repository/Service layers
  - Repository/Service layers → Domain layer and Data layer

## Exception Handling

Packages should define and throw specific exception classes:

```dart
/// Base exception class for all package exceptions
abstract class PackageException implements Exception {
  const PackageException(this.error, this.stackTrace);
  
  final Object error;
  final StackTrace stackTrace;
  
  @override
  String toString() => '$runtimeType: $error';
}

/// Specific exception for a particular error case
class SpecificErrorException extends PackageException {
  const SpecificErrorException(super.error, super.stackTrace);
}
```

## Internationalization (l10n)

### Overview
Internationalization (l10n) enables applications to adapt to different languages and regions. Flutter provides robust tools for internationalizing applications through the `flutter_localizations` package and `intl` package.

### Structure
The recommended structure for internationalization files:

```
my_app/
├── l10n/
│   ├── arb/
│   │   ├── app_en.arb          # English translations
│   │   ├── app_es.arb          # Spanish translations
│   │   └── app_fr.arb          # French translations
│   └── l10n.yaml               # Internationalization config
├── lib/
│   ├── l10n/
│   │   ├── l10n.dart           # Exports extension methods and delegates
│   │   └── generated/          # Generated localization files
│   │       ├── app_localizations.dart
│   │       └── app_localizations_en.dart
```

### Configuration
The `l10n.yaml` file in the project root configures the generation of localization files:

```yaml
arb-dir: l10n/arb
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

### Implementation Guidelines

1. **Translation Files**
   - Use ARB (Application Resource Bundle) files for translations
   - Name files with language code (e.g., `app_en.arb`, `app_fr.arb`)
   - Include all strings that will be displayed to users

2. **Example ARB File (app_en.arb)**
   ```json
   {
     "@@locale": "en",
     "appTitle": "My Application",
     "@appTitle": {
       "description": "The title of the application"
     },
     "welcome": "Welcome {name}",
     "@welcome": {
       "description": "Welcome message on the home screen",
       "placeholders": {
         "name": {
           "type": "String",
           "example": "John"
         }
       }
     }
   }
   ```

3. **Accessing Translations**
   - Access translations through the context:
     ```dart
     // In a widget
     Text(context.l10n.appTitle),
     
     // With parameters
     Text(context.l10n.welcome('John')),
     ```

4. **Extension Methods**
   - Create an extension on `BuildContext` for easier access:
     ```dart
     // In l10n.dart
     extension LocalizationExtension on BuildContext {
       AppLocalizations get l10n => AppLocalizations.of(this);
     }
     ```

5. **Setup in MaterialApp**
   - Configure supported locales and delegates:
     ```dart
     return MaterialApp(
       localizationsDelegates: AppLocalizations.localizationsDelegates,
       supportedLocales: AppLocalizations.supportedLocales,
       // ...
     );
     ```

### Best Practices

1. **String Extraction**
   - Extract all user-facing strings to ARB files
   - Never hardcode strings in the UI
   - Use descriptive keys that indicate string purpose

2. **Placeholders**
   - Use named placeholders for variables in strings
   - Include examples in ARB files for translator context
   
3. **Pluralization**
   - Use ICU syntax for pluralized strings:
     ```json
     "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
     "@itemCount": {
       "description": "The number of items",
       "placeholders": {
         "count": {
           "type": "int",
           "example": "5"
         }
       }
     }
     ```

4. **Testing**
   - Create tests for different locales to verify translations
   - Ensure UI handles different text lengths appropriately
   
5. **Maintenance**
   - Keep translations synchronized across all ARB files
   - Document context for translators to avoid ambiguity
   - Consider using a translation management system for larger projects

---
# Barrel Files Guidelines

## Overview
Barrel files are essential for maintaining clean imports and efficient refactoring in Flutter applications. They help organize and expose public-facing files while keeping implementation details hidden.

## Purpose
- Simplify imports across the application
- Reduce the impact of file name changes during refactoring
- Maintain clean and organized code structure
- Control which files are exposed to the public API

## Package Structure with Barrel Files

```
my_package/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   │   ├── model_1.dart
│   │   │   ├── model_2.dart
│   │   │   └── models.dart        # Barrel file
│   │   ├── widgets/
│   │   │   ├── widget_1.dart
│   │   │   ├── widget_2.dart
│   │   │   └── widgets.dart       # Barrel file
│   │   └── my_package.dart        # Top-level barrel file
├── test/
└── pubspec.yaml
```

## Feature Structure with Barrel Files

```
my_feature/
├── bloc/
│   ├── feature_bloc.dart
│   ├── feature_event.dart
│   └── feature_state.dart
├── view/
│   ├── feature_page.dart
│   ├── feature_view.dart
│   └── view.dart                  # Barrel file
└── my_feature.dart                # Top-level barrel file
```

## Barrel File Guidelines

### General Rules
- Create one barrel file per folder that contains public-facing files
- Include a top-level barrel file for the package/feature
- Only export files that should be accessible to other parts of the application
- Do not export implementation details or internal files

### Barrel File Contents

#### Folder-level barrel file (e.g., `models.dart`):
```dart
export 'model_1.dart';
export 'model_2.dart';
```

#### Top-level barrel file (e.g., `my_package.dart`):
```dart
export 'src/models/models.dart';
export 'src/widgets/widgets.dart';
```

### Special Cases

#### Bloc Files
- Bloc files typically don't need a separate barrel file
- The `feature_bloc.dart` file serves as the barrel file through `part of` directives
- Structure remains:
  ```
  bloc/
  ├── feature_bloc.dart
  ├── feature_event.dart
  └── feature_state.dart
  ```

## Best Practices
1. Only export files that are part of the public API
2. Keep barrel files simple and focused
3. Use barrel files to hide implementation details
4. Maintain consistent naming conventions
5. Consider using VSCode extensions to automate barrel file management

## File Pattern
*.dart 

---
# State Handling Guidelines

## Overview
When working with Blocs/Cubits, there are two main approaches to handling state: using enums with a single state class or using sealed/abstract classes. The choice depends on whether you need to persist previous data when emitting new states.

## Persisting Previous Data

### When to Use
- Forms with step-by-step data updates
- States with independently loaded values
- Need to maintain previous state data

### Implementation with Enum
```dart
enum CreateAccountStatus {
  initial,
  loading,
  success,
  failure,
}

class CreateAccountState extends Equatable {
  const CreateAccountState({
    this.status = CreateAccountStatus.initial,
    this.name,
    this.surname,
    this.email,
  });

  final CreateAccountStatus status;
  final String? name;
  final String? surname;
  final String? email;

  CreateAccountState copyWith({
    CreateAccountStatus? status,
    String? name,
    String? surname,
    String? email,
  }) {
    return CreateAccountState(
      status: status ?? this.status,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }

  bool get isValid => 
      name != null && name!.isNotEmpty &&
      surname != null && surname!.isNotEmpty &&
      email != null && email!.isNotEmpty;
}
```

### Usage in Cubit
```dart
class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit(): super(const CreateAccountState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }
}
```

## Fresh States (No Data Persistence)

### When to Use
- Data fetching operations
- One-time state transitions
- No need to maintain previous state data

### Implementation with Sealed Classes (Flutter 3.13+)
```dart
sealed class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess(this.profile);
  final Profile profile;
}

class ProfileFailure extends ProfileState {
  ProfileFailure(this.errorMessage);
  final String errorMessage;
}
```

### Implementation with Abstract Classes (Pre-Flutter 3.13)
```dart
abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess(this.profile);
  final Profile profile;
}

class ProfileFailure extends ProfileState {
  ProfileFailure(this.errorMessage);
  final String errorMessage;
}
```

## Shared Properties Across States

### Implementation
```dart
sealed class ProfileState {
  // Shared properties go here
}

class ProfileSuccess extends ProfileState {
  ProfileSuccess(this.profile);
  final Profile profile;
}

class ProfileEditing extends ProfileState {
  ProfileEditing(this.profile);
  final Profile profile;
}
```

### Usage in Switch Statements
```dart
switch (state) {
  case ProfileSuccess(profile: final prof):
  case ProfileEditing(profile: final prof):
    // Handle both states that have profile
    break;
  case ProfileLoading():
  case ProfileFailure():
    // Handle other states
    break;
}
```

## Best Practices

### Using Enum States
1. Create a status enum for different state conditions
2. Use a single state class with nullable properties
3. Implement copyWith for state updates
4. Add validation getters as needed

### Using Sealed/Abstract Classes
1. Create separate classes for each state
2. Keep state-specific data isolated
3. Use pattern matching for state handling
4. Share common properties through parent class
5. Do not use freezed files for states

### State Consumption Guidelines
1. Use BlocBuilder for UI updates
2. Leverage switch statements for state handling
3. Use pattern matching with sealed classes
4. Handle all possible states

## Common Pitfalls
1. Mixing state management approaches
2. Not handling all possible states
3. Losing important data during state transitions
4. Over-complicating state structure

## File Pattern
*.dart 

---
# Bloc Event Transformers Guidelines

## Overview
Since Bloc v.7.2.0, events are handled concurrently by default. Event transformers help control how events are processed and prevent issues like race conditions and performance degradation.

## Event Transformer Registration

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyState()) {
    on<MyEvent>(
      _onEvent,
      transformer: mySequentialTransformer(),
    )
    on<MySecondEvent>(
      _onSecondEvent,
      transformer: mySequentialTransformer(),
    )
  }
}
```

Note: Event transformers are only applied within the bucket they are specified in. Events of different types are processed concurrently.

## Available Transformers

### Concurrent (Default)
- Events are handled simultaneously
- No guarantees regarding order of completion
- Best for independent operations

### Sequential
- Events are handled one at a time
- First in, first out order
- Best for operations that depend on previous state
- Example:
  ```dart
  class MoneyBloc extends Bloc<MoneyEvent, MoneyState> {
    MoneyBloc() : super(MoneyState()) {
      on<ChangeBalance>(
        _onChangeBalance,
        transformer: sequential(),
      )
    }
  }
  ```

### Droppable
- Discards events received while processing
- Best for preventing duplicate operations
- Example:
  ```dart
  class SayHiBloc extends Bloc<SayHiEvent, SayHiState> {
    SayHiBloc() : super(SayHiState()) {
      on<SayHello>(
        _onSayHello,
        transformer: droppable(),
      )
    }
  }
  ```

### Restartable
- Halts previous event handlers
- Processes most recent event
- Best for canceling outdated operations
- Example:
  ```dart
  class ThoughtBloc extends Bloc<ThoughtEvent, ThoughtState> {
    ThoughtBloc() : super(ThoughtState()) {
      on<ThoughtEvent>(
        _onThought,
        transformer: restartable(),
      )
    }
  }
  ```

## Best Practices

### When to Use Each Transformer
1. **Concurrent**
   - Independent operations
   - No state dependencies
   - Performance-critical scenarios

2. **Sequential**
   - State-dependent operations
   - Financial transactions
   - Order-sensitive operations

3. **Droppable**
   - API calls that shouldn't be duplicated
   - Rate-limited operations
   - Debounced user actions

4. **Restartable**
   - Search operations
   - Real-time updates
   - Cancelable operations

### Testing Considerations
- Use `await Future<void>.delayed(Duration.zero)` in tests to ensure event order
- Example:
  ```dart
  blocTest<MyBloc, MyState>(
    'change value',
    build: () => MyBloc(),
    act: (bloc) {
      bloc.add(ChangeValue(add: 1));
      await Future<void>.delayed(Duration.zero);
      bloc.add(ChangeValue(remove: 1));
    },
    expect: () => const [
      MyState(value: 1),
      MyState(value: 0),
    ],
  );
  ```

## Common Pitfalls
1. Using concurrent transformer for state-dependent operations
2. Not considering event order in tests
3. Overusing sequential transformer for independent operations
4. Ignoring potential race conditions

## File Pattern
*.dart 

---
# Testing Guidelines

## Overview
At Very Good Ventures, we aim for 100% test coverage on all projects. Testing reduces bugs, encourages clean code, and provides confidence when shipping. While testing adds initial development time, it reduces QA cycles and improves maintainability.

## Incremental Coverage Approach
- Focus on testing one file at a time to achieve 100% code coverage before moving to the next file
- Verify coverage using tools like `lcov` to ensure all lines in a file are being exercised by tests
- Prioritize covering specific functionality branches and edge cases

## File Organization

### Test File Structure
Test files should mirror your project structure:

```
my_package/
├── lib/
│   ├── models/
│   │   ├── model_a.dart
│   │   ├── model_b.dart
│   │   └── models.dart
│   └── widgets/
│       ├── widget_1.dart
│       ├── widget_2.dart
│       └── widgets.dart
└── test/
    ├── models/
    │   ├── model_a_test.dart
    │   └── model_b_test.dart
    └── widgets/
        ├── widget_1_test.dart
        └── widget_2_test.dart
```

Note: Barrel files (like `models.dart` and `widgets.dart`) do not need tests.

## Test Writing Guidelines

### 1. Test Real Interactions
Always test actual user interactions rather than calling handlers directly:

```dart
// Good ✅
testWidgets('calls [onTap] on tapping widget', (tester) async {
  var isTapped = false;
  await tester.pumpWidget(
    SomeTappableWidget(
      onTap: () => isTapped = true,
    ),
  );
  await tester.tap(find.byType(SomeTappableWidget));
  expect(isTapped, isTrue);
});

// Bad ❗️
testWidgets('calls [onTap]', (tester) async {
  var isTapped = false;
  final widget = SomeTappableWidget(
    onTap: () => isTapped = true,
  );
  // Directly calling the handler instead of simulating a tap
  widget.onTap();
  expect(isTapped, isTrue);
});
```

### 2. Assert Results
Always include explicit assertions using `expect` or `verify`:

```dart
// Good ✅
testWidgets('calls [onTap] on tapping widget', (tester) async {
  var isTapped = false;
  await tester.pumpWidget(
    SomeTappableWidget(
      onTap: () => isTapped = true,
    ),
  );
  await tester.tap(find.byType(SomeTappableWidget));
  expect(isTapped, isTrue);
});

// Bad ❗️
testWidgets('can tap widget', (tester) async {
  await tester.pumpWidget(SomeTappableWidget());
  await tester.tap(find.byType(SomeTappableWidget));
});
```

### 3. Use Matchers
Always use matchers for better error messages:

```dart
// Good ✅
expect(name, equals('Hank'));
expect(people, hasLength(3));
expect(valid, isTrue);

// Bad ❗️
expect(name, 'Hank');
expect(people.length, 3);
expect(valid, true);
```

### 4. Type References
Use string interpolation for type references in test descriptions:

```dart
// Good ✅
testWidgets('renders $YourView', (tester) async {});
group(YourView, () {});

// Bad ❗️
testWidgets('renders YourView', (tester) async {});
group('$YourView', () {});
```

### 5. Descriptive Tests
Write clear, descriptive test names:

```dart
// Good ✅
testWidgets('renders $YourView for $YourState', (tester) async {});
test('given an [input] is returning the [output] expected', () {});

// Bad ❗️
testWidgets('renders', (tester) async {});
test('works', () {});
```

### 6. Single Purpose Tests
Test one scenario per test:

```dart
// Good ✅
testWidgets('renders $WidgetA', (tester) async {});
testWidgets('renders $WidgetB', (tester) async {});

// Bad ❗️
testWidgets('renders $WidgetA and $WidgetB', (tester) async {});
```

### 7. Widget Finding
Prefer finding widgets by type over keys:

```dart
// Good ✅
expect(find.byType(HomePage), findsOneWidget);

// Bad ❗️
expect(find.byKey(Key('homePageKey')), findsOneWidget);
```

### 8. Mock Classes
Use private mocks to avoid unintended test interactions:

```dart
// Good ✅
class _MockYourClass extends Mock implements YourClass {}

// Bad ❗️
class MockYourClass extends Mock implements YourClass {}
```

## Test Organization

### 1. Group Tests
Organize tests by functionality:
- Widget tests: group by "renders", "navigation", etc.
- Bloc tests: group by event name
- Repositories/clients: group by method name

### 2. Test Setup
Keep setup inside groups:

```dart
// Good ✅
void main() {
  group(UserRepository, () {
    late ApiClient apiClient;
    setUp(() {
      apiClient = _MockApiClient();
    });
    // Tests...
  });
}

// Bad ❗️
void main() {
  late ApiClient apiClient;
  setUp(() {
    apiClient = _MockApiClient();
  });
  group(UserRepository, () {
    // Tests...
  });
}
```

### 3. State Management
Initialize shared mutable objects per test:

```dart
// Good ✅
void main() {
  group(_MySubject, () {
    late _MySubjectDependency myDependency;
    setUp(() {
      myDependency = _MySubjectDependency();
    });
    test('value starts at 0', () {
      final subject = _MySubject(myDependency);
      expect(subject.value, equals(0));
    });
  });
}
```

### 4. Test Tags
Use constants for test tags:

```dart
// Good ✅
testWidgets(
  'render matches golden file',
  tags: TestTag.golden,
  (tester) async {},
);

// Bad ❗️
testWidgets(
  'render matches golden file',
  tags: 'golden',
  (tester) async {},
);
```

### 5. Dependency Injection and Mocking
Use proper dependency injection in tests:

```dart
// Good ✅
testWidgets('navigates when button is tapped', (tester) async {
  final mockNavigation = _MockAppNavigation();
  when(() => mockNavigation.navigate(any(), any())).thenAnswer((_) async => null);
  
  await tester.pumpWidget(
    RepositoryProvider<AppNavigation>.value(
      value: mockNavigation,
      child: const MyPage(),
    ),
  );
  
  await tester.tap(find.byType(MyButton));
  await tester.pumpAndSettle();
  
  verify(() => mockNavigation.navigate(any(that: isA<TargetRoute>()), any())).called(1);
});

// Bad ❗️
testWidgets('navigates when button is tapped', (tester) async {
  // Using a global mock or directly calling the function
  await tester.pumpWidget(const MyPage());
  await tester.tap(find.byType(MyButton));
});
```

## Best Practices

### 1. Independent Tests
- Do not share state between tests
- Initialize new instances in each test
- Use setUp for common initialization
- Properly reset mocks between tests

### 2. Testing UI with Practical Considerations
- Set appropriate viewport sizes in widget tests to avoid overflow issues:
  ```dart
  testWidgets('renders correctly on various screen sizes', (tester) async {
    // Set a larger viewport to avoid overflow
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    
    await tester.pumpWidget(/* ... */);
    // Test assertions
  });
  ```

### 3. Test Coverage
- Aim for 100% test coverage
- Test both success and failure cases
- Test edge cases and error conditions
- Pay special attention to navigation callbacks and extension methods

### 4. Follow Existing Patterns
- Study existing tests in the codebase to maintain consistent test patterns
- Adapt your test approach to match established practices in the project

## Common Pitfalls
1. Sharing state between tests
2. Using magic strings for test tags
3. Not testing error cases
4. Insufficient assertions
5. Brittle tests dependent on test order
6. Directly calling handlers instead of testing interactions
7. Not properly mocking dependencies
8. Not testing navigation and extension methods

## File Pattern
*_test.dart

---
# Widgetbook Use-Case Generation Instructions

Generate comprehensive Widgetbook use cases for Flutter components that showcase different variants and configurations effectively.

## Core Requirements

### UseCase Annotation Structure

Each use case must have a properly configured `@UseCase` annotation:

```dart
@UseCase(
  name: 'variantName',    // Required: Unique identifier for this variant
  type: ComponentType,    // Required: The Flutter widget class being showcased
)
```

**Naming Rules:**

- Single use case: `name: 'default'`
- Multiple use cases: Use descriptive names like `'with_label'`, `'disabled'`, `'loading'`
- Names must be unique within the same component type

### Method Signature Requirements

**Exact signature pattern:**

```dart
Widget build[ComponentName][VariantName]UseCase(BuildContext context) {
  // Implementation
}
```

**Naming conventions:**

- Single use case: `buildProgressIndicatorUseCase`
- Multiple use cases: `buildProgressIndicatorWithLabelUseCase`, `buildProgressIndicatorDisabledUseCase`
- Always return `Widget`
- Always accept exactly one parameter: `BuildContext context`

## Parameter Configuration Strategy

### Priority System

1. **Critical parameters** (required, affects core functionality): Always use knobs
2. **Visual parameters** (colors, sizes, styles): Use knobs when they demonstrate component flexibility
3. **Behavioral parameters** (enabled/disabled, loading states): Use knobs for interactive demonstration
4. **Callback parameters**: Implement with descriptive print statements
5. **Complex objects**: Hardcode with meaningful defaults, add TODO comments

### Knob Selection Logic

- **Bounded numeric values**: Use sliders (opacity: 0.0-1.0, progress: 0-100)
- **Unbounded numeric values**: Use input fields (dimensions, counts)
- **Enums/predefined options**: Use list knobs
- **Text content**: Use string inputs
- **Feature toggles**: Use boolean checkboxes

## Comprehensive Knobs API

### Basic Types

```dart
// Strings
context.knobs.string(label: 'text', initialValue: 'Hello World')
context.knobs.stringOrNull(label: 'optionalText', initialValue: null)

// Booleans
context.knobs.boolean(label: 'enabled', initialValue: true)
context.knobs.booleanOrNull(label: 'optionalFlag', initialValue: null)

// Integers
context.knobs.int.input(label: 'count', initialValue: 5)
context.knobs.int.slider(label: 'progress', initialValue: 50, min: 0, max: 100, divisions: 10)
context.knobs.intOrNull.input(label: 'optionalCount', initialValue: null)
context.knobs.intOrNull.slider(label: 'progress', initialValue: null, min: 0, max: 100, divisions: 10)

// Doubles
context.knobs.double.input(label: 'value', initialValue: 1.5)
context.knobs.double.slider(label: 'opacity', initialValue: 0.8, min: 0.0, max: 1.0, divisions: 20)
context.knobs.doubleOrNull.input(label: 'value', initialValue: null)
context.knobs.doubleOrNull.slider(label: 'optionalOpacity', initialValue: null, min: 0.0, max: 1.0)
```

### Advanced Types

```dart
// Dropdown lists
context.knobs.list<TextAlign>(
  label: 'textAlign',
  initialOption: TextAlign.center,
  options: [TextAlign.left, TextAlign.center, TextAlign.right],
  labelBuilder: (value) => value.name,
)

// Colors
context.knobs.color(label: 'primaryColor', initialValue: Colors.blue)
context.knobs.colorOrNull(label: 'optionalColor', initialValue: null)

// DateTime
context.knobs.dateTime(
  label: 'selectedDate',
  initialValue: DateTime.now(),
  start: DateTime.now().subtract(const Duration(days: 365)),
  end: DateTime.now().add(const Duration(days: 365)),
)

// Duration
context.knobs.duration(label: 'animationDuration', initialValue: const Duration(milliseconds: 300))
```

## Advanced Component Handling

### State Management Integration

For components requiring external state:

```dart
// Example: Component requiring a provider
@UseCase(name: 'with_data', type: DataWidget)
Widget buildDataWidgetWithDataUseCase(BuildContext context) {
  return MockDataProvider(
    data: _generateMockData(),
    child: DataWidget(
      onItemSelected: (item) => print('Selected item: ${item.id}'),
      showLoading: context.knobs.boolean(label: 'showLoading', initialValue: false),
    ),
  );
}
```

### Complex Parameter Handling

```dart
// For unmappable parameters
final customObject = CustomConfiguration(
  // Hardcoded meaningful defaults
  apiEndpoint: 'https://api.example.com',
  timeout: const Duration(seconds: 30),
); // TODO: User should configure CustomConfiguration manually

// For asset references
final iconPath = 'assets/icons/star.svg'; // Verify asset exists in pubspec.yaml
```

### Callback Implementation Patterns

```dart
// Simple callbacks
onPressed: () => print('Button pressed'),

// Callbacks with data
onChanged: (value) => print('Value changed to: $value'),

// Complex callbacks
onFormSubmitted: (formData) {
  print('Form submitted with data:');
  print('  - Name: ${formData.name}');
  print('  - Email: ${formData.email}');
},

// Async callbacks
onSave: () async {
  print('Save operation started');
  await Future.delayed(const Duration(seconds: 1));
  print('Save operation completed');
},
```

### Theme handling

Themes are globally injected and must not be provided.

## Use Case Variant Strategies

### Single Component, Multiple Variants

Create variants that showcase different states and configurations:

```dart
// Default state
@UseCase(name: 'default', type: CustomButton)
Widget buildCustomButtonUseCase(BuildContext context) { /* ... */ }

// Loading state
@UseCase(name: 'loading', type: CustomButton)
Widget buildCustomButtonLoadingUseCase(BuildContext context) { /* ... */ }

// Disabled state
@UseCase(name: 'disabled', type: CustomButton)
Widget buildCustomButtonDisabledUseCase(BuildContext context) { /* ... */ }

// With icon
@UseCase(name: 'with icon', type: CustomButton)
Widget buildCustomButtonWithIconUseCase(BuildContext context) { /* ... */ }
```

### Responsive and Theme Variants

```dart
// Different sizes
@UseCase(name: 'small', type: ProfileCard)
@UseCase(name: 'medium', type: ProfileCard)
@UseCase(name: 'large', type: ProfileCard)
```

## Quality Standards

### Code Quality

- **No descriptive comments**: Code should be self-documenting
- **Consistent formatting**: Follow Dart style guidelines
- **Meaningful defaults**: Initial values should represent realistic usage
- **Error handling**: Wrap potentially failing operations in try-catch where appropriate

### Use Case Coverage

Ensure use cases demonstrate:

- [ ] Default/primary functionality
- [ ] Edge cases (empty states, maximum values)
- [ ] Interactive behaviors (hover, focus, disabled states)
- [ ] Visual variants (different styles, sizes, colors)
- [ ] Error states when applicable

### Testing Considerations

```dart
// Include realistic data volumes
final items = List.generate(50, (index) => 'Item ${index + 1}');

// Test boundary conditions
final progress = context.knobs.double.slider(
  label: 'progress',
  initialValue: 0.7,
  min: 0.0,
  max: 1.0,
  divisions: 100,
); // Allows testing 0%, 100%, and intermediate values
```

## Complete Example Template

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'interactive',
  type: CustomSlider,
)
Widget buildCustomSliderInteractiveUseCase(BuildContext context) {
  return CustomSlider(
    value: context.knobs.double.slider(
      label: 'value',
      initialValue: 0.5,
      min: 0.0,
      max: 1.0,
      divisions: 20,
    ),
    min: context.knobs.double.input(
      label: 'min',
      initialValue: 0.0,
    ),
    max: context.knobs.double.input(
      label: 'max',
      initialValue: 1.0,
    ),
    enabled: context.knobs.boolean(
      label: 'enabled',
      initialValue: true,
    ),
    showLabels: context.knobs.boolean(
      label: 'showLabels',
      initialValue: true,
    ),
    activeColor: context.knobs.color(
      label: 'activeColor',
      initialValue: Colors.blue,
    ),
    onChanged: (value) => print('Slider value changed to: $value'),
    onChangeStart: (value) => print('Slider interaction started at: $value'),
    onChangeEnd: (value) => print('Slider interaction ended at: $value'),
  );
}
```

## Pre-Generation Checklist

Before generating use cases, verify:

- [ ] Component class name and import path
- [ ] Required vs optional parameters
- [ ] Parameter types and constraints
- [ ] Available enum values for list knobs
- [ ] Asset dependencies and paths
- [ ] State management requirements
- [ ] Theme/localization dependencies
- [ ] Callback signatures and expected behavior

---
# 📝 Package README Format Guidelines

## Overview
This rule file provides guidelines for creating consistent, well-structured README files for packages in the project. Follow this format to maintain a professional and informative documentation style.

## 📄 Main Format

The package README should follow this general structure:

```md
# 📄 Package Name

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

A concise description of what the package does and its primary value proposition.

## ✨ Features

- **Key Feature One**: Brief description of this feature
- **Key Feature Two**: Brief description of this feature
- **Key Feature Three**: Brief description of this feature
- **Key Feature Four**: Brief description of this feature

## 🔍 Overview

A more detailed explanation of the package's purpose, how it fits into the architecture, and its general approach.

## 🔥 External Services (if applicable)

If the package integrates with external services like Firebase, provide links to those resources:
[service-name/resource](mdc:https:/link-to-resource)

## 💡 Usage

```dart
// Example code showing how to initialize and use the package
final repository = Repository(
  dependencies,
);

// Example showing how to use the package
try {
  final result = await repository.performAction();
  // Use the result...
} on SpecificException catch (e) {
  // Handle exception...
}
```

## 💻 Installation

**❗ In order to start using Package Name you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add to your `pubspec.yaml`:

```yaml
dependencies:
  package_name:
    path: path/to/package_name
```

Or install via `flutter pub add`:

```sh
flutter pub add package_name
```

## 📦 Dependencies

- [dependency_one](mdc:https:/pub.dev/packages/dependency_one): Brief description of whr
- [dependency_two](mdc:https:/pub.dev/pack_two): Brief description of what it's used for


## 🛠️ Exception Handling

The package uses custom exception classes to provide detailed error information:

- **SpecificExceptionOne**: When a specific operation fails
- **SpecificExceptionTwo**: When another specific operation fails
- **GenericOperationException**: When a generic operation fails

## 🧪 Running Tests

For first time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](mdc:https:/github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysdge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
```

## 📊 Key Elements

1. **Emojis for headers and features**: Include relevant emojis for headers and individual feature items to make them visually appealing and easy to scan.
   
2. **Badges**: Include badges for analysis style, build tools, and license.
   
3. **Concise description**: Start with a brief, clear description of the package's purpose.
   
4. **Feature list with emojis**: Use bullet points with emojis to highlight key features.
   
5. **Usage examples**: Show practical code examples of how to use the package.
   
6. **Installation instructions**: Provide clear steps for adding the package to a project.
   
7. **Dependencies with links**: List all dependencies with links to their pub.dev pages.
      
8. **Exception handling section**: Detail the custom exceptions and their purposes.
   
9. **Testing instructions**: Include steps for running tests and generating coverage reports.

## 🔧 Implementation Details

When creating or updating a README for a package:

1. Replace "Package Name" with the actual package name.
   
2. Ensure all links are working and point to the correct resources.
   
3. Include practical code examples that demonstrate common use cases.
   
4. Choose appropriate emojis for features that represent their functionality.
   
5. Provide clear descriptions of potential errors and exceptions in the exception handling section.
   
6. If the package integrates with external services (Firebase, APIs, etc.), include relevant links.
   
7. Keep the badges section up to date with correct links.
   
8. Use appropriate emojis that match the section content.

## 📋 Suggested Feature Emojis

- 🔐 Security features / Authentication
- 🧩 Integration features / Plugins
- 📡 Network / API related features
- ⚡ Performance features
- 📊 Analytics / Reporting features
- 🌐 Internationalization features
- 💾 Storage / Database features
- 🏭 Factory patterns / Builders
- 🧪 Testing utilities
- 🔄 State management / Lifecycle features

## 🎯 Template Sections

- **📄 Package Name**: Main title with package name and emoji
- **✨ Features**: Bullet point list of key features with emojis
- **🔍 Overview**: Detailed explanation of the package
- **🔥 External Services**: Links to external services (if applicable)
- **💡 Usage**: Code examples with explanations
- **💻 Installation**: Setup and installation instructions
- **📦 Dependencies**: List of dependencies with links
- **🛠️ Exception Handling**: List of exceptions with descriptions
- **🧪 Running Tests**: Testing procedures

This format ensures consistency across package documentation and provides users with a clear, informative guide to using the package. 
