<h1>shut_down.sh</h1>
<p>Dependencies: None</p>

<ul>
  <li>Choose between shutdown, reboot and cancel</li>
  <li>Close all applications specified inside an array</li>
  <li>Log system startup time and date</li>
  <li>Log system shutdown / reboot time and date</li>
  <li>Log system uptime</li>
  <li>Power system off OR reboot after a specified amount of time</li>
</ul>

<h2>Example log output</h2>
<blockquote>
<p>System powered on at: 07:55:17 on 02 Feb 2018</p>
<p>System shutdown at: 15:02:28 on 02 Feb 2018</p>
<p>The system has been up 7 hours, 6 minutes</p>
</blockquote>

<hr>

<h1>night_light.sh</h1>
<p>Dependencies: GNOME Night Light, xprop, xwininfo</p>

<ul>
  <li>Check if the foreground app is in fullscreen mode</li>
  <li>If it is, turn off gnome-night-light</li>
  <li>Turn it back on when you close the application</li>
</ul>

<hr>

<h1>weight_tracker.sh</h1>
<p>Dependencies: None</p>

<ul>
  <li>Enter your weight (in kilograms) once every week (on a specified day)</li>
  <ul>
      <li>If you've already logged your weight for the week:</li>
        <ul>
            <li>show the change in weight gain / loss (in kilograms and pounds) from the start </li>
            <li>show the change in weight gain / loss (in kilograms and pounds) since last week</li>
            <li>show the weight</li>
        </ul>
  </ul>
  <li>Log the current workout week's number</li>
  <li>Log the current date</li>
  <li>Convert the weight from kg to pounds and log both values</li>
</ul>

<h1>check_websites.sh</h1>
<p>Dependencies: None</p>

<ul>
  <li>Loop through an array of websites</li>
  <li>Print '[website] ONLINE / OFFLINE' for each one, depending on the response status code</li>
</ul>

<h1>pomodoro.sh</h1>
<p>Pomodoro timer, see - https://en.wikipedia.org/wiki/Pomodoro_Technique</p>
<p>Dependencies: speech-dispatcher</p>

<ul>
  <li>Start an x minute timer</li>
  <li>Print 'x minutes have passed' every x minutes</li>
  <li>Produce an audible 'stop' after x minutes and print a checkmark</li>
  <li>Allow an x minute break</li>
  <li>Produce an audible 'start' after the break and restart the timer</li>
  <li>Repeat from the start until the fourth checkmark and then allow an x minute break</li>
  <li>Repeat from the start</li>
</ul>

<h1>workspace.sh</h1>
<p>Dependencies: xdotool</p>

<ul>
  <li>Choose a workspace from a pre-defined list and switch to it</li>
  <li>Run any specified commands in that new workspace, but only if it's inactive (no running apps)</li>
  <li>Change the background depending on the workspace</li>
</ul>

<h1>generate_web_project.sh</h1>
<p>Dependencies: git</p>

<ul>
  <li>Choose the type of web project you're starting (Node.js app, WordPress website, static site, etc.)</li>
  <li>Enter a project name and create a directory of the same name in the current directory</li>
  <li>Copy template files and folders from a predefined location to the project dir</li>
  <li>Install packages (optionally), initialize a git repository, add files / folders to .gitignore</li>
</ul>

<h1>take_notes.sh</h1>
<p>Dependencies: fzf, calibre</p>

<ul>
  <li>Choose between adding a new topic / notes on a topic, editing notes or displaying all notes on a topic</li>
  <li>If adding a new topic, choose a name and enter a title for the first set of notes</li>
  <li>If adding notes, select a topic from all the added ones and enter a title</li>
  <li>The script will generate markdown-formatted lines of text for the title, date, first note and the source</li>
  <li>The script will then open the notes file in your favorite text editor (default is 'neovim')</li>
<li>If editing notes, select the title of a set of notes and open in text editor (default is 'neovim')</li>
  <li>If displaying notes, you can decide to either open the markdown (MD) file in the chosen program (default is the 'less' command) or have the MD converted to a PDF file and then displayed in a PDF file viewer (default is a manually installed version of 'Firefox Developer Edition')</li>
</ul>

<h1>build_web_project.sh</h1>
<p>Dependencies: git, html-minifier, terser, svgo, optipng, fzf</p>

<ul>
  <li>Choose between minifying / optimizing static or dynamic website assets</li>
  <li>For static - you can choose between minifying / optimizing a single file or all files in a directory</li>
  <ul>
    <li>Selecting all files assumes build process for deployment to 'Google Firebase' and the script…</li>
        <ul>
          <li>creates production branch</li>
          <li>initializes new firebase project</li>
          <li>commits all files</li>
        </ul>
    </ul>
<li>For dynamic - the script creates a production branch and minifies / optimizes all files by file type</li>
</ul>
