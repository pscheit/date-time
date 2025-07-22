set dotenv-load := false
set positional-arguments

export COLUMNS := '550'

default:
  @just --list

php := "/usr/bin/php8.2"
composer := "/usr/bin/php8.2 /usr/local/bin/composer"

cli *args='':
    {{ php }} bin/console "$@"

psalm *args='--stats':
    {{ php }} tools/psalm/vendor/bin/psalm --no-cache --config=tools/psalm/psalm.xml "${@}"

watch-psalm *args='':
    find src/ test/ -name '*.php' | entr {{ php }} vendor/bin/psalm "${@}"

phpunit *args='':
    {{ php }} vendor/bin/phpunit "${@}"

fix:
    tools/ecs/vendor/bin/ecs check --config tools/ecs/ecs.php --fix

composer *args='':
    {{ composer }} "${@}"

units:
    j phpunit --exclude-group=integration

install-tools:
    j composer install --working-dir=tools/psalm
    j composer install --working-dir=tools/ecs

prep:
    j fix
    j psalm
    j phpunit
