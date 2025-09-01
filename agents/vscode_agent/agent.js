const vscode = require('vscode');

function activate(context) {
    console.log('Congratulations, your extension "vscode-agent" is now active!');

    let disposable = vscode.commands.registerCommand('vscode-agent.helloWorld', function () {
        vscode.window.showInformationMessage('Hello World from vscode-agent!');
    });

    context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = {
    activate,
    deactivate
}