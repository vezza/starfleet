# Starfleet Command v6 — Fedora 44

Tema Plymouth basato sul plugin `script`, aggiornato per visualizzare i messaggi ricevuti da Plymouth sia durante l'avvio sia durante lo spegnimento.

## Correzione principale: messaggi di sistema

La versione precedente registrava `SetMessageFunction`, che non è una funzione esposta dall'API del plugin Script di Plymouth. Inoltre non registrava il callback `SetUpdateStatusFunction`, usato per ricevere gli aggiornamenti di stato dei servizi.

La v6 usa le callback effettivamente supportate:

- `Plymouth.SetUpdateStatusFunction(...)` per gli aggiornamenti di stato di systemd (ad esempio `Started ...`, `Starting ...`).
- `Plymouth.SetDisplayMessageFunction(...)` per i messaggi inviati a Plymouth.
- `Plymouth.SetHideMessageFunction(...)` per le notifiche di rimozione. Il tema conserva intenzionalmente le ultime sei righe come storico visibile.

Le righe ricevute vengono visualizzate in un pannello inferiore a sei righe, con testo azzurro su sfondo nero. La stessa area viene usata quando Plymouth è in modalità `boot` o `shutdown`.

## Sequenza grafica

- Stemma della Federazione in alto a sinistra.
- Logo Starfleet bianco centrato con alone ciano pulsante.
- Fascio di scansione animato.
- Fasi di avvio sincronizzate con `SetBootProgressFunction(duration, progress)`.
- In modalità shutdown, diciture dedicate alla sequenza di spegnimento.
- La dicitura `ALL SYSTEMS OPERATIONAL` viene mostrata al raggiungimento del progresso 99,9% durante il boot.

Le diciture di scansione e sensori sono elementi scenografici: non rappresentano una diagnostica reale dei componenti hardware.

## Installazione

```bash
sudo dnf install plymouth plymouth-plugin-script plymouth-scripts dracut
sudo ./install.sh
```

L'installatore conserva il tema predefinito precedente al primo utilizzo e rigenera l'initramfs tramite `plymouth-set-default-theme -R`.

## Ripristino

```bash
sudo ./restore.sh
```

## Verifica

Prima dell'installazione è possibile controllare gli script shell con:

```bash
bash -n install.sh restore.sh
```

Dopo l'installazione, controllare il tema selezionato:

```bash
plymouth-set-default-theme
```

Per provare la ricezione di messaggi nella sessione Plymouth, usare una TTY testuale e il comando:

```bash
sudo plymouth display-message --text="STARFLEET TEST MESSAGE"
```

Nota: Plymouth visualizza i messaggi che gli vengono inoltrati. Non può mostrare automaticamente ogni riga grezza del kernel o di tutti i processi. La visibilità degli stati systemd dipende anche dalla configurazione `rhgb`/status del sistema; nel tuo caso hai già verificato che premendo ESC gli stati sono disponibili.
