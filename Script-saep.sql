-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema saep
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema saep
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `saep` DEFAULT CHARACTER SET utf8 ;
USE `saep` ;

-- -----------------------------------------------------
-- Table `saep`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `saep`.`usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `saep`.`reponsavel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `saep`.`reponsavel` (
  `id_responsavel` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `cpf` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id_responsavel`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `saep`.`aluno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `saep`.`aluno` (
  `idaluno` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `reponsavel_id_responsavel` INT NOT NULL,
  PRIMARY KEY (`idaluno`),
  INDEX `fk_aluno_reponsavel_idx` (`reponsavel_id_responsavel` ASC) VISIBLE,
  CONSTRAINT `fk_aluno_reponsavel`
    FOREIGN KEY (`reponsavel_id_responsavel`)
    REFERENCES `saep`.`reponsavel` (`id_responsavel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `saep`.`matricula`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `saep`.`matricula` (
  `idmatricula` INT NOT NULL AUTO_INCREMENT,
  `curso` VARCHAR(45) NULL,
  `data` DATE NULL,
  `aluno_idaluno` INT NOT NULL,
  PRIMARY KEY (`idmatricula`),
  INDEX `fk_matricula_aluno1_idx` (`aluno_idaluno` ASC) VISIBLE,
  CONSTRAINT `fk_matricula_aluno1`
    FOREIGN KEY (`aluno_idaluno`)
    REFERENCES `saep`.`aluno` (`idaluno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
