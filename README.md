# `new` - Project Scaffolding Tool

`new` is a project scaffolding tool designed to help developers quickly generate project structures with ease.
By using various modules, `new` allows you to scaffold projects based on predefined templates, streamlining the initial setup process for new projects.

## Features

- **Modular Architecture**: Easily extendable with new modules for different project types.
- **Command Line Interface**: Simple and intuitive CLI for quick usage.
- **Customizable Options**: Pass in options to customize the scaffolded project.

## Installation

Install with gitpack:

```sh
sudo gitpack add juliankahlert/new
```

## Usage

To use the `new` tool, run the following command:

```sh
$ new [options] TOOL DIR
```

### Options

- `--opt KEY VALUE`: A generic option to pass custom key-value pairs.
- `-h`, `--help`: Prints the help message.
- `-l`, `--list`: Lists all available modules.

### Examples

List all available modules:

```sh
$ new --list
vite-vue-element-electron
vite-vue-electron
```

Create a new project using a module:

```sh
$ new vite-vue-element-electron ./my-new-ui-project
```

## Creating Modules

Modules are used to define the structure and content of the scaffolded projects. To create a new module, follow these steps:

1. Create a new Ruby file with the extension `.new.rb` in the appropriate directory.
2. Define your module by inheriting from `ScaffoldModule` and `ScaffoldModuleBuilder`.
3. Implement the necessary methods (`run`, `build`, `name`).

Example module:

```ruby
class MyModuleBuilder < ScaffoldModuleBuilder
  class MyModule < ScaffoldModule
    def run
      # Your code to generate the project structure
    end
  end

  def build(cfg)
    MyModule.new(cfg[:dir])
  end

  def name
    'my-module'
  end
end

ScaffoldModuleBuilder.register(MyModuleBuilder.new)
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss your ideas.
