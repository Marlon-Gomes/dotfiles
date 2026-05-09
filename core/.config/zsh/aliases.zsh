alias ls='ls --color=auto'

case "$(uname -s)" in
  Darwin)
    if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -d "$HOMEBREW_PREFIX" ]; then
      alias llvm-clang="$HOMEBREW_PREFIX/opt/llvm/bin/clang"
      alias llvm-clang++="$HOMEBREW_PREFIX/opt/llvm/bin/clang++"
      alias run-clang-tidy="$HOMEBREW_PREFIX/opt/llvm/bin/run-clang-tidy"
      alias scan-build="$HOMEBREW_PREFIX/opt/llvm/bin/scan-build"
      alias clang-format="$HOMEBREW_PREFIX/opt/llvm/bin/clang-format"
      alias clang-tidy="$HOMEBREW_PREFIX/opt/llvm/bin/clang-tidy"
      alias iwyu="$HOMEBREW_PREFIX/opt/include-what-you-use/bin/include-what-you-use"
    fi
    ;;
  Linux)
    alias llvm-clang='clang'
    alias llvm-clang++='clang++'
    alias run-clang-tidy='run-clang-tidy.py'
    alias scan-build='scan-build'
    alias clang-format='clang-format'
    alias clang-tidy='clang-tidy'
    alias iwyu='include-what-you-use'
    ;;
esac
