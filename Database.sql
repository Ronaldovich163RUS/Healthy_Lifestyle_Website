-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema health_lifestyle
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema health_lifestyle
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `health_lifestyle` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `health_lifestyle` ;

-- -----------------------------------------------------
-- Table `health_lifestyle`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`client` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `date_of_birth` DATE NULL DEFAULT NULL,
  `gender` VARCHAR(255) NULL DEFAULT NULL,
  `height_cm` INT NULL DEFAULT NULL,
  `weight_kg` INT NULL DEFAULT NULL,
  `progress_data` JSON NULL DEFAULT NULL,
  `profile_photo` VARCHAR(255) NULL DEFAULT NULL,
  `activity_index` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 40
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`food_diary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`food_diary` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `meal_time` ENUM('breakfast', 'lunch', 'dinner', 'snack') NULL DEFAULT NULL,
  `food_items` JSON NULL DEFAULT NULL,
  `total_calories` INT NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `food_diary_ibfk_1` (`client_id` ASC) VISIBLE,
  CONSTRAINT `food_diary_ibfk_1`
    FOREIGN KEY (`client_id`)
    REFERENCES `health_lifestyle`.`client` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`health_calculators`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`health_calculators` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `calculator_type` ENUM('bmi', 'calories', 'water', 'sleep', 'calories_burned') NOT NULL,
  `input_data` JSON NULL DEFAULT NULL,
  `result_data` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `health_calculators_ibfk_1` (`client_id` ASC) VISIBLE,
  CONSTRAINT `health_calculators_ibfk_1`
    FOREIGN KEY (`client_id`)
    REFERENCES `health_lifestyle`.`client` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 70
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`meal_templates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`meal_templates` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `meal_type` ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
  `calories` INT NOT NULL,
  `diet_type` ENUM('standard', 'vegetarian', 'vegan', 'keto') NOT NULL,
  `ingredients` JSON NOT NULL COMMENT '[{\"name\": \"Овсянка\", \"amount\": \"100г\"}, ...]',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`physical_activity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`physical_activity` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `activity_type` VARCHAR(100) NULL DEFAULT NULL,
  `duration_minutes` INT NULL DEFAULT NULL,
  `calories_burned` INT NULL DEFAULT NULL,
  `activity_date` DATE NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `physical_activity_ibfk_1` (`client_id` ASC) VISIBLE,
  CONSTRAINT `physical_activity_ibfk_1`
    FOREIGN KEY (`client_id`)
    REFERENCES `health_lifestyle`.`client` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`user_meal_templates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`user_meal_templates` (
  `client_id` INT NOT NULL,
  `meal_templates_id` INT NOT NULL,
  PRIMARY KEY (`client_id`, `meal_templates_id`),
  INDEX `fk_user_meal_templates_meal_templates1_idx` (`meal_templates_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_meal_templates_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `health_lifestyle`.`client` (`id`),
  CONSTRAINT `fk_user_meal_templates_meal_templates1`
    FOREIGN KEY (`meal_templates_id`)
    REFERENCES `health_lifestyle`.`meal_templates` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`workout_templates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`workout_templates` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `goal` ENUM('weight_loss', 'weight_gain', 'improved_endurance', 'increased_strength_and_power', 'development_of _lexibility_and_mobility', 'improvement_of_health') NOT NULL,
  `level` ENUM('beginner', 'intermediate', 'advanced') NOT NULL,
  `equipment` ENUM('none', 'dumbbells', 'pull_up_bar', 'full_gym') NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `exercises` JSON NOT NULL COMMENT 'Список упражнений: [{\"name\": \"Приседания\", \"sets\": 3, \"reps\": 12}]',
  `duration_minutes` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`user_workout_templates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`user_workout_templates` (
  `workout_templates_id` INT NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`workout_templates_id`, `client_id`),
  INDEX `fk_user_workout_templates_client1_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_workout_templates_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `health_lifestyle`.`client` (`id`),
  CONSTRAINT `fk_user_workout_templates_workout_templates1`
    FOREIGN KEY (`workout_templates_id`)
    REFERENCES `health_lifestyle`.`workout_templates` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `health_lifestyle`.`water_intake`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `health_lifestyle`.`water_intake` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `amount_ml` INT NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `water_intake_ibfk_1` (`client_id` ASC) VISIBLE,
  CONSTRAINT `water_intake_ibfk_1`
    FOREIGN KEY (`client_id`)
    REFERENCES `health_lifestyle`.`client` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
