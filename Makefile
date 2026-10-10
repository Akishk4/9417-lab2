DIR = dir
MALICIOUS_DIR = malicious_dir
INTERVAL = 5

.PHONY: all setup antivirus restore clean

all: setup
	@echo "Antivirus lab is ready."
	@echo "Run 'make antivirus' to start monitoring."
	@echo "Run 'make restore' to review quarantined files."

setup:
	mkdir -p $(DIR) $(MALICIOUS_DIR)
	chmod +x antivirusd.sh restore.sh

antivirus: setup
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: setup
	./restore.sh $(DIR) $(MALICIOUS_DIR)

clean:
	rm -f directory-info.last directory-info.new
