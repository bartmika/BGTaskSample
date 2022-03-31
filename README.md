# README

This is a sample code demonstrating how to use Apple's Background Tasks for iOS.

## Instructions
How to run this code.

1. Clone project.

2. Start project with your physical device

3. When running, click pause.

4. Run in your Xcode's terminal: 

```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.mikasoftware.BGTaskSample.Refresh"]
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.mikasoftware.BGTaskSample.Processing"]
```

5. Resume your code.

6. You should see message in your terminal:

```
Text: Hello world!
Text: Hello world! v2
```

7. Enjoy!
