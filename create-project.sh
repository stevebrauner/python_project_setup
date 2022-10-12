if [ $# -eq 1 ]
then
	echo "The new project is $1."
else
	echo "Please provide project name as only argument."
	exit 0
fi

PROJECT=$1
DUMMY_PROJECT='project'
YEAR=$(date +%Y)

cp -R $DUMMY_PROJECT $PROJECT
cd $PROJECT
mv $DUMMY_PROJECT $PROJECT
sed -i '' -e s/$DUMMY_PROJECT/$PROJECT/g setup.cfg
sed -i '' -e s/$DUMMY_PROJECT/$PROJECT/g pyproject.toml
sed -i '' -e s/$DUMMY_PROJECT/$PROJECT/g tests/test_factorial.py
sed -i '' -e s/\<YEAR\>/$YEAR/g LICENSE
git init
poetry install
poetry run pre-commit install

echo "Testing project:"
poetry run pytest --cov --cov-fail-under=100

echo "Testing pre-commit:"
poetry run pre-commit run --all-files
