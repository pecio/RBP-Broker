local L = LibStub('AceLocale-3.0'):NewLocale('RBPBroker', 'esES')

if not L then return end

-- LibDataBroker data object title
L['Revive Battle Pets'] = 'Revivir Mascotas'

-- Configuration dialog
L['Main'] = 'Principal'
L['Show Cooldown'] = 'Mostrar tiempo de Reutilización'
L['Show cooldown time for Revive Battle Pets spell in bar'] = 'Mostrar tiempo de Reutilización restante para la habilidad de Reivivir Mascotas en la barra'
L['Notify Availability'] = 'Notificar Disponibilidad'
L['Notify the player when cooldown time finishes'] = 'Notificar al jugador cuando el tiempode reutilización finalice'
L['None'] = 'Ninguna'
L['With Level Up Sound'] = 'Con sonido Subir de Nivel'
L['In Chat'] = 'En el chat'
L['Both'] = 'Ambas'
L['Report Current Status'] = 'Informar de Estado Actual'
L['At Battle Start'] = 'Al Inicio de la Batalla'
L['Notify current status in chat after battle start animation finishes'] = 'Notificar el estado actual en el chat después de que la animación de comienzo de la batalla termine'
L['At Battle End'] = 'Al Final de la Batalla'
L['Notify current status in chat on returning to normal game'] = 'Notificar el estado actual en el chat al volver al juego normal'

-- Notifications
-- Cooldown finished, RBP is ready; %s will be replaced by icon and name
L['%s is ready'] = '%s está lista'

-- Current status, not yet ready. First %s is RBP icon and name, second
-- is time in long form (as per SecondsToTime API call)
L['%s ready in %s'] = '%s lista en %s'

-- Display
-- Shortest possible way to say it is ready
L['Ready'] = 'Lista'

-- Tooltip
L['Click for options'] = 'Click para opciones'
