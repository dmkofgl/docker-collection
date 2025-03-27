echo "test from container: "> a.txt
echo "abc"> b.txt
docker run --rm \
 --mount type=bind,src=./a.txt,dst=/test/a.tr\
 --mount type=bind,src=./b.txt,dst=/test/b.txt \
 ubuntu sh -c 'cat /test/b.txt>> test/a.tr'

cat a.txt

echo "a "> c.txt
#read only
docker run --rm \
 --mount type=bind,src=./c.txt,dst=/test/c.tr:ro\
 --mount type=bind,src=./b.txt,dst=/test/b.txt \
 ubuntu sh -c 'cat /test/b.txt>> test/c.tr'

echo "Cat from c:" && cat c.txt
#mount with volume command
docker run --rm \
 -v ./Dockerfile:/test/a.tr\
 ubuntu sh -c 'cat /test/a.tr'

