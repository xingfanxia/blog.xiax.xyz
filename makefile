HUGO_POST_DIR := content/post

# Phony target to avoid make doing anything with a command like "make new-iceberg"
.PHONY: $(filter-out new hs default,$(MAKECMDGOALS))

# Default usage instructions
.PHONY: default
default:
	@echo "Usage: make new POST_NAME"
	@echo "   or: make hs"

# Start the hugo build
.PHONY: hb
hb:
	hugo

# Start the hugo server
.PHONY: hs
hs:
	hugo server --gc

# Intercept the new post command, parse it, and execute hugo new
.PHONY: new
new: guard-POST_ARG
	$(eval NEW_TARGET := $(word 2, $(MAKECMDGOALS)))
	@echo "Creating new post in $(HUGO_POST_DIR)/$(NEW_TARGET)..."
	@hugo new "$(HUGO_POST_DIR)/$(NEW_TARGET)/index.md"

# Guard to ensure we have an argument after "new"
.PHONY: guard-POST_ARG
guard-POST_ARG:
	$(if $(word 2, $(MAKECMDGOALS)), , $(error Please specify a post name. Usage: make new POST_NAME))
# Trick to avoid Make doing anything with the post name argument
%:
	@:

# Tell make to ignore the post name (So `make new iceberg` still works)
# but this must be after the `new` target; otherwise, it would take precedence
new-%:
	@true