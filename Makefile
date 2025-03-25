.PHONY: c
c:
	docker-compose exec web bin/rails console

.PHONY: sh
sh:
	docker-compose exec web sh