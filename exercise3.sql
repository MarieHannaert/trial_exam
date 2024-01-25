-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Specialist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Specialist` (
  `Field_area` INT NOT NULL,
  PRIMARY KEY (`Field_area`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Medical`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Medical` (
  `Overtime_rate` INT NULL,
  PRIMARY KEY (`Overtime_rate`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Doctor` (
  `Name` VARCHAR(45) NOT NULL,
  `Date_of_birth` DATE NOT NULL,
  `Address` VARCHAR(45) NOT NULL,
  `Phone_number` VARCHAR(45) NOT NULL,
  `Salary` INT NOT NULL,
  `Specialist_Field_area` INT NOT NULL,
  `Medical_Overtime_rate` INT NOT NULL,
  PRIMARY KEY (`Name`, `Specialist_Field_area`, `Medical_Overtime_rate`),
  UNIQUE INDEX `Address_UNIQUE` (`Address` ASC) VISIBLE,
  UNIQUE INDEX `Phone_number_UNIQUE` (`Phone_number` ASC) VISIBLE,
  INDEX `fk_Doctor_Specialist_idx` (`Specialist_Field_area` ASC) VISIBLE,
  INDEX `fk_Doctor_Medical1_idx` (`Medical_Overtime_rate` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_Specialist`
    FOREIGN KEY (`Specialist_Field_area`)
    REFERENCES `mydb`.`Specialist` (`Field_area`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Doctor_Medical1`
    FOREIGN KEY (`Medical_Overtime_rate`)
    REFERENCES `mydb`.`Medical` (`Overtime_rate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Patient` (
  `Patient_name` VARCHAR(45) NOT NULL,
  `Patient_address` VARCHAR(120) NOT NULL,
  `Patient_Phone_number` VARCHAR(45) NOT NULL,
  `Patient_Date_of_birth` DATE NOT NULL,
  PRIMARY KEY (`Patient_name`),
  UNIQUE INDEX `Patient_Phone_number_UNIQUE` (`Patient_Phone_number` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Payment` (
  `Details` VARCHAR(120) NOT NULL,
  `Method` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Details`),
  UNIQUE INDEX `Details_UNIQUE` (`Details` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bill` (
  `Total` INT NOT NULL,
  PRIMARY KEY (`Total`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Payment_has_Bill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Payment_has_Bill` (
  `Payment_Details` VARCHAR(120) NOT NULL,
  `Bill_Total` INT NOT NULL,
  PRIMARY KEY (`Payment_Details`, `Bill_Total`),
  INDEX `fk_Payment_has_Bill_Bill1_idx` (`Bill_Total` ASC) VISIBLE,
  INDEX `fk_Payment_has_Bill_Payment1_idx` (`Payment_Details` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_has_Bill_Payment1`
    FOREIGN KEY (`Payment_Details`)
    REFERENCES `mydb`.`Payment` (`Details`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_has_Bill_Bill1`
    FOREIGN KEY (`Bill_Total`)
    REFERENCES `mydb`.`Bill` (`Total`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Appointment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Appointment` (
  `Appointment_date` DATE NOT NULL,
  `Appointment_time` TIME NOT NULL,
  `Payment_has_Bill_Payment_Details` VARCHAR(120) NOT NULL,
  `Payment_has_Bill_Bill_Total` INT NOT NULL,
  PRIMARY KEY (`Appointment_date`, `Payment_has_Bill_Payment_Details`, `Payment_has_Bill_Bill_Total`),
  INDEX `fk_Appointment_Payment_has_Bill1_idx` (`Payment_has_Bill_Payment_Details` ASC, `Payment_has_Bill_Bill_Total` ASC) VISIBLE,
  CONSTRAINT `fk_Appointment_Payment_has_Bill1`
    FOREIGN KEY (`Payment_has_Bill_Payment_Details` , `Payment_has_Bill_Bill_Total`)
    REFERENCES `mydb`.`Payment_has_Bill` (`Payment_Details` , `Bill_Total`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Patient_has_Doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Patient_has_Doctor` (
  `Patient_Patient_name` VARCHAR(45) NOT NULL,
  `Doctor_Name` VARCHAR(45) NOT NULL,
  `Doctor_Specialist_Field_area` INT NOT NULL,
  `Doctor_Medical_Overtime_rate` INT NOT NULL,
  `Appointment_Appointment_date` DATE NOT NULL,
  PRIMARY KEY (`Patient_Patient_name`, `Doctor_Name`, `Doctor_Specialist_Field_area`, `Doctor_Medical_Overtime_rate`, `Appointment_Appointment_date`),
  INDEX `fk_Patient_has_Doctor_Doctor1_idx` (`Doctor_Name` ASC, `Doctor_Specialist_Field_area` ASC, `Doctor_Medical_Overtime_rate` ASC) VISIBLE,
  INDEX `fk_Patient_has_Doctor_Patient1_idx` (`Patient_Patient_name` ASC) VISIBLE,
  INDEX `fk_Patient_has_Doctor_Appointment1_idx` (`Appointment_Appointment_date` ASC) VISIBLE,
  CONSTRAINT `fk_Patient_has_Doctor_Patient1`
    FOREIGN KEY (`Patient_Patient_name`)
    REFERENCES `mydb`.`Patient` (`Patient_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Patient_has_Doctor_Doctor1`
    FOREIGN KEY (`Doctor_Name` , `Doctor_Specialist_Field_area` , `Doctor_Medical_Overtime_rate`)
    REFERENCES `mydb`.`Doctor` (`Name` , `Specialist_Field_area` , `Medical_Overtime_rate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Patient_has_Doctor_Appointment1`
    FOREIGN KEY (`Appointment_Appointment_date`)
    REFERENCES `mydb`.`Appointment` (`Appointment_date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
