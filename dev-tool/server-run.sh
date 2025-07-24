#!/bin/bash

#---------------check module version
MAX_GO_VERSION="1.18"
for mod in $(go list -m -f '{{if not .Indirect}}{{.Path}}{{end}}' all | grep -v '^$'); do
  url="https://proxy.golang.org/${mod}/@v/$(go list -m -f '{{.Version}}' $mod).mod"
  go_version=$(curl -s $url | grep '^go ' | awk '{print $2}')
  if [[ "$go_version" > "$MAX_GO_VERSION" ]]; then
    echo "$mod requires go $go_version, which exceeds $MAX_GO_VERSION"
  fi
done
echo "module version check passed"


CUR_DIR=$(pwd)

#--------------- check if mockgen is installed

if ! command -v ginkgo >/dev/null 2>&1; then
  echo "ginkgo could not be found, installing it now"
  cd ~/ && go install github.com/onsi/ginkgo/v2/ginkgo@v2.9.5
fi
#--------------- check if mockgen is installed
if ! command -v mockgen >/dev/null 2>&1; then
  echo "mockgen could not be found, installing it now"
  cd ~/ && go install github.com/golang/mock/mockgen@latest
fi

echo "mockgen and ginkgo are installed"
cd "$CUR_DIR"
#---------------generate mock files
mockgen -destination=./test/mocks/keystore_mock.go  -package=mocks_test gitlab.bee.to/aladdin/rd/ecb/grpc-pb/payment-secret-pb/go/keystore IKeyStore
mockgen -destination=./test/mocks/risk_mock.go -package=mocks_test -source=./third/risk/pouch.go
mockgen -destination=./test/mocks/payment_billing_mock.go -package=mocks_test -source=./third/payment-billing/pouch.go
mockgen -destination=./test/mocks/paycore_mock.go -package=mocks_test -source=./third/paycore/paycore.go
mockgen -destination=./test/mocks/payment_secret_mock.go -package=mocks_test -source=./third/payment-secret/pouch.go

mockgen -destination=./test/mocks/http_sign_mock.go -package=mocks_test gitlab.bee.to/aladdin/rd/ecb/payment-trade/third/payment-secret ApiSignInfo

echo "mock files generated successfully"


#---------------run ginkgo tests
ginkgo -r # run all tests
# ginkgo -r  --focus="XX"# replace XX with the specific test you want to run