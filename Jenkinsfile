pipeline {
    agent any

    environment {
        SNOWSQL_PATH = 'C:\Program Files\Snowflake SnowSQL\snowsql.exe'
        ENV_FILE = " "
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Select Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        ENV_FILE = 'config/dev.env'
                    } else if (env.BRANCH_NAME == 'test') {
                        ENV_FILE = 'config/test.env'
                    } else if (env.BRANCH_NAME == 'prod') {
                        ENV_FILE = 'config/prod.env'
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }
                }
            }
        }

        stage('Run SQL Scripts') {
            steps {
                sh """
                source ${ENV_FILE}
                ${SNOWSQL_PATH} -a $SNOWFLAKE_ACCOUNT -u $SNOWFLAKE_USER -r $SNOWFLAKE_ROLE \\
                -w $SNOWFLAKE_WAREHOUSE -d $SNOWFLAKE_DATABASE -p $SNOWFLAKE_PASSWORD \\
                -f scripts/create_tables.sql
                ${SNOWSQL_PATH} -f scripts/insert_data.sql
                """
            }
        }

        stage('Run Python Notebook') {
            steps {
                sh """
                papermill notebooks/insert_data.ipynb notebooks/output.ipynb
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
