# iquartz

This file aims at explaining birefly the purpose of every other file submitted from the group **iquartz**, to clarify possible doubts.

## `configuration.m`

This file holds several constants that are used to configure the execution of the insertion and detection of the watermark.

## `insertion_iquartz.m`

This file is responsible for the insertion of our watermark in the desired image, specified in the `img_name` local variable. Watermarked images are placed in the folder `Images_watermarked/`. This file makes use of the `apdcbt` function, implemented in the `apdcbt.m` file.

The insertion is customizable by tuning some constants in the `configuration.m` file. Specifically, it is possible to chose the level of the `dwt` on which to apply the watermark, and to chose whether to rescale the watermark on a `-1 to 1` range before the insertion.

## `embed.m`

Is the file that implements the function that actually embeds the watermark in an image, it takes as input the image, the watermark and the value `alpha`.

## `detection_iquartz.m`

This file implements the function responsible to check the presence of the watermark in an attacked image, by confronting it with the watermark extracted from a watermarked, but not attacked, image. The function is as follows:

`function [contains, wpsnr_value] = new_detection_iquartz(original, watermarked, attacked)`

## `interactive_detection_iquartz.m`

This file implements the detection of the watermark, but must not be confused with `detection_iquartz.m`. Indeed, this file is used to check the presence of the watermark in an image using the original watermark matrix provided to the team. This file shall be used only for testing purposes. Setting the `SHOW_IMAGES` constant, this files also shows some testing images to the user. This file makes use of the `iapdcbt` function, implemented in the `iapdcbt.m` file. This file also makes use of `extract_watermark_helper.m`.

## `extract_watermark_helper.m`

Implements the function that extracts the watermark from a watermarked image, by confronting it with a non-watermarked one. It takes as input some configurational variables.

## `apdcbt.m` and `iapdcbt.m`

These files implement respectively the `apdcbt` (All Phase Discrete Cosine Biorthogonal Transform) and its inverse `iapdcbt` functions. These files are developed by Zabir Al Nazi and not by a member of the iquartz team.
