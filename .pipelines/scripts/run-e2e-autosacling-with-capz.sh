if [[ ! -f "${KUBECONFIG:-}" ]]; then
  echo "kubeconfig not exists"
  exit 1
fi

# Ensure the provisioned cluster can be accessed with the kubeconfig
for i in `seq 1 6`; do
  kubectl get pod --all-namespaces=true && break
  sleep 10
done

kubectl wait --for=condition=Ready node --all --timeout=5m
kubectl get node -owide

echo "Running e2e"


export LABEL_FILTER=${LABEL_FILTER:-Feature:Autoscaling || !Serial && !Slow}
export SKIP_ARGS=${SKIP_ARGS:-""}
make test-ccm-e2e
