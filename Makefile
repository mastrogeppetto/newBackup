install:
	mkdir -p ${HOME}/bin
	cp newBackup.sh ${HOME}/bin
	chmod u+x ${HOME}/bin/newBackup.sh
	cp exclude_patterns.txt ${HOME}/exclude_patterns.txt
