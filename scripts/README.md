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

<ul>
  <li>Enter your weight (in kilograms) every monday morning</li>
  <li>Log the current workout week's number</li>
  <li>Log the current date</li>
  <li>Convert the weight from kg to pounds and log both values</li>
</ul>

<h1>check_websites.sh</h1>

<ul>
  <li>Loop through an array of websites</li>
  <li>Print '[website] ONLINE / OFFLINE' for each one, depending on the response status code</li>
</ul>

