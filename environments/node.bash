#!/usr/bin/env bash
export NODE_REPL_HISTORY=~/.node_history # Enable persistent REPL history for `node`, see https://nodejs.org/api/repl.html
export NODE_REPL_HISTORY_SIZE='32768'    # Allow 32³ entries; the default is 1000.
export NODE_REPL_MODE='sloppy'           # Use sloppy mode by default, matching web browsers.
