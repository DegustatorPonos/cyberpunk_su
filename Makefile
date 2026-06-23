all:
	cd backend && make container
	cd front && make container
	sudo docker compose up
