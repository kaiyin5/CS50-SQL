from cs50 import SQL


db = SQL("sqlite:///dont-panic.db")
password = input("Enter a password: ")
# frame = input("Enter a frame password for the log: ")
db.execute(
    """
    UPDATE "users"
    SET "password" = ?
    WHERE "username" = 'admin';
    """,
    password
)

# db.execute(
#     """
#     UPDATE "user_logs"
#     SET "new_password" = ?
#     WHERE "new_username" = 'admin'
#     AND "new_password" = ?;
#     """,
#     frame,
#     password
# )