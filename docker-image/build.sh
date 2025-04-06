docker build --secret=type=file,id=pipconf,src=./pip.conf --secret=type=file,id=aptconf,src=./secret.txt -t nickfreer/turbomonitor:0.1 .
# docker push 



