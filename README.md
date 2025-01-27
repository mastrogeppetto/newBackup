### Configurazione, installazione e uso
Un altro script per fare backup incrementale con rsync, adatto sopratutto a dispositivi rimovibili (chiavetta).
Cercare il UUID della chiavetta con il comando `lsblk -e7 -lo NAME,LABEL,UUID,FSAVAIL` cercando la "Label" corrispondente a quella della chiavetta.
Per configurarle lo script editarlo per sostituire il valore della variabile BACKUPUUID con quella copiata al passo precedente. Ad esempio:
```
BACKUPUUID="2d2b7382-3d33-4242-8cd6-77e4617c8d52"
```
Per installarlo usare il comando make:
```
make install
```
Per usarlo, inserire la chiavetta in una porta USB e digitare il comando:
```
newBackup.sh
```
Nel caso il sistema risponda `newBackup.sh: comando non trovato` utilizzare la sintassi alternativa
```
~/bin/newBackup.sh
```
e considerare di aggiungere l'impostazione della directory `~/bin` nel `PATH`, aggiungendo la riga
```
PATH="$HOME/bin:$PATH"
```
nel file `.profile` per utilizzare la sintassi semplificata.

Chiamando lo script con l'ozione -n si ottiene che vengano solo elencate le operazioni che verrebbero eseguite.
Il programma verifica che

* la chiavetta sia quella giusta
* il filesystem di backup sia montato
* l'utente abbia diritti di scrittura sul filesystem.

### Come funziona

Nella chiavetta viene mantenuta una copia completa della directory home dell'utente, con l'esclusione dei file che corrispondono ai pattern nel file `exclude_patterns.txt`.

Il file `exclude_patterns.txt` è contenuto in questo repo, può essere configurato e viene copiato nella home dell'utente con il comando `make install`. E' preferibile modificare il file nel repo ed installare piuttosto che modificare il file nella home dell'utente. Il file contiene un certo numero di pattern di nomi di file per cui non verrà eseguito il backup. Ad esempio, una riga contenente la stringa `noBackup` indica che tutti le directory e file chiamati `noBackup` non verranno inclusi nel backup. Per indicare un pattern è possibile usare i caratteri jolly, come `*`.

Ogni volta che il comando viene eseguito viene creata nella chiavetta una directory chiamata `backup_yyyymmgg-hhmmss`. La seconda parte del nome del file indica l'ora dell'esecuzione del comando.  Nella directoy sono registrati solo i file modificati per effetto del backup. Il contenuto dei file è quello precedente all'operazione di backup.

Se sulla linea di comando viene inserita l'opzione -n il comando viene eseguito senza apportare nessuna modifica, ma elencando le azioni che sarebbe eseguite in assenza dell'opzione. Utile per valutare la presenza di file estranei nel backup.

**Importante**: il comando non rimuove le directory vuote nel backup.

### Preparazione del backup

 1. Analizzare la propria home directory e inserire nel file `exclude_patterns.txt` le directories che non si desidera salvare nel backup. Possono essere inseriti anche pattern di file temporanei (ad esempio `*.o`) o di debug (`*.log`).
 2. Eseguire `make install`
 3. Chiamare il comando con l'opzione `-n` ed osservare quali files vengono inseriti nel backup
 4. Perfezionare il contenuto di `exclude_patterns.txt` con le directories nascoste che contengono dati temporanei della applicazioni (*cache*) e altri dati di cui non è necessario mantenere il backup.
 5. Ripetere il comando con l'opzione `-n` per migliorare `exclude_patterns.txt` sino ad ottenere un risultato soddisfacente
 6. Eseguire il comando `newBackup.sh senza l'opzione -n

**Nota**: Nel log del comando cercare la riga `Total transferred file size:` per capire la dimensione del backup.

### Recuperare i dati

Il backup serve a ripristinare alcuni file o, più raramente, l'intera `home`.

E' necessario prima identificare l'istante in cui si è verificata la compromissione, e poi cercare una directory `backup_yyyymmdd-hhmmss` precedente alla compromissione.

Se la compromissione si limita ad un singolo file, cercare nelle directory `backup_yyyymmdd-hhmmss` successive tutte le revisioni del file compromesso, identificando quella valida.

Se la compromissione riguarda l'intera `home`, copiare l'intero contenuto della chiavetta, escludendo le directory `backup_yyyymmdd-hhmmss`. Se necessario risalire ad un backup che non sia l'ultimo, applicare `rsync` a ritroso utilizzando le directory `backup_yyyymmdd-hhmmss` sino a quella precedente la compromissione.
