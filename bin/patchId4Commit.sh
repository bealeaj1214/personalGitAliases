
#!/bin/bash
# linux and mac OS only - solaris #!/usr/bin/env bash
COMMIT=$(git rev-parse --verify $1) && git show $COMMIT | git patch-id