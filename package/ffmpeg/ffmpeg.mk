################################################################################
#
# ffmpeg
#
################################################################################

ffmpeg: $(if $(filter $(BOXTYPE),coolstream),ffmpeg2,ffmpeg4)
	@$(call TOUCH)
