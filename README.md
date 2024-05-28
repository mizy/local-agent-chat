# LLM Flutter Application

This is a Flutter application that utilizes the Llama.cpp library to run large LLM models offline. 

## Features

- **Offline Model Execution**: The application is capable of running large LLM models offline, making it ideal for environments with limited or no internet connectivity.
- **Cross-Platform**: Built with Flutter, this application can be compiled and run on multiple platforms including iOS, Android, and web.
- **Efficient Performance**: The use of Llama.cpp ensures efficient execution of large models, providing fast and accurate results.


## demo png

- ![Image 3](https://github.com/mizy/local-agent-chat/assets/7129229/00f34c7c-0638-4906-9f32-ebbaa523fb31)
- ![Image 4](https://github.com/mizy/local-agent-chat/assets/7129229/338690f3-da6c-4b26-bf33-566f1cedd388)
- ![Image 1](https://github.com/mizy/local-agent-chat/assets/7129229/3de55e54-eae4-42d4-bf59-73fada1f72f2)
- ![Image 2](https://github.com/mizy/local-agent-chat/assets/7129229/6da688fd-465b-4c49-80ec-0f1a7bf3940d)

## Getting Started

To get started with this project, clone the repository and navigate to the project directory.

```sh
git clone https://github.com/mizy/local-agent-chat.git
cd local-agent-chat
git submodule update --init --recursive
```

## Supported Platforms
+ [x] MacOS
+ [x] Linux
+ [x] IOS

## Building the Project

To build the project, use the following command:

```sh
flutter build
```

This will generate a build based on your current platform.

## Running the Project

To run the project, use the following command:

```sh
flutter run
```

## Add a new prompt format
change llama_cpp_dart/src/llm.cpp antiprompt_map to add a new prompt format

## Contributing

Contributions are welcome! 

## License

This project is licensed under the terms of the MIT license.