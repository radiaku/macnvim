function create_swiftui_project() {
    if [ -z "$1" ]; then
        echo "Usage: create_swiftui_project <ProjectName>"
        return 1
    fi

    PROJECT_NAME="$1"
    PROJECT_DIR="$PWD/$PROJECT_NAME"

    # Create project directory
    mkdir -p "$PROJECT_DIR/Sources" "$PROJECT_DIR/Resources"

    # Create project.yml file
    cat <<EOL > "$PROJECT_DIR/project.yml"
name: $PROJECT_NAME
options:
  bundleIdPrefix: com.example
  deploymentTarget:
    macOS: '11.0'
configurations:
  Debug:
    buildSettings:
      SWIFT_OPTIMIZATION_LEVEL: '-Onone'
  Release:
    buildSettings:
      SWIFT_OPTIMIZATION_LEVEL: '-O'

targets:
  $PROJECT_NAME:
    type: application
    platform: macOS
    sources: [Sources/**]
    resources: [Resources/**]
    dependencies:
      - target: $PROJECT_NAME
EOL

    # Create a basic Swift file
    cat <<EOL > "$PROJECT_DIR/Sources/$PROJECT_NAME.swift"
import SwiftUI

@main
struct $PROJECT_NAME: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
            .padding()
    }
}
EOL

    # Generate the Xcode project
    cd "$PROJECT_DIR" || return
    xcodegen

    # Open the project
    open "$PROJECT_NAME.xcodeproj"
}

