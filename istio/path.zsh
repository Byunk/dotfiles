ISTIO_VERSION="$(curl -sL https://github.com/istio/istio/releases | \
grep -o 'releases/[0-9]*.[0-9]*.[0-9]*/' | sort -V | \
tail -1 | awk -F'/' '{ print $2}')"
ISTIO_VERSION="${ISTIO_VERSION##*/}"

export PATH=$PATH:$DOTFILES_ROOT/bin/istio-$ISTIO_VERSION/bin