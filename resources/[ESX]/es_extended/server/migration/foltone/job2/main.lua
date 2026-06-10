local esxVersion = "foltone-job2"

Core.Migrations = Core.Migrations or {}
Core.Migrations[esxVersion] = Core.Migrations[esxVersion] or {}

if GetResourceKvpInt(("esx_migration:%s"):format(esxVersion)) == 1 then
  return
end

---@return boolean restartRequired
Core.Migrations[esxVersion].job2 = function()
  print("^4[esx_migration:foltone-job2]^7 Adding secondary job (job2) columns to users table.")

  local job2 = MySQL.scalar.await([[
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'users'
      AND COLUMN_NAME = 'job2'
  ]])

  local job2Grade = MySQL.scalar.await([[
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'users'
      AND COLUMN_NAME = 'job2_grade'
  ]])

  if job2 ~= 0 and job2Grade ~= 0 then
    print("^4[esx_migration:foltone-job2]^7 Columns already exist, migration not needed.")
    return false
  end

  if job2 == 0 then
    MySQL.update.await("ALTER TABLE `users` ADD COLUMN `job2` VARCHAR(20) NULL DEFAULT 'unemployed' AFTER `job_grade`")
  end

  if job2Grade == 0 then
    MySQL.update.await("ALTER TABLE `users` ADD COLUMN `job2_grade` INT NULL DEFAULT 0 AFTER `job2`")
  end

  print("^4[esx_migration:foltone-job2]^7 Migration complete.")
  return true
end
