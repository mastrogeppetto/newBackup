### Configurazione, installazione e uso
Un altro script per fare backup incrementale con rsync, adatto sopratutto a dispositivi rimovibili (chiavetta)
La chiavetta deve essere formattata come ext, provato con ext4, con `gnome-disks`. Copiare il UUID del filesystem da `gnome-disks`.
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

### Organizzazione dei dati

La chiavetta contiene il contenuto della home nella directory con il nome dell'utente. Vengono esclusi i file indicati nel parametro --exclude di rsync. Quindi è un diff rispetto al backup precedente.
