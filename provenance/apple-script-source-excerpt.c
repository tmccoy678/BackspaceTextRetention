/*
Source: Apple Open Source, shell_cmds/script/script.c
Commit: e256b9a97f9bbd751305b7af36cf751668fbb849
URL:
https://github.com/apple-oss-distributions/shell_cmds/blob/e256b9a97f9bbd751305b7af36cf751668fbb849/script/script.c
Downloaded upstream file SHA-256:
90d15bffd032a68732a31bfc29dba91ac47117dcf112044d6d516e90fdf787c3

Experiment-relevant excerpt from upstream lines 379–388. The code reads bytes
from the child PTY master, writes the same bytes to the visible terminal, and
writes them sequentially to the transcript file. Apple source licensing and
notices apply to this excerpt.
*/

        if (n > 0 && FD_ISSET(master, &rfd)) {
            cc = read(master, obuf, sizeof (obuf));
            if (cc <= 0)
                break;
            (void)write(STDOUT_FILENO, obuf, cc);
            if (rawout)
                record(fscript, obuf, cc, 'o');
            else
                (void)fwrite(obuf, 1, cc, fscript);
        }
