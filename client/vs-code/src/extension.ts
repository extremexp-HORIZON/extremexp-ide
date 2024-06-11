'use strict';

import * as net from 'net';

import {Trace} from 'vscode-jsonrpc';
import { window, workspace, commands, ExtensionContext, Uri } from 'vscode';
import { LanguageClient, LanguageClientOptions, StreamInfo, Position as LSPosition, Location as LSLocation } from 'vscode-languageclient/node';

let lc: LanguageClient;

export function activate(context: ExtensionContext) {
    // The server is a started as a separate app and listens on port 5007
    let connectionInfo = {
       	host: process.env.LANG_SERVER_HOST || "localhost",
	port: parseInt(process.env.LANG_SERVER_PORT || "5007", 10)
    };
     
    let serverOptions = () => {
        // Connect to language server via socket
        let socket = net.connect(connectionInfo);
        let result: StreamInfo = {
            writer: socket,
            reader: socket
        };
        return Promise.resolve(result);
    };
    
    let clientOptions: LanguageClientOptions = {
        documentSelector: ['xxp'],
        synchronize: {
            fileEvents: workspace.createFileSystemWatcher('**/*.xxp')
        }
    };
    
    // Create the language client and start the client.
    lc = new LanguageClient('Xtext Server', serverOptions, clientOptions);

    lc.setTrace(Trace.Verbose);
    lc.start();
}

export function deactivate() {
    return lc.stop();
}
