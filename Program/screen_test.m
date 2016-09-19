screenNum = 0;
HideCursor;
commandwindow;

MainWindow = Screen(screenNum, 'OpenWindow', [], [], 32);
Screen('TextFont', MainWindow, 'Courier New');
Screen('TextSize', MainWindow, 34);


Screen('FillRect',MainWindow, black);

