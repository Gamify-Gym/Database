CREATE DATABASE if not exists gamify_gym;

USE gamify_gym;

/* TODOS os alimentos tem seus atributos baseados em 1g (uma grama)*/
CREATE TABLE if not exists foods(
	id_food INT AUTO_INCREMENT PRIMARY KEY,
    name_food VARCHAR(25) NOT NULL,
    calories DOUBLE NOT NULL,
    proteins DOUBLE NOT NULL,
    carbohydrates DOUBLE NOT NULL,
    fats DOUBLE NOT NULL,
    fibers DOUBLE NOT NULL,
	sodium DOUBLE NOT NULL
);

CREATE TABLE if not exists sugars(
	id_sugar INT AUTO_INCREMENT PRIMARY KEY,
    total_sugar DOUBLE NOT NULL,
    added_sugar DOUBLE NOT NULL,
    food_id INT NOT NULL
);

CREATE TABLE if not exists fats(
	id_fat INT AUTO_INCREMENT PRIMARY KEY,
    trans_fats DOUBLE NOT NULL,
    monounsaturated_fats DOUBLE NOT NULL,
    polyunsaturated_fats DOUBLE NOT NULL,
    satured_fats DOUBLE NOT NULL,
    food_id INT NOT NULL
);

CREATE TABLE if not exists foods_logs(
	id_food_log INT AUTO_INCREMENT PRIMARY KEY,
    when_eat DATETIME NOT NULL,
	food_id INT NOT NULL, 
    player_id INT NOT NULL
);

CREATE TABLE if not exists diet_plans(
	id_diet_plan INT AUTO_INCREMENT PRIMARY KEY,
    name_diet VARCHAR(25) NOT NULL,
    description VARCHAR(255),
    player_id INT NOT NULL,
    nutritionist_id INT 
);

CREATE TABLE if not exists diet_items(
	id_diet_item INT AUTO_INCREMENT PRIMARY KEY,
    grams DOUBLE NOT NULL,
    diet_plan_id INT NOT NULL,
    food_id INT NOT NULL,
    meal_id INT NOT NULL
);

CREATE TABLE if not exists meals(
	id_meal INT AUTO_INCREMENT PRIMARY KEY,
    name_meal VARCHAR(25) NOT NULL,
    order_meal TINYINT NOT NULL 
);

CREATE TABLE if not exists exercises(
	id_exercise INT AUTO_INCREMENT PRIMARY KEY,
    name_exercise VARCHAR(25) NOT NULL,
    muscles VARCHAR(25) NOT NULL -- Músculos que são treinados nesse exercício separados por vírgulas
);

CREATE TABLE if not exists exercises_logs(
	id_exercise_log INT AUTO_INCREMENT PRIMARY KEY,
    weight DOUBLE,
    reps INT,
    time_in TIME,
    day_made DATE NOT NULL,
    exercise_id INT NOT NULL,
    player_id INT NOT NULL
);

CREATE TABLE if not exists nutritionists(
	id_nutritionist INT AUTO_INCREMENT PRIMARY KEY,
    crn VARCHAR(7) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    user_id INT NOT NULL
);

CREATE TABLE if not exists users(
	id_user INT AUTO_INCREMENT PRIMARY KEY,
    name_user VARCHAR(25) NOT NULL,
    password CHAR(60) NOT NULL
);

CREATE TABLE if not exists personal_trainers(
	id_personal_trainer INT AUTO_INCREMENT PRIMARY KEY,
    cref VARCHAR(7) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
	user_id INT NOT NULL
);

CREATE TABLE if not exists players(
	id_player INT AUTO_INCREMENT PRIMARY KEY,
    height DOUBLE,
    weight DOUBLE,
    user_id INT NOT NULL,
	personal_trainer_id INT,
    nutritionist_id INT
);

CREATE TABLE IF NOT EXISTS friendships (
    id_friendship INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,        -- Quem fez a solicitação
    friend_id INT NOT NULL,        -- Quem foi adicionado
    status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    responded_at DATETIME NULL,
    
    FOREIGN KEY (player_id) REFERENCES players(id_player)
        ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES players(id_player)
        ON DELETE CASCADE,
    
    CONSTRAINT uq_unique_friendship UNIQUE (player_id, friend_id),
    CONSTRAINT chk_no_self_friend CHECK (player_id <> friend_id)
);


/* Tabela para reduzir a redundãncia dos dados e associar as tabelas treinos e exercicios*/
CREATE TABLE if not exists exercises_workouts(
	id_exercise_workout INT AUTO_INCREMENT PRIMARY KEY,
	min_reps TINYINT, -- Atributo vinculado ao alcance de repetições
    max_reps TINYINT, -- Atributo vinculado ao alcance de repetições
    time TIME, -- Tempo em um exercício(prancha por exemplo)
    n_sets TINYINT NOT NULL,
    exercise_id INT NOT NULL,
    workout_id INT NOT NULL
);

CREATE TABLE if not exists workouts(
	id_workout INT AUTO_INCREMENT PRIMARY KEY,
    name_workout VARCHAR(25) NOT NULL,
    description VARCHAR(255) NOT NULL, -- Espaço para o usuário colocar observações e etc
    player_id INT NOT NULL,
    personal_trainer_id INT
);

ALTER TABLE diet_plans
ADD CONSTRAINT fk_player_diet_plan
FOREIGN KEY (player_id) REFERENCES players(id_player)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE diet_plans
ADD CONSTRAINT fk_nutritionist_diet_plan
FOREIGN KEY (nutritionist_id) REFERENCES nutritionists(id_nutritionist)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE diet_items
ADD CONSTRAINT fk_diet_plan_diet_item
FOREIGN KEY (diet_plan_id) REFERENCES diet_plans(id_diet_plan)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE diet_items
ADD CONSTRAINT fk_food_diet_item
FOREIGN KEY (food_id) REFERENCES foods(id_food)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE diet_items
ADD CONSTRAINT fk_meal_diet_item
FOREIGN KEY (meal_id) REFERENCES meals(id_meal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE fats
ADD CONSTRAINT fk_food_fat
FOREIGN KEY (food_id) REFERENCES foods(id_food)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE foods_logs
ADD CONSTRAINT fk_food_food_log
FOREIGN KEY (food_id) REFERENCES foods(id_food)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE foods_logs
ADD CONSTRAINT fk_player_food_log
FOREIGN KEY (player_id) REFERENCES players(id_player)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE exercises_logs
ADD CONSTRAINT fk_exercise_exercise_log
FOREIGN KEY (exercise_id) REFERENCES exercises(id_exercise)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE exercises_logs
ADD CONSTRAINT fk_player_exercise_log
FOREIGN KEY (player_id) REFERENCES players(id_player)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE exercises_workouts
ADD CONSTRAINT fk_exercise
FOREIGN KEY (exercise_id) REFERENCES exercises(id_exercise)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE exercises_workouts
ADD CONSTRAINT fk_workout
FOREIGN KEY (workout_id) REFERENCES workouts(id_workout)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE nutritionists
ADD CONSTRAINT fk_user_nutritionist
FOREIGN KEY (user_id) REFERENCES users(id_user)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE players
ADD CONSTRAINT fk_user_player
FOREIGN KEY (user_id) REFERENCES users(id_user)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE players
ADD CONSTRAINT fk_nutritionist_player
FOREIGN KEY (nutritionist_id) REFERENCES nutritionists(id_nutritionist)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE players
ADD CONSTRAINT fk_personal_trainer_player
FOREIGN KEY (personal_trainer_id) REFERENCES personal_trainers(id_personal_trainer)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE personal_trainers
ADD CONSTRAINT fk_user_personal_trainer
FOREIGN KEY (user_id) REFERENCES users(id_user)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE sugars
ADD CONSTRAINT fk_food_sugar
FOREIGN KEY (food_id) REFERENCES foods(id_food)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE workouts
ADD CONSTRAINT fk_player_workout
FOREIGN KEY (player_id) REFERENCES players(id_player)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE workouts
ADD CONSTRAINT fk_personal_trainer_workout
FOREIGN KEY (personal_trainer_id) REFERENCES personal_trainers(id_personal_trainer)
ON DELETE CASCADE
ON UPDATE CASCADE;
