FIRST_EXTERNAL='HDMI3'
SECOND_EXTERNAL='HDMI2'
LCD_SCREEN='LVDS1'

logger 'Running dock/undock script'

# Start by activating the laptop screen
xrandr --output ${FIRST_EXTERNAL} --off --output ${SECOND_EXTERNAL} --off > /tmp/dock_helper.log 2>&1
logger "Setting ${LCD_SCREEN} as primary monitor"
xrandr --output ${LCD_SCREEN} --auto --primary >> /tmp/dock_helper.log 2>&1

# Attempt to determine which external screens are attached
xrandr | grep "${FIRST_EXTERNAL} connected" >> /tmp/dock_helper.log 2>&1
if [ $? -eq 0 ]; then
    logger "Found ${FIRST_EXTERNAL}. Setting ${FIRST_EXTERNAL} as primary and turning ${LCD_SCREEN} off"
    xrandr --output ${LCD_SCREEN} --off --output ${FIRST_EXTERNAL} --auto --primary >> /tmp/dock_helper.log 2>&1
    xrandr | grep "${SECOND_EXTERNAL} connected" >> /tmp/dock_helper.log 2>&1
    if [ $? -eq 0 ]; then
        logger "Found ${SECOND_EXTERNAL}. Setting ${SECOND_EXTERNAL} to the right of ${FIRST_EXTERNAL}"
        xrandr --output ${LCD_SCREEN} --off --output ${SECOND_EXTERNAL} --auto --right-of ${FIRST_EXTERNAL} >> /tmp/dock_helper.log 2>&1
    fi
else
    xrandr | grep "${SECOND_EXTERNAL} connected" >> /tmp/dock_helper.log 2>&1
    if [ $? -eq 0 ]; then
        logger "Found ${SECOND_EXTERNAL}. Setting ${SECOND_EXTERNAL} as primary and turning ${LCD_SCREEN} off"
        xrandr --output ${LCD_SCREEN} --off --output ${SECOND_EXTERNAL} --auto --primary >> /tmp/dock_helper.log 2>&1
    fi
fi
