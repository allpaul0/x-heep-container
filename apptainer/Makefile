SHELL := /bin/bash
APPTAINER = apptainer

# Directories
DEF_DIR = container_layers
BUILD_DIR = container_layers/build

# Ensure build directory exists
$(shell mkdir -p $(BUILD_DIR))

# Default target
all: $(BUILD_DIR)/gcc.sif

# Base image
$(BUILD_DIR)/base.sif: $(DEF_DIR)/base.def
	$(APPTAINER) build $@ $<

# Verilator (depends on base)
$(BUILD_DIR)/verilator.sif: $(DEF_DIR)/verilator.def $(BUILD_DIR)/base.sif
	$(APPTAINER) build $@ $<

# Verible (depends on verilator)
$(BUILD_DIR)/verible.sif: $(DEF_DIR)/verible.def $(BUILD_DIR)/verilator.sif 
	$(APPTAINER) build $@ $<

# Build Conda (depends on verible)
$(BUILD_DIR)/conda.sif: $(DEF_DIR)/conda.def $(BUILD_DIR)/verible.sif 
	$(APPTAINER) build $@ $<

# GCC RISC-V (depends on conda)
$(BUILD_DIR)/gcc.sif: $(DEF_DIR)/gcc.def $(BUILD_DIR)/conda.sif 
	$(APPTAINER) build $@ $<

# CORE-V GCC (depends on gcc)
$(BUILD_DIR)/corev-gcc.sif: $(DEF_DIR)/corev-gcc.def $(BUILD_DIR)/gcc.sif 
	$(APPTAINER) build $@ $<


# Convenience targets
.PHONY: all base verilator verible conda gcc clean help 
base: $(BUILD_DIR)/base.sif
verilator: $(BUILD_DIR)/verilator.sif
verible: $(BUILD_DIR)/verible.sif
conda: $(BUILD_DIR)/conda.sif
gcc: $(BUILD_DIR)/gcc.sif
corev-gcc: $(BUILD_DIR)/corev-gcc.sif


# Remove generated SIFs
clean:
	rm -f $(BUILD_DIR)/*.sif

help:
	@echo "Usage:"
	@echo "  make            # build everything (ends with gcc.sif)"
	@echo "  make base		 # build only base"
	@echo "  make verilator  # build verilator image (depends on base)"
	@echo "  make verible    # build verible image (depends on verilator)"
	@echo "  make conda      # build conda image (depends on verible)"
	@echo "  make gcc		 # build gcc last (depends on conda)"
	@echo "  make corev-gcc  # build corev-gcc image (depends on gcc)"
	@echo "  make clean      # remove all generated .sif files"
