#!/bin/bash

#путь к папке с тестами
TESTS_PATH='/devops-examples/EXAMPLE_APP'
LOG_PATH="${TESTS_PATH}/logs"

#создание папки для результатов тестов, если она не существует
mkdir -p "${LOG_PATH}"

#функция для записи сообщения в лог с временным штампом
log_message() {
    local timestamp=$(date '+%Y-%m-%d %T')
    echo "$timestamp $1" | tee -a "${LOG_FILE}"
}

#функция для запуска теста и записи вывода в журнал
run_test() {
    local test_name=$1
    local test_script=$2
    local log_file="${LOG_PATH}/${test_name}_$(date '+%Y%m%d_%H%M%S').log"

    local LOG_FILE="${log_file}"

    log_message "Starting ${test_name}"

    #проверка расширения файла и выбор соответствующего интерпретатора
    if [[ "$test_script" == *".py" ]]; then
        interpreter="python3"
    elif [[ "$test_script" == *".sh" ]]; then
        interpreter="bash"
    else
        log_message "Unsupported file extension for test script: ${test_script}"
        return 1
    fi

    #запуск теста и запись stdout и stderr в файл журнала
    echo "Running ${test_name}..."
    if "$interpreter" "${test_script}" > >(tee -a "${log_file}") 2> >(tee -a "${log_file}" >&2);
    then
        log_message "${test_name} finished successfully. Log file: ${log_file}"
    else
        log_message "${test_name} failed to run. Log file: ${log_file}"
    fi
}

#запуск теста форматирования кода black
run_test "black_style.sh" "${TESTS_PATH}/black_style.sh"

#запуск статического теста pylint
touch /devops-examples/EXAMPLE_APP/__init__.py && pylint --load-plugins StaticTest /devops-examples/EXAMPLE_APP > >(tee -a "${LOG_PATH}/static_test.py_$(date '+%Y%m%d_%H%M%S').log") 2> >(tee -a "${LOG_PATH}/static_test.py_$(date '+%Y%m%d_%H%M%S').log" >&2);

#запуск интеграционного теста проверки загрузки файла
run_test "integration_test.py" "${TESTS_PATH}/integration_test.py"

log_message "All tests finished."
