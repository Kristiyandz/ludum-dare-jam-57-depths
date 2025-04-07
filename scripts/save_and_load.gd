extends Node

const SAVE_PATH = "user://save.cfg"

# handle best time saving
func save_time(best_time):
    var config = ConfigFile.new()
    config.load(SAVE_PATH)
    config.set_value("Game", "BestTime", best_time)
    config.save(SAVE_PATH)

# handle attempt time saving
func save_time_attempt_time(attempt_time):
    var config = ConfigFile.new()
    config.load(SAVE_PATH)
    config.set_value("Game", "AttemptTime", attempt_time)
    config.save(SAVE_PATH)

# handle saved salvage amount
func save_salvage_amount(amount):
    var config = ConfigFile.new()
    config.load(SAVE_PATH)
    config.set_value("Game", "BestSalvageCount", amount)
    config.save(SAVE_PATH)

# save the attempted salvage count
func save_attempt_salvage_amount(amount):
    var config = ConfigFile.new()
    config.load(SAVE_PATH)
    config.set_value("Game", "AttemptSalvage", amount)
    config.save(SAVE_PATH)

# load the best time
func load_best_time():
    var best_time = 0
    var config = ConfigFile.new()
    var err = config.load(SAVE_PATH)
    if err != OK: return 0

    best_time = config.get_value("Game", "BestTime", 0)
    return best_time

# load the best time
func load_attempt_time():
    var attempt_time = 0
    var config = ConfigFile.new()
    var err = config.load(SAVE_PATH)
    if err != OK: return 0

    attempt_time = config.get_value("Game", "AttemptTime", 0)
    return attempt_time

# load best salvage count
func load_best_salvage_count():
    var best_salvage_count = 0
    var config = ConfigFile.new()
    var err = config.load(SAVE_PATH)
    if err != OK: return 0

    best_salvage_count = config.get_value("Game", "BestSalvageCount", 0)
    return best_salvage_count

# load best salvage count
func load_attempt_salvage_count():
    var attempt_salvage_count = 0
    var config = ConfigFile.new()
    var err = config.load(SAVE_PATH)
    if err != OK: return 0

    attempt_salvage_count = config.get_value("Game", "AttemptSalvage", 0)
    return attempt_salvage_count
