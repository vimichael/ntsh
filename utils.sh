

handle_help() {
  first_arg="$1"
  msg="$2"

  case "$first_arg" in
    -h|--help|help)
      echo "$msg" 
      exit 0
      ;;
  esac
}
