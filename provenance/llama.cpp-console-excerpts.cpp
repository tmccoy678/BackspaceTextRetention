/*
Source: ggml-org/llama.cpp, common/console.cpp
Commit: b29c606e28a01b1bc8c1351026a0fa6e616bf6c4
Upstream URL:
https://github.com/ggml-org/llama.cpp/blob/b29c606e28a01b1bc8c1351026a0fa6e616bf6c4/common/console.cpp
Full upstream file SHA-256:
2036d837458426b3d7c456cdfdb5ace53232fd84e0e11ec3395ee7ab04f901bf

Only the two experiment-relevant excerpts are reproduced below. Upstream is
MIT-licensed; see provenance/llama.cpp-LICENSE.
*/

// Upstream lines 130–145: --simple-io bypasses this POSIX raw-mode branch.
        // POSIX-specific console initialization
        if (!simple_io) {
            struct termios new_termios;
            tcgetattr(STDIN_FILENO, &initial_state);
            new_termios = initial_state;
            new_termios.c_lflag &= ~(ICANON | ECHO);
            new_termios.c_cc[VMIN] = 1;
            new_termios.c_cc[VTIME] = 0;
            tcsetattr(STDIN_FILENO, TCSANOW, &new_termios);

            tty = fopen("/dev/tty", "w+");
            if (tty != nullptr) {
                out = tty;
            }
        }

// Upstream lines 1046–1087: the simple path reads a completed line.
    static bool readline_simple(std::string & line, bool multiline_input) {
#if defined(_WIN32)
        std::wstring wline;
        if (!std::getline(std::wcin, wline)) {
            line.clear();
            GenerateConsoleCtrlEvent(CTRL_C_EVENT, 0);
            return false;
        }

        int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wline[0], (int)wline.size(), NULL, 0, NULL, NULL);
        line.resize(size_needed);
        WideCharToMultiByte(CP_UTF8, 0, &wline[0], (int)wline.size(), &line[0], size_needed, NULL, NULL);
#else
        if (!std::getline(std::cin, line)) {
            line.clear();
            return false;
        }
#endif
        if (!line.empty()) {
            char last = line.back();
            if (last == '/') {
                line.pop_back();
                return false;
            }
            if (last == '\\') {
                line.pop_back();
                multiline_input = !multiline_input;
            }
        }
        line += '\n';
        return multiline_input;
    }

    bool readline(std::string & line, bool multiline_input) {
        if (simple_io) {
            return readline_simple(line, multiline_input);
        }
        return readline_advanced(line, multiline_input);
    }
