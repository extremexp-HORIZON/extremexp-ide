# Experiment DSL Language Server
The language server provides grammar validation of DSL in preferred editor, for example Visual Studio Code or IntelliJ IDEA. The language server has fundamentally two sides, server side and clients side. 

- [Server Side](#server-side)
- [Client Side](#client-side)

## Server Side 
The server in this case is an executable JAR built from [LanguageServer.java](https://colab-repo.intracom-telecom.com/colab-projects/extremexp/experiment-modelling/extremexp-dsl-framework/-/blob/main/eu.extremexp.dsl.parent/eu.extremexp.dsl.ide/src/eu/extremexp/dsl/ide/ServerLauncher.java?ref_type=heads), from [extremexp-dsl-framework](https://colab-repo.intracom-telecom.com/colab-projects/extremexp/experiment-modelling/extremexp-dsl-framework) repository, where the grammar is defined. The server listens to port `5007`.

At this moment, the server is a prototype and to quickly launch it, the executable JAR file is provided, no need to build it from the source. Simply, run the JAR file, as:

```cmd
java -jar server/eu.extremexp.dsl.ide-1.0.0-SNAPSHOT-ls.jar
```
To ensure that you are running the current version of the language, a message will be printed:

```
Welcome to XXP LSP version 4.0
```

*Note*: the server closes when the editor (client) is closed. 


## Client Side
The client side for each editor is a separated project, which develops an extension of the same editor. 

- [Visual Studio Code](#visual-studio-code)
- [IntelliJ IDEA](#intellij-idea)

### Visual Studio Code
For a full documentation please attend to [Language Server Extension Guide](https://code.visualstudio.com/api/language-extensions/language-server-extension-guide). In this project we have replaced the server side of the language server to our implemented grammar. However, the client side is designed according to the documentation. 

1. Open `client/vs-code` folder as a Visual Studio Code project
    ```cmd
    cd client/vs-code
    code .
    ```

1. Install `node_modules`:
    ```cmd
    npm install
    ```

1. Run the extension:

    There now should be a folder with generated `extension.js` at [client/vs-code/src/out/extension.js](client/vs-code/src/out/extension.js). Open the file, and press **F5** (or goto *RUN->Start Debugging*). There must be a number of options to run the extension as, select **VS Code Extension Development**. A new Visual Stdio Code (*extension*) will appear.

1. Test the editor:

    Open an empty folder and create files with extension `.xxp`. Please keep in mind that the name of workflows should be same as the name of the files. There is no syntax-highlight at this moment, so the editor would look like this:

    ![VS code no editor](assets/vs-editor-no-error.png)


    **Now try to make an (or multiple) error(s)**:
    ![VS code with error](assets/vs-editor-with-error.png)

Once the extension project is closed, the server listener is also closed.

### IntelliJ IDEA
TODO