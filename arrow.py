import curses
import time

def main(stdscr):
    # Disable cursor
    curses.curs_set(0)

    frame_time = 3  # Target loop duration in seconds (500 ms)

    # Set a longer timeout (e.g., 300 ms)
    timeout_ms = int(frame_time * 1000 * 0.95)
    stdscr.timeout(timeout_ms)


    stdscr.addstr("Press an arrow key (Press 'q' to exit)\n")
    
    while True:
        # Record the start time of the loop
        start_time = time.time()

        key = stdscr.getch()  # Wait for a key press or timeout
        if key == curses.KEY_UP:
            stdscr.addstr("Up arrow pressed\n")
        elif key == curses.KEY_DOWN:
            stdscr.addstr("Down arrow pressed\n")
        elif key == curses.KEY_LEFT:
            stdscr.addstr("Left arrow pressed\n")
        elif key == curses.KEY_RIGHT:
            stdscr.addstr("Right arrow pressed\n")
        elif key == ord('q'):
            stdscr.addstr("Exiting...\n")
            break
        elif key == -1:  # Timeout occurred
            stdscr.addstr("No key pressed\n")
        
        # Calculate elapsed time
        elapsed_time = time.time() - start_time

        # Calculate remaining time to meet the target frame duration
        remaining_time = frame_time - elapsed_time
        if remaining_time > 0:
            print(f'remain {remaining_time}\r')
            time.sleep(remaining_time)  # Sleep for the remaining time

curses.wrapper(main)
